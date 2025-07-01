(ns cores-and-threads.core
  (:require [clj-statsd :as statsd]
            [clojure.edn :as edn]
            [clojure.java.io :as io]
            [cores-and-threads.routes :refer [app-routes]]
            [nrepl.server :as nrepl]
            [ring.adapter.jetty :refer [run-jetty]]
            [ring.middleware.defaults :refer [wrap-defaults api-defaults]]
            [ring.middleware.json :refer [wrap-json-body wrap-json-response]]
            [cores-and-threads.logger :as logger]
            [cores-and-threads.utils :as utils])
  (:gen-class))


(def config
  (-> (if (seq (System/getenv "CONFIG_FILE"))
        (do (println "reading from system env")
            (System/getenv "CONFIG_FILE"))
        (do (println "using default-config-path : " utils/default-config-path)
            (str utils/default-config-path
                 "/"
                 utils/default-config-file)))
      io/reader
      slurp
      edn/read-string))


(defn wrap-ctx
  [handler config]
  (fn [request]
    (handler (assoc request :ctx config))))


(def app
  (-> app-routes
      (wrap-ctx config)
      (wrap-json-body {:keywords? true})
      (wrap-json-response)
      (wrap-defaults api-defaults)))


(let [nrepl-started? (atom false)]
  (defn start-nrepl-server
    "Start an nREPL server"
    [& {:keys [port] :or {port 6066}}]
    (when-not @nrepl-started?
      (nrepl/start-server :bind "0.0.0.0" :port port)
      (reset! nrepl-started? true)
      (println "Started nREPL server on localhost:" port))))


(defn- setup
  []
  (statsd/setup (get-in config [:statsd :host])
                (get-in config [:statsd :port]))
  (logger/setup-logger! (format "%s/%s"
                                (get-in config [:log-config :dir])
                                (get-in config [:log-config :file-name])))
  (logger/info "Setup completed ..." config))


(defn -main
  [& args]
  (setup)
  (run-jetty app {:port (get-in config [:service :port])
                  :join? false})
  (start-nrepl-server {:port (get-in config [:service :repl-port])}))
