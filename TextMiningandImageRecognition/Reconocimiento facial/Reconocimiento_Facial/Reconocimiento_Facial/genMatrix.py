# -*- coding: utf-8 -*-
"""
Created on Fri Aug 21 20:26:26 2020

@author: ruben
"""

import cv2
import os
import numpy as np
import pandas as pd

def main():
    dataPath = 'C:/Users/ruben/Documents/MSDegree/TextMiningandImageRecognition/Reconocimiento facial/Reconocimiento_Facial/Reconocimiento_Facial/Data'
    listaPersonas = os.listdir(dataPath)
    print('Lista de Personas: '+ str(listaPersonas))
    
    labels = []
    faceList = []
    dataValues = []
    label = 0
    imDim = 0
    
    for nameDir in listaPersonas:
        personaPath = dataPath + '/' + nameDir
        print('Leyendo...')
        for fileName in os.listdir(personaPath):
            print('Rostro: ' + nameDir + '/' + fileName)
            labels.append(label)
            strRostro = personaPath + '/' + fileName
            imagen = cv2.imread(strRostro, cv2.IMREAD_GRAYSCALE)
            imDim = imagen.shape[0] * imagen.shape[1]
            cv2.imshow('imagen', imagen)
            dataValues.append(imagen.reshape(-1))
            cv2.waitKey(10)
        label = label + 1
    
    cols = ['X'+str(i) for i in range(0, imDim)]
    dfOut = pd.DataFrame(np.vstack(dataValues), columns = cols)
    dfOut['target'] = labels
    dfOut.to_csv('imagesData.csv')
    
    print(dfOut)
    
    cv2.destroyAllWindows()

main()