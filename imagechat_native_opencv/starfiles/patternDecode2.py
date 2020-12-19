import numpy as np
from Delaunator import Delaunator
import time
import cv2
import math

import patternECC

def checkEOF(bytesData):
    counter = 0
    index = 0
    for byte in bytesData:
        if byte == 0x1a:
            counter += 1
            # break
            if counter == 3:
                break
        else:
            index += 1
    return bytesData[:index]

# valid for method 2
def formatColour(colour):  # format the mean colour to whole number
    # b = round(colour[0] // 32) * 32 + 16
    # g = round(colour[1] // 32) * 32 + 16
    # r = round(colour[2] // 32) * 32 + 16
    b = round(colour[0] // 64) * 64 + 32
    g = round(colour[1] // 64) * 64 + 32
    r = round(colour[2] // 64) * 64 + 32
    if b > 255:
        b = 255
    if g > 255:
        g = 255
    if r > 255:
        r = 255
    return b, g, r

def greater(contour):  # for sorting the contours
    cx, cy = cv2.boundingRect(contour)[:2]
    return cy, cx

def PolyArea(x,y):
    return 0.5*np.abs(np.dot(x,np.roll(y,1))-np.dot(y,np.roll(x,1)))

def PointsCloseEnough(p1,p2):
    return ((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2) < 15**2

def centroid(vertexes):
    _x_list = [vertex [0] for vertex in vertexes]
    _y_list = [vertex [1] for vertex in vertexes]
    _len = len(vertexes)
    _x = sum(_x_list) / _len
    _y = sum(_y_list) / _len
    return[_x, _y]

def extractFromTriangleColor(delaunator, points, numberData, multipleCounter, maxSize, img):
    cloneImg = np.zeros(img.shape, np.uint8)
    temp = delaunator.triangles
    triangles = []
    for i in range(len(temp)//3):
        pointA = temp[i*3]
        pointB = temp[i*3+1]
        pointC = temp[i*3+2]
        pointsABC = [pointA, pointB, pointC]
        pointsABC.sort()
        triangles.append(pointsABC)
    triangles.sort()
    # print(triangles)
    # print(points)
    
    for i in range(len(triangles)):
        pointA = triangles[i][0]
        pointB = triangles[i][1]
        pointC = triangles[i][2]

        triangle_cnt = np.array( [(points[pointA][0], points[pointA][1]), (points[pointB][0], points[pointB][1]), (points[pointC][0], points[pointC][1])] )

        imgray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        mask = np.zeros(imgray.shape[:2], np.uint8)
        mask = cv2.drawContours(mask, [triangle_cnt], 0, 255, -1)
        mean_val = cv2.mean(img, mask=mask)
        # method 2: 32 (8) [all]
        b, g, r = formatColour(mean_val)
        ib = b // 64#32
        ig = g // 64#32
        ir = r // 64#32

        dataRGB = ib
        dataRGB = dataRGB*4 + ig
        dataRGB = dataRGB*4 + ir
        numberData = numberData + dataRGB * multipleCounter
        multipleCounter *= 64#512

        cloneImg = cv2.drawContours(cloneImg, [triangle_cnt], 0, (b, g, r), -1)
        # cv2.imshow("cloneImg", cloneImg)
        # cv2.waitKey(0)
        # cv2.imwrite('decodeStep/'+str(i)+'.png', cloneImg)
    return numberData, multipleCounter

# revert of encode.generatePoints
def extractFromPoints(points, maxSize):
    numberData = 0
    multipleCounter = 1
    for point in points:
        if round(point[0] / 50) > 0 and round(point[0] / 50) < round(maxSize / 50) :
            xr = round( ((point[0] - (round(point[0] / 50) * 50)) / 5) + 3 )
            numberData = numberData + xr * multipleCounter
            multipleCounter *= 8
        if round(point[1] / 50) > 0 and round(point[1] / 50) < round(maxSize / 50) :
            yr = round( ((point[1] - (round(point[1] / 50) * 50)) / 5) + 3 )
            numberData = numberData + yr * multipleCounter
            multipleCounter *= 8
    # return numberData, multipleCounter
    return 0, 1

def getPoints(img):
    points = []
    n = 0
    imgDraw = np.ones(img.shape, np.uint8) * 255
    for r in range(4):
        for g in range(4):
            for b in range(4):
                # low_threshold = np.array(( b*32, g*32, r*32 ), dtype=np.uint8, ndmin=1)
                # threshold = np.array(( b*32+16, g*32+16, r*32+16 ), dtype=np.uint8, ndmin=1)
                # high_threshold = np.array(( b*32+31, g*32+31, r*32+31 ), dtype=np.uint8, ndmin=1)
                low_threshold = np.array(( b*64, g*64, r*64 ), dtype=np.uint8, ndmin=1)
                threshold = np.array(( b*64+32, g*64+32, r*64+32 ), dtype=np.uint8, ndmin=1)
                high_threshold = np.array(( b*64+63, g*64+63, r*64+63 ), dtype=np.uint8, ndmin=1)
                mask = cv2.inRange(img, low_threshold, high_threshold)
                # mean_val = cv2.mean(img, mask=mask)

                contours, hierarchy = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
                contours.sort(key=greater)
                for i in range(len(contours)):
                    shape = "unidentified"
                    c = contours[i]

                    peri = cv2.arcLength(c, True)
                    approx = cv2.approxPolyDP(c, 0.04 * peri, True)
                    xa = []
                    ya = []
                    for p in range(len(approx)):
                        xa.append(approx[p][0][0])
                        ya.append(approx[p][0][1])
                    xna = np.array(xa)
                    yna = np.array(ya)
                    area = PolyArea(xna, yna)

                    if len(approx) == 3 and peri >= 24 and area > 180:
                        # shape = "triangle"
                        # print('is triangle with '+str(peri)+', area '+str(area))
                        for p in range(len(approx)):
                            points.append([ approx[p][0][0], approx[p][0][1] ])
                    elif len(approx) > 3 and peri >= 80 and area > 200:
                        # shape = "shape"
                        # print('is shape with '+str(peri)+', area '+str(area)+ ' '+str(len(approx)))
                        for p in range(len(approx)):
                            points.append([ approx[p][0][0], approx[p][0][1] ])
                    else:
                        continue
                    
                    # cv2.drawContours(imgDraw, [approx], 0, ( b*32+16, g*32+16, r*32+16 ), -1)

                    n += 1
    # cv2.imshow("decode", imgDraw)
    # cv2.waitKey(0)

    adjusted_points = []
    for point in points:
        insert = False
        for adjusted_point in adjusted_points:
            for ap in adjusted_point:
                if PointsCloseEnough(point, ap):
                    insert = True
                    adjusted_point.append(point)
                    break
            if insert:
                break
        if not insert:
            adjusted_points.append([point])
    points = []
    for adjusted_point in adjusted_points:
        point = centroid(adjusted_point)
        point[0] = round(point[0] / 5) * 5
        point[1] = round(point[1] / 5) * 5
        points.append(point)
    print('Points: '+str(len(points)))
    if(math.sqrt(len(points)) % 1 != 0):
        match = False
        print('additional step')
        size = round(math.sqrt(len(points)))
        for i in range(1, size-1):
            for point in points:
                if not PointsCloseEnough(point, [0, i * 50]):
                    points.append([0, i * 50])
                elif not PointsCloseEnough(point, [size * 50, i * 50]):
                    points.append([size * 50, i * 50])
                elif not PointsCloseEnough(point, [i * 50, 0]):
                    points.append([i * 50, 0])
                elif not PointsCloseEnough(point, [i * 50, size * 50]):
                    points.append([i * 50, size * 50])
                if(math.sqrt(len(points)) % 1 == 0):
                    match = True
                    break
            if match:
                break
    print('Points: '+str(len(points)))
    points = sorted(points , key=lambda k: [round(k[0]/50), round(k[1]/50)])
    for point in points:
        if point[0] < 15:
            point[0] = 0
        elif point[0] > img.shape[1] - 15:
            point[0] = img.shape[1]
        if point[1] < 15:
            point[1] = 0
        elif point[1] > img.shape[1] - 15:
            point[1] = img.shape[1]
    # print(points)
    # print(n)
    return points

def decode(inputfile):
    print('use default color set encode')
    img = cv2.imread(inputfile)
    print(img.shape)
    cloneImg = img.copy()
    imgDraw = np.ones(img.shape, np.uint8) * 255

    points = getPoints(img)
    numberData, multipleCounter = extractFromPoints(points, img.shape[0])
    # print(numberData)
    # print(multipleCounter)
    delaunator = Delaunator(points)
    byteData = numberData.to_bytes((numberData.bit_length() + 7) // 8, byteorder='little')

    numberData, multipleCounter = extractFromTriangleColor(delaunator, points, numberData, multipleCounter, img.shape[0], img)
    byteData = numberData.to_bytes((numberData.bit_length() + 7) // 8, byteorder='little')

    # print(byteData)
    print(len(byteData))
    # msg, check, errorlen = patternECC.decodeWithReedSolo(byteData)
    # print('Error Len: '+str(errorlen))
    # return patternECC.checkEOF(msg)
    return checkEOF(byteData)
