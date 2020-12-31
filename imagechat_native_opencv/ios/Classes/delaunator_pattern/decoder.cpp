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

Scalar formatColor(Scalar color) {
    // int b = floor(color[0] / 64) * 64 + 32;
    // int g = floor(color[1] / 64) * 64 + 32;
    // int r = floor(color[2] / 64) * 64 + 32;
    int b = floor(color[0] / 32) * 32 + 16;
    int g = floor(color[1] / 32) * 32 + 16;
    int r = floor(color[2] / 32) * 32 + 16;
    if(b > 255) b = 255;
    if(g > 255) g = 255;
    if(r > 255) r = 255;
    return Scalar(b, g, r);
}

bool isPerfectSquare(long double x) {   
  // Find floating point value of  
  // square root of x. 
  long double sr = sqrt(x); 
  
  // If square root is an integer 
  return ((sr - floor(sr)) == 0); 
} 

Point centroid(vector<Point> vertexes) {
    int _x_sum = 0;
    int _y_sum = 0;
    for(Point vertex : vertexes) {
        _x_sum += vertex.x;
        _y_sum += vertex.y;
    }
    int _x = _x_sum / vertexes.size();
    int _y = _y_sum / vertexes.size();
    return Point(_x, _y);
}

bool pointsCloseEnough(Point p1,Point p2) {
    return (pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2)) < pow(15, 2);
}

// double polyArea(double x[], double y[], int n){
//    double area = 0.0;
//    int j = n - 1;
//    for (int i = 0; i < n; i++){
//       area += (x[j] + x[i]) * (y[j] - y[i]);
//       j = i;
//    }
//    return abs(area / 2.0);
// }

double polyArea(vector<Point> points){
   double area = 0.0;
   int j = points.size() - 1;
   for (int i = 0; i < points.size(); i++){
      area += (points[j].x + points[i].x) * (points[j].y - points[i].y);
      j = i;
   }
   return abs(area / 2.0);
}

InfInt decodeFromTriangleColor(delaunator::Delaunator delaunator, vector<double> points, Mat img) {
    // Mat cloneImg = Mat::zeros(img.rows, img.cols, CV_8UC3);
    vector<vector<size_t>> triangles = {};
    for (size_t i = 0; i < delaunator.triangles.size(); i+=3) {
    	vector<size_t> triangle = { delaunator.triangles[i], delaunator.triangles[i+1], delaunator.triangles[i+2] };
        sort(triangle.begin(), triangle.end());
        triangles.push_back(triangle);
    }
    sort(triangles.begin(), triangles.end());

    // --- checking ---
    // __android_log_print(ANDROID_LOG_DEBUG, "flutter", );
    // platform_log("triangles:");
    for(vector<size_t> triangle : triangles) {
        // __android_log_print(ANDROID_LOG_DEBUG, "flutter", "\t[%d, %d, %d]", triangle[0], triangle[1], triangle[2]);
        // platform_log("\t[%d, %d, %d]", triangle[0], triangle[1], triangle[2]);
    }

    InfInt data = InfInt();
    InfInt multipleCounter = InfInt(1);

    // __android_log_print(ANDROID_LOG_DEBUG, "flutter", "color:");
    // platform_log("color:");
    for (size_t i = 0; i < triangles.size(); i++) {
        // cout << triangles[i][0] << " " << triangles[i][1] << " " << triangles[i][2] << " \n" ;
        Point pointA = Point(static_cast<int>(delaunator.coords[2 * triangles[i][0]]), static_cast<int>(delaunator.coords[2 * triangles[i][0] + 1]));
        Point pointB = Point(static_cast<int>(delaunator.coords[2 * triangles[i][1]]), static_cast<int>(delaunator.coords[2 * triangles[i][1] + 1]));
        Point pointC = Point(static_cast<int>(delaunator.coords[2 * triangles[i][2]]), static_cast<int>(delaunator.coords[2 * triangles[i][2] + 1]));
        vector<vector<Point> > contours{ {
            pointA, 
            pointB, 
            pointC
        } };

        Mat mask = Mat::zeros(img.rows, img.cols, CV_8UC1);
        drawContours(mask, contours, 0, 255, -1);
        // string f = "/storage/emulated/0/Android/data/com.getitqec.imagechat/files/Pictures/"+to_string(i);
        // imwrite(f+".webp", mask);
        Scalar mean_val = mean(img, mask);
        // __android_log_print(ANDROID_LOG_DEBUG, "flutter", "\t\t%f, %f, %f", mean_val[0], mean_val[1], mean_val[2]);
        // platform_log("\t\t%f, %f, %f", mean_val[0], mean_val[1], mean_val[2]);
        Scalar bgr = formatColor(mean_val);
        // __android_log_print(ANDROID_LOG_DEBUG, "flutter", "\t\t%f, %f, %f", bgr[0], bgr[1], bgr[2]);
        // platform_log("\t\t%f, %f, %f", bgr[0], bgr[1], bgr[2]);
        int ib = (int) bgr[0] / 32;//64;
        int ig = (int) bgr[1] / 32;//64;
        int ir = (int) bgr[2] / 32;//64;
        // __android_log_print(ANDROID_LOG_DEBUG, "flutter", "\t\t%d, %d, %d", ib, ig, ir);
        // platform_log("\t\t%d, %d, %d", ib, ig, ir);
        int dataRGB = ib;
        dataRGB = dataRGB * 8 + ig;
        dataRGB = dataRGB * 8 + ir;
        // __android_log_print(ANDROID_LOG_DEBUG, "flutter", "\t%d", dataRGB);
        // platform_log("\t%d", dataRGB);
        data = data + multipleCounter * dataRGB;
        multipleCounter *= 512;//64;
    }

    return data;
}

vector<double> decodePoints(Mat img) {
    vector<Point> points = {};
    // int n = 0;
    int maxSize = img.rows;
    Mat imgDraw = Mat::zeros( maxSize, maxSize, CV_8UC3 );
    int _tempNum = 0;
    platform_log("\t\tdecode2a");
    for(int r = 0; r < 8; r++) {
        for(int g = 0; g < 8; g++) {
            for(int b = 0; b < 8; b++) {
                Mat mask;
                inRange(
                    img, 
                    // Scalar(b*64, g*64, r*64), 
                    // Scalar( b*64+63, g*64+63, r*64+63), 
                    Scalar(b*32, g*32, r*32), 
                    Scalar( b*32+31, g*32+31, r*32+31), 
                    mask
                );

                vector<vector<Point>> contours;
                vector<Vec4i> hierarchy;
                findContours( mask, contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE );
                // sort(contours.begin(), contours.end()); 

                for(vector<Point> c : contours) {
                    double peri = arcLength(c, true);
                    vector<Point> approx;
                    approxPolyDP(c, approx, 0.04*peri, true);
                    
                    double area = polyArea(approx);

                    if(approx.size() == 3 && peri >= 24 && area > 180) {
                        for(Point p : approx) {
                            points.push_back(p);
                            // points.push_back(p.x);
                            // points.push_back(p.y);
                        }
                        _tempNum++;
                    } else if(approx.size() > 3 && peri >= 80 && area > 200) {
                        for(Point p : approx) {
                            points.push_back(p);
                            // points.push_back(p.x);
                            // points.push_back(p.y);
                        }
                        _tempNum++;
                    }
                }
            }
        }
    }
    platform_log("\t\tNum of Tri: %d", _tempNum);
    platform_log("\t\tNum of Pnt: %d", points.size());

    platform_log("\t\tdecode2b");
    vector<vector<Point>> adjusted_points = {};
    for(Point point : points ) {
        bool insert = false;
        for(vector<Point> v_adjusted_point : adjusted_points ) {
            for(Point ap : v_adjusted_point) {
                if(pointsCloseEnough(point, ap)) {
                    insert = true;
                    v_adjusted_point.push_back(point);
                    break;
                }
            }
            if(insert) break;
        }
        if(!insert) adjusted_points.push_back({point});
    }
    points = {};
    for(vector<Point> v_adjusted_point : adjusted_points ) {
        Point point = centroid(v_adjusted_point);
        point.x = (int) round(point.x / 5.0) * 5;
        point.y = (int) round(point.y / 5.0) * 5;
        points.push_back(point);
    }

    // TODO: 
    platform_log("\t\tdecode2c");
    if(!isPerfectSquare(points.size())) {
        platform_log("\t\t\tsize: %d", points.size());
        throw("error on decoding points");
        // bool match = false;
        // int size = (int) round(sqrt(points.size()));
        // for(int i = 1; i < size - 1; i++) {
        //     //
        // }
    }
    for(Point point : points) {
        if(point.x < 15) point.x = 0;
        if(point.x > maxSize - 15) point.x = maxSize;
        if(point.y < 15) point.y = 0;
        if(point.y > maxSize - 15) point.y = maxSize;
    }

    sort(points.begin(), points.end(), [](const Point &a, const Point &b) {
        return round(a.x/50.0) < round(b.x/50.0) || ( (round(a.x/50.0) == round(b.x/50.0)) && round(a.y/50.0) < round(b.y/50.0));
        // return a[0] < b[0] || (a[0] == b[0] && a[1] < b[1]);
    });
    vector<double> double_points = {};
    
    // --- checking ---
    // __android_log_print(ANDROID_LOG_DEBUG, "flutter", "points:");
    // platform_log("points:");
    for(Point point : points) {
        double_points.push_back(point.x);
        double_points.push_back(point.y);
        // __android_log_print(ANDROID_LOG_DEBUG, "flutter", "\t[%d, %d]", point.x, point.y);
        // platform_log("\t[%d, %d]", point.x, point.y);
    }
    
    return double_points;
}