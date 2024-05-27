#import "template.typ": project
#import "@preview/mitex:0.2.3": mitex, mi
#show: project.with(
  title: "Calculate " + $alpha$,
  authors: (
    "Bian Kaiming",
  ),
  lang: "en",
)

#import "src/Notations.typ": ii, id, longSpace


#import "@preview/ctheorems:1.1.2": thmrules, thmbox, thmplain, thmproof

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

// ----------- Utils -----------
// #let P1(i,j,t) = 
#import emoji: ballot
#let check = { ballot.check + [Test Pass]}

// #check

// ----------- Main Doc -----------
= Dealing PP
#theorem()[
  Let $cal(P)(t)= &sum_i P_1(i,t)P_N (i,t)$, and $M = floor((N-1)/2)$, $c = N-1 - 2M in {0,1}$. Then, $cal(P)$ could be bonded by the following equation
  $
  L(t) =&  1/N + 1/pi B^((1))_N (2t+1) + 1/pi B^((2))_N (2t+1) \
  &-1/sqrt(pi)Gamma(3/2+2t)/Gamma(2+2t) - 2/N sin^(4t+2)((pi)/ (2N)) \
  U(t) =&  1/N -1/pi B^((1))_N (2t+1) - 1/pi B^((2))_N (2t+1) \
  &+1/sqrt(pi)Gamma(3/2+2t)/Gamma(2+2t)
  $

]



#lemma(check)[
  $
  cal(P)(t)= &sum_i P_1(i,t)P_N (i,t) \
  =& 1/N + 2/N sum_(m=1)^M cos^(4t+2)((pi m) /N) - 2/N sum_(m=1)^M cos^(4t+2)((pi (2m-1)) /(2N))\
  &-(2c)/N sin^(4t+2)((pi)/ (2N)),
  $
  where $M = floor((N-1)/2)$, $c = N-1 - 2M in {0,1}$.
]<lemma:PP_rigid>
#proof[
Let 
$
P_1(i,t) = 1/N + 2/N A_1 (i,t)\
P_N(i,t) = 1/N + 2/N A_N (i,t)\
,
$
where 
#mitex(`
A_1(i,t) = \sum_k \cos \left(\frac{\pi  \left(i-\frac{1}{2}\right) k}{N}\right) \cos ^{2 t+1}\left(\frac{\pi  k}{2 N}\right) 

\\

A_N(i,t) = \sum_k \cos \left(\frac{\pi  \left(i-\frac{1}{2}\right) k}{N}\right) \cos ^{2 t+1}\left(\frac{\pi  k}{2 N}\right)
`)

Then we have
$
sum P_1(i,t)P_N (i,t) = 1/N + 2/N^2 sum_(i=1)^(N-1) (A_1(i,t) + A_N (i,t)) + 4/N^2 sum_(i=1)^(N-1)  A_1(i,t) A_N (i,t)
$

Now, let's analysis the second term.
// $
// sum_(i=1)^(N-1) (A_1(i,t) + A_N (i,t)) = 
// $
#mitex(`
&\sum_{i=1}^{N-1} (A_1(i,t) + A_N (i,t))  \\
=&\sum \left(\cos \left(\frac{\pi  k}{2 N}\right)+\cos \left(\frac{\pi  k \left(N-\frac{1}{2}\right)}{N}\right)\right) \cos \left(\frac{\pi  \left(i-\frac{1}{2}\right) k}{N}\right) \cos ^{2 t}\left(\frac{\pi  k}{2 N}\right)\\
`)

The summation of the second factor is zero

#mitex(`
&\sum_i \cos \left(\frac{\pi  \left(i-\frac{1}{2}\right) k}{N}\right)\\
=&-\frac{1}{2} \cos \left(\frac{1}{2} \pi  (2 k+1)\right) \csc \left(\frac{\pi  k}{2 N}\right)\\
=&\sin(k \pi) \csc \left(\frac{\pi  k}{2 N}\right)\\
=&0
`)
]

Thus, we have $sum P_1(i,t)P_N (i,t) = 1/N + 4/N^2 sum_(i=1)^(N-1)  A_1(i,t) A_N (i,t)$. Then we move to the term $ sum_(i=1)^(N-1)  A_1(i,t) A_N (i,t)$.

#mitex(`
 &\sum_{i=1}^{N-1} A_1(i,t) A_N (i,t)  \\
=&\sum_{i,j,k} \cos \left(\frac{\pi  j \left(N-\frac{1}{2}\right)}{N}\right) \cos \left(\frac{\pi  \left(i-\frac{1}{2}\right) j}{N}\right) \cos
   \left(\frac{\pi  \left(i-\frac{1}{2}\right) k}{N}\right) \cos ^{2 t}\left(\frac{\pi  j}{2 N}\right) \cos ^{2 t+1}\left(\frac{\pi 
   k}{2 N}\right)

`)

We also begin to deal with the factor
#mitex(`
 & \sum_{i=1}^{N-1} \cos \left(\frac{\pi  \left(i-\frac{1}{2}\right) j}{N}\right) \cos
   \left(\frac{\pi  \left(i-\frac{1}{2}\right) k}{N}\right)\\
=& \frac{1}{2} \sum_{i=1}^{N-1} \cos \left(\frac{\pi  \left(i-\frac{1}{2}\right) j}{N}-\frac{\pi  \left(i-\frac{1}{2}\right) k}{N}\right)+\cos
   \left(\frac{\pi  \left(i-\frac{1}{2}\right) j}{N}+\frac{\pi  \left(i-\frac{1}{2}\right) k}{N}\right)\\
=& \frac{1}{2} \sum_{i=1}^{N-1} \cos \left(\frac{\pi  (2 i-1) (j-k)}{2 N}\right) + \cos \left(\frac{\pi  (2 i-1) (j+k)}{2 N}\right) \\
=& \frac{1}{4} \left(\sin (\pi  (j+k)) \csc \left(\frac{\pi  (j+k)}{2 N}\right)-\sin (\pi  (k-j)) \csc \left(\frac{\pi  (j-k)}{2
   N}\right)\right)
`)

We know that $sin(pi m) =0$, but $csc(pi m) = infinity$. Thus, the above term is non-zero 
only when $ (pi (j+k))/ (2N) = a pi$ or $ (pi (j-k))/ (2N) = b pi$ for some integer $a$ and $b$. This condition could be neatened to 
$
cases(
j+k = 2 a N " or " j-k = 2 b N,
a", " b in bb(Z),
1< j", " k <N-1
)
arrow.double.long
j=k
$

In this case, we aim to get the value of $sin(pi (j-k))csc((pi (j-k))/ (2N))$ when $j=k$. Thus, we evaluate the following term
$
lim_(x->0) sin(pi x)csc((pi x)/ (2N)) = lim_(x->0) sin(pi x) / sin((pi x) / (2N)) = 2N
$
Then, we have
#mitex(`
 &\sum_{i=1}^{N-1} A_1(i,t) A_N (i,t)  \\
=& \frac{N}{2} \sum_{k=1}^{N-1} 
\cos \left(\frac{\pi  k \left(N-\frac{1}{2}\right)}{N}\right) 

\cos ^{2 t}\left(\frac{\pi  k}{2 N}\right) 
\cos ^{2 t+1}\left(\frac{\pi k}{2 N}\right)\\
=& \frac{N}{2} \sum _{k=1}^{N-1} \cos \left(\frac{\pi  k \left(N-\frac{1}{2}\right)}{N}\right) \cos ^{4 t+1}\left(\frac{\pi  k}{2 N}\right) \\
= & \frac{N}{4} \sum _{k=1}^{N-1} (\cos \left(\frac{\pi  k (N-1)}{N}\right) + \cos (\pi  k))\cos ^{4 t}\left(\frac{\pi  k}{2 N}\right)
`)
analysis the first factor
$
&cos ( (pi k (N-1))/ (N)  )+ cos(pi k)\
=& cos(pi k)cos( (pi k)/N) + sin(pi k)sin( (pi k)/N) + cos(pi k)\
=& cos(pi k)(cos( (pi k)/N) + 1)
$

Then, we sum these terms pairly. Let $M = floor((N-1)/2)$, $c = N-1 - 2M in {0,1}$.
#mitex(`
&\sum_{i=1}^{N-1} A_1(i,t) A_N (i,t) \\
= & \frac{N}{4} \sum_{m=1}^{M} \left(\cos \left(\frac{2 \pi  m}{N}\right)+1\right) \cos ^{4 t}\left(\frac{\pi  m}{N}\right)-\left(\cos \left(\frac{\pi  (2
   m-1)}{N}\right)+1\right) \cos ^{4 t}\left(\frac{\pi  (2 m-1)}{2 N}\right)\\
    &-c\frac{N}{4} (\cos(\frac{\pi (N-1)}{N})+1)\cos^{4t}(\frac{\pi (N-1)}{2N})\\
=&\frac{N}{2} \sum_{m=1}^{M}\left(\cos ^{4 t+2}\left(\frac{\pi  m}{N}\right)-\cos ^{4 t+2}\left(\frac{\pi  (2 m-1)}{2 N}\right)\right)\\
&-c\frac{N}{2} \cos^{4t+2}(\frac{\pi (N-1)}{2N})
`)

where $cos( (pi(N-1))/(2N)  ) = sin( (pi)/(2N)) $.


#lemma(check)[
  $
  Beta_N^((1)) (p) <= 2 sum_(m=1)^M  pi/N cos^(2p) ((m pi)/ N )  <= sqrt(pi) ( Gamma(1/2 + p))/Gamma(1 + p) - Beta_N^((2)) (p)
  $
  where $Gamma$ is gamma function, $Beta$ is beta function, $Beta_N^((1))(p) = Beta(cos^2((2pi)/N), 1/2+p,1/2) $, $Beta_N^((2))(p) = Beta(sin^2((pi)/N), 1/2+p,1/2) $.
]<lemma:sum_cos_bond>

#proof[
  Because the $cos^(2p)(x)$ is monotonic decreasing when $x in [0, pi/2]$, we have
  $
   &cos^(2p) ((m pi)/ N )  
   <= 1/2(cos^(2p) ( (2m pi)/(2N) )+ cos^(2p) ( ((2m-1) pi)/(2N) )  ) \
   "and  " longSpace & cos^(2p) ((m pi)/ N )  
   >= 1/2(cos^(2p) ( (2m pi)/(2N) )+ cos^(2p) ( ((2m+1) pi)/(2N) )  )
  $
  for $p in bb(Z)_+ $, $0<m<(N-1)/2$. Similarly, we have
  $
   &cos^(2p) ((m pi)/ N )  
   <= 1/B sum_(b=0)^(B-1) cos^(2p) (((B m-b ) pi)/ (B N) )  \
   "and  " longSpace & cos^(2p) ((m pi)/ N )  
   >= 1/B sum_(b=0)^(B-1) cos^(2p) (((B m+b ) pi)/ (B N) )
  $
  Thus, we have

  $
   & sum_(m=1)^M  pi/N cos^(2p) ((m pi)/ N )  
   <= lim_(B->infinity) sum_(n=1)^(B M) pi/(B N)  cos^(2p) ((n pi)/ (B N) )  \
   "and  " longSpace & sum_(m=1)^M  pi/N cos^(2p) ((m pi)/ N )  
   >= lim_(B->infinity) sum_(n=0)^(B M-1) pi/(B N)  cos^(2p) ((n pi)/ (B N) + pi/N)
  $

  Turn the summation to the integral, and using $M = floor((N-1)/2)$
  $
  &lim_(B->infinity) sum_(n=1)^(B M) pi/(B N)  cos^(2p) ((n pi)/ (B N))\
  =& integral_0^((M pi)/N)   cos^(2p) (kappa) d kappa \
  <=& integral_0^(pi/2 - pi/(2N))   cos^(2p) (kappa) d kappa \
  =& sqrt(pi)/2 ( Gamma(1/2 + p))/Gamma(1 + p) - 1/2 Beta(sin^2(pi/(2N)), 1/2 + p , 1/2)
   
  $
  where $Gamma$ is gamma function, $Beta$ is beta function.
  Similarly, we have
  $
  & lim_(B->infinity) sum_(n=0)^(B M-1) pi/(B N)  cos^(2p) ((n pi)/ (B N) + pi/N)  \
  >=& integral_((2 pi)/N)^(pi/2)   cos^(2p) (kappa) d kappa \
  =&1/2 Beta(cos^2((2 pi)/N), 1/2 + p, 1/2)
  $

  Combine these results, we have
  $
  Beta_N^((1)) (p) <= 2 sum_(m=1)^M  pi/N cos^(2p) ((m pi)/ N )  <= sqrt(pi) ( Gamma(1/2 + p))/Gamma(1 + p) - Beta_N^((2)) (p)
  $


]

#corollary(check)[
  $
  Beta_N^((1)) (p) <= 2 sum_(m=1)^M  pi/N cos^(2p) (((2m-1) pi)/ 2N )  <= sqrt(pi) ( Gamma(1/2 + p))/Gamma(1 + p) - Beta_N^((2)) (p)
  $
]
#proof[
  The proof is similar to the @lemma:sum_cos_bond.
]

#figure(
  image("../figures/test_csSum_bond.svg", width: 95%),
  caption: [test @lemma:sum_cos_bond. We could see that the upper bond is very tight.]
)