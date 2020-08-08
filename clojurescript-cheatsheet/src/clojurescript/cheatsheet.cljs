;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic types
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Keyword - Evaluate to itself
:ok
;; Namespaced keyword
::ok

;; Symbol - Evaluate to something else
(def ok "not okay")
ok

;; Characters
\a

;; Lists - ' Single quote is only necessary when standalone
;; very efficient if you access them sequentially or access their first elements
'(5 4 3 2 1)
(def a-list '(5 4 3 2 1))
(list 5 4 3 2 1)

;; Vectors - very efficient index access to their elements
[:a :b :c :d]
(vector :d :c :b :a)
(nth [0 1 2 3] 3)
(vector? [1 2 3])
(assoc ["eins" "zwei" "three"] 2 "drei") ;; => ["eins" "zwei" "drei"]
(["eins" "zwei" "drei"] 2) ;; => "drei"

;; Maps
{:name "Bob", :age 27}
({:name "Bob", :age 27} :name)
(hash-map :name "Bob")
(conj {:name "Alice"} [:age 27]) ;; => {:name "Alice", :age 27}
(assoc {:age 27} :age 30) ;; => {:age 30}
(dissoc {:age 27} :age) ;; => {}
({:age 27} :age) ;; => 27
(keys {:age 27}) ;; => (:age)

;; Sets - store zero or more unique items of any type and are unordered
#{:x :y :z}
(require '[clojure.set :as s])
(s/difference #{1 2} #{2 3})
(s/union #{1 2} #{2 3})
(s/intersection #{1 2} #{2 3}) ;; => #{2}
;; Use set as a set as a function
;; Prints out every number from the second set
;; thai is in the first set
(run! println (filter #{1 2 3} #{1 3}))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(fn [param-1 param-2]
  (* param-1 param-2))

((fn [x y]
   (* x y)) 5 6)

;; Let's assign it to a symbol
(def halve (fn [x] (/ x 2)))
(halve 10)

;; Now with defn macro and doc string
(defn quarter
  "Quarters a number"
  [x]
  (/ x 4))

;; Multiple arities
(defn power
  ([x] (* x x))
  ([x n] (loop [r x f n]
           (if (= f 1)
             r
             (recur (* r x) (- f 1))))))

;; Variadic functions
(defn print-&-set
  [& params]
  (println params)
  (set params))
(print-&-set  [1 2 3 4])

;; Short syntax for anonymous functions
(def div #(/ %1 %2))
(div 10 5)

(def pow #(* % %))
(pow 5)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Others
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Locals
(require '[clojure.string :as string])
(let [name "Bob"
      other-name "Alice"]
  (println (string/join ["Hello " name " and " other-name])))

;; blocks - do expression and are usually used for side effects
;; accepts arbitrary number, but returns only the last one
(do
  (+ 1 2)
  (- 30 15)
  "This will be returned")

;; Loop
(loop [r 10 f 3]
  (if (= f 1)
    r ;; if f == 1 will break the loop
    (recur (* r 10) (- f 1))))
;; => 1000


;; destructing
(defn swap-and-forget-the-rest
  [[second first & _rest :as original]] {:new [first second] :source original})
(swap-and-forget-the-rest [1 2 3 4]) ;; => {:new [2 1], :source [1 2 3 4]}
;; With associative data
(defn extract-name [{name :name}] (println name))
(extract-name {:name "Alice" :age 33}) ;; => Alice
;; Alternative
(defn extract-name [{:keys [name age]}]
  [name age]) ;; :keys, :strs, :syms
(extract-name {:name "Alice" :age 33}) ;; => ["Alice" 33]


;; Threading marcros
;; https://www.spacjer.com/blog/2015/11/09/lesser-known-clojure-variants-of-threading-macro/
(defn power [x] (* x x)) ;; Just for example
;; thread-first "->"
(-> 2
    power
    power
    power) ;; => 256
;; thread-last "->>"
(->> 2
    (/ 50)
    (/ 625)
    (/ 50)) ;; => 2
;; thread-as "as->"
(as-> 2 $
  (* $ $)
  (/ 16 $)
  (- $ 2)) ;; => 2
;; thread-cond "cond->" or "cond->>"
(defn foo [x]
  (cond->> x
    (pos? x) (/ 10)
    (pos? x) (- 20)))
(foo 2)  ;; => 15
(foo -2) ;; => -2
(foo 0)  ;; => 0
