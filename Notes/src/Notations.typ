// ---------- math ------------

#let ii = math.sans("i")

#let id = math.bb("1")

// ---------- quantum information ------------

#let supvec(m) = $lr(| #m angle.r.double )$

#let supbra(m) = $lr(angle.l.double #m | )$



// ---------- spacing ------------

#let longSpace = $space.quad space.quad$