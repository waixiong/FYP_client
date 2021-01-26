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

void _encode(string inputData, string outputFile, int8_t type, int8_t colorFixed, int8_t fixedValue) {
    srand(time(0));
    platform_log("\tgenerate2");
    inputData = appendEndOfFile(inputData);
    long size;
    if(type == 0)
        size = calculateImgSize(inputData);
    else
        size = calculateImgSize_1(inputData);
    platform_log("\tgenerate3 %d", size);
    vector<double> points = generatePoints(size);
    platform_log("\tgenerate4 points");
    delaunator::Delaunator delaunator(points);
    platform_log("\tgenerate4 Delaunator");
    Mat img;
    if(type == 0)
        img = imgGenerator(delaunator, inputData, size);
    else
        img = imgGenerator_1(delaunator, inputData, size, colorFixed, fixedValue);
    platform_log("\tgenerate5");
    imwrite(outputFile, img);
}

string _decode(string inputFile, int8_t type, int8_t colorFixed) {
    srand(time(0));
    platform_log("\tdecode2");
    Mat inputImg = imread(inputFile);
    platform_log("\tdecode2.5");
    try {
        vector<double> points = decodePoints(inputImg);
        platform_log("\tdecode3");
        delaunator::Delaunator delaunator(points);

        InfInt data;
        if(type == 0) 
            data = decodeFromTriangleColor(delaunator, points, inputImg);
        else 
            data = decodeFromTriangleColor_1(delaunator, points, inputImg, colorFixed);
        string output = BigIntToBytes(data);
        output = checkEOF(output);
        platform_log("\tdecode4");
        return output;
    } catch (char* e) {
        return e;
    }
}

/*
 * type [ 
 *  0 - 512 colors of 8r * 8g * 8b,
 *  1 - 64 colors of either 2 of (8r, 8g and 8b)
 * ]
 * colorFixed [
 *  0 - red,
 *  1 - green,
 *  2 - blue
 * ] <Valid if type = 1>
 * fixedValue [
 *  0 - 7
 * ] <Valid if type = 1>
*/

// Avoiding name mangling
extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    void decodeDelaunatorPattern(char* inputFileChar, char* outputFileChar, int8_t type, int8_t colorFixed) {
        // long long start = get_now();
        string inputFile = string(inputFileChar);
        string outputFile = string(outputFileChar);

        string output = _decode(inputFile, type, colorFixed);
        platform_log("%s", output.c_str());
        
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
    char* encodeDelaunatorPattern(char* inputChar, char* outputFileChar, int8_t type, int8_t colorFixed, int8_t fixedValue) {
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
        string inputData = string(inputChar);
        string outputFile = string(outputFileChar);
        platform_log("input: %s", inputData.c_str());
        _encode(inputData, outputFile, type, colorFixed, fixedValue);
        platform_log("check");

        int tries = 0;
        string ret = _decode(outputFile, type, colorFixed);
        while(ret.compare(inputData) != 0 && tries < 5) {
            platform_log("decoded: %s", ret.c_str());
            platform_log("try again: %d", tries + 1);
            _encode(inputData, outputFile, type, colorFixed, fixedValue);
            ret = _decode(outputFile, type, colorFixed);
            tries ++;
        }
        // cout << "cpp [encodeDelaunatorPattern] Done\n";
        
        if(ret.compare(inputData) != 0) {
            // return (char*) "Please try again ";
            platform_log("decoded: %s", ret.c_str());
            platform_log("Fail");
            string o = "Error on encoding";
            o = o.append(ret);
            remove(outputFile.c_str());
            // ret = 0;
            return (char*) o.c_str();
        }
        // ret = 0;
        platform_log("Okay");
        return (char*) "OK";
    }
}