library(shiny)
library(stats)
library(MASS)

shinyUI(fluidPage(
  
  titlePanel("LDA plot 4 Smari"),
  
  sidebarLayout(position="left",
              
                sidebarPanel(
                  h3("Options"),
                  fileInput("file", label = h4("Import Excel File"),accept = c(".xlsx",".XLSX")),
                  # textInput("response_text", label = h4("Response Variable"), value = 'Q51Brand_a'),
                  # textInput("question_substring",label=h4("Question Substring"), value='q51a'),
                  checkboxGroupInput("plotcheck",label = h4("select plot functionality"),
                                                            choices = list("Every Observations"=1,"Brand Centroid"=2,
                                                                           'Questions as Features'=3),
                                                            selected=c(2,3)),
                  hr()
                  # uiOutput("feature_for_select"),
                  # uiOutput("response_for_select")
                ),
                
                
                
                mainPanel(h3("LDA Plot",align='center'),
                          tabsetPanel(
                            tabPanel("plot", plotOutput("plot")),
                            tabPanel("unstack keywords",
                                     textInput("response_text", label = h4("Response Variable"), value = 'Q51Brand_a'),
                                     textInput("question_substring",label=h4("Question Substring"), value='q51a'),
                                     textInput("response_text2", label = h4("Response Variable"), value = "Q51Brand_b"),
                                     textInput("question_substring2",label=h4("Question Substring"), value="q51b"))
                          )
                          
                ) 
)))