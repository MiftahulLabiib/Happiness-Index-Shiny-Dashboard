function(input, output) { 
  #output$idplot <- renderapa({})
output$region_rank_viz <- renderPlotly({
  #Persiapan Data
  region_rank <- happines_data %>% 
    group_by(Region) %>% 
    summarise(avarage_index= mean(Happiness.Score))
  #plot 1
  region_rank_viz<-region_rank %>% 
    ggplot(mapping = aes(x= avarage_index, 
                         y= reorder(Region, avarage_index),
                         text= glue("Avarage Index: {round(avarage_index,2)}
                                  Region: {Region}")))+
    geom_col(fill="#1D267D")+
    scale_y_discrete(labels= wrap_format(width = 20))+
    labs(title = NULL,
         x="Avarage Happiness Index",
         y=NULL)
  #plot interaktif 1
  ggplotly(region_rank_viz, tooltip = "text")
})
output$Correlation <- renderPlotly({
  Correlation <- happines_data %>%
    ggplot(mapping = aes(x = Happiness.Score, 
                         y = happines_data[,input$input_aspect])) +
    geom_point(aes(col = Region, size = Happiness.Score, 
                   text = glue("Region : {Region}
                               Happiness Score : {round(Happiness.Score,2)}
                               {str_to_title(gsub('\\\\.', ' ', input$input_aspect))} : {happines_data[,input$input_aspect]}"))) +
    geom_smooth() +
    labs(
      title = NULL,
      x = "Happiness Score",
      y = glue("{str_to_title(gsub('\\\\.', ' ', input$input_aspect))}")
    ) +
    theme(
      legend.position = "none",
      plot.title = element_text(hjust = 0.5)
    )
  ggplotly(Correlation, tooltip = "text")
})

output$map1 <- renderPlotly({
  #data preparation
  mapdata<- map_data("world")
  region_data <- happines_data %>%
    select(Country, Happiness.Score)
  
  mapdata <- inner_join(mapdata, region_data, by = c("region" = "Country"))
  mapdata1<-mapdata %>% 
    filter(!is.na(Happiness.Score))
  #statis viz
  map1<-mapdata1 %>% 
    ggplot(mapping = aes(x= long, 
                         y= lat, 
                         group= group,
                         text= glue("{region}
                                  Happiness Score : {round(Happiness.Score,2)}")))+
    geom_polygon(aes(fill= Happiness.Score))+
    labs(title = tags$b("Happiness Index per Country"),
         x= NULL,
         y=NULL,
         fill= "Happiness Score")+
    theme(
      panel.background = element_rect(fill = "gray", color = "black", linewidth = 0.5),
      plot.title = element_text(hjust = 0.5),
      legend.background = element_blank()
    )
  #interactive plot
  ggplotly(map1, tooltip = "text")
})
output$aspect <- renderPlotly({
  #data preparation
  data_dist<-happines_data %>% 
    filter(Country==input$input_country) %>% 
    select(Economy..GDP.per.Capita., Family, Health..Life.Expectancy., Freedom, Trust..Government.Corruption., Generosity, Dystopia.Residual ) %>% 
    pivot_longer(cols = c("Economy..GDP.per.Capita.", "Family", "Health..Life.Expectancy.", "Freedom", "Trust..Government.Corruption.", "Generosity", "Dystopia.Residual")) %>% 
    mutate(name = gsub("\\.", " ", name))
  #statis plot
  aspect<-data_dist %>%
    ggplot(mapping = aes(x = name, 
                         y = value, 
                         fill = name,
                         text= glue("{name} : {value}"))) +
    geom_col(width = 1) +
    
    theme(axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.title.x = element_blank(),
          plot.title = element_text(hjust = 0.5)) +
    labs(title = NULL, 
         y = NULL, 
         fill= "Aspect")
  #interactive plot
  ggplotly(aspect, tooltip = "text")
})
output$country_gdp <- renderPlotly({
  country_gdp<-happines_data %>% 
    filter(Region==input$input_region) %>% 
    select(Country,Economy..GDP.per.Capita.) %>% 
    ggplot(aes(x= reorder(Country, Economy..GDP.per.Capita.), 
               y=Economy..GDP.per.Capita.,
               text= glue("GDP per Capita: {Economy..GDP.per.Capita.}")))+
    geom_col(fill="#068DA9")+
    labs(title = NULL,
         x=NULL,
         y="GDP per Capita")+
    theme(axis.text.x = element_text(angle = 75, hjust = 1),
          plot.title = element_text(hjust = 0.5))
  #interactive plot
  ggplotly(country_gdp, tooltip = "text")
})
output$table_data <- renderDataTable({
  datatable(data = happines_data,
            options = list(scrollX = TRUE)
  )
})
  }