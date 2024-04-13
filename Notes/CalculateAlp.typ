#import "@preview/quill:0.2.1": *
#import "@preview/physica:0.9.2": ket
#import "@preview/ctheorems:1.1.2": thmrules, thmbox, thmplain, thmproof
#import "@preview/commute:0.2.0": node, arr, commutative-diagram


#import "template.typ": project
#import "src/Notations.typ": ii, id, supvec, supbra, longSpace


#show: project.with(
  title: "Calculate " + $alpha$,
  authors: (
    "Bian Kaiming",
  ),
  lang: "en",
)

#show:  thmrules.with(qed-symbol: $square$)

#let lemma = thmbox("theorem", "Lemma", fill: rgb("#EBFFFF"))
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#E0F7F7"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))

#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")





= The tensor and the vector space



#let Todd = $T^(("o"))$
#let Teven = $T^(("e"))$
Let $Todd $ be the odd layer of T gates, and #Teven be the even layer of T gates. Then we have the following circuits:

#let group = gategroup.with(stroke: (dash: "dotted", thickness: .8pt))

#let Todd_circuit = {
  quantum-circuit(
    1, group(6,1, label:(content: Todd, pos: bottom))  ,  2, [\ ], 
    1, mqgate($space.quad$, n:2), 1, [\ ],
    3, [\ ],
    1, mqgate($space.quad$, n:2), 1, [\ ],
    3, [\ ],
    3, 
  )
}
#let Teven_circuit = {
  quantum-circuit(
    1, group(6,1, label:(content: Teven, pos: bottom))  ,  
    mqgate($space.quad$, n:2), 1, [\ ], 
    3, [\ ],
    1, mqgate($space.quad$, n:2), 1, [\ ],
    3, [\ ],
    1, mqgate($space.quad$, n:2), 1, [\ ],
    3, [\ ], 
  )
}
#figure(grid(
  columns: 2,
  gutter: 40pt,

  
  Todd_circuit, Teven_circuit

))

Now, alternately apply the odd and even layers of T gates to the $supvec(gamma_1 gamma_(2n))$
$
T^(("whole"))(b_1, t) =  Todd^(b_2) (product_(i = 0)^(t-b_2) Teven Todd)Teven^(b_1),
$
where $b_1, b_2 in {0,1}$, $t + b_1$ stands for the number of layers. 
The output states must in the vector space spaned by the following basis
//  $"span"{T^d supvec(gamma_1 gamma_(2n)) bar.v  d in ZZ} $. The basis of this vector space are
$
supvec(Z_i), space.quad supvec(X_i (product_(k = i+1)^(j-1) Z_k) Y_j )
$

Let $M_i = 1/sqrt(2) ( X_i + Y_i) $, the space
$
V := "span"{supvec(Z_i), space supvec(M_i (product Z_k) M_j )}
$
is the image subspace for all $T^(("whole"))(b_1, t)$ with $ b_1+t >0$ if the input state is limit to $Gamma_2$. Thus, the action of $T^(("whole"))(b_1, t)$ could always be written in the following form
$
T^(("whole"))(b_1, t) supvec(gamma_1 gamma_(2n)) = sum P(i,i, t) supvec(Z_i) + sum_(i<j) P(i,j,t) supvec(M_i (product Z_k) M_j ). 
$
The action of the tensor could be simplified by studying the coefficients $P(i,j,t)$.
// $
// T^(("whole"))(b_1, t) supvec(gamma_1 gamma_(2n)) = sum P(i,j,t) 
// $


= Propagator
To simplify the discussion, we start with a special case: $b_1 = 1, b_2 = 0$, and the number of wires is an even number $2N$. In this case, the whole tensor $T^(("whole"))$ could be written as
$
T^(("whole"))(1, t) = lr(( Teven Todd )^t) Teven.
$
Then, we lift the $V$ into the space of the second order 2N-dimensional polynomials
$
W := "span"{sum_(i,j = 1)^(2N) c_(i,j)x_i x_j }
$
We can prove that the space $V$ is isometric to the space $W$ by $phi.alt$, 
$
phi.alt : V ->& W\
 supvec(M_i (product Z_k) M_j ) ->& x_i x_j \
  supvec(Z_i) ->& x_i^2 .
$

#let Tp2n = $T_p^((2N))$
#let Tpn = $T_p^((N))$

Let $Tp2n(t)$ be the map $phi.alt  T^(("whole"))(1, t) phi.alt^(-1)$, the following diagram commutes.

#align(center)[#commutative-diagram(
  node((0, 0), $V$),
  node((0, 2), $V$),
  node((1, 0), $W$),
  node((1, 2), $W$),
  arr((0,0), (0,2), $T^(("whole"))(1,t)$),
  arr((0,0), (1,0), $phi.alt$),
  arr((0,2), (1,2), $phi.alt$),
  arr((1,0), (1,2), $Tp2n (t)$),
)]

Now, let's consider the action of the tensor $Tp2n(t)$ on the space $W$. Similarly, we could write down the recursive relation of coefficients $a_(i,j)$. 


// Apply operator #Teven to any state $sum c_i c'_j x_i x_j$, the result is
// $
// Teven sum c_i c'_j x_i x_j = sum_k c_(2k-1)c'
// $


When $t=0$, the transforming state $Teven supvec(gamma_1 gamma_(4N))$ to $W$, and we got $1/4(x_1 x_(2N) + x_1 x_(2N-1) + x_2 x_(2N) + x_1 x_(2N-1))$.
Suppose at $t$, the vector in $W$ is $sum c_i (t) c'_j (t) x_i x_j$, 
$
&Tp2n (t+1) (1/4(x_1 x_(2N) + x_1 x_(2N-1) + x_2 x_(2N) + x_1 x_(2N-1))) \
=& Teven Todd Tp2n (t) (1/4(x_1 x_(2N) + x_1 x_(2N-1) + x_2 x_(2N) + x_1 x_(2N-1))) \
=& Teven Todd  sum c_i (t) c'_j (t) x_i x_j \
$




// Observe that at any time $t$, the coefficients $c_(2i-1) (t)$ and $c_(2i) (t)$ are
Then, the action of  $space phi.alt  space.quarter Teven Todd phi.alt^(-1)$ on this vector is

// #align(center)[
//   #table(
//     // columns: (auto, 70pt, 70pt, 70pt),
//     columns: 4,
//   table.header($phi.alt  space.quarter Teven Todd phi.alt^(-1)$,
//   $i=j$, $|i-j| =1$, $|i-j| >1$ ),
//   $c_i c_j x_i x_j$,
//   $1/6 (c_i x_i + c_(i + eta)x_(i+eta) )$
// )
// ]
#figure(
  table(
    // columns: (auto, 70pt, 70pt, 70pt),
    columns: (auto, auto),
    inset: 14pt,
    align: (horizon, left),
  table.header(
    $c_i c'_j x_i x_j$, 
    $space phi.alt  space.quarter Teven Todd phi.alt^(-1) (c_i c'_j x_i x_j)$
    ),

  [$i=j=1$ ] ,
  $1/6 (c_1 x_1 + c_1 x_2 )(c'_2x_1 + c'_2 x_2 )$,
  [$i = 1, j =2, 3$],
  $1/8 (c_1 x_1 + c_1 x_2 )(4/3 c'_2x_1 + 4/3 c'_2 x_2 + c'_2x_3 + c'_2x_4)$,
  [$i = 1, j >3$],
  $1/8 (c_1 x_1 + c_1 x_2 )(c'_j x_(j-2+eta_j) + c'_j x_(j-1+eta_j) + c'_j x_(j+eta_j) + c'_j x_(j+1+eta_j))$,

  [$1<i<2N$, \ $ i=j$],
  $1/24 (c_i x_(i-2+eta_i) + c_i x_(i-1+eta_i)+ c_i x_(i+eta_i) + c_i x_(i+1+eta_i) ) \
  (c'_j x_(j-2+eta_j) + c'_j x_(j-1+eta_j)+ c'_j x_(j+eta_j) + c'_j x_(j+1+eta_j) ) \
  -1/72  (c_i x_(i-2+eta_i) + c_i x_(i-1+eta_i)) (c'_j x_(j-2+eta_j) + c'_j x_(j-1+eta_j)) \
  -1/72  (c_i x_(i+eta_i) + c_i x_(i+1+eta_i)) (c'_j x_(j+eta_j) + c'_j x_(j+1+eta_j)) $,

  [$1<i<2N$, \ $i$ is even, \ $j = i+1$],
  $1/12 (c_i x_(i-2+eta_i) + c_i x_(i-1+eta_i)+ c_i x_(i+eta_i) + c_i x_(i+1+eta_i) ) \
  (c'_j x_(j-2+eta_j) + c'_j x_(j-1+eta_j)+ c'_j x_(j+eta_j) + c'_j x_(j+1+eta_j) ) \
  -1/36  (c_i x_(i-2+eta_i) + c_i x_(i-1+eta_i)) (c'_j x_(j-2+eta_j) + c'_j x_(j-1+eta_j)) \
  -1/36  (c_i x_(i+eta_i) + c_i x_(i+1+eta_i)) (c'_j x_(j+eta_j) + c'_j x_(j+1+eta_j)) $,

  [$1<i<2N$, \ $ i+eta_i <= j <= i+eta_i+2 $],
  $1/16   (c_i x_(i-2+eta_i) + c_i x_(i-1+eta_i)+ c_i x_(i+eta_i) + c_i x_(i+1+eta_i) ) \
  (c'_j x_(j-2+eta_j) + c'_j x_(j-1+eta_j)+ c'_j x_(j+eta_j) + c'_j x_(j+1+eta_j) ) \
  +  1/48 (c_i x_(i+eta_i) + c_i x_(i+1+ eta_i) )(c'_j x_(j-2+eta_j) + c'_j x_(j-1+eta_j))  $ ,

  [$1<i<2N$, \ $j >i+eta_i+2$],
   $1/16   (c_i x_(i-2+eta_i) + c_i x_(i-1+eta_i)+ c_i x_(i+eta_i) + c_i x_(i+1+eta_i) ) \
  (c'_j x_(j-2+eta_j) + c'_j x_(j-1+eta_j)+ c'_j x_(j+eta_j) + c'_j x_(j+1+eta_j) )$,


  [$i = j = 2N$],
  $1/6 (c_(2N) x_(2N-1) + c_(2N) x_(2N) )(c'_(2N)x_(2N-1) + c'_(2N) x_(2N) )$,
),
caption: [The action of the tensor $phi.alt  space.quarter Teven Todd phi.alt^(-1)$ on the space of second order 2N-dimensional polynomials.]
)<table:Tp2N>

We can see that, $c_(2i-1)$ and $c_(2i)$ are always the same. So do $c'_(2j-1)$ and $c'_(2j)$. Let $b_i = 2c_(2i-1) = 2c_(2i)$ and $b'_j = 2c'_(2j-1) = 2c'_(2j)$, we could further simplify the action of the tensor in the space of second order N-dimensional polynomials $W_N$. 
For simplemess, we define a "free" recursive relation in $W_N$
//  we define a operator $S$ on first order N-dimensional polynomials space
$
P( i, t+1) = cases(
  1/4 (P(i-1, t) + 2 P(i, t) + P (i+1, t) ) ", " i eq.not 1 "or" N ,
  1/4 (P(i-1, t) + 2 P(i, t) + P (i+1, t))
).
$<eq:free_recursive_equation>

We call it "free" because $b_i (t) b'_j (t) = P(i ,t) P(j, t)  $ if $i$ and $j$ are not "collide" with each other (which means $|i-j|>3$). And the solution of Eq. @eq:free_recursive_equation is a propagating wave. Refs. @giuggioli2020exact provide the solution of this equation,

// #let pik = $ (pi) $
$
P_(n_0)(n, t) = 1/N + 2/N sum_(k = 1)^(N-1) cos((n-1/2) (pi k )/N) cos((n_0 - 1/2) (pi k )/N)cos^(2t)(pi k )/ (2N),
$<eq:propagator>
where $n_0$ is the initial state. The term $P_(n_0)(n, t)$ also called the propagator.

For our case, there are 2 propagators, which are $P_1$ and $P_N$. And the initial state is $x_1x_N$. Let $phi.alt()$




Now, let's pluge $b_i = 2c_(2i-1) = 2c_(2i)$ and $b'_j = 2c'_(2j-1) = 2c'_(2j)$ into  @table:Tp2N. More concretely, let $phi.alt'$ be the map 
$
phi.alt': W_(N) -> W_(2N) \
y_i y_j  -> 1/4(x_(2i-1)+ x_(2i))(x_(2j-1)+ x_(2j)).  
$
If we consider the subspace $W'_(2N)$ of $W_(2N)$, where $W'_(2N) := "span"((x_(2i-1)+ x_(2i))(x_(2j-1)+ x_(2j))) $ (it means $c_(2i-1) = c_(2i)$ and $c'_(2j-1) = c'_(2j)$), the   $phi.alt'$ will be the isometric between $W_(N)$ and $W'_(2N)$. Thus, the following diagram commutes.

#let Wsub = $W'_(2N)$
#align(center)[#commutative-diagram(
  node((0, 0), $V$),
  node((0, 2), $V$),
  node((1, 0), Wsub),
  node((1, 2), Wsub),
  node((2, 0), $W_N$),
  node((2, 2), $W_N$),
  arr((0,0), (0,2), $T^(("whole"))(1,t)$),
  arr((0,0), (1,0), $phi.alt$, options: "bij"),
  arr((0,2), (1,2), $phi.alt$, options: "bij"),
  arr((1,0), (1,2), $Tp2n(t)$),
  arr((1,0), (2,0), $phi.alt'$, options: "bij"),
  arr((1,2), (2,2), $phi.alt'$, options: "bij"),
  arr((2,0), (2,2), $Tpn(t)$),
)]


Then we get
#align(center)[
  #table(
    columns: (auto, auto),
    align: center,
    table.header([$y_i, y_j$], [$Teven Todd$]),

    [$i=j=1$],
    $$


)
]


// Because $T_p(t)(x_i x_j) =  T_p(t)(x_i x_j)   $, we only list the result of $i<=j$. 
// $
//  phi.alt  space.quarter Teven Todd phi.alt^(-1) (sum c_i c_j x_i x_j)
// $


// #lemma("Euclid")[
//  There are infinitely many primes. 21312
// ] <euclid>





// Then, we could rewrite the action of the tensor as recursive relation
// $
// T^(("whole"))(0, t+1) supvec(gamma_1 gamma_(2n)) 
// = &  Teven Todd lr(( Teven Todd )^t) supvec(gamma_1 gamma_(2n)) \
// supbra(Z_i)  T^(("whole"))(0, t+1) supvec(gamma_1 gamma_(2n)) 
// = &  supbra(Z_i) Teven Todd [lr(( Teven Todd )^t) supvec(gamma_1 gamma_(2n))] \
// P(i,i,t+1) = &  supbra(Z_i) Teven Todd lr(( Teven Todd )^t) supvec(gamma_1 gamma_(2n)) \

// $
// By take the 

// Now, we want to add more structure to this vector space, but it is hard to directly add more structure to $V$. Thus, we define another vector space, and analysis the behavior of similar tensor on this vector space. Then, we shift result back to $V$. 

// The new space we focus on is the space of N-dimensional polynomials. We define the spread operator $S$ as
// $
// S(x_i) = 1/4 (x_(i-1) + 2 x_i + x_(i+1))
// $


= Proofs

#proof([of ])[
  The latest layer of T gates is #Teven, which behaves 
$
  Teven &supvec(M_(2i+c) (product Z_k) M_(2j+c') )\
 = 1/4 lr(( 
    &supvec(M_(2i+(-1)^(1-c)) (product Z_k) M_(2j+(-1)^(1-c')) ) + supvec(M_(2i+(-1)^(1-c)) (product Z_k) M_(2j+c') ) \
    + &supvec(M_(2i+c) (product Z_k) M_(2j+(-1)^(1-c')) ) + supvec(M_(2i+c) (product Z_k) M_(2j+c') )
  )), 
$
if $ 2j+c' > 2i+c+1$. $c$ and $c'$ are the parity of the input state, which take the value $0$ or $1$. Similarly, we write down the output of #Teven in the other cases
$
Teven supvec(M_(2i+c)M_(2i+1+c)) = cases(
  1/4 lr((
    supvec(M_(2i)M_(2i+1)) + supvec(M_(2i-1)Z_i M_(2i+1))\ 
    space.quad supvec(M_(2i)Z_(i+1) M_(2i+2)) + supvec(M_(2i-1)Z_i Z_(i+1) M_(2i+2))
  )) ", "  space c = 0,
  1/3 supvec(Z_(2i+1)) + 1/3 supvec(Z_(2i+2)) + 1/3 supvec(M_(2i+1)M_(2i+2))
)
$
]



#bibliography("refs.bib")