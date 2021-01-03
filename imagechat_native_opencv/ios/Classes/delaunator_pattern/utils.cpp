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

// #include "BigInt/BigIntegerLibrary.hh"
#include "../InfInt.h"
#include "../delaunator.hpp"
// #include <native_opencv.cpp>

using namespace std;

string checkEOF(string array) {
    size_t len = array.length();
    size_t counter = 0;
    size_t index = 0;

    for(size_t i = 0; i < array.length(); i++) {
        if(array[i] == 0x1a) {
            counter += 1;
            if(counter >= 3) break;
        } else {
            index = i + 1;
        }
    }
    return array.substr(0, index);

    // char* ret = new char[index + 1];
    // memcpy( ret, array, index );
    // ret[index] = '\0';
    // return ret;
}

string BigIntToBytes(InfInt num) {
    string data = "";
    // BigInteger num2 = BigInteger(array, 0, 1);
    // cout << "\t\t" << strlen(array) << "\n";
    while(num > 0) {
        InfInt mod = num % 256;
        data += mod.toInt();
        num /= 256;
    }

    return data;

    // // return data.c_str();
    // char* array = new char;
    // strcpy(array, data.c_str());
    // return array;
}

InfInt BigIntFromBytes(string array) {
    InfInt num = InfInt();
    // BigInteger num2 = BigInteger(array, 0, 1);
    // cout << "\t\t" << strlen(array) << "\n";
    for(size_t i = 0; i < array.length(); i++) {
        num *= 256;
        // cout << "\t\t\t" << array[strlen(array)-1-i] << "\n";
        num += array[array.length()-1-i];
        // cout << "\t\t" << num << "\n";
    }
    return num;
}

string appendEndOfFile(string array)
{
    // size_t len = strlen(array);

    // char* ret = new char[len+5];

    // strcpy(ret, array);    
    // ret[len] = 0x1a;
    // ret[len+1] = 0x1a;
    // ret[len+2] = 0x1a;
    // ret[len+3] = 0x1a;
    // ret[len+4] = '\0';
    // return ret;

    array += 0x1a;
    array += 0x1a;
    array += 0x1a;
    array += 0x1a;
    return array;
}