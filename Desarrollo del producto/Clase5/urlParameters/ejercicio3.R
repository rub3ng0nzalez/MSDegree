library(plumber)

suma <- function(a,b){
  return(a+b)
}


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


#' Graficar un histograma
#' @serializer png
#' @get /plot
function(){
  rand <- rnorm(100)
  hist(rand)
}

#' Devuelve la suma de los dos parametros que se envian
#' @param a El primer numero
#' @param b El segundo numero
#' @serializer unboxedJSON
#' @post /sum

function(a,b){
  list(
    a=a,
    b=b,
    output=suma(as.numeric(a),as.numeric(b))
  )
  
}
