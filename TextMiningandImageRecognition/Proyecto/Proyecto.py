# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'Proyecto.ui'
#
# Created by: PyQt5 UI code generator 5.15.0
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.

from PyQt5 import QtCore, QtGui, QtWidgets
import cvlib as cv
import cv2
from PIL import Image
import xmltodict
import random
import imutils
import os
from os import listdir
from os.path import isfile, join
import torchvision 
import torch 
import torchvision.models as models
import torchvision.transforms as transforms
import torchvision.datasets as datasets

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(1024, 828)
        
        #---Nuestro Modelo
        self.filepath = "models/2.pth"
        self.loaded_model = self.load_checkpoint(self.filepath)
        
        self.font_scale=1
        self.thickness = 2
        self.red = (0,0,255)
        self.green = (0,255,0)
        self.blue = (255,0,0)
        self.font=cv2.FONT_HERSHEY_SIMPLEX

        self.face_cascade = cv2.CascadeClassifier(r'haarcascade_frontalface_default.xml')
        
        self.train_transforms = transforms.Compose([
            transforms.Resize((224,224)),
            transforms.ToTensor(),
            transforms.Normalize((0.5,0.5,0.5), (0.5,0.5,0.5))
            ])
        #---Nuestro Modelo
        
        self.capture = cv2.VideoCapture(0)
        self.dimensions = self.capture.read()[1].shape[1::-1]
        
        # Define the codec and create VideoWriter object
        self.fourcc = cv2.VideoWriter_fourcc(*'XVID')
        
        # count variable 
        self.count = 0
        self.countMask = 0
        
        # start flag 
        self.start = False
        self.startMask = False
        
        #--Definicion de variables a usar por el modelo
        #------Fin variables a usar por el modelo
        
        
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.playButton = QtWidgets.QPushButton(self.centralwidget)
        self.playButton.setGeometry(QtCore.QRect(200, 570, 171, 71))
        icon = QtGui.QIcon()
        icon.addPixmap(QtGui.QPixmap("play.ico"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.playButton.setIcon(icon)
        self.playButton.setIconSize(QtCore.QSize(32, 32))
        self.playButton.setObjectName("playButton")
        self.playButton.clicked.connect(self.clickedPlay)
        
        self.stopButton = QtWidgets.QPushButton(self.centralwidget)
        self.stopButton.setGeometry(QtCore.QRect(390, 570, 121, 71))
        icon1 = QtGui.QIcon()
        icon1.addPixmap(QtGui.QPixmap("stop.ico"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.stopButton.setIcon(icon1)
        self.stopButton.setIconSize(QtCore.QSize(32, 32))
        self.stopButton.setObjectName("stopButton")
        self.stopButton.clicked.connect(self.clickedStop)
        self.stopButton.setEnabled(False)
        
        scene = QtWidgets.QGraphicsScene(self.centralwidget)
        pixmap = QtGui.QPixmap(*self.dimensions)
        self.pixmapItem = scene.addPixmap(pixmap)
        
        self.graphicsView = QtWidgets.QGraphicsView(self.centralwidget)
        self.graphicsView.setGeometry(QtCore.QRect(40, 30, 951, 481))
        self.graphicsView.setObjectName("graphicsView")
        self.graphicsView.setScene(scene)
        
        self.timer = QtCore.QTimer(self.centralwidget)
        self.timer.setInterval(0)
        self.timer.timeout.connect(self.get_frame)
        
        # creating a timer object 
        self.timerDuracion = QtCore.QTimer(self.centralwidget) 
  
        # adding action to timer 
        self.timerDuracion.timeout.connect(self.showTime) 
  
        # update the timer every tenth second 
        self.timerDuracion.start(100)
        
        # creating a timer object 
        self.timerMask = QtCore.QTimer(self.centralwidget) 
  
        # adding action to timer 
        self.timerMask.timeout.connect(self.showTimeMask) 
  
        # update the timer every tenth second 
        self.timerMask.start(100)
        
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(370, 740, 121, 16))
        self.label.setObjectName("label")
        self.label_2 = QtWidgets.QLabel(self.centralwidget)
        self.label_2.setGeometry(QtCore.QRect(360, 680, 131, 16))
        self.label_2.setObjectName("label_2")
        self.label_3 = QtWidgets.QLabel(self.centralwidget)
        self.label_3.setGeometry(QtCore.QRect(360, 710, 131, 16))
        self.label_3.setObjectName("label_3")
        self.conMascarilla = QtWidgets.QLabel(self.centralwidget)
        self.conMascarilla.setGeometry(QtCore.QRect(510, 680, 47, 13))
        self.conMascarilla.setText("0")
        self.conMascarilla.setObjectName("conMascarilla")
        self.sinMascarilla = QtWidgets.QLabel(self.centralwidget)
        self.sinMascarilla.setGeometry(QtCore.QRect(510, 710, 47, 13))
        self.sinMascarilla.setText("0")
        self.sinMascarilla.setObjectName("sinMascarilla")
        self.total = QtWidgets.QLabel(self.centralwidget)
        self.total.setGeometry(QtCore.QRect(510, 740, 47, 13))
        self.total.setText("0")
        self.total.setObjectName("total")
        
        self.reiniciarButton = QtWidgets.QPushButton(self.centralwidget)
        self.reiniciarButton.setGeometry(QtCore.QRect(530, 570, 121, 71))
        self.reiniciarButton.setEnabled(False)
        icon2 = QtGui.QIcon()
        icon2.addPixmap(QtGui.QPixmap("reiniciar.ico"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.reiniciarButton.setIcon(icon2)
        self.reiniciarButton.setIconSize(QtCore.QSize(32, 32))
        self.reiniciarButton.setObjectName("reiniciarButton")
        self.reiniciarButton.clicked.connect(self.clickedReiniciar)
        self.label_4 = QtWidgets.QLabel(self.centralwidget)
        self.label_4.setGeometry(QtCore.QRect(320, 760, 181, 20))
        self.label_4.setText("Porcentaje de tiempo con mascarilla")
        self.label_4.setObjectName("label_4")
        self.label_5 = QtWidgets.QLabel(self.centralwidget)
        self.label_5.setGeometry(QtCore.QRect(510, 760, 47, 13))
        self.label_5.setObjectName("label_5")
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 1024, 21))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

#-----Metodos para lectura del modelo
#--Nuestro Modelo
    def load_checkpoint(self,filepath):
        if torch.cuda.is_available():
            checkpoint = torch.load(filepath)
        else:
            checkpoint = torch.load(filepath, map_location=torch.device('cpu'))
        model = checkpoint['model']
        model.load_state_dict(checkpoint['state_dict'])
        for parameter in model.parameters():
            parameter.requires_grad = False
    
        return model.eval()
#--Nuestro Modelo   
    
# -----Fin metodos de lectura del modelo

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "Proyecto Text Mining and Image Recognition"))
        self.playButton.setText(_translate("MainWindow", "Play"))
        self.stopButton.setText(_translate("MainWindow", "Stop"))
        self.label.setText(_translate("MainWindow", "Duración total del video"))
        self.label_2.setText(_translate("MainWindow", "Total tiempo con mascarilla"))
        self.label_3.setText(_translate("MainWindow", "Total tiempo sin mascarilla"))
        self.reiniciarButton.setText(_translate("MainWindow", "Reiniciar"))
        
    def clickedPlay(self):
        self.stopButton.setEnabled(True)
        self.playButton.setEnabled(False)
        
        
        self.out = cv2.VideoWriter('output.avi',self.fourcc, 20.0, (640,480))
        self.timer.start()
        # making flag true 
        self.start = True

        
    def clickedStop(self):
        self.stopButton.setEnabled(False)
        self.reiniciarButton.setEnabled(True)
        self.out.release()
        self.timer.stop()
        # making flag false 
        self.start = False
        self.startMask = False
        
        #Llenar tiempo sin mascarilla
        self.sinMascarilla.setText(str((self.count-self.countMask)/10)+" s")
        
        #Llenar porcentaje de tiempo con mascarilla
        self.label_5.setText(str(round(((self.countMask/self.count)*100),2))+ "%")
        
    def clickedReiniciar(self):
        self.reiniciarButton.setEnabled(False)
        self.playButton.setEnabled(True)
        scene = QtWidgets.QGraphicsScene(self.centralwidget)
        pixmap = QtGui.QPixmap(*self.dimensions)
        self.pixmapItem = scene.addPixmap(pixmap)
        self.graphicsView.setScene(scene)
        
         # making flag false 
        self.start = False
        self.startMask = False
  
        # setting count value to 0 
        self.count = 0
        self.countMask = 0
  
        # setting label text 
        self.total.setText("0")
        self.conMascarilla.setText("0")
        self.sinMascarilla.setText("0")
        self.label_5.setText("0")
        
    
    def get_frame(self):
        #_, frame = self.capture.read()
        
        #-------Codigo para llamar al modelo
        ret, frame = self.capture.read()
        if ret:

            frame = imutils.resize(frame, width=640)
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            faces = self.face_cascade.detectMultiScale(gray, 1.3, 5)
            
            for (x, y, w, h) in faces:
                
                cv2.rectangle(frame, (x, y), (x+w, y+h), self.blue, 2)
                
                croped_img = frame[y:y+h, x:x+w]
                pil_image = Image.fromarray(croped_img, mode = "RGB")
                pil_image = self.train_transforms(pil_image)
                image = pil_image.unsqueeze(0)
                
                #image = image.to(device)
                
                result = self.loaded_model(image)
                _, maximum = torch.max(result.data, 1)
                prediction = maximum.item()

                
                if prediction == 0:
                    cv2.putText(frame, "Mascarilla", (x,y - 10), self.font, self.font_scale, self.green, self.thickness)
                    cv2.rectangle(frame, (x, y), (x+w, y+h), self.green, 2)
                    self.startMask = True
                elif prediction == 1:
                    cv2.putText(frame, "Sin mascarilla", (x,y - 10), self.font, self.font_scale, self.red, self.thickness)
                    cv2.rectangle(frame, (x, y), (x+w, y+h), self.red, 2)
                    self.startMask = False
            
            #cv2.imshow('frame',frame)
        
        
        #--Captura de pantalla        
        #-----Final de captura del modelo
        
        
            self.out.write(frame)
            image = QtGui.QImage(frame, *self.dimensions, QtGui.QImage.Format_RGB888).rgbSwapped()
            pixmap = QtGui.QPixmap.fromImage(image)
            self.pixmapItem.setPixmap(pixmap)
            
    # method called by timer 
    def showTime(self): 
  
        # checking if flag is true 
        if self.start: 
            # incrementing the counter 
            self.count += 1
            
            # getting text from count 
            text = str(self.count /10 ) + " s"
  
            # showing text 
            self.total.setText(text) 
            
     # method called by timer 
    def showTimeMask(self): 
  
        # checking if flag is true 
        if self.startMask: 
            # incrementing the counter 
            self.countMask += 1
            
            # getting text from count 
            text = str(self.countMask /10) + " s"
  
            # showing text 
            self.conMascarilla.setText(text)

if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())
