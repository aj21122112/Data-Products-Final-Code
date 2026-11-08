library(shiny)

shinyUI(fluidPage(
  titlePanel("Penguin Flipper Length and Body Mass by Species and Sex"),
  sidebarLayout(
    sidebarPanel(
      h3("Slope"),
      #look for sloptOut from server
      textOutput("slopeOut"),
      #look for inOut from server
      h3("Intercept"),
      textOutput("intOut"),
      h3('Species'),
      checkboxInput('adelie', 'Adelie', value=TRUE),
      checkboxInput('gentoo', 'Gentoo', value=TRUE),
      checkboxInput('chinstrap', 'Chinstrap', value=TRUE),
      h3('Sex'),
      checkboxInput('male', 'male', value=TRUE),
      checkboxInput('female', 'female', value=TRUE)
    ),
    mainPanel(
      #plot1 from server
      plotOutput("plot1", brush = brushOpts(
        id = "brush1"
      ))
    )
  ),
  
  hr(),
  tags$footer(
    style = "text-align: center; color: #777; padding: 10px 0 20px 0;",
    p("Click and drag on the plot to brush points and fit a linear model",
      "of flipper length on body mass for the selected penguins. Use checkboxes to select which species and sex are shown in the plot."),
    p("Data: Palmer Penguins dataset (Gorman, Williams & Fraser, 2014)."),
    p("Built with R and Shiny.")
  )
  
))