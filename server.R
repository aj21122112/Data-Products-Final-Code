library(shiny)

#only keeping species, body_mass, flipper_len, and sex from penguins dataset, getting NA's out
penguin_data <- na.omit(penguins[, c("species", "body_mass", "flipper_len", "sex")])

shinyServer(function(input, output) {
  
  # Shared filtered data, used by both the plot and the model
  filtered <- reactive({
    
    #input$[species_name] checks the checkbox from the ui, the species name needs to match the spelling/capitalization as the df
    keep_species <- c(
      if (input$adelie)     "Adelie",
      if (input$gentoo)     "Gentoo",
      if (input$chinstrap)  "Chinstrap"
    )
    
    #same thing with sex
    keep_sex <- c(
      if (input$male) "male",
      if (input$female) "female"
    )
    
    #subset data set using the vectors made from the checkboxes
    subset(penguin_data, species %in% keep_species & sex %in% keep_sex)
    
  })
  
  #make reactive regression modes of body_mass vs. flipper_len in a brushed area of the plot
  model <- reactive({
    if (is.null(input$brush1)) return(NULL)
    
    brushed <- brushedPoints(filtered(), input$brush1,
                             xvar = "body_mass", yvar = "flipper_len")
    
    if (nrow(brushed) < 2) return(NULL)
    
    lm(flipper_len ~ body_mass, data = brushed)
  })
  
  output$slopeOut <- renderText({
    m <- model()
    if (is.null(m)) "No Model Found" else round(coef(m)[2], 4)
  })
  
  output$intOut <- renderText({
    m <- model()
    if (is.null(m)) "No Model Found" else round(coef(m)[1], 4)
  })
  
  
  #render the plot to include different colors for species and different shapes for sex
  output$plot1 <- renderPlot({
    d <- filtered()
    
    species_lvls <- c("Adelie", "Chinstrap", "Gentoo")
    sex_lvls     <- c("male", "female")
    sex_pch      <- c(16, 17) 
    
    plot(d$body_mass, d$flipper_len,
         xlab = "Body Mass (g)", ylab = "Flipper Length (mm)",
         main = "Penguin Body Mass and Flipper Length",
         cex = 1.5, bty = "n",
         col = factor(d$species, levels = species_lvls),
         pch = sex_pch[match(d$sex, sex_lvls)],
         xlim = range(penguin_data$body_mass),
         ylim = range(penguin_data$flipper_len))
    
    legend("topleft", title = "Species", legend = species_lvls,
           col = 1:3, pch = 16, bty = "n")
    legend("bottomright", title = "Sex", legend = c("Male", "Female"),
           col = "gray40", pch = sex_pch, bty = "n")
    
    if (!is.null(model())) {
      abline(model(), col = "blue", lwd = 2)
    }
  })
})


