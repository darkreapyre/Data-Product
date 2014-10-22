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
                numericInput("hrate", "Enter your current hasrate:", min = 0),
                
## Determine if it's necesary to put hashrate per second in "hrate" as well
## a "selectInput" option. this is dependdent on wther the btc calculation
## requires input in kH/s. If necessary, use the following code:
##selectInput("prefix', "Prefix Multiplier:", ## or simply ""
##              c("kH/s", "MH/s", "GH/s", "TH/s")),
                
                ## Submit button to server.R
                submitButton("Submit")
                ),
        mainPanel(
                tabsetPanel(
                        ## Tab with the prediction results
                        tabPanel("Results", dataTableOutput("table")),
                        ## Tab with the actual Foreecast object
                        tabPanel("Arima Forecast",
                                 dataTableOutput("fcast")),
                        ## Tab with the plot of the Forecast object
                        tabPanel("Arima Plot", plotOutput("plot"))
                        )
                )
        )
)
