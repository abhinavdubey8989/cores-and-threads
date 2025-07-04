

(ns cores-and-threads.routes
  (:require [compojure.core :as cc :refer [GET POST defroutes]]
            [compojure.route :as route]
            [cores-and-threads.service :refer [process-api]]))


(defroutes app-routes
  (POST "/api/foo-bar" req (process-api (:ctx req)
                                        (:body req)))
  (route/not-found "Not Found"))
