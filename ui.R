# Fungsi dashboardPage() diperuntuhkan untuk membuat ketiga bagian pada Shiny
dashboardPage(
  
  # Fungsi dashboardHeader() adalah bagian untuk membuat header
  dashboardHeader(title="Happiness Index"),
  
  # Fungsi dashboardSidebar() adalah bagian untuk membuat sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem(text= "Overview",
               tabName="page1",
               icon= icon("house")),
      menuItem(text= "Happiness Index-Country",
               tabName="page2",
               icon= icon("chart-column")),
      menuItem(text="data",
               tabName="page3",
               icon=icon("table"))
      
    )
  ),
  
  # Fungsi dashboardBody() adalah bagian untuk membuat isi body
  dashboardBody(
    tabItems(
      tabItem(tabName = "page1",
              h2(tags$b("OVERVIEW HAPPINESS INDEX")),
              fluidPage(
                div(stylestyle = "text-align:justify"),
                p("The happiness index, also known as the World Happiness Report, is a measure of subjective well-being and life satisfaction in different countries around the world.",
                  "The happiness index is based on surveys conducted in each country, where individuals are asked to rate their own happiness and life satisfaction.", "
                  The results are then analyzed and used to calculate a happiness score for each country.")
              ),
              fluidRow(
                valueBox( value= round(mean(happines_data$Happiness.Score),2),
                          "Avarage Happiness Index",
                        icon= icon("chart-area"),
                        color= "blue"),
                valueBox(value= nrow(happines_data),
                         "Total Country",
                        icon= icon("earth-asia"),
                        color= "aqua"),
                valueBox(value= length(unique(happines_data$Region)),
                         "Total Region",
                        icon= icon("globe"),
                        color= "purple")
              ),
              fluidRow(
                box(width = 12,
                    title = tags$b("Avarage Happiness Index by Region in 2015"),
                    plotlyOutput(outputId = "region_rank_viz",
                                 height = 500))
              ),
              fluidRow(
                box(width = 8,
                    title = tags$b("Measurement Aspect"),
                    plotlyOutput(outputId = "Correlation",
                                 height = 350)),
                box(width = 4,
                    title = "Choose Aspect",
                    background = "green",
                    height = 350,
                    radioButtons(
                      inputId = "input_aspect",
                      label = NULL,
                      choiceNames = str_to_title(gsub("\\.", " ", names(subset(happines_data, select = sapply(happines_data, is.numeric) & !names(happines_data) %in% c("Happiness.Rank", "Happiness.Score", "Standard.Error"))))),
                      choiceValues = names(subset(happines_data, select = sapply(happines_data, is.numeric) & !names(happines_data) %in% c("Happiness.Rank", "Happiness.Score", "Standard.Error")))
                    )
                    
 )
              )
              ),
 tabItem(tabName = "page2",
         fluidRow(
           box(width = 12,
               title = tags$b("Country's Happiness Score"),
               plotlyOutput(outputId = "map1",
                            height = 500))
         ),
         fluidRow(
           box(width = 9,
               title = tags$b("Aspect To Measure Happiness Index"),
               plotlyOutput(outputId = "aspect",
                            height = 400)),
           box(width = 3,
               title = "Country",
               background = "red",
               height = 450,
               selectInput(inputId="input_country", 
                           label="Choose Country", 
                           choices= unique(happines_data$Country)))
         ),
         fluidRow(
           box(width = 9,
               title = tags$b("Country's GDP per Capita"),
               plotlyOutput(outputId = "country_gdp",
                            height = 500)),
           box(width = 3,
               title = "Region",
               background = "aqua",
               height = 150,
               selectInput(inputId="input_region", 
                           label="Choose Region", 
                           choices= unique(happines_data$Region))
               ),
           box(width = 3,
               title = tags$b("REMEMBER!"),
               height = 400,
               div(stylestyle = "text-align:justify"),
               p("GDP per capita is one of the factors considered in the measurement of the happiness index.",
                 "A higher GDP per capita can provide individuals with access to better resources and opportunities, but it does not necessarily guarantee happiness.",
                 "Therefore, while GDP per capita is considered in the happiness index, it is not the sole or most important factor. "),
               h3("Further Reading"),
               p("Let's get to know more about happiness index in",
               a(href = "bit.ly/get-to-know-about-happinessindex",
                 "Public Health Notes")
               )
               )
         )
         ),
 tabItem(tabName = "page3",
         fluidRow(
           box(width = 12,
               dataTableOutput(outputId = "table_data"))  
         ))
    )
  )
)