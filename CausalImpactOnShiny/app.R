library(pipeR)
library(bsts)
library(CausalImpact)
#sample data
server <- function(input, output) {
  output$causalPlot <- renderPlot({
    if(is.null(data)){return(NULL)}
    pre.max <- which(data$period == 0) %>>% max
    impact <- data %>>% select(-period) %>>% 
      CausalImpact(pre.period = c(1, pre.max), 
                   post.period=c(pre.max+1, nrow(data)), 
                   alpha=1-input$alpha,
                   model.args=list(niter=input$niter))
    plot(impact, c("original", "pointwise"))
  })
  output$summary <- renderPrint({
    if (is.null(input$file1)){return(NULL)}
    data <- read.csv(input$file1$datapath, header=input$header,sep=input$sep, quote=input$quote)
    print("Uploaded data.....")
    print(data)
  })  
}

ui <- shinyUI(
  navbarPage("Causal Impact analysis", 
    tabPanel("View",
             fluidPage(
               verticalLayout(
                 h3("Causal Impact plot"),
                 plotOutput("causalPlot"),
                 wellPanel(
                   sliderInput("alpha", "Confidential interval", 0.9, 0.99, value = 0.9, step = 0.01),
                   sliderInput("niter", "Iteration ", 10^3, 10^4, value = 10^3, step = 10^3)
                 ),
                 p("powered by ", a(href="http://shiny.rstudio.com/", "Shiny"), "which is an ", a(href="www.rstudio.com", "RStudio"), "project.")
               )
             )
    ),
    tabPanel("Uploading files",
             sidebarLayout(
               sidebarPanel(
                 fileInput('file1', 'Choose file to upload',
                           accept = c(
                             'text/csv',
                             'text/comma-separated-values',
                             'text/tab-separated-values',
                             'text/plain',
                             '.csv',
                             '.tsv')
                 ),
                 tags$hr(),
                 checkboxInput('header', 'Header', TRUE),
                 radioButtons('sep', 'Separator',
                              c(Comma=',',
                                Semicolon=';',
                                Tab='\t'),
                              ','),
                 radioButtons('quote', 'Quote',
                              c(None='',
                                'Double Quote'='"',
                                'Single Quote'="'"),
                              '"')
               ),
               mainPanel(verbatimTextOutput("summary"))
             )
    ),
    navbarMenu("More", tabPanel("About"))))
shinyApp(ui = ui, server = server)