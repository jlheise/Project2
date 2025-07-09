#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(jsonlite)
library(tidyverse)
library(httr)
library(ggplot2)
library(ggDoubleHeat)
source("helpers.R")
# Define UI for application
ui <- fluidPage(
    titlePanel("Reed Job Query"),
    tabsetPanel(
      tabPanel("About",
        h2("Purpose"),
        p("This app allows the user to query jobs on the Reed job board and explore trends in job postings."),
        h2("Data"),
        p("The data is obtained from Reed Jobseeker: https://www.reed.co.uk/developers/Jobseeker and returns UK job listings."),
        tags$img(src="https://www.google.com/url?sa=i&url=https%3A%2F%2Fuk.linkedin.com%2Fcompany%2Freed-co-uk&psig=AOvVaw2-_i5NUUeq49PZu_DnQizp&ust=1752111632692000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCJDdq87Sro4DFQAAAAAdAAAAABAE",
                 width = "100px"),
        h2("App Functions"),
        p("The Data Download tab is where the user can input criteria in their search and return appropriate job listings.
          The Data Exploration tab allows the user to visually look at the job listing data.")
      ),
      tabPanel("Data Download",
        h2("Keword Search"),
        p("Enter a keyword to narrow your job search"),
        textInput("keyword", "Enter Keyword:"),
        h2("Select Location and Employer"),
        p("Select a location and an employer to narrow your job search"),
        fluidRow(
          column(4, 
                 selectInput("location", "Select a Location:", choices = list_locations),
                 selectInput("employer", "Select an Employer:", choices = list_employers)
          )
        ),
        h2("Minimum Salary Expected"),
        p("Enter the minimum salary you are looking for"),
        textInput("minimumSalary", "Enter Minimum Salary:"),
        tableOutput("Jobs")
      ),
      tabPanel("Data Exploration",
        h2("Correlation Heatmap: Number of jobs posted by each company by month"),
        plotOutput("Heatmap")
      )
    )
)

# Define server logic
server <- function(input, output, session) {
  reactive({
    output$Jobs <- renderTable({query_func(input$keyword, input$location, input$employer, input$minimumSalary)
    })
  })
  reactive({
    output$Heatmap <- renderPlot({
      ggplot(data = postings_by_month, aes(x = month, y = employerName, fill = n)) +
        geom_tile() +
        labs(title = "Correlation Heatmap: Number of jobs posted by each company by month",
           x = "Month",
           y = "Company")+
        scale_fill_distiller(palette = "Spectral")+
        scale_y_discrete(label = abbreviate, guide = guide_axis(n.dodge = 2))
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
