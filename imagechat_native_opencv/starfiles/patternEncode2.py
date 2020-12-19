import numpy as np
from Delaunator import Delaunator
import time
import cv2
import os
import math
import random

import patternECC
import patternDecode2

size = 0

def imgGenerator(delaunator, points, numberData, maxSize):
    global size
    excessData = 0
    colorData = 0
    dd2 = 0
    img = np.ones((maxSize, maxSize, 3), np.uint8) * 255
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

    # print('\ta  size: '+str(size.bit_length() / 8))
    # print('\ta color: '+str(colorData.bit_length() / 8))
    for i in range(len(triangles)):
        pointA = triangles[i][0]
        pointB = triangles[i][1]
        pointC = triangles[i][2]

        triangle_cnt = np.array( [(points[pointA][0], points[pointA][1]), (points[pointB][0], points[pointB][1]), (points[pointC][0], points[pointC][1])] )

        # method 2: 32 (8) [all]
        if numberData != 0:
            rgb = (numberData % 64)
            numberData = numberData // 64
            r = rgb % 4
            g = (rgb // 4) % 4
            b = (rgb // 16) % 4
            # cv2.drawContours(img, [triangle_cnt], 0, (b*32+16, g*32+16, r*32+16), -1)
            cv2.drawContours(img, [triangle_cnt], 0, (b*64+32, g*64+32, r*64+32), -1)

            # dataRGB = b
            # dataRGB = dataRGB*8 + g
            # dataRGB = dataRGB*8 + r
            # numberData = numberData + dataRGB * multipleCounter
            # multipleCounter *= 512
        else:
            r = np.random.randint(0,4)
            g = np.random.randint(0,4)
            b = np.random.randint(0,4)
            if excessData == 0:
                excessData = 1
            excessData *= 64
            cv2.drawContours(img, [triangle_cnt], 0, (b*64+32, g*64+32, r*64+32), -1)
        # cv2.imshow("process", img)
        # cv2.waitKey(0)
        size = (size + 1) * 512 - 1
        colorData = (colorData + 1) * 512 - 1
        # print('\ta  size: '+str(size.bit_length() / 8))
        # print('\ta color: '+str(colorData.bit_length() / 8))
        # cv2.imwrite('encodeStep/'+str(i)+'.png', img)

    # print('Color byte : '+str(colorData.bit_length() / 8))
    # print('Total byte : '+str(size.bit_length() / 8))
    return img

def generatePoints(numberData, maxSize):
    global size
    #create random points
    points = []
    for x in range(maxSize//50 + 1):
        for y in range(maxSize//50 + 1):
            xp = x * 50
            yp = y * 50
            if xp >= maxSize :
                xp = maxSize-1
            if yp >= maxSize :
                yp = maxSize-1
            points.append( [xp, yp] )
    # size_on_line = 0
    dd2 = 0
    
    # point adjustment on data
    for point in points:
        if point[0] > 0 and point[0] < maxSize - 1 and point[1] > 0 and point[1] < maxSize - 1:
            xr = (numberData % 7 - 2) * 5
            numberData = numberData // 7
            # point[0] += xr
            point[0] += random.randint(-2,2) * 5
        # if point[1] > 0 and point[1] < maxSize - 1:
            yr = (numberData % 7 - 2) * 5
            numberData = numberData // 7
            # point[1] += yr
            point[1] += random.randint(-2,2) * 5
    print('\tgenerate points: '+str(len(points)))
    # print('Points byte : '+str((size_on_line.bit_length()) / 8))
    # size += size_on_line
    # print('line: '+str((size_on_line.bit_length() + 7) // 8) + ' bytes')
    return points

def calculateImgSize(byteData):
    global size
    maxSize = 0
    
    # pointsByte = 0
    colorsByte = 0
    # while patternECC.estimateLengthWithReedSolo(byteData) > (colorsByte):
    while len(byteData) > (colorsByte):
        maxSize += 250
        # points
        numOfPoints = pow(maxSize//50 + 1, 2)
        # print(numOfPoints)
        pointsNumber = pow( 8 * 8 , pow(maxSize//50 - 1, 2) ) * pow( 8 , (maxSize//50 - 1) * 4 ) - 1
        print('\tgenerate points: '+str(numOfPoints))
        # pointsByte = int(pointsNumber).bit_length() / 8

        # color
        # numOfTriangle = numOfPoints * 1.28
        numOfTriangle = round(2 * ((maxSize//50) ** 2))
        # print('tri: '+str(numOfTriangle))
        # method 2: 15 (18)
        # TODO: method
        # colorsByte = (int(pow(512, int(numOfTriangle))).bit_length() + 7) // 8
        # colorsByte = (int(pow(512, int(numOfTriangle)) - 1).bit_length()) / 8
        colorsByte = (int(pow(64, int(numOfTriangle)) - 1).bit_length()) / 8
        # # print('\tEstimate Points: '+str(pointsByte))
        # print('\tEstimate Colors: '+str(colorsByte))
        print('\tEstimate CurrentByte: '+str(colorsByte))
    # print('\tLine bytes: '+str(pointsByte))
    # print('\tColor bytes: '+str(colorsByte))
    # print('\tEstimate bytes: '+str(pointsByte+colorsByte))
    return maxSize, colorsByte

def encode(byteData, outputfile):
    global size
    size = 0
    oriByte = byteData
    byteData += b'\x1A\x1A\x1A'
    maxSize, length = calculateImgSize(byteData)
    print(len(byteData))
    # byteData = patternECC.encodeWithReedSolo(byteData, length = length)
    # if len(byteData) == 0:
    #     print('CURRENTLY PROGRAM ONLY ALLOW 51 CHARACTERS')
    #     exit(0)
    print(byteData)
    print('use default color set encode')
    numberData = int.from_bytes(byteData, byteorder='little')
    
    points = generatePoints(numberData, maxSize)
    delaunator = Delaunator(points)

    img = imgGenerator(delaunator, points, numberData, maxSize)
    cv2.imwrite(outputfile, img)
    # cv2.imwrite(outputfile, img, [cv2.IMWRITE_JPEG_QUALITY, 30])

    decodedByte = patternDecode2.decode(outputfile)
    print(oriByte == decodedByte)

    if(oriByte == decodedByte):
        cv2.imshow("triangle", img)
        cv2.waitKey(0)
    else:
        encode(oriByte, outputfile)
