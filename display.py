#!/usr/bin/python3

import sys, cv2
import numpy as np 
import matplotlib.image as mpi

cv2.namedWindow('VGA')
data = np.zeros((480, 640, 3), np.uint8)
x,y = 0,0
xoff,yoff = 51, 30	# Offsets
hsold, vsold = 0, 0

for line in sys.stdin:
  hs,vs,rs,gs,bs = [int(k) if k!='x' else 0 for k in line.split()]

  if 0 <= x-xoff < 640 and 0 <= y-yoff < 480:
    data[y-yoff,x-xoff] = [bs*255, gs*255, rs*255]
    
  # new line
  if hs==1 and hsold==0:
    x = 0
    y += 1
  else:
    x += 1
  hsold = hs

  # new frame
  if vs==1 and vsold==0:
    y = 0
    print("posedge VSYNC")
    cv2.imshow('VGA', data)
    ch = cv2.waitKey(2) & 0xFF
    if ord('q') == ch:
      break
    elif ord('p') == ch:
      print("Screenshot...")
      mpi.imsave('screenshot.png', data)
  vsold = vs

cv2.destroyAllWindows()

