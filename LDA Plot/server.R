library(shiny)
require(openxlsx)
library(ggplot2)
library(plyr)
library(dplyr)
library(MASS)
library(scales)

library(readxl)

shinyServer(function(input,output){
  
  read_df<- function(){
    if(is.null(input$file)){
      df = read.xlsx("Sample Data - Rose Student.xlsx")
      df2 = read_excel("Sample Data - Rose Student.xlsx")
      check1 = !is.na(df2[,input$response_text])
      check2 = !is.na(df2[,input$response_text2])
      
      df = df[check1 & check2,]
      
    }else{
      df<- read.xlsx(input$file$datapath)
    }
    return(df)
  }
  
  get_df_question <- function(question_keyword){
    df <- read_df()
    return(df[,grepl(question_keyword, colnames(df))])
  }
  
  get_df_response <- function(response_keyword){
    df <- read_df()
    response = df[,response_keyword]
    return(response)
  }
  
  get_common_words <- function(words) {
    #extract substrings from length 1 to length of shortest word
    subs <- sapply(seq_len(min(nchar(words))), 
                   function(x, words) substring(words, 1, x), 
                   words=words)
    #max length for which substrings are equal
    neqal <- max(cumsum(apply(subs, 2, function(x) length(unique(x)) == 1L)))
    #return substring
    substring(words[1], 1, neqal)
  }
  
  get_common_words_from_back <- function(words) {
    #extract substrings from length 1 to length of shortest word
    word_length = max(nchar(words))
    subs <- sapply(rev(seq_len(min(nchar(words)))), 
                   function(x, words) substring(words, x,max(nchar(words))), 
                   words=words)
   
    #max length for which substrings are equal
    neqal <- max(cumsum(apply(subs, 2, function(x) length(unique(x)) == 1L)))
    #return substring
    substring(words[1],word_length-neqal+1 , word_length)
  }
  
  get_common_words_of_df <- function(df1, df2){
    names1 <- names(df1)
    names2 <- names(df2)
    new_names <- c()
    
    for(i in 1:length(names1)){
      new_p1 <- get_common_words(c(names1[i],names2[i]))
      new_p2 <- get_common_words_from_back(c(names1[i],names2[i]))
      new_names <- c(new_names,paste(new_p1,new_p2,sep = ""))
    }
    return(new_names)
  }
  
  LDA <- function(){
    if(is.null(input$file)){
      df = read.xlsx("Sample Data - Rose Student.xlsx")
    }else{
      df<- read.xlsx(input$file$datapath)
    }
    
    df_sub <- get_df_question(input$question_substring)
    response <- get_df_response(input$response_text)
    
    if ((input$response_text2)!=""){
      extra_response<- get_df_response(input$response_text2)
      response <- c(response,extra_response)
      print(length(response))
    }
    if ((input$question_substring2)!=""){
      df_sub_extra <- get_df_question(input$question_substring2)
      common_names <- (get_common_words_of_df(df_sub,df_sub_extra))
      names(df_sub) <- common_names
      names(df_sub_extra) <- common_names
      df_sub <- rbind(df_sub,df_sub_extra)
    }
    
   

    response = as.factor(response)
    l <- lda(data=df_sub, response~.)
    plda <- predict(l,df_sub)
    dataset <- data.frame(response,lda = plda$x)
    prop.lda = l$svd^2/sum(l$svd^2)
    
    g <- ggplot()
    
    if (1 %in% input$plotcheck){
      g <- g+ geom_point(data=dataset,aes(lda.LD1, lda.LD2, colour = response), size = 1.5,alpha=0.5)
    }
    if (2 %in% input$plotcheck){
      lda_names <- paste("lda",colnames(plda$x),sep = ".")
      df_centroid <- aggregate(data=dataset,x=dataset[,lda_names],by=list(dataset[,"response"]),FUN = mean)
      colnames(df_centroid)[1]<-"response"
      g <- g+geom_point(data=df_centroid,aes(lda.LD1, lda.LD2, colour = response), size = 4)
    }
    
    if (3 %in% input$plotcheck){
      df_feature_mean = l$means
      g <- g+geom_segment(aes(x=0,y=0,xend=df_feature_mean[2,],yend=df_feature_mean[3,],
                                     colour=colnames(df_feature_mean)),size=0.8,arrow = arrow(length = unit(0.3,"cm")))
      g
    }
    
    
    g <- g+labs(x = paste("LD1 (", percent(prop.lda[1]), ")", sep=""),
           y = paste("LD2 (", percent(prop.lda[2]), ")", sep=""))
    return(g)
  }
  
  output$out <- renderPrint(input$column_select)
  
  output$plot <- reactivePlot(function(){
    g <- LDA()
    print(g)
  })
  
  # output$feature_for_select <- renderUI({
  #   df <- read_df()
  #   hr()
  #   selectInput('feature_select', label = h4('select questions'), names(df), multiple=TRUE, selectize=TRUE)
  # })
  # 
  # output$response_for_select <- renderUI({
  #   df <- read_df()
  #   hr()
  #   selectInput('response_select', label = h4('select response variable'), names(df), multiple=TRUE, selectize=TRUE)
  # })
  
})