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

;; Maps
{:name "Bob", :age 27}
({:name "Bob", :age 27} :name)

;; Sets - store zero or more unique items of any type and are unordered
#{:x :y :z}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(fn [param-1 param-2]
  (* param-1 param-2))

((fn [x y]
   (* x y)) 5 6)

;; Let's assign it to a symbol
(def halve (fn [x](/ x 2)))
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

(def pow #(* % % ))
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
