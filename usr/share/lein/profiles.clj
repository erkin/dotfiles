{:user {:plugins [[jonase/eastwood "0.3.5"]
                  [lein-bikeshed "0.5.2"]
                  [lein-kibit "0.1.6"
                   :exclusions [org.clojure/tools.namespace]]
                  [cider/cider-nrepl "0.22.0-beta1"]
                  [nrepl/lein-nrepl "0.3.2"
                   :exclusions [commons-codec
                                commons-io
                                org.clojure/tools.logging]]
                  [venantius/yagni "0.1.7"
                   :exclusions [org.clojure/clojure
                                org.clojure/tools.namespace]]]}}
