#include <cstdio>

#include <vector>

// #include <opencv2/opencv.hpp>
#include "../../include/opencv2/opencv.hpp"
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

// Avoiding name mangling
extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    char* decodeDelaunatorPattern(char* inputFile) {
        // long long start = get_now();
        srand(time(0));

        Mat inputImg = imread(inputFile);
        vector<double> points = decodePoints(inputImg);

        delaunator::Delaunator delaunator(points);

        InfInt data = decodeFromTriangleColor(delaunator, points, inputImg);
        char* output = BigIntToBytes(data);
        output = checkEOF(output);
        
        char* ret = new char;
        strcpy(ret, output);
        
        cout << "cpp [decodeDelaunatorPattern] Done\n";
        
        return ret;
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
        char* ret = decodeDelaunatorPattern(outputFile);
        cout << "check\n";
        while(ret != inputData && tries < 5) {
            cout << ret << "\n";
            _encode(inputData, outputFile);
            ret = decodeDelaunatorPattern(outputFile);
            tries ++;
        }
        cout << "cpp [encodeDelaunatorPattern] Done\n";
        
        if(ret != inputData) {
            string o = "Please try again ";
            o = o.append(inputData);
            return (char*) o.c_str();
        }
        return (char*) "OK";
    }
}

// g++ -o test delaunator_pattern.test2.cpp

int main() {
    string i = "Hello";
    int n = i.length();
    char input[n + 1];
    strcpy(input, i.c_str());
    cout << input << "\n";

    string o = "./test/webp";
    int n2 = o.length();
    char t[n2 + 1];
    strcpy(t, o.c_str());
    char* out = encodeDelaunatorPattern(input, t);
    cout << out << "\n";
    return 0;
}