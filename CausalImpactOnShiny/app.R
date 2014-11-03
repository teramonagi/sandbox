library(CausalImpact)
#sample data
set.seed(1)
x1 <- 100 + arima.sim(model = list(ar = 0.999), n = 100)
y <- 1.2 * x1 + rnorm(100)
y[71:100] <- y[71:100] + 10
data <- cbind(y, x1)
pre.period <- c(1, 70)
post.period <- c(71, 100)

server <- function(input, output) {
  output$causalPlot <- renderPlot({
    post.period.response <- y[post.period[1] : post.period[2]]
    y[post.period[1] : post.period[2]] <- NA
    bsts.model <- bsts(y ~ x1, AddLocalLevel(list(), y), niter = 50)
    impact <- CausalImpact(bsts.model = bsts.model, post.period.response = post.period.response, alpha=1-input$alpha)
    plot(impact, c("original", "pointwise"))
  })
  output$summary <- renderPrint({
    print("Sales data")
    print(y)
  })  
}

ui <- shinyUI(
  navbarPage(
    "Causal Impact analysis",
    tabPanel("View",
             fluidPage(
               verticalLayout(
                 h3("Causal Impact plot"),
                 plotOutput("causalPlot"),
                 wellPanel(
                    sliderInput("alpha", "Confidential interval", 0.9, 0.99,
                               value = 0.9, step = 0.01)
                 ),
                 p("powered by ", a(href="http://shiny.rstudio.com/", "Shiny"), "which is an ", a(href="www.rstudio.com", "RStudio"), "project.")
               )
      )
    ),
    tabPanel("Data Summary",
      verbatimTextOutput("summary")
    ),
    tabPanel("Data upload"),
    navbarMenu("More",
      tabPanel("About")
    )
  )
)

shinyApp(ui = ui, server = server)