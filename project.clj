(defproject cores-and-threads "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "EPL-2.0 OR GPL-2.0-or-later WITH Classpath-exception-2.0"
            :url "https://www.eclipse.org/legal/epl-2.0/"}
  :dependencies [[org.clojure/clojure "1.11.1"]
                 [clj-statsd "0.4.2"]
                 [cheshire "5.11.0"]
                 [com.taoensso/timbre "6.3.1"]
                 [compojure "1.7.0"]
                 [nrepl/nrepl "0.9.0"]
                 [org.clojure/tools.logging "1.3.0"]
                 [ring/ring-json "0.5.1"]
                 [ring/ring-defaults "0.3.4"]
                 [ring/ring-jetty-adapter "1.9.6"]]
  :main ^:skip-aot cores-and-threads.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all
                       :jvm-opts ["-Dclojure.compiler.direct-linking=true"]}})
