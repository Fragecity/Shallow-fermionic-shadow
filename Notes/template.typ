
#let project(
  title: "",
  authors: (),
  lang: "zh",
  body,
) = {
  // Set the document's basic properties.
  set document(author: authors, title: title)
  set page(
    margin: (left: 24mm, right: 24mm, top: 24mm, bottom: 24mm),
    numbering: "1",
    number-align: center,
  )

  let font_size = 12pt
  if lang == "zh"{
    font_size = 11.6pt
  } else if lang == "en"{
    font_size = 13pt
  }
  
  set text(
    font: ("Linux Libertine", "Microsoft YaHei"), 
    lang: lang, 
    size: font_size, 
    weight: "extralight"
  )
  
  



  // Set paragraph spacing.
  show par: set block(above: 1.2em, below: 1.2em)

  set par(leading: 0.75em)

  // Title row.
  align(center)[
    #block(text(weight: 700, 2.5em, title))
    #v(1.2em, weak: true)
    #datetime.today().display()
  ]

  // Author information.
  pad(
    top: 0.8em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(center, strong(author))),
    ),
  )
   
   show figure: set block(breakable: true)
   
  show heading.where(level: 1): it=>{

    set text(
      rgb(0, 0, 140), 
      font: "Microsoft JhengHei UI",
      size: 17pt,
    )
    v(0.6em)
    it
  }


  show heading.where(level: 2): it=>{
    set text(
      rgb(10, 10, 95), 
      font: "Microsoft JhengHei UI",
      size: 15pt,
    )
    it
  }


set heading(numbering: "1.")
  
  

  show link: underline

  // set math.equ
  show math.equation:it => {
    if it.fields().keys().contains("label"){
      math.equation(block: true, numbering: "(1)", it)
      // change your numbering style in `numbering`
    } else {
      it
    }
  }

  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation {
      link(el.location(), numbering(
        "(1)",
        counter(math.equation).at(el.location()).at(0) + 1
      ))
    } else {
      it
    }
  }
  // Main body.
  set par(justify: true)



  body

}




