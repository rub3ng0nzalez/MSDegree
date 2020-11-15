library(plumber)

#' @apiTitle Tutorial Plumber
#' @apiDescription En este endpoint tenemos los 
#' tres ejemplo de como utilizar Plumber para
#' crear API's

#' Eco del input
#' @param msg El mensaje que vamos a repetir
#' @get /echo

function(msg=""){
  list(msg = paste0("El mensaje es: ", msg) )
}
