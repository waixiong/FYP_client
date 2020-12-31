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
    platform_log("\tgenerate2");
    inputData = appendEndOfFile(inputData);
    long size = calculateImgSize(inputData);
    platform_log("\tgenerate3 %d", size);
    vector<double> points = generatePoints(size);
    platform_log("\tgenerate4 points");
    delaunator::Delaunator delaunator(points);
    platform_log("\tgenerate4 Delaunator");
    Mat img = imgGenerator(delaunator, inputData, size);
    platform_log("\tgenerate5");
    imwrite(outputFile, img);
}

char* _decode(char* inputFile) {
    srand(time(0));
    platform_log("\tdecode2");
    Mat inputImg = imread(inputFile);
    platform_log("\tdecode2.5");
    try {
        vector<double> points = decodePoints(inputImg);
        platform_log("\tdecode3");
        delaunator::Delaunator delaunator(points);

        InfInt data = decodeFromTriangleColor(delaunator, points, inputImg);
        char* output = BigIntToBytes(data);
        output = checkEOF(output);
        platform_log("\tdecode4");
        return output;
    } catch (char* e) {
        return e;
    }
}

// Avoiding name mangling
extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    void decodeDelaunatorPattern(char* inputFile, char* outputFile) {
        // long long start = get_now();
        char* output = _decode(inputFile);
        platform_log("%s", output);
        
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
        // ifstream in(inputFile, ios::in | ios::binary);
        // string contents((std::istreambuf_iterator<char>(in)), 
        // std::istreambuf_iterator<char>());
        
        // char inputData[contents.length() + 1];
        // strcpy(inputData, contents.c_str());
        platform_log("%s", inputData);
        _encode(inputData, outputFile);
        platform_log("check");

        int tries = 0;
        char* ret = _decode(outputFile);
        while(strcmp(ret, inputData) != 0 && tries < 5) {
            platform_log("%s", ret);
            platform_log("try again: %d", tries + 1);
            _encode(inputData, outputFile);
            ret = _decode(outputFile);
            tries ++;
        }
        // cout << "cpp [encodeDelaunatorPattern] Done\n";
        
        if(strcmp(ret, inputData) != 0) {
            // return (char*) "Please try again ";
            platform_log("Fail");
            string o = "Error on encoding";
            o = o.append(ret);
            ret = 0;
            return (char*) o.c_str();
        }
        ret = 0;
        platform_log("Okay");
        return (char*) "OK";
    }
}