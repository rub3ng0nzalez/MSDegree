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

def load_checkpoint(filepath):
    if torch.cuda.is_available():
        checkpoint = torch.load(filepath)
    else:
        checkpoint = torch.load(filepath, map_location=torch.device('cpu'))
    model = checkpoint['model']
    model.load_state_dict(checkpoint['state_dict'])
    for parameter in model.parameters():
        parameter.requires_grad = False
    
    return model.eval()


filepath = "models/2.pth"
loaded_model = load_checkpoint(filepath)

cap = cv2.VideoCapture(0)
assert cap.isOpened(), 'No se puede abrir la webcam'

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

font_scale=1
thickness = 2
red = (0,0,255)
green = (0,255,0)
blue = (255,0,0)
font=cv2.FONT_HERSHEY_SIMPLEX

face_cascade = cv2.CascadeClassifier(r'haarcascade_frontalface_default.xml')
#face_cascade = cv2.CascadeClassifier(r'haarcascade_profileface_umist1.xml')

#classifier = cv2.CascadeClassifier()

#SI
train_transforms = transforms.Compose([
    transforms.Resize((224,224)),
    transforms.ToTensor(),
    transforms.Normalize((0.5,0.5,0.5), (0.5,0.5,0.5))
    ])


while(cap.isOpened()):
    ret, frame = cap.read()
    if ret == True:

        frame = imutils.resize(frame, width=640)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = face_cascade.detectMultiScale(gray, 1.3, 5)
        
        for (x, y, w, h) in faces:
            
            cv2.rectangle(frame, (x, y), (x+w, y+h), blue, 2)
            
            croped_img = frame[y:y+h, x:x+w]
            pil_image = Image.fromarray(croped_img, mode = "RGB")
            pil_image = train_transforms(pil_image)
            image = pil_image.unsqueeze(0)
            
            #image = image.to(device)
            
            result = loaded_model(image)
            _, maximum = torch.max(result.data, 1)
            prediction = maximum.item()

            
            if prediction == 0:
                cv2.putText(frame, "Mascarilla", (x,y - 10), font, font_scale, green, thickness)
                cv2.rectangle(frame, (x, y), (x+w, y+h), green, 2)
            elif prediction == 1:
                cv2.putText(frame, "Sin mascarilla", (x,y - 10), font, font_scale, red, thickness)
                cv2.rectangle(frame, (x, y), (x+w, y+h), red, 2)
        
        cv2.imshow('frame',frame)
        
        if (cv2.waitKey(1) & 0xFF) == ord('q'):
            break
    else:
        break

cap.release()
cv2.destroyAllWindows()