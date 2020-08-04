import pandas
import re
import sympy
from sympy import diff
from sympy.abc import x,y
from sympy.parsing.sympy_parser import parse_expr
import numpy as np

#Evaluación REGREX
def evaluate_Fx(str_equ, valX):
    strOut = str_equ.replace("x", '*(x)')
    strOut = strOut.replace("^", "**")
    out = parse_expr(strOut, evaluate = False)
    return out.subs(x,valX)

#Evaluación Derivada
def derivate(str_equ, valX):
    strOut = str_equ.replace("x", '*(x)')
    strOut = strOut.replace("^", "**")
    out = parse_expr(strOut, evaluate = False)
    der = diff(out, x)
    return der.subs(x,valX)

#Diferencias finitas Centradas
def evaluate_derivate_centrada1(str_equ, x0, h, metodo):
    metodo = int(metodo)
    x0 = float(x0)
    h = float(h)
    if metodo == 1:
        valMax=evaluate_Fx(str_equ,x0+h)
        valMin=evaluate_Fx(str_equ,x0-h)
        return (valMax-valMin)/(2*h)
    elif metodo == 2:
        valMin = evaluate_Fx(str_equ,x0)
        valMedio = evaluate_Fx(str_equ,x0+h)
        valMax = evaluate_Fx(str_equ,x0+(2*h))
        parametros=[-3,4,-1]
        valores = [valMin,valMedio,valMax]
        fPrima = (np.dot(valores,parametros)/(2*h))
        return fPrima
    elif metodo == 3:
        valMax1=evaluate_Fx(str_equ,x0+h)
        valMin1=evaluate_Fx(str_equ,x0-h)
        valMax2=evaluate_Fx(str_equ,x0+(2*h))
        valMin2=evaluate_Fx(str_equ,x0-(2*h))
        parametros=[1,-8,8,-1]
        valores = [valMin2,valMin1,valMax1,valMax2]
        fPrima = (np.dot(valores,parametros)/(12*h))
        return fPrima

#Resolverdor de Newton
def newtonSolverX(x0, f_x, eps):
  x0 = float(x0)
  eps = float(eps)
  xn = x0
  error = 1
  arrayIters = []
  arrayF_x = []
  arrayf_x = []
  arrayXn = []
  arrayErr = []
  
  i = 0
  h = 0.000001
  while(error > eps):
    print("...")
    x_n1 = xn - (evaluate_Fx(f_x, xn)/evaluate_derivate_fx(f_x, xn, h))
    error = abs(x_n1 - xn)
    i = i + 1
    xn = x_n1
    arrayIters.append(i)
    arrayXn.append(xn)
    arrayErr.append(error)
    solution = [i, xn, error]

  print("Finalizo...")
  TableOut = pandas.DataFrame({'Iter':arrayIters, 'Xn':arrayXn, 'Error': arrayErr})
  return TableOut
