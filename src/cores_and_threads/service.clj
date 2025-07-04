(ns cores-and-threads.service
  (:require [cores-and-threads.logger :as logger]
            [cores-and-threads.utils :as utils]))


(defn do-work
  [ctx {:keys [input_num
               times
               print_percent]}]
  (let [start_epoch (utils/current-epoch)]
    (dotimes [_ times]
      (Math/sqrt input_num))
    (let [end_epoch (utils/current-epoch)]
      (when (utils/within-percent? ctx
                                   print_percent)
        (logger/info (format "Time taken : [%s] seconds"
                             (/ (Math/abs (- end_epoch start_epoch)) 1000.0))
                     {})))))


(defn run-gc
  [ctx {:keys [force_gc?]}]
  (let [utilization (utils/heap-utilization)]
    (when (or force_gc?
              (> utilization
                 (get-in ctx [:gc :threadhold-ratio])))
      (System/gc))))


(defn start-a-thread
  "Business logic to be executed by each thread"
  [ctx {:keys [thread_id
               metric_prefix
               duration_minutes
               total_counter_atom] :as params}]
  (let [hostname (utils/hostname)
        thread_name (utils/thread-name)
        end_epoch (+ (utils/current-epoch)
                     (* duration_minutes 60 1000))
        loop_counter (atom 0)]
    (try
      (loop []
        (let [curr_epoch (utils/current-epoch)
              diff (- end_epoch curr_epoch)]
          (if (> diff 0)
            (do
              (utils/wrap-statsd-time (format "%s.%s"
                                              hostname
                                              (if (seq metric_prefix)
                                                metric_prefix
                                                "work"))
                                      (do-work ctx params))
              (swap! loop_counter inc)
              (recur))
            (do
              (logger/info (format "Done work : [%s] times, th-name : [%s]"
                                   @loop_counter
                                   thread_name)
                           {:hostname hostname
                            :thread_name thread_name
                            :thread_id (inc thread_id)})
              (swap! total_counter_atom + @loop_counter)))))
      (catch java.lang.OutOfMemoryError oom
        (logger/info (format "OOM occured ...")
                     {:msg (.getMessage oom)
                      :thread_name thread_name
                      :thread_id (inc thread_id)}))
      (catch Exception e
        (logger/info (format "Exception occured ...")
                     {:msg (.getMessage e)
                      :thread_name thread_name
                      :thread_id (inc thread_id)}))
      (finally
        ;(run-gc ctx {:force_gc? true})
        (logger/info (format "total_counter_atom ...")
                     {:total_counter_atom @total_counter_atom})))))


(defn process-api
  [ctx {:keys [threads metric_prefix duration_minutes] :as params}]
  (let [curr_epoch (utils/current-epoch)
        end_epoch (+ curr_epoch (* duration_minutes 60 1000))]
    (when (and (number? threads)
               (> threads 0))
      (logger/info (format "Metric prefix=[%s] , Formatted-times : "
                           metric_prefix)
                   {:start (utils/epoch->formatted-time curr_epoch)
                    :end (utils/epoch->formatted-time end_epoch)})
      (dotimes [i threads]
        ;; spawn new thread
        (future
          (start-a-thread ctx
                          (merge params
                                 {:thread_id i
                                  :total_counter_atom (atom 0)})))))
    {:status 200
     :body {:message "Processing started"}}))