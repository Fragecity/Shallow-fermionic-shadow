#import "@preview/quill:0.2.1": *
#import "@preview/physica:0.9.2": ket
#import "@preview/ctheorems:1.1.2": thmrules, thmbox, thmplain, thmproof
#import "@preview/commute:0.2.0": node, arr, commutative-diagram


#import "template.typ": project
#import "src/Notations.typ": ii, id, supvec, supbra, longSpace


#show: project.with(
  title: "Results",
  authors: (
    "Bian Kaiming",
  ),
)

// ------ Theorems Setting ------


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

// ------ Theorems Setting ------





#let draw_Z(i) = {
  
}




// ----------- Main Doc -----------


= Introduction

长久以来，量子态的读取都是量子计算中的一个重要问题。
// 量子态的读取指的是，当我们对一个量子系统进行一些操作之后，如何得到这个演化后的量子系统的信息。




= Fermionic Quantum Computing

= Classical shadow

= Shallow shadow

= The attempts in Fermionic Shallow shadow



#bibliography("refs.bib")