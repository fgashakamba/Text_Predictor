library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("N-Gram Word Predictor"),
  h4("Faustin Gashakamba for the John Hopkins Coursera Data Science Capstone", style="color: #FF5733"),
  hr(),
  
  fluidRow(width=2,
           p("Enter a sentence, hit enter (or press the 'Predict next' button)"),
           p("Sometimes, the algorithm would stutter. Don't sweat it.")),
  hr(),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      textInput("text", label = h3("Input"), value = "Your text goes here"),
      helpText("Type in a sentence above, hit enter (or press the button below), and the results will display to the right."),
      submitButton("Submit"),
      hr()
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      br(),
      h2(textOutput("sentence"), align="center"),
      h1(textOutput("predicted"), align="center", style="color:blue"),
      hr(),
      h3("Top 5 Possibilities:", align="center"),
      div(tableOutput("alts"), align="center")
    )
  )
))