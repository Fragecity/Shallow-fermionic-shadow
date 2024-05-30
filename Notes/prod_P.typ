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

// Utils








// content
= for any $S$
#lemma[
  Let $S subset [2n]$, $|S| = k$
  $
  cal(P)_S (t) :=  sum_mu product_(i in S) P_i (mu, t)
  $
]

#proof[
  Let $A_i (mu) = sum_(k=1)^(N-1) cos((mu-1/2) (pi k)/N ) cos((i-1/2) (pi k)/N ) cos^(2t) ( (pi k)/(2N) ) $.
  $
  cal(P)_S (t) =& sum_mu product_(i in S) 1/N (1+ 2 A_i (mu)) \
  =& 1/(N^k) sum_(mu, nu) 2^nu sum_(S_nu subset S) product_(i in S_nu) A_i (mu),
  $

  where $|S_nu| = nu$. 

  Now, we begin to deal with $sum_mu product_(i in S_nu) A_i (mu) $
  // And, $A_i (mu) = $
]

= $P_i (mu, t) P_j (mu, t)$

#lemma[
  Let $S subset [2n]$, $|S| = k$
  $
  cal(P)_S (t) :=  sum_mu product_(i in S) P_i (mu, t)
  $
]

#proof[
  As the same as the $cal(P)_(1 N)$, $sum(A_1(mu, t) + A_2 (mu, t)) = 0$. Thus, 
  $
  cal(P)_(i j) (t) = 1/N + 4/N^2 sum_mu A_i (mu,t) A_j (mu, t)
  $
  where 
  $
  A_i (mu,t) = sum  cos((pi (i-1/2)k)/N) cos( (pi (mu-1/2)k)/N ) cos^(2t)( (pi k)/ (2N) )
  $

  As the same as the $cal(P)_(1 N)$, 
  $
  sum cos( (pi (mu-1/2)j)/N ) cos( (pi (mu-1/2)k)/N ) = N/2
  $

  Thus, 
  $
  &sum A_i (mu,t) A_j (mu,t) \
  =& N/2 sum_mu cos( (pi mu (i-1/2))/N ) cos( (pi mu (j-1/2))/N ) cos^(4t) ((pi mu) / (2N) ) \
  =& N/4 sum_mu cos( (pi mu (i-j))/N ) cos^(4t) ((pi mu) / (2N) ) - N/4 sum_mu cos( (pi mu (i+j-1))/N ) cos^(4t) ((pi mu) / (2N) )
  $


]