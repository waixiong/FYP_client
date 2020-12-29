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

#include <iostream>
#include <fstream>

#include "delaunator_pattern/utils.cpp"
#include "delaunator_pattern/encoder.cpp"
#include "delaunator_pattern/decoder.cpp"

using namespace cv;
using namespace std;

// InfInt BigIntFromBytes(char* array) {
//     InfInt num = InfInt();
//     // BigInteger num2 = BigInteger(array, 0, 1);
//     // cout << "\t\t" << strlen(array) << "\n";
//     for(size_t i = 0; i < strlen(array); i++) {
//         num *= 256;
//         // cout << "\t\t\t" << array[strlen(array)-1-i] << "\n";
//         num += array[strlen(array)-1-i];
//         // cout << "\t\t" << num << "\n";
//     }
//     return num;
// }

// char* appendEndOfFile(char* array)
// {
//     size_t len = strlen(array);

//     char* ret = new char[len+5];

//     strcpy(ret, array);    
//     ret[len] = 0x1a;
//     ret[len+1] = 0x1a;
//     ret[len+2] = 0x1a;
//     ret[len+3] = 0x1a;
//     ret[len+4] = '\0';

//     return ret;
// }

void _encode(char* inputData, char* outputFile) {
    srand(time(0));

    inputData = appendEndOfFile(inputData);
    long size = calculateImgSize(inputData);
    vector<double> points = generatePoints(size);

    delaunator::Delaunator delaunator(points);

    Mat img = imgGenerator(delaunator, inputData, size);
    
    imwrite(outputFile, img);
}

char* _decode(char* inputFile) {
    srand(time(0));

    Mat inputImg = imread(inputFile);
    vector<double> points = decodePoints(inputImg);

    delaunator::Delaunator delaunator(points);

    InfInt data = decodeFromTriangleColor(delaunator, points, inputImg);
    char* output = BigIntToBytes(data);
    output = checkEOF(output);

    __android_log_print(ANDROID_LOG_DEBUG, "flutter", "output: %s", output);

    return output;
}

// Avoiding name mangling
extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    void decodeDelaunatorPattern(char* inputFile, char* outputFile) {
        // long long start = get_now();
        char* output = _decode(inputFile);
        
        // char* ret = new char;
        // strcpy(ret, output);
        ofstream OutFile(outputFile);
        OutFile << output;
        OutFile.close();
        
        // cout << "cpp [decodeDelaunatorPattern] Done\n";
        
        // return (char*) "OK";
        // return ret;
    }

    __attribute__((visibility("default"))) __attribute__((used))
    char* encodeDelaunatorPattern(char* inputData, char* outputFile) {
        // long long start = get_now();
        // srand(time(0));

        // inputData = appendEndOfFile(inputData);
        // long size = calculateImgSize(inputData);
        // vector<double> points = generatePoints(size);

        // delaunator::Delaunator delaunator(points);

        // Mat img = imgGenerator(delaunator, inputData, size);
        
        // imwrite(outputFile, img);
        _encode(inputData, outputFile);

        int tries = 0;
        char* ret = _decode(outputFile);
        while(strcmp(ret, inputData) != 0 && tries < 5) {
            _encode(inputData, outputFile);
            ret = _decode(outputFile);
            tries ++;
            delete (ret);
        }
        // cout << "cpp [encodeDelaunatorPattern] Done\n";
        
        if(strcmp(ret, inputData) != 0) {
            // return (char*) "Please try again ";
            string o = "Error on encoding";
            o = o.append(ret);
            delete (ret);
            return (char*) o.c_str();
        }
        return (char*) "OK";
    }
}