library(shiny)
## Create the shiny user interface
shinyUI(pageWithSidebar(
        ## Main title
        headerPanel("Estimate future Bitcoin profit"),
        ## side panel for the hasrate input
        sidebarPanel(
                helpText("This app estimates the total amount of Bitcoins
                         you will mine, based on your current hastrate."),
                ## hashrate input by user (must bre greater then 0)
                numericInput("hrate", "Enter your current hasrate:", 0,
                             min = 0),
                selectInput("prefix",
                            label = NULL,
                            choices = list("kH/s", "MH/s", "GH/s", "TH/s"),
                            selected = "TH/s"),
                ## Submit button to server.R
                submitButton("Submit"),
                p("Documentation:", a("About", href = "About.html"))
                ),
        mainPanel(
                tabsetPanel(
                        ## Tab with the plot of the Forecast object
                        tabPanel("Arima Plot", plotOutput("plot")),
                        ## Tab with the actual Forecast object
                        tabPanel("Arima Forecast",
                                 dataTableOutput("Fcast")),
                        ## Tab with the prediction results
                        tabPanel("Results", dataTableOutput("Table"))
                        )
                )
        )
)
