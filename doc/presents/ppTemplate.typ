#import "@preview/polylux:0.3.1": *

#let withSlides = {
  set document()
  set page(paper: "presentation-16-9")

  set text(size: 25pt)
}



#let title-slide(title:"", author:"Bian Kaiming", collaborator:"", affiliation:"") = {
  polylux-slide[
    #set align(horizon + center)

    #{
      set text(size: 30pt)
      [= #title]
    }

    #v(1em)

    #{
      set text(size: 30pt)
      [#author]
    }
    
    #if collaborator != ""{
      [Collaborate with: \ ]

      collaborator
    }

    #if affiliation != ""{
      [Affiliation: \ ]

      affiliation
    }
    
  ]
}


#let overview(body) = polylux-slide[
  #show heading.where(level: 1): it=>{
    set text(
      rgb(0, 0, 140), 
      font: "Microsoft JhengHei UI",
      size: 35pt,
    )
    it
    }
    = overview
    #set align(horizon + center)
    #block[
    #set align(left)
    #body
  ]
]



#let content-slide(
    title: "", 
    body
  ) = polylux-slide[
  #show heading.where(level: 1): it=>{

    set text(
      rgb(0, 0, 140), 
      font: "Microsoft JhengHei UI",
      size: 32pt,
    )
    it
  }
  #set par(justify: true)
  = #title
  #body

]




#let main-bullet(body)={
  set text(rgb(0, 0, 0))
  block(
    fill: rgb(10, 10, 180, 30),
    inset: 10pt,
    radius: 8pt,
    body
  )
}

// #let illustrate-figure(file, size, body) = {
// grid(
//   columns: (auto, auto),
//   align: center+horizon,
//   figure(image(file, width: size)),
//   body
// )
// }
