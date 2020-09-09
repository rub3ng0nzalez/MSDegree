# -*- coding: utf-8 -*-
"""
Created on Tue Sep  8 17:57:49 2020

@author: ruben
"""

import cv2

cap = cv2.VideoCapture(0)

# Define the codec and create VideoWriter object
fourcc = cv2.VideoWriter_fourcc(*'XVID')
out = cv2.VideoWriter('output.avi',fourcc, 20.0, (640,480))

while(cap.isOpened()):
    ret, frame = cap.read()
    if ret==True:
        #frame = cv2.flip(frame,0)

        # write the flipped frame
        out.write(frame)

        cv2.imshow('frame',frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            out.release()
            cap.release()
            cv2.destroyAllWindows()
            break
    else:
        out.release()
        cap.release()
        cv2.destroyAllWindows()
        break

# Release everything if job is finished
out.release()
#fourcc.release()
cap.release()
cv2.destroyAllWindows()