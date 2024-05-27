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


//% ----------- Utils -----------
#let OO = $cal(O)$


#theorem[
 when $abs(i-j) space ~ space OO(log(n))$, $alpha_(i j) space ~ space 1/OO(n)$
]

#theorem[
  $B_(i j)(mu, nu, t) = P_i (mu, t) P_j(nu, t)$
]