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


= Propagation in polynomials space
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
  arr((0,0), (1,0), $phi.alt$, "bij"),
  arr((0,2), (1,2), $phi.alt$, "bij"),
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
  $1/12 c_i c_j'(c_i x_(i-2+eta_i) + c_i x_(i-1+eta_i)+ c_i x_(i+eta_i) + c_i x_(i+1+eta_i) )^2 \
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


The subsript $eta_i$ is defined as $eta_i := 1 - (i mod 2)$.  We can see that, $c_(2i-1)$ and $c_(2i)$ are always the same. So do $c'_(2j-1)$ and $c'_(2j)$. Let $b_i = 2c_(2i-1) = 2c_(2i)$ and $b'_j = 2c'_(2j-1) = 2c'_(2j)$, we could further simplify the action of the tensor in the space of second order N-dimensional polynomials $W_N$. 
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
  arr((0,0), (1,0), $phi.alt$, "bij"),
  arr((0,2), (1,2), $phi.alt$, "bij"),
  arr((1,0), (1,2), $Tp2n(t)$),
  arr((1,0), (2,0), $phi.alt'$, "bij"),
  arr((1,2), (2,2), $phi.alt'$, "bij"),
  arr((2,0), (2,2), $Tpn(t)$),
)]
#let y1 = $y_1$
#let y2 = $y_2$
#let y3 = $y_3$
#let yi = $y_i$
#let yj = $y_j$

For simpliness, let 
$
F(y_i) = cases(
  3/4 y_1 + 1/4 y_2 ", " i = 1,
  1/4 y_(i-1) + 1/2 y_i + 1/4 y_(i+1) ", " 1<i<N,
  3/4 y_N + 1/4 y_(N-1) ", " i = N
)
$
Then we get
#figure(table(
    columns: (auto, auto),
    align: center,
    inset: 14pt,
    table.header([$y_i y_j$], [$Teven Todd$]),

    [$i=j=1$],
    $F(y_1)F(y_1)- 5/ 144 (y_1 + y_2)^2 + 1/36 y_1 y_2 $,

    [$i=1, j=2$],
    $F(y1) F(y2) + (5/144) (y1^2) + (1/24) y1 y2 + (1/72) (y2^2)$,

    [$i=1, j=3$],
    $F(y1) F(y3) + 1/48 y2^2$,

    // [$i=1, j>3$],
    // $F(y1) F(yj)$,


    [$1<i<N, j=i$],
    {
    let y0 = $y_(i-1)$
    let y1 = $y_i$
    let y2 = $y_(i+1)$
    $
    F(yi ) F(yi)   -5/144 y0^2 - 5/48 y0 y1 - 1/16 y0 y2 \
    - (1/9) (y1^2) - (5/48) y1 y2 - (5/144) (y2^2)
    $},


    [$1<i<N, j=i+1$],
    {
    let y0 = $y_(i-1)$
    let y1 = $y_i$
    let y2 = $y_(i+1)$
    let y3 = $y_(i+2)$
    $
    F(yi ) F(y2)  + 1/72 y1^2 + 1/24 y1 y2 + 1/72 y2^2
    $
    },

    [$1<i<N, j=i+2$],
    $
    F(yi ) F(y_(i+2)) + 1/48 y_(i+1)^2
    $,

    [$i= j=N$],
    $F(y_N)F(y_N)- 5/ 144 (y_N + y_(N-1))^2 + 1/36 y_(N-1) y_N $,

    [other cases when $i<=j$],
    $
    F(yi ) F(yj) 
    $,



))<table:TpN>

这个table的计算实在是太太太太太折磨人了。详细计算我放在了@section:proofs 中。


= The interaction term

let $b(i,j,t) = P_1 (i,t) P_N (j,t) + I(i,j,t)  $. Then, 
$
ket(psi(t)) = sum_(i,j) P_1 (i,t) P_N (j,t) yi yj + sum_(i,j) I(i,j,t) yi yj.
$<eq:interaction_state>
From simpleness, let the terms in @table:TpN be $F(y_i) F(y_j) + R(i,j)$. Then we get

$
ket(psi(t+1))
 =& sum_(i,j) P_1 (i,t) P_N (j,t) (F(yi) F(yj)+ R(i,j)) + sum_(i,j) I(i,j,t) (F(yi) F(yj)+ R(i,j))\
=&  sum_(i,j) P_1 (i,t+1) P_N (j,t+1) y_i y_j + sum_(i,j) P_1 (i,t) P_N (i,t) R(i,j) \
&+sum_(i,j) I(i,j,t) (F(yi) F(yj)+ R(i,j))
$

这里又又又为了简洁性， 定义 
$
F_f^((1)): "Func"(i,j,t) |->  cases(1/4 "Func"(i-1,j,t) + ... "if ...",  3/4 "Func"(i,j,t)+ ... "if i = 1" )\
F_f^((2)): "Func"(i,j,t) |->  cases(1/4 "Func"(i,j-1,t) + ... "if ...",  3/4 "Func"(i,j,t)+ ... "if j = 1" )
$  By using Eq. @eq:interaction_state to expand $ket(psi(t+1))$,  we have
$
I(i,j,t+1) &= (partial)/(partial y_i) (partial)/(partial y_j)lr( (sum_(i,j) P_1 (i,t) P_N (i,t) R(i,j) +sum_(i,j) I(i,j,t) (F(yi) F(yj)+ R(i,j))) ) \ 
&= F_f^((1))  (I)(i,j,t) F_f^((2))  (I)(i,j,t)
\ +& 
$

// from the @table:TpN, we get

#figure(table(
    columns: (auto, auto),
    align: center,
    inset: 14pt,
    table.header([$y_i y_j$], [$Teven Todd$]),

    [$i=j=1$],
    $F(y_1)F(y_1)- 5/ 144 (y_1 + y_2)^2 + 1/36 y_1 y_2 $,

    [$i=1, j=2$],
    $F(y1) F(y2) + (5/144) (y1^2) + (1/24) y1 y2 + (1/72) (y2^2)$,

    [$i=1, j=3$],
    $F(y1) F(y3) + 1/48 y2^2$,

    // [$i=1, j>3$],
    // $F(y1) F(yj)$,


    [$1<i<N, j=i$],
    {
    let y0 = $y_(i-1)$
    let y1 = $y_i$
    let y2 = $y_(i+1)$
    $
    F(yi ) F(yi)   -5/144 y0^2 - 5/48 y0 y1 - 1/16 y0 y2 \
    - (1/9) (y1^2) - (5/48) y1 y2 - (5/144) (y2^2)
    $},


    [$1<i<N, j=i+1$],
    {
    let y0 = $y_(i-1)$
    let y1 = $y_i$
    let y2 = $y_(i+1)$
    let y3 = $y_(i+2)$
    $
    F(yi ) F(y2)  + 1/72 y1^2 + 1/24 y1 y2 + 1/72 y2^2
    $
    },

    [$1<i<N, j=i+2$],
    $
    F(yi ) F(y_(i+2)) + 1/48 y_(i+1)^2
    $,

    [$i= j=N$],
    $F(y_N)F(y_N)- 5/ 144 (y_N + y_(N-1))^2 + 1/36 y_(N-1) y_N $,

    [other cases when $i<=j$],
    $
    F(yi ) F(yj) 
    $,



))<table:recursive>
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


= Proofs<section:proofs>

#proof([of @table:TpN])[
现在我们想要计算 $Tpn(t)$ 在$W_N$ 中的作用。因此我们需要计算 
$ 
 &phi.alt' phi.alt Teven Todd phi.alt^(-1) phi.alt'^(-1) (y_i y_j)\
=& phi.alt Teven Todd phi.alt^(-1) ( 1/4 (x_(2i-1)+ x_(2i)) (x_(2j-1)+ x_(2j))) \
=& phi.alt Teven Todd phi.alt^(-1) ( 1/4 (x_(2i-1)x_(2j-1)+x_(2i-1)x_(2j)+ x_(2i)x_(2j-1) +x_(2i)x_(2j)))
$
相当于对于每一个 $x_(2i-1)x_(2j-1)$ 这样的项进行查表。我们现在来分析不同的y的映射。为了简化符号，这里记 $S_N = phi.alt' phi.alt Teven Todd phi.alt^(-1) phi.alt'^(-1)$, $S_(2N) = phi.alt Teven Todd phi.alt^(-1)$.

$
phi.alt' (y_1 y_1) =& 1/4 (x_1x_1 + 2x_1x_2 + x_2x_2) \
S_N (y_1y_1) = & 1/4 (S_(2N)(x_1x_1) + S_(2N) ( 2x_1x_2) + S_(2N)(x_2x_2)) \
$

依据 @table:Tp2N, 我们有

$
S_N (y_1y_1) = & 1/4 lr((\
  &longSpace 1/6  ( x₁ +x₂)  (x₁ + x₂) + \
  &longSpace (1/4)((4/3)x₁ + (4/3)x₂ + x₃ + x₄)(x₁ + x₂) + \ 
  &longSpace -(1/72)((x₁ + x₂)^2) + (1/24)((x₁ + x₂ + x₃ + x₄)^2) - (1/72)((x₃ + x₄)^2)\
))  \
// =& (19/36)(x₁^2) + (19/18)x₁x₂ + (1/3)x₁x₃ + (1/3)x₁x₄ \
// &+ (19/36)(x₂^2) + (1/3)x₂x₃ + (1/3)x₂x₄ \
// &+ (1/36)(x₃^2) + (1/18)x₃x₄ + (1/36)(x₄^2)
&(19/144)(x₁^2) + (19/72)x₁x₂ + (1/12)x₁x₃ + (1/12)x₁x₄ \
&+ (19/144)(x₂^2) + (1/12)x₂x₃ + (1/12)x₂x₄ \
&+ (1/144)(x₃^2) + (1/72)x₃x₄ + (1/144)(x₄^2)

$

我们想要和“自由演化”进行对比。而 $y_1 y_1$ 自由演化的结果是
$
F(y_1 y_1) = & 1/16 ( 3 y_1+ y_2) ( 3 y_1+ y_2) \
= & 1/16 (
 3/2 x_1 + 3/2 x_2 + 1/2 x_3 + 1/2 x_4) (3/2 x_1 + 3/2 x_2 + 1/2 x_3 + 1/2 x_4) \
= & (9/64)(x₁^2) + (9/32)x₁x₂ + (3/32)x₁x₃ + (3/32)x₁x₄ \
&+ (9/64)(x₂^2) + (3/32)x₂x₃ + (3/32)x₂x₄ + (1/64)(x₃^2)\
& + (1/32)x₃x₄ + (1/64)(x₄^2)
$

二者之差为
$
S_N (y_1y_1) - F(y_1 y_1)=
&-(5/576)(x₁^2) - (5/288)x₁x₂ - (1/96)x₁x₃ - (1/96)x₁x₄ \
&- (5/576)(x₂^2) - (1/96)x₂x₃ - (1/96)x₂x₄ \
&- (5/576)(x₃^2) - (5/288)x₃x₄ - (5/576)(x₄^2)\
=& - 5/576 (x_1 + x_2 + x_3 + x_4)^2 + 1/144 (x_1 + x_2)(x_3 + x_4) \
=& - 5/ 144 (y_1 + y_2)^2 + 1/36 y_1 y_2
$

接下来，算 $S_N (y_1y_2)$



$
S_N (y_1y_2) =& 1/4 (S_(2N)(x_1x_3) + S_(2N) ( x_1x_4) + S_(2N)(x_2x_3) + S_(2N)(x_2x_4)) \
=& 1/4(\
  & 1/8 (4/3 x₁ + 4/3 x₂ + x₃ + x₄)(x₁ + x_2)  \
  &+ 1/8 ( x₃ + x₄ + x_5 + x_6)(x₁ + x_2)  \
  // &+ 1/12 ( x₁ +  x₂ + x₃ + x₄)^2 \
  &-(1/36)((x₁ + x₂)^2) + (1/12)((x₁ + x₂ + x₃ + x₄)^2) - (1/36)((x₃ + x₄)^2) \
  & + 1/16 ( x₁ +  x₂ + x₃ + x₄)( x₃ + x₄ + x_5 + x_6) + 1/48 (x₃ + x₄)^2\

)
=& (2/9)(y1^2) + (23/48)y1 y2 + (3/16)y1 y3 + (5/36)(y2^2) + (1/16)y2 y3
$

$F(y1) F(y2) = (3/4y1 + 1/4y2) (1/4y1+1/2 y2 + 1/4 y3) $

$
S_N (y_1y_2) =& F(y1) F(y2) + (5/144) (y1^2) + (1/24) y1 y2 + (1/72) (y2^2)
$

接下来，算 $S_N (y_1y3)$

$
S_N (y_1y3) = F(y1)F(y3) + 1/48 y2^2
$

然后， $j>3$时

$
S_N (y_1yj) = F(y1)F(yj)
$

然后， $i>1, i=j$时,


#let x2i1 = $x_(2i-1)$
#let x2i = $x_(2i)$
#let x2j1 = $x_(2j-1)$
#let x2j = $x_(2j)$
$
S_N (yi yj) =& 1/4(S_N  (x_(2i-1)x_(2j-1))+S_N (x_(2i-1)x_(2j))+ S_N (x_(2i)x_(2j-1)) + S_N (x_(2i)x_(2j))) \
=& 1/4(S_N  (x_(2i-1)x_(2i-1))+2 S_N (x_(2i-1)x_(2i)) + S_N  (x_(2i)x_(2i))) \
=& 1/4(\
  &1/24 (x_(2i-3) + x_(2i-2) + x_(2i-1) + x_(2i))^2 \
  &- 1/72 (x_(2i-3) + x_(2i-2))^2 - 1/72 (x_(2i-1) + x_(2i))^2\
  &+ 1/24 (x_(2i-1) + x_(2i) + x_(2i+1) + x_(2i+2))^2 \
  &- 1/72 (x_(2i-1) + x_(2i))^2 - 1/72 (x_(2i+1) + x_(2i+2))^2\
  & + 1/16 (x_(2i-3) + x_(2i-2) + x_(2i-1) + x_(2i))(x_(2i-1) + x_(2i) + x_(2i+1) + x_(2i+2)) \
  & + 1/48 (x_(2i-1) + x_(2i))^2\
) \
=& 1/24 (y_(i-1) + y_i)^2 - 1/72 (y_(i-1))^2 - 1/72 (yi)^2\
  &+ 1/24 (yi + y_(i+1))^2 - 1/72 (yi)^2 - 1/72 (y_(i+1))^2\
  & + 1/16 (y_(i-1) + y_i)(yi + y_(i+1)) +1/48 (y_i)^2\
$

#{let y0 = $y_(i-1)$
  let y1 = $y_i$
  let y2 = $y_(i+1)$
$
S_N (yi yj) =& F(yi ) F(yj)   -(5/144) (y0^2) - (5/48) y0 y1 - (1/16) y0 y2 \
&- (1/9) (y1^2) - (5/48) y1 y2 - (5/144) (y2^2)
$}

#{
[然后， $i>1, j=i+1$时,]

$
S_N (yi yj) 
=& 1/4(S_N  (x_(2i-1)x_(2i+1))+ S_N (x_(2i-1)x_(2i+2)) + S_N  (x_(2i)x_(2i+1)) + S_N  (x_(2i)x_(2i+2)) )\
=& 1/4(\
&  1/16 (x_(2i-3) + x_(2i-2) + x_(2i-1) + x_(2i))(x_(2i-1) + x_(2i) + x_(2i+1) + x_(2i+2)) \
  & + 1/48 (x_(2i-1) + x_(2i))^2 \
& + 1/16 (x_(2i-3) + x_(2i-2) + x_(2i-1) + x_(2i))(x_(2i+1) + x_(2i+2) + x_(2i+3) + x_(2i+4))\
&+ 1/12 (x_(2i-1) + x_(2i) + x_(2i+1) + x_(2i+2))^2 \
  &- 1/36 (x_(2i-1) + x_(2i))^2 - 1/36 (x_(2i+1) + x_(2i+2))^2\
  &+ 1/16 (x_(2i-1) + x_(2i) + x_(2i+1) + x_(2i+2))(x_(2i+1) + x_(2i+2) + x_(2i+3) + x_(2i+4)) \
  & + 1/48 (x_(2i+1) + x_(2i+2))^2 \
//   &1/24 (x_(2i-3) + x_(2i-2) + x_(2i-1) + x_(2i))^2 \
//   &- 1/72 (x_(2i-3) + x_(2i-2))^2 - 1/72 (x_(2i-1) + x_(2i))^2\
//   &+ 1/24 (x_(2i-1) + x_(2i) + x_(2i+1) + x_(2i+2))^2 \
//   &- 1/72 (x_(2i-1) + x_(2i))^2 - 1/72 (x_(2i+1) + x_(2i+2))^2\
//   & + 1/16 (x_(2i-3) + x_(2i-2) + x_(2i-1) + x_(2i))(x_(2i-1) + x_(2i) + x_(2i+1) + x_(2i+2)) \
//   & + 1/48 (x_(2i-1) + x_(2i))^2\
) \
// =& 1/24 (y_(i-1) + y_i)^2 - 1/72 (y_(i-1))^2 - 1/72 (yi)^2\
// =  &+ 1/24 (yi + y_(i+1))^2 - 1/72 (yi)^2 - 1/72 (y_(i+1))^2\
 = &  1/16 (y_(i-1) + y_i)(yi + y_(i+1)) +1/48 (y_i)^2\
  & + 1/16 (y_(i) + y_(i+1))(y_(i+1) + y_(i+2)) +1/48 (y_(i+1))^2\
  &+ 1/16 (y_(i-1)+ yi) (y_(i+1) + y_(i+2)) \
  & + 1/12 (y_i + y_(i+1))^2 - 1/36 (y_i)^2 - 1/36 (y_(i+1))^2\
$

  let y0 = $y_(i-1)$
  let y1 = $y_i$
  let y2 = $y_(i+1)$
  let y3 = $y_(i+2)$
$
S_N (yi yj) =& F(yi ) F(yj)  + (1/72) (y1^2) + (1/24) y1 y2 + (1/72) (y2^2)
$

}




// / / 我崩溃辣
// 因此，总体来说，
// $
// S_N (y_1y_1) = F(y_1y_1) - 
// $
]



#bibliography("refs.bib")