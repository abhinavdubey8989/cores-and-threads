(ns cores-and-threads.service
  (:require [cores-and-threads.logger :as logger]
            [cores-and-threads.utils :as utils]))


(defn do-work
  [{:keys [input_num
           times]}]
  (dotimes [_ times]
    (Math/sqrt input_num)))


(defn run-gc
  [ctx {:keys [force_gc?]}]
  (let [utilization (utils/heap-utilization)]
    (when (or force_gc?
              (> (utils/heap-utilization)
                 (get-in ctx [:gc :threadhold-ratio])))
      (logger/info "Running GC ..."
                   {:force_gc? force_gc?
                    :utilization utilization})
      (System/gc))))


(defn start-a-thread
  "Business logic to be executed by each thread"
  [ctx {:keys [thread_id
               metric_prefix
               duration_minutes
               input_num] :as params}]
  (let [hostname (utils/hostname)
        thread_name (.getName (Thread/currentThread))
        curr_epoch (System/currentTimeMillis)
        end_epoch (+ curr_epoch (* duration_minutes 60 1000))
        loop_counter (atom 0)]
    (try
      (loop []
        (let [curr_epoch (System/currentTimeMillis)
              diff (- end_epoch curr_epoch)]
          (if (> diff 0)
            (do
              (utils/wrap-statsd-time (format "%s.%s.%s"
                                              hostname
                                              (if (seq metric_prefix)
                                                metric_prefix
                                                "work")
                                              (str "thread-" thread_id))
                                      (do (run-gc ctx {:force_gc? false})
                                          (do-work params)))
              (swap! loop_counter inc)
              (recur))
            (logger/info (format "Done work : [%s] times, th-name : [%s]"
                                 @loop_counter
                                 thread_name)
                         {:hostname hostname
                          :input_num input_num
                          :thread_name thread_name
                          :thread_id (inc thread_id)}))))
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
        (run-gc ctx {:force_gc? true})))))


(defn process-api
  [ctx {:keys [threads duration_minutes] :as params}]
  (when (and (number? threads)
             (> threads 0))
    (logger/info (format "Starting work for [%s] minutes with [%s] threads"
                         duration_minutes
                         threads)
                 {:params params
                  :ctx ctx})
    (dotimes [i threads]
      ;; spawn new thread
      (future
        (start-a-thread ctx
                        (merge params
                               {:thread_id i})))))
  {:status 200
   :body {:message "Processing started"}})