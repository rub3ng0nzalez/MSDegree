# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import cv2
import os
import imutils
import sys

def main():
    persona = sys.argv[1]
    dataPath = 'C:/Users/ruben/Documents/MSDegree/TextMiningandImageRecognition/Reconocimiento facial/Reconocimiento_Facial/Reconocimiento_Facial/Data'
    dataPersona = dataPath + '/' + persona
    
    if(not(os.path.exists(dataPersona))):
        print("Creamos carpeta")
        os.makedirs(dataPersona)
    
    videoPath = persona + '.mp4'
    captura = cv2.VideoCapture(videoPath)
    print('Iniciando...')
    faceDetect = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
    count = 0
    
    while True:
        _, frame = captura.read()
        frame = imutils.resize(frame, width = 640)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        tempFrame = frame.copy()
        
        face = faceDetect.detectMultiScale(gray, 1.3, 5)
        #face = faceDetect.detectMultiple(gray, 1.3, 5)
        
        for (x, y, w, h) in face:
            cv2.rectangle(frame, (x,y), (x+w , y+h), (0,255,0), 2)
            cara = tempFrame[y: y+h, x:x + w]
            cara = cv2.resize(cara, (90,90), interpolation = cv2.INTER_CUBIC)
            strCara = dataPersona + '/rostro_' + str(count) + '.jpg'
            count = count + 1
            cv2.imwrite(strCara, cara)
            cv2.imshow('frame', frame)
        
        k = cv2.waitKey(1)
        if ((k == 27) or (count >= 500)):
            break
    
    print('Termino')
    captura.release()
    cv2.destroyAllWindows()
