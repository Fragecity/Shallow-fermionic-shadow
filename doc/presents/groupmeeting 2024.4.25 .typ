#import "@preview/physica:0.9.3": ket, bra
#import "@preview/mitex:0.2.3": mitex, mi


#import "./ppTemplate.typ": title-slide, overview, content-slide, main-bullet, 

#set page(paper: "presentation-16-9")

#set text(font: "DengXian", size: 24pt)

#let gray = rgb(92, 92, 92)
// #withSlides

// 123123123
// Remember to actually import polylux before this!

#title-slide(
  title: "Learning Properties from Quantum Systems",
  collaborator: "Wu Bujiao"
)

#overview[
- Introduction

- Classical shadows
  // - Ideas
  // - Shadow protocol
  // - Shallow shadows
- Fermionic computing
  // - Majorana fermions
  // - Match gates
- Shallow Fermionic shadow 
]

#overview[
#set text(rgb(92, 92, 92))

#main-bullet[
  - Introduction
    - Learning properties from quantum systems
    - Quantum state tomography (QST)
    - Drawbacks of QST
]


- Classical shadows
  // - Ideas
  // - Shadow protocol
  // - Shallow shadows
- Fermionic shadows
  // - Majorana fermions
  // - Match gates
- Shallow Fermionic shadow 
]

#content-slide(title: "Hook")[
  #grid(
    columns: (auto, auto),
    align: center+horizon,
    figure(
      image("../figures/groupMeeting/AI gener classical shadow.png", width: 68%),
      caption: [AI generation: Learning Properties from Quantum Systems ]
    ),
    [
  Problem: After we manipulating the quantum systems, how can we know certain properties of the system? Say $tr(O rho) $.]
  )
  // #align(center+horizon)[
  // Problem: After we manipulating the quantum systems, how can we know certain properties of the system? Say $tr(O rho) $.]
]

#content-slide(title:"Quantum State Tomography")[
#grid(
  columns: (auto, auto),
  align: center+horizon,
  figure(
    image("../figures/groupMeeting/qst.jpg", width: 70%),
    caption: [illustrating QST \ (a figure from bing)]
  ),
  [
    \ 
    A solution in stone age: \
  Quantum state tomography@nielsen2001quantum \
  
  Expanding state in Pauli basis\ 
  Extracting information by insane measurement. 
  ]
)


$
rho = 1/(2^n) sum c_i P_i, space space space 
c_i = tr(rho P_i), space space space
P_i in cal(P_n)
$
]

#content-slide(title: "Drawbacks of QST")[
  - A theorem promise that *the number of measurements is exponential* to the number of qubits if we want to get the full information of the quantum state.


  - A way out
    - learn "main information" rather than "full information"
    - Example: If we only care $tr(rho Z)$, we only need to measure $Z$ basis.
    #text(size: 25pt)[$
    tr((I+Z)/2) = tr((I+Z+X)/2)
    $]

]

#overview[
#set text(gray)

- Introduction
#main-bullet[
- Classical shadows
  // - Ideas
  - Shadow protocol
  - Drawbacks of classical shadows
  - Shallow shadows
  ]
- Fermionic shadows
  // - Majorana fermions
  // - Match gates
- Shallow Fermionic shadow 
]


#content-slide(title: "Classical Shadows Protocol")[
  Classical shadows @huang2020predicting: Using random shadows (or projections, sections) to predict the expectation value.​

  #grid(
    columns: (auto, auto),
    align: center+horizon,
    figure(
      image("../figures/groupMeeting/classical shadow.png", width: 55%),
      caption: [(pennylane.ai)]
    ),
    text(size: 23pt)[
      #align(left)[
      - Randomly choose a Clifford gate $U$.  
      - Apllly $U$ to $rho$, get $U rho U^dagger$
      - Measure $U rho U^dagger$ in computational basis, get $ket(b)$
      - Undo the $U$, get $U^dagger ket(b)bra(b) U$ \ (shadows $hat(rho)$)
      - using shadows to calculate the expectation value of $O$.
      ]
    ]
    
  )
]


#content-slide(title:"Drawbacks of Classical Shadows")[
  The depth of the shadow protocol is $cal(O)(n log(n))$

  #{
    let file = "../figures/groupMeeting/circuit of classical shadow.png"
    let size = 70%
    let body = [
      - Using this circuit to construct a random Clifford circuit

      - $cal(O)(n log(n))$ depth circuit is still un-acceptable for current quantum devices.
    ]
    grid(
    columns: (480pt, auto),
    align: center+horizon,
    figure(
      image(file, width: size),
      // caption: [(pennylane.ai)]
    ),
    text(size: 23pt, )[
      #align(left)[
        #body
      ]
    ]
  )
  }
]

#content-slide(title:"Shallow shadow")[
  Can those beautiful properties still hold for $cal(O)(log(n))$ depth circuit?
  #align(center+horizon)[
    #text(size: 30pt)[*Yes, they holds!*] @bertoni2022shallow
  ]
  
  #{
    let file = "../figures/groupMeeting/circuit of classical shadow.png"
    grid(
      columns: (480pt, auto),
      align: center+horizon,
      figure(
        image(file, width: 60%),
        // caption: []
      ),
      text(size: 23pt, )[
        #align(left)[
          -  $cal(O)(log(n))$ depth is good enough. 

          - proof idea: 
          $
          "Var"[tr(hat(rho) O)] <= C norm(O)
          $
         ]
      ]
    )

  }
]

#overview[
#set text(gray)

- Introduction
- Classical shadows

#main-bullet[
- Fermionic shadows
  - Fermionic quantum computing
  - Majorana fermions
  - Match gates
  - Fermionic shadows
  ]
- Shallow Fermionic shadow 
]



#content-slide(title: "Fermionic computing")[
  #{
    let content1 = [
     #align(center)[Normal system]
     $
     a^dagger ket(0) =& ket(1) \
     $ 
    ]
    let content2 = [
      #set text(size: 20pt)
     #align(center)[Fermionic (topo?) system]
     $
     a^dagger =& gamma_1 + i gamma_2\
     a        =& gamma_1 + i gamma_2
     $ 
    //  TODO: 对此还不确定

    //  目前的理解是，对Anyons的系统来说，其上的升降算符就是用 $gamma$ 来描述的
    ]
    grid(
      columns: (1fr, 1fr),
      inset: 10pt,
      content1, 
      content2
      
    )
    [
      // somehow move to analyze the Majorana operators
    #mitex(`
  \ket{b} \bra{b}=\prod_{j=1}^n \frac{1}{2}\left(I-i(-1)^{b_j} \gamma_{2 j-1} \gamma_{2 j}\right) .
  `)

  - The state could be represented by the Majorana operators.
  - The quantum gate on $ket(b)$ could be transformed to the gate on the Majorana operators.
    ]
    }
]


#content-slide(title: "Majorana operators")[
  We call a set of operators Majorana operators if they satisfy the following commutation relation:
  $
  {gamma_mu, gamma_nu} = 2 delta_(mu,nu) I
  $
  (just like we call a set of operators ladder operators if they satisfy the commutation relation $[a, a^dagger] = 1$)

  Valid Majorana operators obtains the following form
  $
  tilde(gamma)_nu = sum_mu Q_(mu nu) gamma_mu  
  $
]

#content-slide(title: "Match gates")[
  The basis transform could be written in
  $
    U_Q gamma_mu U_Q = sum_mu Q_(mu nu) gamma_mu.
  $
  All possible $U_Q$ could be achieved by interweavely applying the *match gates*, where the match gates are in the following form
  $
  e^(i theta X_i X_(i+1))e^(i (beta_i Z_i + beta_(i+1) Z_(i+1) ))
  $
]
#content-slide(title:"Fermionic shadows")[
- If we want to learn properties from a Fermionic system, we could also do classical shadows to the state
- In this case, *the random unitaries will be the random n-qubits match gates*
- Then, following the classical shadows protocol, we could extract "good enough" information from the system@wan2023matchgate
]

#overview[
#set text(gray)

- Introduction
- Classical shadows

- Fermionic shadows

#main-bullet[
- Shallow Fermionic shadow
  - proof idea
  - Tensor net representation
  - Simplification by projection
  - Approximate solution: Propogator
] 

]

#content-slide(title:"Goal and Proof idea")[
  Like classical shadow, we need to bond the variance of the expectation value of the shadows.
  $
  "Var"[tr(hat(rho) O)] <=  ??
  $
  Now, the shadows are given by the match gates. And then we could proof that, 
  $
  "Var"[tr(hat(rho) O)]
  $
]

#content-slide(title:"Tensor net representation")[
  
  
  #{
    let file = "../figures/groupMeeting/tensor representation.png"
    grid(
      columns: 800pt,
      rows: auto,
      align: center+horizon,
      figure(
        image(file, width: 70%),
        // caption: []
      ),
      [
        $
        T = integral d mu(Q) U_Q^(times.circle 2) =sum_k mat(4;k)^(-1)  
        $

      ]
    )

  }
]

#content-slide(title:"Shallow Fermionic shadows")[
  Our main contribution!

  coming soon...
]


#content-slide(title: "")[
  #set text(size: 18pt)
  #bibliography("refs.bib")
]
