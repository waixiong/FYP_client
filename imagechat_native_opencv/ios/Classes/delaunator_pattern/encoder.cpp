#include <cstdio>

#include <vector>

#include <opencv2/opencv.hpp>
// #include <opencv2/core.hpp>
// #include <opencv2/imgproc.hpp>
// #include <opencv2/highgui.hpp>
// #include <opencv2/highgui/highgui.hpp>
// #include <opencv2/imgproc/imgproc.hpp>
// #include <opencv2/imgcodecs.hpp>

#include <chrono>

#ifdef __ANDROID__
#include <android/log.h>
#endif

// #include "BigInt/BigIntegerLibrary.hh"
#include "../InfInt.h"
#include "../delaunator.hpp"
// #include <native_opencv.cpp>
// #include "utils.cpp"

using namespace cv;
using namespace std;

Mat imgGenerator(delaunator::Delaunator d, char* inputData, long maxSize) {
    vector<vector<size_t>> triangles = {};
    for (size_t i = 0; i < d.triangles.size(); i+=3) {
    	vector<size_t> triangle = { d.triangles[i], d.triangles[i+1], d.triangles[i+2] };
        sort(triangle.begin(), triangle.end());
        triangles.push_back(triangle);
    }
    sort(triangles.begin(), triangles.end());
    
    Mat img = Mat::zeros( maxSize, maxSize, CV_8UC3 );
    // Mat img = Mat::zeros( maxSize, maxSize, 3);

    // InfInt data = InfInt(inputData);
    InfInt data = BigIntFromBytes(inputData);
    
    for (size_t i = 0; i < triangles.size(); i++) {
        // cout << triangles[i][0] << " " << triangles[i][1] << " " << triangles[i][2] << " \n" ;
        Point pointA = Point(static_cast<int>(d.coords[2 * triangles[i][0]]), static_cast<int>(d.coords[2 * triangles[i][0] + 1]));
        Point pointB = Point(static_cast<int>(d.coords[2 * triangles[i][1]]), static_cast<int>(d.coords[2 * triangles[i][1] + 1]));
        Point pointC = Point(static_cast<int>(d.coords[2 * triangles[i][2]]), static_cast<int>(d.coords[2 * triangles[i][2] + 1]));
        vector<vector<Point> > contours{ {
            pointA, 
            pointB, 
            pointC
        } };

        int r, g, b; 
        // InfInt data(inputData);
        if(data != 0) {
            // int rgb = (data % 64).toInt();
            int rgb = (data % 512).toInt();
            r = rgb % 8;//4;
            g = (rgb / 8) % 8;//4;
            b = (rgb / 64) % 8;//4;
            data /= 512;
            // drawContours(img, {contours}, 0, Scalar(b*64+32, g*64+32, r*64+32));
            // fillPoly(img, {contours}, Scalar(b*64+32, g*64+32, r*64+32));
        } else {
            // cout << "\tdone byte\n";
            r = rand() % 8;//4;
            g = rand() % 8;//4;
            b = rand() % 8;//4;
            // drawContours(img, {contours}, 0, Scalar(b*64+32, g*64+32, r*64+32));
            // fillPoly(img, {contours}, Scalar(b*64+32, g*64+32, r*64+32));
        }
        fillPoly(img, {contours}, Scalar(b*32+16, g*32+16, r*32+16));
    }

    return img;
}

Mat imgGenerator_1(delaunator::Delaunator d, char* inputData, long maxSize, int8_t colorFixed, int8_t fixedValue) {
    vector<vector<size_t>> triangles = {};
    for (size_t i = 0; i < d.triangles.size(); i+=3) {
    	vector<size_t> triangle = { d.triangles[i], d.triangles[i+1], d.triangles[i+2] };
        sort(triangle.begin(), triangle.end());
        triangles.push_back(triangle);
    }
    sort(triangles.begin(), triangles.end());
    
    Mat img = Mat::zeros( maxSize, maxSize, CV_8UC3 );
    // Mat img = Mat::zeros( maxSize, maxSize, 3);

    // InfInt data = InfInt(inputData);
    InfInt data = BigIntFromBytes(inputData);
    
    for (size_t i = 0; i < triangles.size(); i++) {
        // cout << triangles[i][0] << " " << triangles[i][1] << " " << triangles[i][2] << " \n" ;
        Point pointA = Point(static_cast<int>(d.coords[2 * triangles[i][0]]), static_cast<int>(d.coords[2 * triangles[i][0] + 1]));
        Point pointB = Point(static_cast<int>(d.coords[2 * triangles[i][1]]), static_cast<int>(d.coords[2 * triangles[i][1] + 1]));
        Point pointC = Point(static_cast<int>(d.coords[2 * triangles[i][2]]), static_cast<int>(d.coords[2 * triangles[i][2] + 1]));
        vector<vector<Point> > contours{ {
            pointA, 
            pointB, 
            pointC
        } };

        int r, g, b; 
        // InfInt data(inputData);
        if(data != 0) {
            // int rgb = (data % 64).toInt();
            int rgb = (data % 64).toInt();
            if(colorFixed == 0) {
                g = rgb % 8;//4;
                b = (rgb / 8) % 8;//4;
                if(fixedValue >= 8) {
                    r = rand() % 8;
                } else {
                    r = fixedValue;
                }
            } else if(colorFixed == 1) {
                r = rgb % 8;//4;
                b = (rgb / 8) % 8;//4;
                if(fixedValue >= 8) {
                    g = rand() % 8;
                } else {
                    g = fixedValue;
                }
            } else {
                r = rgb % 8;//4;
                g = (rgb / 8) % 8;//4;
                if(fixedValue >= 8) {
                    b = rand() % 8;
                } else {
                    b = fixedValue;
                }
            }
            data /= 64;
            // drawContours(img, {contours}, 0, Scalar(b*64+32, g*64+32, r*64+32));
            // fillPoly(img, {contours}, Scalar(b*64+32, g*64+32, r*64+32));
        } else {
            if(colorFixed == 0) {
                g = rand() % 8;//4;
                b = rand() % 8;//4;
                if(fixedValue >= 8) {
                    r = rand() % 8;
                } else {
                    r = fixedValue;
                }
            } else if(colorFixed == 1) {
                r = rand() % 8;//4;
                b = rand() % 8;//4;
                if(fixedValue >= 8) {
                    g = rand() % 8;
                } else {
                    g = fixedValue;
                }
            } else {
                r = rand() % 8;//4;
                g = rand() % 8;//4;
                if(fixedValue >= 8) {
                    b = rand() % 8;
                } else {
                    b = fixedValue;
                }
            }
        }
        fillPoly(img, {contours}, Scalar(b*32+16, g*32+16, r*32+16));
    }

    return img;
}

vector<double> generatePoints(long maxSize) {
    vector<double> points = {};
    for(int x = 0; x < maxSize/50 + 1; x++) {
        for(int y = 0; y < maxSize/50 + 1; y++) {
            int xp = x * 50;
            int yp = y * 50;
            if(xp >= maxSize)
                xp = maxSize-1;
            if(yp >= maxSize)
                yp = maxSize-1;
            // points.push_back({xp, yp});
            points.push_back(xp);
            points.push_back(yp);
        }
    }
    for(size_t i = 0; i < points.size(); i+=2) {
        // if(points[i][0] > 0 && points[i][0] < maxSize - 1 && points[i][1] > 0 && points[i][1] < maxSize - 1) {
        //     points[i][0] += (rand() % 5 - 2) * 5;
        //     points[i][1] += (rand() % 5 - 2) * 5;
        // }
        if(points[i] > 0 && points[i] < maxSize - 1 && points[i+1] > 0 && points[i+1] < maxSize - 1) {
            points[i] += (rand() % 5 - 2) * 5;
            points[i+1] += (rand() % 5 - 2) * 5;
        }
    }
    return points;
}

long calculateImgSize(char* inputData) {
    long maxSize = 0;
    long bytes = 0;
    while(strlen(inputData) > bytes) {
        maxSize += 250;
        // long numOfPoints = (long) pow(maxSize/50 + 1, 2);
        long numOfTriangle = (long) round(2 * pow((maxSize/50), 2));
        bytes = (9 * numOfTriangle - 1) / 8;
    }
    return maxSize;
}

long calculateImgSize_1(char* inputData) {
    long maxSize = 0;
    long bytes = 0;
    while(strlen(inputData) > bytes) {
        maxSize += 250;
        // long numOfPoints = (long) pow(maxSize/50 + 1, 2);
        long numOfTriangle = (long) round(2 * pow((maxSize/50), 2));
        bytes = (6 * numOfTriangle - 1) / 8;
    }
    return maxSize;
}