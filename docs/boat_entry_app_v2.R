# Data entry app for marine surveys 
# NCCS - Hannah Barrow - 2026

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(shiny)
library(lubridate)
library(DT)
library(dplyr)
library(bslib)

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

ui <- page_sidebar(
  titlePanel(h3("Marine Data Entry App")),
  tabsetPanel(
    tabPanel(h5("Survey Info"),
             br(),
             fluidRow(
               column(2, selectInput('scribe',
                                     label = 'Data Entry',
                                     choices = c('select scribe','Grace','Charline','Hannah','Robyn','Barbara'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               column(2, selectInput('boat_driver',
                                     label = 'Boat Driver',
                                     choices = c('select driver','Grace','Eric','Ron','Hannah'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               column(2, selectInput('observerS',
                                     label = 'Observer (single)',
                                     choices = c('NA','Grace','Charline','Hannah','Robyn','Barbara'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               column(2, selectInput('observerL',
                                     label = 'Observer Left',
                                     choices = c('NA','Grace','Charline','Hannah','Robyn','Barbara'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               column(2, selectInput('observerR',
                                     label = 'Observer Right',
                                     choices = c('NA','Grace','Charline','Hannah','Robyn','Barbara'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE))),
             fluidRow(
               column(2, selectInput('area',
                                     label = 'Area',
                                     choices = c('select area','LEWIS PASSAGE','VERNEY','BISHOP BAY','SQUALLY','OTTER/NEPEAN'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               column(2, selectInput('surv_num',
                                     label = 'Survey #',
                                     choices = c('select #','01','02','03','04','05','06'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               uiOutput('trail')),
             fluidRow(
               column(2, selectInput('line_main',
                                     label = 'Line (main)',
                                     choices = c('select line','A','B','C','D','E','F','G','H'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)), 
               column(3, selectInput('line_sub',
                                     label = 'Line sub (if discontinuous)',
                                     choices = c('NA','a','b','c','d','e','f','g','h'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)), 
               column(3, selectInput('el_direction',
                                     label = 'Travel Direction (of Elemiah)',
                                     choices = c('select direction','N','NE','E','SE','S','SW','W','NW'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE))),
             br(),
             h4("Weather Conditions"),
             fluidRow(
               column(3, numericInput('waypoint1',
                                      label = span("Waypoint"),
                                      value = '1',
                                      width = '95%')),
               column(3, textInput('speed_kts1',
                                   label = 'Average Speed (kts)',
                                   value = 'enter speed',
                                   width = '95%')),
               column(3, selectInput('species1',
                                     label = span('Species (MarMam or Vessel)'),
                                     choices = c('NA','HW','FW','BAL','OO','DP',
                                                 'SR','LR','CFV','ECOT','CRUISE',
                                                 'R','GG','SAIL','TANKER','TUG',
                                                 'TUG+BARGE','CG','OTHER'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE))),
             fluidRow(
               column(2, selectInput('beaufort',
                                     label = 'Beaufort',
                                     choices = c('0','0.5','1','1.5','2','2.5','3','3.5','4'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               column(2, selectInput('wave_height',
                                     label = 'Wave Height',
                                     choices = c('0','0.5','1','1.5','2','2.5','3'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               column(2, selectInput('cc',
                                     label = 'Cloud Cover %',
                                     choices = c('0','1','2','3','4','5','6','7','8','9','10',
                                                 '11','12','13','14','15','16','17','18','19','20',
                                                 '21','22','23','24','25','26','27','28','29','30',
                                                 '31','32','33','34','35','36','37','38','39','40',
                                                 '41','42','43','44','45','46','47','48','49','50',
                                                 '51','52','53','54','55','56','57','58','59','60',
                                                 '61','62','63','64','65','66','67','68','69','70',
                                                 '71','72','73','74','75','76','77','78','79','80',
                                                 '81','82','83','84','85','86','87','88','89','90',
                                                 '91','92','93','94','95','96','97','98','99','100'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               column(2, selectInput('vis_km',
                                     label = 'Visibility (km)',
                                     choices = c('30','29','28','27','26','25','24','23','22','21',
                                                 '20','19','18','17','16','15','14','13','12','11',
                                                 '10','9','8','7','6','5','4','3','2','1','0'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               column(2, selectInput('weather',
                                     label = 'Weather',
                                     choices = c('S','PS','OC','LR','R','F','SS','SR'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE))),
             fluidRow(
               column(2, selectInput('glare',
                                     label = 'Glare Intensity',
                                     choices = c('NONE','MILD','SEVERE'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               uiOutput('glareL'),
               uiOutput('glareR')),
             br(),
             h4("sighting input on next page"),
             h6("*the info here will stay the same until you change it, even after hitting save on the next page"),
             h6("**if only updating weather, make sure NA species is selected before saving"),
             br(),
             fluidRow(column(4),
                      column(4, h4("only hit save here if you are on effort")),
                      column(4)),
             fluidRow(column(4),
                      column(4, actionButton('save',
                                             h2('Save'),
                                             width='100%')),
                      column(4)),
             br(),
             br()
    ),
    tabPanel(h5("Sighting Details"),
             br(),
             fluidRow(
               column(2, radioButtons('effort',
                                      label = 'Effort',
                                      choices = c('ON','OFF'),
                                      inline = TRUE,
                                      width = '95%')),
               uiOutput('line')),
             br(),
             h4("Sightings"),
             h6("*you have to select species first"),
             fluidRow(
               column(3, numericInput('waypoint2',
                                      label = span("Waypoint"),
                                      value = '1',
                                      width = '95%')),
               column(3, textInput('speed_kts2',
                                   label = 'Average Speed (kts)',
                                   value = 'enter speed',
                                   width = '95%'))),
             fluidRow(
               column(3, selectInput('species2', 
                                     label = span('Species (MarMam or Vessel)', style = "font-weight: bold;"),
                                     choices = c('NA','HW','FW','BAL','OO','DP',
                                                 'SR','LR','CFV','ECOT','CRUISE',
                                                 'R','GG','SAIL','TANKER','TUG',
                                                 'TUG+BARGE','CG','OTHER'),
                                     width = '95%',
                                     multiple=FALSE, selectize=FALSE)),
               uiOutput('boat_bearing'),
               uiOutput('bino_bearing'),
               uiOutput('bino_reticle')),
             fluidRow(
               uiOutput('group_min'),
               uiOutput('group_max'),
               uiOutput('group_best')),
             fluidRow(
               uiOutput('bhv'),
               uiOutput('tr_direction'),
               uiOutput('vessels_500m'),
               uiOutput('vessels_2km')),
             br(),
             h4("Comments"),
             fluidRow(
               column(12, textInput('comments__________________________________',
                                    label = 'Anything to note or add?',
                                    value = '',
                                    width = '95%'))),
             br(),
             br(),
             fluidRow(column(4),
                      column(4, actionButton('save',
                                             h2('Save'),
                                             width='100%')),
                      column(4)),
             br(),
             br()
    ),
    tabPanel(h5("Raw Data"),
             fluidRow(column(12, 
                             DTOutput("datatable"))))
  ),
  
  sidebar = sidebar(
    br(),
    verbatimTextOutput("display"),
    fluidRow(
      actionButton("btn_7", "7", class = "btn-default btn-lg", style = "width: 70px;"),
      actionButton("btn_8", "8", class = "btn-default btn-lg", style = "width: 70px;"),
      actionButton("btn_9", "9", class = "btn-default btn-lg", style = "width: 70px;")),
    fluidRow(
      actionButton("btn_4", "4", class = "btn-default btn-lg", style = "width: 70px;"),
      actionButton("btn_5", "5", class = "btn-default btn-lg", style = "width: 70px;"),
      actionButton("btn_6", "6", class = "btn-default btn-lg", style = "width: 70px;")),
    fluidRow(
      actionButton("btn_1", "1", class = "btn-default btn-lg", style = "width: 70px;"),
      actionButton("btn_2", "2", class = "btn-default btn-lg", style = "width: 70px;"),
      actionButton("btn_3", "3", class = "btn-default btn-lg", style = "width: 70px;")),
    fluidRow(
      actionButton("btn_0", "0", class = "btn-default btn-lg", style = "width: 70px;"),
      actionButton("btn_dec", ".", class = "btn-default btn-lg", style = "width: 70px;"),
      actionButton("btn_na", "NA", class = "btn-default btn-lg", style = "width: 70px;")),
    actionButton("clear", "Clear", class = "btn-danger", style = "width: 210px;"),
    tags$script(HTML("
      $(document).on('click', 'input.form-control', function() {
        Shiny.setInputValue('keypad_target', this.id, {priority: 'event'});
      });
    ")),
    tags$script("
      $(document).on('focus', 'input.form-control', function() {
        if (this.id != 'comments__________________________________') {
          $(this).prop('readonly', true);
        }
      });
    ")  
  )
)

################################################################################
################################################################################

server <- function(input, output, session) {
  
  rv <- reactiveValues()
  rv$mr <- read.csv('marine_data.csv', header = TRUE)
  current_val <- reactiveVal("")
  
  #=============================================================================
  # reactive UIs
  
  # BUTTONS ####################################################################
  add_digit <- function(digit) {
    current_val(paste0(current_val(), digit))
  }
  
  observeEvent(input$btn_na, add_digit("NA"))
  observeEvent(input$btn_dec, add_digit("."))
  observeEvent(input$btn_0, add_digit("0"))
  observeEvent(input$btn_1, add_digit("1"))
  observeEvent(input$btn_2, add_digit("2"))
  observeEvent(input$btn_3, add_digit("3"))
  observeEvent(input$btn_4, add_digit("4"))
  observeEvent(input$btn_5, add_digit("5"))
  observeEvent(input$btn_6, add_digit("6"))
  observeEvent(input$btn_7, add_digit("7"))
  observeEvent(input$btn_8, add_digit("8"))
  observeEvent(input$btn_9, add_digit("9"))
  
  observeEvent(input$clear, {
    current_val("")
  })
  
  output$display <- renderText({
    if(current_val() == "") "0" else current_val()
  })
  
  observeEvent(input$keypad_target, {
    
    req(current_val() != "")
    
    target <- input$keypad_target
    value <- current_val()
    
    numeric_ids <- c(
      "glareL","glareR","waypoint","boat_bearing","bino_bearing","bino_reticle",
      "group_min","group_max","vessels_500m","vessels_2km")
    if (target %in% numeric_ids) {
      updateNumericInput(session, target, value = value)
    } else {
      updateTextInput(session, target, value = value)
    }
    
    current_val("")
  })
  
  # WAYPOINT ###################################################################
  observeEvent(input$waypoint1, {
    if (input$waypoint1 != input$waypoint2) {
      updateTextInput(session, "waypoint2", value = input$waypoint1)
    }
  })
  
  observeEvent(input$waypoint2, {
    if (input$waypoint2 != input$waypoint1) {
      updateTextInput(session, "waypoint1", value = input$waypoint2)
    }
  })
  
  # SPEED ######################################################################
  observeEvent(input$speed_kts1, {
    if (input$speed_kts1 != input$speed_kts2) {
      updateTextInput(session, "speed_kts2", value = input$speed_kts1)
    }
  })
  
  observeEvent(input$speed_kts2, {
    if (input$speed_kts2 != input$speed_kts1) {
      updateTextInput(session, "speed_kts1", value = input$speed_kts2)
    }
  })
  
  # SPECIES ######################################################################
  observeEvent(input$species1, {
    if (input$species1 != input$species2) {
      updateTextInput(session, "species2", value = input$species1)
    }
  })
  
  observeEvent(input$species2, {
    if (input$species2 != input$species1) {
      updateTextInput(session, "species1", value = input$species2)
    }
  })

  # LINE #######################################################################
  output$line <- renderUI({
    if(input$line_sub == "NA"){
      line <- paste0(input$line_main)
    }else{
      line <- paste0(input$line_main, "-", input$line_sub)
    }
    column(2, textInput("line",
                        label = 'Line (automatic input)',
                        value = line,
                        width = '95%'))
    
  })
  
  # TRAIL NAME #################################################################
  output$trail <- renderUI({
    if(input$area == "LEWIS PASSAGE"){
      trail_name <- paste0(format(Sys.Date(), "%Y%m%d"),"_","LP","_",input$surv_num)
    }else if(input$area == "VERNEY" | input$area == "BISHOP BAY"){
      trail_name <- paste0(format(Sys.Date(), "%Y%m%d"),"_","GBL","_",input$surv_num)
    }else if(input$area == "SQUALLY"){
      trail_name <- paste0(format(Sys.Date(), "%Y%m%d"),"_","SQ","_",input$surv_num)
    }else if(input$area == "OTTER/NEPEAN"){
      trail_name <- paste0(format(Sys.Date(), "%Y%m%d"),"_","OTNS","_",input$surv_num)
    }else{
      trail_name <- paste0(format(Sys.Date(), "%Y%m%d"),"_","NA","_",input$surv_num)
    }
    column(3, textInput("trail",
                        label = 'Trail Name  (automatic input)',
                        value = trail_name,
                        width = '95%'))
  })
  
  # GLARE LEFT #################################################################
  output$glareL <- renderUI({
    if(input$glare == 'NONE'){
      column(2, textInput('glareL',
                          label = 'Glare Left',
                          value = 'NA',
                          width = '95%'))
    }else{
      column(2, numericInput('glareL',
                             label = 'Glare Left',
                             value = 0, 
                             width = '95%'))
    }
  })
  # GLARE RIGHT #################################################################
  output$glareR <- renderUI({
    if(input$glare == 'NONE'){
      column(2, textInput('glareR',
                          label = 'Glare Right',
                          value = 'NA',
                          width = '95%'))
    }else{
      column(2, numericInput('glareR',
                             label = 'Glare Right',
                             value = 0,
                             width = '95%'))
    }
  })
  # BOAT BEARING ###############################################################
  output$boat_bearing <- renderUI({
    if(input$species1 == 'NA'){
      column(3, textInput('boat_bearing',
                          label = 'Boat Bearing',
                          value = 'NA',
                          width = '95%'))
    }else{
      column(3, numericInput('boat_bearing',
                             label = 'Boat Bearing',
                             value = 0, 
                             width = '95%'))
    }
  })
  # BINO BEARING ###############################################################
  output$bino_bearing <- renderUI({
    if(input$species1 == 'NA'){
      column(3, textInput('bino_bearing',
                          label = 'Bino Bearing',
                          value = 'NA',
                          width = '95%'))
    }else{
      column(3, numericInput('bino_bearing',
                             label = 'Bino Bearing',
                             value = 0, 
                             width = '95%'))
    }
  })
  # BINO RETICLE ###############################################################
  output$bino_reticle <- renderUI({
    if(input$species1 == 'NA'){
      column(3, textInput('bino_reticle',
                          label = 'Bino Reticle',
                          value = 'NA',
                          width = '95%'))
    }else{
      column(3, numericInput('bino_reticle',
                             label = 'Bino Reticle',
                             value = 0, 
                             width = '95%'))
    }
  })
  # GROUP MIN ###############################################################
  output$group_min <- renderUI({
    if(input$species1 == 'NA'){
      column(3, textInput('group_min',
                          label = 'Minimum Group Size',
                          value = 'NA',
                          width = '95%'))
    }else{
      column(3, numericInput('group_min',
                             label = 'Minimum Group Size',
                             value = 1,
                             width = '95%'))
    }
  })
  # GROUP MAX ###############################################################
  output$group_max <- renderUI({
    if(input$species1 == 'NA'){
      column(3, textInput('group_max',
                          label = 'Maximum Group Size',
                          value = 'NA',
                          width = '95%'))
    }else{
      column(3, numericInput('group_max',
                             label = 'Maximum Group Size',
                             value = 1,
                             width = '95%'))
    }
  })
  # GROUP BEST ###############################################################
  output$group_best <- renderUI({
    if(input$species1 == 'NA'){
      column(3, textInput('group_best',
                          label = 'Group Size Best Guess (automatic input)',
                          value = 'NA',
                          width = '95%'))
    }else{
      req(input$group_max, input$group_min)
      groupavg <- (input$group_max + input$group_min) / 2
      column(3, textInput("group_best",
                          label = 'Group Size Best Guess (automatic input)',
                          value = floor(groupavg),
                          width = '95%'))
    }
  })
  # BEHAVIOR ###################################################################
  output$bhv <- renderUI({
    if(input$species1 == 'NA'){
      column(3, textInput('bhv',
                          label = 'Behavior',
                          value = 'NA',
                          width = '95%'))
    }else if(input$species1 == 'HW' || input$species1 == 'FW' || input$species1 == 'BAL' || 
             input$species1 == 'OO' || input$species1 == 'DP'){
      column(3, selectInput('bhv',
                            label = 'Behavior',
                            choices = c('NA','ACTIVE','TR','RE-TR','SL','BNF','BR',
                                        'PS','HL','TL','TS','P','OTHER'),
                            width = '95%',
                            multiple=FALSE, selectize=FALSE))
    }else if(input$species1 == 'SR' || input$species1 == 'LR' || input$species1 == 'CFV' || 
             input$species1 == 'ECOT' || input$species1 == 'CRUISE' || input$species1 == 'R' || 
             input$species1 == 'GG' || input$species1 == 'SAIL' || input$species1 == 'TANKER' || 
             input$species1 == 'TUG' || input$species1 == 'TUG+BARGE' || input$species1 == 'CG'){
      column(3, selectInput('bhv',
                            label = 'Behavior',
                            choices = c('NA','FTR','STR','FISH','I','SAIL','OTHER'),
                            width = '95%',
                            multiple=FALSE, selectize=FALSE))
    }else{
      column(3, selectInput('bhv',
                            label = 'Behavior',
                            choices = c('NA','ACTIVE','TR','RE-TR','SL','BNF','BR','PS',
                                        'HL','TL','TS','P','FTR','STR','FISH',
                                        'I','SAIL','OTHER'),
                            width = '95%',
                            multiple=FALSE, selectize=FALSE))
    }
  })
  # TRAVEL DIRECTION ###########################################################
  output$tr_direction <- renderUI({
    if(input$species1 == 'NA'){
      column(3, textInput('tr_direction',
                          label = 'Travel Direction (of sighting)',
                          value = 'NA',
                          width = '95%'))
    }else{
      column(3, selectInput('tr_direction',
                            label = 'Travel Direction (of sighting)',
                            choices = c('NA','NONE','N','NE','E','SE','S','SW','W','NW'),
                            width = '95%',
                            multiple=FALSE, selectize=FALSE))
    }
  })
  # VESSELS 500 ################################################################
  output$vessels_500m <- renderUI({
    if(input$species1 == 'NA' || input$species1 == 'SR' || input$species1 == 'LR' || 
       input$species1 == 'CFV' || input$species1 == 'ECOT' || input$species1 == 'CRUISE' || 
       input$species1 == 'R' || input$species1 == 'GG' || input$species1 == 'SAIL' || 
       input$species1 == 'TANKER' || input$species1 == 'TUG' || input$species1 == 'TUG+BARGE' || 
       input$species1 == 'CG'){
      column(3, textInput('vessels_500m',
                          label = 'Vessels <500m',
                          value = 'NA',
                          width = '95%'))
    }else{
      column(3, numericInput('vessels_500m',
                             label = 'Vessels <500m',
                             value = 0,
                             width = '95%'))
    }
  })
  # VESSELS 2 ################################################################
  output$vessels_2km <- renderUI({
    if(input$species1 == 'NA' || input$species1 == 'SR' || input$species1 == 'LR' || 
       input$species1 == 'CFV' || input$species1 == 'ECOT' || input$species1 == 'CRUISE' || 
       input$species1 == 'R' || input$species1 == 'GG' || input$species1 == 'SAIL' || 
       input$species1 == 'TANKER' || input$species1 == 'TUG' || input$species1 == 'TUG+BARGE' || 
       input$species1 == 'CG'){
      column(3, textInput('vessels_2km',
                          label = 'Vessels <500m',
                          value = 'NA',
                          width = '95%'))
    }else{
      column(3, numericInput('vessels_2km',
                             label = 'Vessels <500m',
                             value = 0,
                             width = '95%'))
    }
  })
  
  # Save button ================================================================
  observeEvent(input$save, {
    newdata <- c(input$scribe, input$boat_driver, input$observerS, input$observerL, 
                 input$observerR, input$area, input$surv_num, input$trail, 
                 input$effort, input$line, input$el_direction, input$speed_kts1, 
                 input$waypoint1, input$beaufort, input$wave_height, input$cc, 
                 input$vis_km, input$weather, input$glare, input$glareL, input$glareR, 
                 input$boat_bearing, input$bino_bearing,input$bino_reticle, 
                 input$species1, input$group_min, input$group_max, input$group_best, 
                 input$bhv, input$tr_direction, input$vessels_500m, input$vessels_2km, 
                 input$comments__________________________________)
    log_line(newdata)
    rv$mr <- read.csv('marine_data.csv', header = TRUE)
    showNotification("Save successful!")
  })
  
  # Data table =================================================================
  output$datatable <- renderDT({ 
    datatable(rv$mr, 
              editable = TRUE, 
              options = list(pageLength = 100))
  })
  
  observeEvent(input$datatable_cell_edit, {
    info <- input$datatable_cell_edit
    rv$mr[info$row, info$col] <- DT::coerceValue(
      info$value,
      rv$mr[[info$col]]
    )
    write.csv(
      rv$mr,
      'marine_data.csv',
      row.names = FALSE
    )
  })
  
}

################################################################################
################################################################################

shinyApp(ui, server)
