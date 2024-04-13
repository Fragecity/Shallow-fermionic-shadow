#import "@preview/ctheorems:1.1.2": *

#show: thmrules

#let theorem = thmbox(
 "theorem", // identifier
 "Theorem", // head
 fill: rgb("#e8e8f8")
)

#theorem("Euclid")[
 There are infinitely many primes.
] <euclid>