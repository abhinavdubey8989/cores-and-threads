(ns cores-and-threads.logger
  (:require [taoensso.timbre :as timbre]))


(defn setup-logger!
  [log-file-path]
  (timbre/merge-config!
   {:appenders
    {:spit (timbre/spit-appender {:fname log-file-path})}}))


(defn info
  [msg data]
  (timbre/info msg data))


(defn error
  [msg data]
  (timbre/error msg data))

