

(ns cores-and-threads.routes
  (:require [compojure.core :as cc :refer [GET POST defroutes]]
            [compojure.route :as route]))

(defroutes app-routes
  (GET "/" [] "Welcome to Clojure REST API!")
  (GET "/hello/:name" [name] (str "Hello, " name "!"))
  (POST "/echo" req
    (str "You posted: " (slurp (:body req))))
  (route/not-found "Not Found"))
