(ns cores-and-threads.utils
  (:require [clj-statsd :as statsd])
  (:import [java.io BufferedReader InputStreamReader]
           [java.lang.management ManagementFactory]))



(def default-config-path "/Users/abhinav.dubey/Documents/ad/cores-and-threads/resources")
(def default-config-file "config-local.edn")


(defmacro wrap-statsd-time
  [datapoint & body]
  `(statsd/with-timing ~datapoint ~@body))


(defn heap-utilization
  "Returns the current JVM heap utilization percentage (1-100)"
  []
  (let [mem (ManagementFactory/getMemoryMXBean)
        heap (.getHeapMemoryUsage mem)
        used (double (.getUsed heap))
        max (double (.getMax heap))]
    (int (Math/ceil (* 100 (/ used max))))))


(defn hostname
  []
  (-> (Runtime/getRuntime)
      (.exec "hostname")
      .getInputStream
      (InputStreamReader.)
      (BufferedReader.)
      .readLine))
