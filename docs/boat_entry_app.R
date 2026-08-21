#Data entry app for marine surveys NCCS

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(shiny)
library(lubridate)
library(DT)
library(dplyr)

# Save data to CSV
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
               column(2, selectInput('scribe',
                                     label = 'Data Entry',
                                     choices = c('select name','Grace','Janie','Charline','Hannah','Robyn','Sacha'),
                                     width = '95%')),
               column(2, selectInput('boat_driver',
                                     label = 'Boat Driver',
                                     choices = c('select name','Grace','Janie','Eric','Ron','Hannah'),
                                     width = '95%')),
               column(2, selectInput('observerS',
                                     label = 'Observer (single)',
                                     choices = c('NA','Grace','Janie','Charline','Hannah','Robyn','Sacha'),
                                     width = '95%')),
               column(2, selectInput('observerL',
                                     label = 'Observer Left',
                                     choices = c('NA','Grace','Janie','Charline','Hannah','Robyn','Sacha'),
                                     width = '95%')),
               column(2, selectInput('observerR',
                                     label = 'Observer Right',
                                     choices = c('NA','Grace','Janie','Charline','Hannah','Robyn','Sacha'),
                                     width = '95%'))),
             fluidRow(
               column(2, selectInput('area',
                                     label = 'Area',
                                     choices = c('select area','LEWIS PASSAGE','VERNEY','BISHOP BAY','SQUALLY','OTTER/NEPEAN'),
                                     width = '95%')),
               column(2, numericInput('surv_num',
                                      label = 'Survey #',
                                      value = 0, 
                                      min = 0, 
                                      max = 12,
                                      width = '95%')),
               column(2, textInput('trail',
                                   label = 'Trail Name',
                                   value = 'enter trail',
                                   width = '95%'))),
             h3("Boat Info"),
             fluidRow(
               column(2, radioButtons('effort',
                                      label = 'Effort',
                                      choices = c('ON','OFF'),
                                      inline = TRUE,
                                      width = '95%')),
               column(2, textInput("line",
                                   label = 'Line',
                                   value = 'enter line',
                                   width = '95%')),
               column(2, selectInput('el_direction',
                                     label = 'Travel Direction (of Elemiah)',
                                     choices = c('select direction','N','NE','E','SE','S','SW','W','NW'),
                                     width = '95%')), 
               column(2, textInput('speed_kts',
                                   label = 'Average Speed (kts)',
                                   value = 'enter speed',
                                   width = '95%')),
               column(2, numericInput('waypoint',
                                      label = 'Waypoint',
                                      value = '1',
                                      min = 1, 
                                      max = 2000,
                                      width = '95%'))),
             h3("Weather Conditions"),
             fluidRow(
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
               column(2, numericInput('vis_km',
                                      label = 'Visibility (km)',
                                      value = 30, 
                                      min = 0, 
                                      max = 30,
                                      width = '95%')),
               column(2, selectInput('weather',
                                     label = 'Weather',
                                     choices = c('select weather','S','PS','OC','LR','R','F','SS','SR'),
                                     width = '95%'))),
             ## GLARE ##########################################################
             fluidRow(
               column(2, selectInput('glare',
                                     label = 'Glare Intensity',
                                     choices = c('NONE','MILD','SEVERE'),
                                     width = '95%')),
               ## IF NONE ######################################################
               conditionalPanel(
                 condition = "input.glare == 'NONE'",
                 column(2, textInput('glareL',
                                     label = 'Glare Left',
                                     value = 'NA',
                                     width = '95%')),
                 column(2, textInput('glareR',
                                     label = 'Glare Right',
                                     value = 'NA',
                                     width = '95%'))),
               ## IF MILD OR SEVERE ############################################
               conditionalPanel(
                 condition = "input.glare == 'MILD' || input.glare == 'SEVERE'",
                 column(2, numericInput('glareL',
                                        label = 'Glare Left',
                                        value = 0, 
                                        min = 0, 
                                        max = 360,
                                        width = '95%')),
                 column(2, numericInput('glareR',
                                        label = 'Glare Right',
                                        value = 0, 
                                        min = 0, 
                                        max = 360,
                                        width = '95%')))),
             h3("Sighting Details"),
             ## SPECIES ########################################################
             fluidRow(
               column(2, selectInput('species',
                                     label = 'Species (MarMam or Vessel)',
                                     choices = c('NA','HW','FW','BAL','OO','DP',
                                                 'SR','LR','CFV','ECOT','CRUISE',
                                                 'R','GG','SAIL','TANKER','TUG',
                                                 'TUG+BARGE','CG','OTHER'),
                                     width = '95%')),
               ## BEARING: IF NA ###############################################
               conditionalPanel(
                 condition = "input.species == 'NA'",
                 column(2, textInput('boat_bearing',
                                     label = 'Boat Bearing',
                                     value = 'NA',
                                     width = '95%')),
                 column(2, textInput('bino_bearing',
                                     label = 'Bino Bearing',
                                     value = 'NA',
                                     width = '95%')),
                 column(2, textInput('bino_reticle',
                                     label = 'Bino Reticle',
                                     value = 'NA',
                                     width = '95%'))),
               ## BEARING: IF SPECIES ##########################################
               conditionalPanel(
                 condition = "input.species == 'HW' || input.species == 'FW' || 
                 input.species == 'BAL' || input.species == 'OO' || input.species == 'DP' || 
                 input.species == 'SR' || input.species == 'LR' || input.species == 'CFV' || 
                 input.species == 'ECOT' || input.species == 'CRUISE' || input.species == 'R' || 
                 input.species == 'GG' || input.species == 'SAIL' || input.species == 'TANKER' || 
                 input.species == 'TUG' || input.species == 'TUG+BARGE' || input.species == 'CG' || 
                 input.species == 'OTHER'",
                 column(2, numericInput('boat_bearing',
                                        label = 'Boat Bearing',
                                        value = 0, 
                                        min = 0, 
                                        max = 360,
                                        width = '95%')),
                 column(2, numericInput('bino_bearing',
                                        label = 'Bino Bearing',
                                        value = 0, 
                                        min = 0, 
                                        max = 360,
                                        width = '95%')),
                 column(2, numericInput('bino_reticle',
                                        label = 'Bino Reticle',
                                        value = 0, 
                                        min = 0, 
                                        max = 360,
                                        width = '95%')))),
             fluidRow(
               ## GROUP: IF NA ###############################################
               conditionalPanel(
                 condition = "input.species == 'NA'",
                 column(2, textInput('group_min',
                                     label = 'Minimum Group Size',
                                     value = 'NA',
                                     width = '95%')),
                 column(2, textInput('group_max',
                                     label = 'Maximum Group Size',
                                     value = 'NA',
                                     width = '95%')),
                 column(2, textInput('group_best',
                                     label = 'Group Size Best Guess',
                                     value = 'NA',
                                     width = '95%'))),
               ## GROUP: IF SPECIES ###############################################
               conditionalPanel(
                 condition = "input.species == 'HW' || input.species == 'FW' || 
                 input.species == 'BAL' || input.species == 'OO' || input.species == 'DP' || 
                 input.species == 'SR' || input.species == 'LR' || input.species == 'CFV' || 
                 input.species == 'ECOT' || input.species == 'CRUISE' || input.species == 'R' || 
                 input.species == 'GG' || input.species == 'SAIL' || input.species == 'TANKER' || 
                 input.species == 'TUG' || input.species == 'TUG+BARGE' || input.species == 'CG' || 
                 input.species == 'OTHER'",
                 column(2, numericInput('group_min',
                                        label = 'Minimum Group Size',
                                        value = 1, 
                                        min = 1, 
                                        max = 100,
                                        width = '95%')),
                 column(2, numericInput('group_max',
                                        label = 'Maximum Group Size',
                                        value = 1, 
                                        min = 1, 
                                        max = 100,
                                        width = '95%')),
                 column(2, numericInput('group_best',
                                        label = 'Group Size Best Guess',
                                        value = 1, 
                                        min = 1, 
                                        max = 100,
                                        width = '95%')))),
             fluidRow(
               ## BHV: IF NA ###################################################
               conditionalPanel(
                 condition = "input.species == 'NA'",
                 column(2, textInput('bhv',
                                     label = 'Behavior',
                                     value = 'NA',
                                     width = '95%')),
                 column(2, textInput('tr_direction',
                                     label = 'Travel Direction (of sighting)',
                                     value = 'NA',
                                     width = '95%')),
                 column(2, textInput('vessels_500m',
                                     label = 'Vessels <500m',
                                     value = 'NA',
                                     width = '95%')),
                 column(2, textInput('vessels_2km',
                                     label = 'Vessels <2km',
                                     value = 'NA',
                                     width = '95%'))),
               ## BHV: IF MARMAM ###############################################
               conditionalPanel(
                 condition = "input.species == 'HW' || input.species == 'FW' || 
                 input.species == 'BAL' || input.species == 'OO' || input.species == 'DP'",
                 column(2, selectInput('bhv',
                                       label = 'Behavior',
                                       choices = c('NA','TR','RE-TR','SL','BNF','BR',
                                                   'PS','HL','TL','TS','P','OTHER'),
                                       width = '95%')),
                 column(2, selectInput('tr_direction',
                                       label = 'Travel Direction (of sighting)',
                                       choices = c('NA','N','NE','E','SE','S','SW','W','NW'),
                                       width = '95%')),
                 column(2, numericInput('vessels_500m',
                                        label = 'Vessels <500m',
                                        value = 0, 
                                        min = 0, 
                                        max = 100,
                                        width = '95%')),
                 column(2, numericInput('vessels_2km',
                                        label = 'Vessels <2km',
                                        value = 0, 
                                        min = 0, 
                                        max = 100,
                                        width = '95%'))),
               ## BHV: IF VESSEL ###############################################
               conditionalPanel(
                 condition = "input.species == 'SR' || input.species == 'LR' || input.species == 'CFV' || 
                 input.species == 'ECOT' || input.species == 'CRUISE' || input.species == 'R' || 
                 input.species == 'GG' || input.species == 'SAIL' || input.species == 'TANKER' || 
                 input.species == 'TUG' || input.species == 'TUG+BARGE' || input.species == 'CG'",
                 column(2, selectInput('bhv',
                                       label = 'Behavior',
                                       choices = c('NA','FTR','STR','FISH','SAIL',
                                                   'ANCH/I','W/ WHALES','OTHER'),
                                       width = '95%')),
                 column(2, selectInput('tr_direction',
                                       label = 'Travel Direction (of sighting)',
                                       choices = c('NA','N','NE','E','SE','S','SW','W','NW'),
                                       width = '95%')),
                 column(2, textInput('vessels_500m',
                                     label = 'Vessels <500m',
                                     value = 'NA',
                                     width = '95%')),
                 column(2, textInput('vessels_2km',
                                     label = 'Vessels <2km',
                                     value = 'NA',
                                     width = '95%'))),
               ## BHV: IF OTHER ################################################
               conditionalPanel(
                 condition = "input.species == 'OTHER'",
                 column(2, selectInput('bhv',
                                       label = 'Behavior',
                                       choices = c('NA','TR','RE-TR','SL','BNF','BR','PS',
                                                   'HL','TL','TS','P','FTR','STR','FISH',
                                                   'SAIL','ANCH/I','W/ WHALES','OTHER'),
                                       width = '95%')),
                 column(2, selectInput('tr_direction',
                                       label = 'Travel Direction (of sighting)',
                                       choices = c('NA','N','NE','E','SE','S','SW','W','NW'),
                                       width = '95%')),
                 column(2, numericInput('vessels_500m',
                                        label = 'Vessels <500m',
                                        value = 0, 
                                        min = 0, 
                                        max = 100,
                                        width = '95%')),
                 column(2, numericInput('vessels_2km',
                                        label = 'Vessels <2km',
                                        value = 0, 
                                        min = 0, 
                                        max = 100,
                                        width = '95%')))),
             h3("Comments"),
             fluidRow(
               column(12, textInput('comments__________________________________',
                                    label = 'Anything to note or add?',
                                    value = 'NA',
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
             br()
    ),
    
    tabPanel(h4("Raw Data"),
             fluidRow(column(12, 
                             DTOutput("datatable"))))
  )
)

################################################################################
################################################################################

server <- function(input, output) {
  
  rv <- reactiveValues()
  rv$mr <- read.csv('marine_data.csv', header = TRUE)
  
  # Save button ================================================================
  observeEvent(input$save, {
    newdata <- c(input$scribe, input$boat_driver, input$observerS, input$observerL, input$observerR,
                 input$area, input$surv_num, input$trail, 
                 input$effort, input$line, input$el_direction, input$speed_kts, input$waypoint, 
                 input$beaufort, input$wave_height, input$cc, input$vis_km, input$weather, 
                 input$glare, input$glareL, input$glareR, 
                 input$boat_bearing, input$bino_bearing,input$bino_reticle, input$species, 
                 input$group_min, input$group_max, input$group_best, 
                 input$bhv, input$tr_direction, input$vessels_500m, input$vessels_2km, 
                 input$comments__________________________________)
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