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
#include "InfInt.h"
#include "delaunator.hpp"
// #include <native_opencv.cpp>

using namespace cv;
using namespace std;

// int main() {
//     /* x0, y0, x1, y1, ... */
//     // std::vector<double> coords = {-1, 1, 1, 1, 1, -1, -1, -1};
//     vector<double> coords = {0, 0, 0, 110, 0, 180, 0, 300, 0, 410, 0, 480, 0, 620, 0, 680, 0, 800, 0, 890, 0, 999, 110, 0, 110, 110, 100, 190, 80, 310, 90, 420, 100, 510, 90, 610, 110, 720, 80, 810, 110, 910, 100, 999, 210, 0, 190, 110, 200, 200, 220, 280, 220, 410, 210, 480, 220, 610, 190, 700, 200, 820, 210, 910, 200, 999, 280, 0, 290, 80, 280, 220, 310, 290, 320, 380, 300, 490, 320, 580, 300, 710, 310, 810, 290, 920, 280, 999, 390, 0, 420, 100, 380, 190, 400, 290, 420, 420, 390, 510, 410, 610, 400, 720, 420, 800, 380, 900, 400, 999, 480, 0, 500, 90, 510, 190, 480, 300, 510, 420, 490, 480, 480, 600, 490, 720, 480, 790, 490, 920, 490, 999, 590, 0, 580, 110, 590, 190, 580, 310, 600, 400, 610, 490, 580, 600, 600, 700, 590, 780, 590, 890, 580, 999, 710, 0, 690, 100, 680, 200, 720, 320, 690, 400, 680, 500, 710, 600, 680, 710, 700, 800, 710, 890, 720, 999, 780, 0, 800, 120, 790, 220, 820, 320, 820, 380, 780, 500, 800, 590, 790, 720, 810, 820, 800, 880, 820, 999, 890, 0, 900, 120, 900, 210, 920, 280, 880, 420, 900, 520, 890, 620, 900, 700, 900, 810, 920, 900, 900, 999, 999, 0, 999, 90, 999, 220, 999, 290, 999, 410, 999, 490, 999, 610, 999, 680, 999, 810, 999, 880, 999, 999};

//     //triangulation happens here
//     delaunator::Delaunator d(coords);

//     int w = 1000;
//     // Mat img = Mat::zeros( w, w, CV_8UC3 );
//     // vector<Scalar> triColor{
//     //     Scalar(0, 0, 255), 
//     //     Scalar(0, 255, 0), 
//     //     Scalar(255, 0, 0), 
//     //     Scalar(0, 255, 255), 
//     //     Scalar(255, 255, 0), 
//     //     Scalar(255, 0, 255)
//     // };

//     for(std::size_t i = 0; i < d.triangles.size(); i+=3) {
//         printf(
//             "Triangle points: [[%f, %f], [%f, %f], [%f, %f]]\n",
//             // i, // index
//             d.coords[2 * d.triangles[i]],        //tx0
//             d.coords[2 * d.triangles[i] + 1],    //ty0
//             d.coords[2 * d.triangles[i + 1]],    //tx1
//             d.coords[2 * d.triangles[i + 1] + 1],//ty1
//             d.coords[2 * d.triangles[i + 2]],    //tx2
//             d.coords[2 * d.triangles[i + 2] + 1] //ty2
//         );
//         // Point pointA = Point(static_cast<int>(d.coords[2 * d.triangles[i]]), static_cast<int>(d.coords[2 * d.triangles[i] + 1]));
//         // Point pointB = Point(static_cast<int>(d.coords[2 * d.triangles[i + 1]]), static_cast<int>(d.coords[2 * d.triangles[i + 1] + 1]));
//         // Point pointC = Point(static_cast<int>(d.coords[2 * d.triangles[i + 2]]), static_cast<int>(d.coords[2 * d.triangles[i + 2] + 1]));
//         // vector<vector<Point> > contours{ {
//         //     pointA, 
//         //     pointB, 
//         //     pointC
//         // } };
//         // drawContours(img, contours, 0, triColor[i%triColor.size()]);
//         // line( img, pointA, pointB, Scalar( 255, 255, 255 ), 2);
//         // line( img, pointB, pointC, Scalar( 255, 255, 255 ), 2);
//         // line( img, pointC, pointA, Scalar( 255, 255, 255 ), 2);
//     }

//     // Show in a window
//     // namedWindow( "Contours", 1 );
//     // imshow( "Contours", img );
//     // imwrite("./img.webp", img);
// }

InfInt BigIntFromBytes(char* array) {
    InfInt num = InfInt();
    // BigInteger num2 = BigInteger(array, 0, 1);
    // cout << "\t\t" << strlen(array) << "\n";
    for(size_t i = 0; i < strlen(array); i++) {
        num *= 256;
        // cout << "\t\t\t" << array[strlen(array)-1-i] << "\n";
        num += array[strlen(array)-1-i];
        // cout << "\t\t" << num << "\n";
    }
    return num;
}

char* appendEndOfFile(char* array)
{
    size_t len = strlen(array);

    char* ret = new char[len+5];

    strcpy(ret, array);    
    ret[len] = 0x1a;
    ret[len+1] = 0x1a;
    ret[len+2] = 0x1a;
    ret[len+3] = 0x1a;
    ret[len+4] = '\0';

    return ret;
}

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
 
        // InfInt data(inputData);
        if(data != 0) {
            int rgb = (data % 64).toInt();
            int r = rgb % 4;
            int g = (rgb / 4) % 4;
            int b = (rgb / 16) % 4;
            data /= 64;
            // drawContours(img, {contours}, 0, Scalar(b*64+32, g*64+32, r*64+32));
            fillPoly(img, {contours}, Scalar(b*64+32, g*64+32, r*64+32));
        } else {
            cout << "\tdone byte\n";
            int r = rand() % 4;
            int g = rand() % 4;
            int b = rand() % 4;
            // drawContours(img, {contours}, 0, Scalar(b*64+32, g*64+32, r*64+32));
            fillPoly(img, {contours}, Scalar(b*64+32, g*64+32, r*64+32));
        }
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
        bytes = (6 * numOfTriangle - 1) / 8;
    }
    return maxSize;
}

// Avoiding name mangling
extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    char* encodeDelaunatorPattern(char* inputData, char* outputFile) {
        // long long start = get_now();
        srand(time(0));

        inputData = appendEndOfFile(inputData);
        long size = calculateImgSize(inputData);
        vector<double> points = generatePoints(size);

        delaunator::Delaunator delaunator(points);

        Mat img = imgGenerator(delaunator, inputData, size);
        
        imwrite(outputFile, img);
        cout << "cpp [encodeDelaunatorPattern] Done\n";
        
        return (char*) "OK";
    }
}