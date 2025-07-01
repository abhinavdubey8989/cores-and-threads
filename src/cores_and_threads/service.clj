(ns cores-and-threads.service
  (:require [clj-statsd :as statsd]
            [cores-and-threads.logger :as logger]))


(defn do-work
  "Business logic to be executed by each thread"
  [{:keys [thread_id
           machine_type
           metric_prefix
           duration_minutes
           input_num]}]
  (let [curr_epoch (System/currentTimeMillis)
        end_epoch (+ curr_epoch (* duration_minutes 60 1000))]
    (loop [loop-counter 0]
      (let [curr_epoch (System/currentTimeMillis)
            diff (- end_epoch curr_epoch)]
        (if (> diff 0)
          (do (Math/sqrt input_num)
              (statsd/increment (format "%s.%s.success.%s"
                                        machine_type
                                        metric_prefix
                                        (str "thread-" thread_id)))
              (recur (inc loop-counter)))
          (logger/info (format "Done work for %s minutes"
                               duration_minutes)
                       {:machine_type machine_type
                        :input_num input_num
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
        (do-work (merge params
                        {:thread_id i})))))
  {:status 200
   :body {:message "Processing started"}})