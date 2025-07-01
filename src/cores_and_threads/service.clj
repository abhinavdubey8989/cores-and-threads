(ns cores-and-threads.service
  (:require [clj-statsd :as statsd]
            [cores-and-threads.logger :as logger]))


(defmacro wrap-statsd-time
  [datapoint & body]
  `(statsd/with-timing ~datapoint ~@body))


(defn do-work
  [{:keys [input_num
           times]}]
  (dotimes [_ times]
    (Math/sqrt input_num)))


(defn start-a-thread
  "Business logic to be executed by each thread"
  [{:keys [thread_id
           machine_type
           metric_prefix
           duration_minutes
           input_num] :as params}]
  (let [thread_name (.getName (Thread/currentThread))
        curr_epoch (System/currentTimeMillis)
        end_epoch (+ curr_epoch (* duration_minutes 60 1000))
        loop_counter (atom 0)]
    (logger/info (format "th-name : [%s]"
                         thread_name)
                 {})
    (loop []
      (let [curr_epoch (System/currentTimeMillis)
            diff (- end_epoch curr_epoch)]
        (if (> diff 0)
          (do
            (wrap-statsd-time (format "%s.%s.success.%s"
                                      machine_type
                                      metric_prefix
                                      (str "thread-" thread_id))
                              (do-work params))
            (swap! loop_counter inc)
            (recur))
          (logger/info (format "Done work : [%s] times, th-name : [%s]"
                               @loop_counter
                               thread_name)
                       {:machine_type machine_type
                        :input_num input_num
                        :thread_name thread_name
                        :thread_id (inc thread_id)}))))))


(defn process-api
  [{:keys [threads duration_minutes
           input_num machine_type] :as params}]
  (def p params)
  (when (and (number? threads)
             (> threads 0))
    (logger/info (format "Starting work for [%s] minutes with [%s] threads"
                         duration_minutes
                         threads)
                 {:machine_type machine_type
                  :input_num input_num})
    (dotimes [i threads]
      ;; spawn new thread
      (future
        (start-a-thread (merge params
                               {:thread_id i})))))
  {:status 200
   :body {:message "Processing started"}})