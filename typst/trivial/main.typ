#set text(font: "Libertinus Serif", size: 11pt)
#set page(paper: "a4", margin: 1in)
#set par(justify: true)
#set list(tight: true)

// Custom line function
#let chiline() = {
  v(-1pt)
  line(length: 100%)
  v(-6pt)
}

#chiline()

= Title

#v(0.5em)

// Title
Author Name
#h(1fr) Date

#v(0.5em)

== First Header

=== Second Header