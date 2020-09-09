# -*- coding: utf-8 -*-
"""
Created on Tue Sep  8 18:18:32 2020

@author: ruben
"""
import cv2
def write(self, filename, frames, fps, show=False):
        fps = max(1, fps)
        out = None

        try:
            for image in frames:
                frame = cv2.imread(image)
                if show:
                    cv2.imshow('video', frame)

                if not out:
                    height, width, channels = frame.shape
                    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
                    out = cv2.VideoWriter(filename, fourcc, 20, (width, height))

                out.write(frame)

        finally:
            out and out.release()
            cv2.destroyAllWindows() 