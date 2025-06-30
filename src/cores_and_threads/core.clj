(ns cores-and-threads.core
  (:require [ring.adapter.jetty :refer [run-jetty]]
            [ring.middleware.defaults :refer [wrap-defaults site-defaults]]
            [cores-and-threads.routes :refer [app-routes]])
  (:gen-class))

(def app
  (wrap-defaults app-routes site-defaults))

(defn -main [& args]
  (println "Starting server on port 3000...")
  (run-jetty app {:port 3000}))
