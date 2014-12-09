library(bsts)
library(CausaImpact)
#sample data
set.seed(1)
x1 <- 100 + arima.sim(model = list(ar = 0.999), n = 100)
y <- 1.2 * x1 + rnorm(100)
y[71:100] <- y[71:100] + 10
data <- cbind(y, x1)
pre.period <- c(1, 70)
post.period <- c(71, 100)
data <- NULL
server <- function(input, output) {
  output$causalPlot <- renderPlot({
    if(is.null(data)){return(NULL)}
    post.period.response <- y[post.period[1] : post.period[2]]
    y[post.period[1] : post.period[2]] <- NA
    bsts.model <- bsts(y ~ x1, AddLocalLevel(list(), y), niter = 50)
    impact <- CausalImpact(bsts.model = bsts.model, post.period.response = post.period.response, alpha=1-input$alpha)
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
                   sliderInput("alpha", "Confidential interval", 0.9, 0.99, value = 0.9, step = 0.01)
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