#include <cstdio>

#include <vector>
#include <string.h>

// #include <opencv2/opencv.hpp>
// #include <opencv2/core.hpp>
// #include <opencv2/imgproc.hpp>
// #include <opencv2/highgui.hpp>
// #include <opencv2/highgui/highgui.hpp>
// #include <opencv2/imgproc/imgproc.hpp>
// #include <opencv2/imgcodecs.hpp>

#include <chrono>

// #ifdef __ANDROID__
// #include <android/log.h>
// #endif

// #include "BigInt/BigIntegerLibrary.hh"
#include "InfInt.h"
#include "delaunator.hpp"
// #include <native_opencv.cpp>

using namespace std;

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

void imgGenerator(delaunator::Delaunator d, char* inputData, long maxSize) {
    vector<vector<size_t>> triangles = {};
    for (size_t i = 0; i < d.triangles.size(); i+=3) {
    	vector<size_t> triangle = { d.triangles[i], d.triangles[i+1], d.triangles[i+2] };
        sort(triangle.begin(), triangle.end());
        triangles.push_back(triangle);
    }
    sort(triangles.begin(), triangles.end());
    
    // Mat img = Mat::zeros( maxSize, maxSize, CV_8UC3 );
    // Mat img = Mat::zeros( maxSize, maxSize, 3);

    cout << "Char: " << inputData << "\n\n";
    // InfInt data = InfInt(inputData);
    InfInt data = BigIntFromBytes(inputData);
    cout << "BigInt: " << data << "\n\n";
    
    for (size_t i = 0; i < triangles.size(); i++) {
        cout << triangles[i][0] << " " << triangles[i][1] << " " << triangles[i][2] << " \n" ;
        // Point pointA = Point(static_cast<int>(d.coords[2 * triangles[i][0]]), static_cast<int>(d.coords[2 * triangles[i][0] + 1]));
        // Point pointB = Point(static_cast<int>(d.coords[2 * triangles[i][1]]), static_cast<int>(d.coords[2 * triangles[i][1] + 1]));
        // Point pointC = Point(static_cast<int>(d.coords[2 * triangles[i][2]]), static_cast<int>(d.coords[2 * triangles[i][2] + 1]));
        // vector<vector<Point> > contours{ {
        //     pointA, 
        //     pointB, 
        //     pointC
        // } };
 
        // InfInt data(inputData);
        if(data != 0) {
            cout << "\thave data\n";
            int rgb = (data % 64).toInt();
            int r = rgb % 4;
            int g = (rgb / 4) % 4;
            int b = (rgb / 16) % 4;
            data /= 64;
            cout << "\t\t" << rgb << "\n";
            // drawContours(img, {contours}, 0, Scalar(b*64+32, g*64+32, r*64+32));
            // fillPoly(img, {contours}, Scalar(b*64+32, g*64+32, r*64+32));
        } else {
            cout << "\tdone byte\n";
            int r = rand() % 4;
            int g = rand() % 4;
            int b = rand() % 4;
            cout << "\t\t" << r << " " << g << " " << b << " \n" ;
            // drawContours(img, {contours}, 0, Scalar(b*64+32, g*64+32, r*64+32));
            // fillPoly(img, {contours}, Scalar(b*64+32, g*64+32, r*64+32));
        }
    }
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

        for(int i = 0; i < points.size(); i+=2) {
            cout << points[i] << ", " << points[i+1] << "\n";
        }

        delaunator::Delaunator delaunator(points);

        imgGenerator(delaunator, inputData, size);
        
        // imwrite(outputFile, img);
        cout << "cpp [encodeDelaunatorPattern] Done\n";
        
        return (char*) "OK";
    }
}

int main() {
    string i = "Hello world";
    int n = i.length();
    char input[n + 1];
    strcpy(input, i.c_str());

    string o = "";
    int n2 = o.length();
    char t[n2 + 1];
    strcpy(t, o.c_str());
    encodeDelaunatorPattern(input, t);
    return 0;
}