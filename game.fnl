
(local grid-size 50)
(local cell-size 10)

(fn new-grid []
  (var g [])
  (for [x 1 grid-size]
    (var row [])
    (for [y 1 grid-size]
      (tset row y (> (love.math.random) 0.8)))
    (tset g x row))
  g)

(var current-grid (new-grid))
(var paused true)
(var step-next false)

(fn count-neighbors [g x y]
  (var count 0)
  (for [dx -1 1]
    (for [dy -1 1]
      (when (not= dx 0 dy 0)
        (let [nx (+ x dx)
              ny (+ y dy)]
          (when (and (>= nx 1) (<= nx grid-size)
                     (>= ny 1) (<= ny grid-size))
            (let [row (. g nx)]
              (when (and row (. row ny))
                (set count (+ count 1)))))))))
  count)

(fn next-gen [g]
  (var new-g [])
  (for [x 1 grid-size]
    (var row [])
    (for [y 1 grid-size]
      (let [alive? (. (. g x) y)
            neighbors (count-neighbors g x y)
            new-state (or
                        (and alive? (or (= neighbors 2) (= neighbors 3)))
                        (and (not alive?) (= neighbors 3)))]
        (tset row y new-state)))
    (tset new-g x row))
  new-g)

(fn love.update [dt]
  (when (or (not paused) step-next)
    (set current-grid (next-gen current-grid))
    (set step-next false)))

(fn love.draw []
  (love.graphics.setBackgroundColor 0 0 0)
  (love.graphics.setColor 1 1 1)
  (for [x 1 grid-size]
    (for [y 1 grid-size]
      (when (. (. current-grid x) y)
        (love.graphics.rectangle "fill"
          (* (- x 1) cell-size)
          (* (- y 1) cell-size)
          cell-size
          cell-size))))
  ;; Show status
  (love.graphics.setColor 1 1 0)
  (love.graphics.print (if paused "Paused" "Running") 10 10))

(fn toggle-cell [x y]
  (let [gx (+ 1 (math.floor (/ x cell-size)))
        gy (+ 1 (math.floor (/ y cell-size)))]
    (when (and (>= gx 1) (<= gx grid-size)
               (>= gy 1) (<= gy grid-size))
      (let [row (. current-grid gx)]
        (tset row gy (not (. row gy)))))))

(fn love.mousepressed [x y button]
  (when (= button 1) ;; left click
    (toggle-cell x y)))

(fn love.keypressed [key scancode isrepeat]
  (match key
    "space" (set paused (not paused))
    "n"     (set step-next true)
    _ nil))
