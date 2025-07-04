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


(defn epoch->formatted-time
  [epoch-millisec]
  (let [format (doto (java.text.SimpleDateFormat. "yyyy-MM-dd HH:mm:ss")
                 (.setTimeZone (java.util.TimeZone/getTimeZone "Asia/Kolkata")))]
    (.format format (java.util.Date. epoch-millisec))))


(defn within-percent?
  "Returns boolean value if a random-number b/w 1-100 is less than target-percent arg"
  [ctx target-percent]
  (<= (inc (rand-int 100))
      (if (int? target-percent)
        target-percent
        (get-in ctx [:service :print-percent]))))


(defn thread-name
  "Return current thread name"
  []
  (.getName (Thread/currentThread)))


(defn current-epoch
  "Returns epoch in milliseconds"
  []
  (System/currentTimeMillis))