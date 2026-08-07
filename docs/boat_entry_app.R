#Data entry app for marine surveys NCCS

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(shiny)
library(lubridate)
library(DT)
library(dplyr)

# Function for saving data to a CSV file
log_line <- function(newdata, filename = 'marine_data.csv'){
  (dt <- Sys.time() %>% round %>% as.character)
  (newline <- c(dt, newdata) %>% paste(collapse = ',') %>% paste0('\n'))
  cat(newline, file = filename, append = TRUE)
  print('Data stored!')
}


#measurements <- read.csv(file.choose())

################################################################################
################################################################################

ui <- fluidPage(
  titlePanel(h3("Marine Data Entry App")),
  br(),
  tabsetPanel(
    tabPanel(h4("Entry"),
             br(),
             fluidRow(
               column(3, selectInput('scribe',
                                     label = 'Scribe',
                                     choices = c('select name','Grace','Janie','Paula','Charline'),
                                     width = '95%')),
               
               column(3, selectInput('boat_driver',
                                     label = 'Boat Driver',
                                     choices = c('select name','Grace','Janie'),
                                     width = '95%')),
               
               column(3, selectInput('observerL',
                                     label = 'Observer Left',
                                     choices = c('select name','Charline','Sacha','Hannah','Janie','Grace','Nadege','Lloyd','Dalton','Robyn','Nia'),
                                     width = '95%')),
               
               column(3, selectInput('observerR',
                                     label = 'Observer Right',
                                     choices = c('select name','Charline','Sacha','Hannah','Janie','Grace','Nadege','Lloyd','Dalton','Robyn','Nia'),
                                     width = '95%'))),
             
             fluidRow(
               column(2, selectInput('area',
                                     label='Area',
                                     choices = c('select area','Lewis','Gribbell','Otter','Squally'),
                                     width = '95%')),
               
               column(1, numericInput('surv_num',
                                      label='Survey #',
                                      value = 0, 
                                      min = 0, 
                                      max = 10,
                                      width = '95%')),
               
               column(3, textInput('trail',
                                   label = 'Trail Name',
                                   value='enter trail',
                                   width = '95%'))),
             
             fluidRow(
               h3("Boat Info"),
               column(1, radioButtons('effort',
                                      label = 'Effort',
                                      choices = c('On','Off'),
                                      inline = TRUE,
                                      width = '95%')),
               
               column(2, textInput("line",
                                   label='Line',
                                   value='enter line',
                                   width = '95%')),
               
               column(3, selectInput('direction',
                                     label = 'Travel Direction (of Elemiah)',
                                     choices = c('N','NE','E','SE','S','SW','W','NW'),
                                     width = '95%')), 
               
               column(3, textInput('speed',
                                   label='Average Speed (kts)',
                                   value='enter speed',
                                   width = '95%')),
               
               column(3, numericInput('waypoint',
                                      label='Waypoint',
                                      value='1',
                                      min = 1, 
                                      max = 1000,
                                      width = '95%'))),
             
             fluidRow(
               h3("Weather Conditions"),
               column(2, numericInput('beaufort',
                                      label = 'Beaufort',
                                      value = 0, 
                                      min = 0, 
                                      max = 6,
                                      width = '95%')), 
               
               column(2, numericInput('wave_height',
                                      label = 'Wave Height',
                                      value = 0, 
                                      min = 0, 
                                      max = 10,
                                      step = 0.25,
                                      width = '95%')), 
               
               column(2, numericInput('cc',
                                      label = 'Cloud Cover %',
                                      value = 0, 
                                      min = 0, 
                                      max = 100,
                                      width = '95%')),
               
               column(3, numericInput('vis',
                                      label = 'Visibility (km)',
                                      value = 0, 
                                      min = 0, 
                                      max = 40,
                                      width = '95%')),
               
               column(3, selectInput('weather',
                                     label = 'Weather',
                                     choices = c('S','PS','OC','LR','R','F','SS','SR'),
                                     width = '95%'))),
             
             fluidRow(
               column(4, selectInput('glare',
                                     label = 'Glare Intensity',
                                     choices = c('None','Mild','Severe'),
                                     width = '95%')),
               
               column(4, textInput('glareL',
                                   label = 'Glare Left',
                                   value='NA',
                                   width = '95%')),
               
               column(4, textInput('glareR',
                                   label = 'Glare Right',
                                   value='NA',
                                   width = '95%'))),
             br(),
             fluidRow(
               h3("Sighting Details"),
               column(4, textInput('boat_bearing',
                                   label='Boat Bearing',
                                   value='NA',
                                   width = '95%')),
               
               column(4, textInput('bino_bearing',
                                   label='Bino Bearing',
                                   value='NA',
                                   width = '95%')),
               
               column(4, textInput('bino_reticle',
                                   label='Bino Reticle',
                                   value='NA',
                                   width = '95%'))),
             
             fluidRow(
               column(3, selectInput('species',
                                     label='Species (of MarMam)',
                                     choices = c('NA','HW','FW','BALLEEN','ORCA','DP'),
                                     width = '95%')),
               
               column(3, selectInput('vessel',
                                     label='Vessel',
                                     choices = c('NA','LR','SR','ECOT','CFV','SAIL','GITGAAT','COASTGUARD','TUG','TANKER','TUG+BARGE','CRUISE'),
                                     width = '95%')),
               
               column(3, textInput('group_min',
                                   label='Minimum Group Size',
                                   value='NA',
                                   width = '95%')),
               
               column(3, textInput('group_max',
                                   label='Maximum Group Size',
                                   value='NA',
                                   width = '95%'))),
             
             fluidRow(
               column(3, textInput('bhv',
                                   label='Behavior',
                                   value='NA',
                                   width = '95%')),
               
               column(3, selectInput('tr_direction',
                                     label='Travel Direction (of sighting)',
                                     choices = c('NA','N','NE','E','SE','S','SW','W','NW'),
                                     width = '95%')),
               
               column(3, textInput('vessels_500m',
                                   label='Vessels <500m',
                                   value='NA',
                                   width = '95%')),
               
               column(3, textInput('vessels_2km',
                                   label='Vessels <2km',
                                   value='NA',
                                   width = '95%'))),
             br(),
             fluidRow(
               column(12, textInput('notes',
                                    label='Notes',
                                    value='NA',
                                    width = '95%'))),
             br(),
             br(),
             fluidRow(column(2),
                      # Save button!
                      column(8, actionButton('save',
                                             h2('Save'),
                                             width='100%')),
                      column(2)),
             br(),
             br(),
    ),
    
    tabPanel(h4("Raw Data"),
             fluidRow(column(12, 
                             DTOutput("datatable")))),
    
  )
)

################################################################################
################################################################################

server <- function(input, output) {
  
  rv <- reactiveValues()
  rv$mr <- read.csv('marine_data.csv', header = TRUE)
  
  # Save button ================================================================
  observeEvent(input$save, {
    newdata <- c(input$scribe, input$boat_driver, input$area, 
                 input$surv_num, input$trail, input$observerL, input$observerR, 
                 input$effort, input$line, input$direction, input$speed, 
                 input$waypoint, input$beaufort, input$wave_height, input$cc, 
                 input$vis, input$weather, input$glare, input$glareL, 
                 input$glareR, input$boat_bearing, input$bino_bearing, 
                 input$bino_reticle, input$species, input$vessel, 
                 input$group_min, input$group_max, input$bhv, 
                 input$tr_direction, input$vessels_500m, input$vessels_2km, 
                 input$notes)
    
    log_line(newdata)
    rv$mr <- read.csv('marine_data.csv', header = TRUE)
    showNotification("Save successful!")
  })
  #=============================================================================
  
  output$datatable <- renderDT({ rv$mr })
  
}

################################################################################
################################################################################

shinyApp(ui, server)