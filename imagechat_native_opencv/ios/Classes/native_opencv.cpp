#include <opencv2/opencv.hpp>
#include <chrono>
#include <bitset>
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */

#ifdef __ANDROID__
#include <android/log.h>
#endif

#include "util.cpp"
#include "delaunator_pattern.cpp"

using namespace cv;
using namespace std;

const string EOFBinary = "0000100";

map<string, Scalar> colours = {
	{"0000", Scalar(0, 0, 128)},
	{"0001", Scalar(0, 0, 255)},
	{"0010", Scalar(0, 128, 0)},
	{"0011", Scalar(0, 128, 128)},
	{"0100", Scalar(0, 128, 255)},
	{"0101", Scalar(128, 0, 0)},
	{"0110", Scalar(128, 0, 128)},
	{"0111", Scalar(128, 0, 255)},
	{"1000", Scalar(128, 128, 0)},
	{"1001", Scalar(128, 128, 128)},
	{"1010", Scalar(128, 128, 255)},
	{"1011", Scalar(255, 128, 128)},
	{"1100", Scalar(255, 0, 0)},
	{"1101", Scalar(255, 0, 128)},
	{"1110", Scalar(255, 0, 255)},
	{"1111", Scalar(255, 128, 0)}
};

Scalar formatColour(Scalar colour) {
	double blue = round(colour[0] / 128) * 128;
	if (blue > 255) {
		blue -= 1;
	}
	double green = round(colour[1] / 128) * 128;
	if (green > 255) {
		green -= 1;
	}
	double red = round(colour[2] / 128) * 128;
	if (red > 255) {
		red -= 1;
	}
	return Scalar(blue, green, red);
}

Scalar encode(string data) {
	return colours[data];
}

string decode(Scalar colour) {
	colour = formatColour(colour);
	cout << colour << endl;
	for (std::map<std::string, cv::Scalar>::iterator itr = colours.begin(); itr != colours.end(); ++itr) {
		if (itr->second == colour) {
			return itr->first;
		}
	}
	return "error finding match";
}

// utility function
string strToBinary(string s)
{
	int n = s.length();
	string binData = "";

	for (int i = 0; i < n; i++)
	{
		// convert each char to
		// ASCII value
		int val = int(s[i]);

		// Convert ASCII value to binary
		string bin = "";
		while (val > 0)
		{
			(val % 2) ? bin.push_back('1') :
				bin.push_back('0');
			val /= 2;
		}
		reverse(bin.begin(), bin.end());
		if (bin.length() < 7) {
			for (int i = 0; i < 7 - bin.length(); i++){
				bin = "0" + bin;
			}
		}
		binData += bin;
		cout << s[i] << " " << bin << endl;
	}
	return binData;
}

string binaryToStr(string s)
{
	int n = s.length();
	string str = "";

	for (int i = 0; i < n/7; i++)
	{
		int val = 0;
		int base = 1;
		for (int j = 6; j >= 0; j--) {
			if (s[i * 7 + j] == '1') {
				val += base;
			}
			base *= 2;
		}
		char c = char(val);
		str += c;
	}
	return str;
}

Mat encodeImage(string encryptedData, string type) {
	string data = strToBinary(encryptedData);
	data = data + EOFBinary;
	int dataLength = data.length();

	/* initialize random seed: */
	srand(time(NULL));

	/* generate secret number between 1 and 10: */
	int distance = 5; //distance between triangles
	int tw = 50;  //triangle width, change this to change the width of triangle generated
	int th = 25;  //triangle height, change this to change the height of triangle generated
	int horDis = tw + distance;  //horizontal distance
	int verDis = th + distance;  //vertical distance between triangle
	Point points[1][3];
	points[0][0] = Point(distance, distance);
	points[0][1] = Point(horDis, distance);
	points[0][2] = Point(verDis, verDis);
	bool inverted = true;  //to check if triangle that will be generated next is inverted
	int numOfRow, numOfColumn;
	if (type == "Code") {
		numOfRow = ceil(sqrt(dataLength / 4.0));
		if (numOfRow % 2 != 1) {//the number of row is set as odd number so the image can be scanned from 360 degree
			numOfRow += 1;
		}
		numOfColumn = numOfRow;
		if (numOfColumn % 2 != 1) {//the number of column is set as odd number so the image is balance
			numOfColumn += 1;
		}
	}
	else {
		int min = int(ceil(sqrt(dataLength / 4.0 / 2.0)));
		numOfRow = rand() % int(ceil(sqrt(dataLength / 4.0))) + min;
		if (numOfRow < 1) {
			numOfRow = 1;
		}
		if (numOfRow % 2 != 1) {//the number of row is set as odd number so the image can be scanned from 360 degree
			numOfRow += 1;
		}
		numOfColumn = ceil(dataLength / 4.0 / numOfRow);
		if (numOfColumn % 2 != 1) {//the number of column is set as odd number so the picture is balance
			numOfColumn += 1;
		}
	}

	int maxHeight = numOfRow * verDis + 5;
	int maxWidth = (ceil(numOfColumn / 2.0)) * (horDis + distance);

	Mat image(maxHeight, maxWidth, CV_8UC3, Scalar(255,255,255));
	int indexToEmbed = dataLength;
	for (int i = 0; i < numOfRow; i++) {
		for (int j = 0; j < numOfColumn; j++) {
			string currentData = "";
			if (indexToEmbed > 0) {
				int index = dataLength - indexToEmbed;
				currentData = data.substr(index, (indexToEmbed >= 4 ? 4: indexToEmbed));//get the 4 bit data for encoding
				indexToEmbed -= 4;
				if (currentData.length() < 4) {
					int randIndex = rand() % (dataLength - 4);
					currentData += data.substr(randIndex, 4 - currentData.length());
				}
			}
			else {
				int randIndex = rand() % (dataLength-4);
				currentData = data.substr(randIndex, 4); //get random 4 bit data for encoding
			}
			Scalar colour = encode(currentData);
			const Point* ppt[1] = { points[0] };
			int npt[] = { 3 };
			int lineType = LINE_8;
			fillPoly(image, ppt, npt, 1, colour, lineType);
			if (inverted) {
				points[0][0] = Point(points[0][1].x + distance, points[0][1].y);
				points[0][1] = Point(points[0][2].x + distance, points[0][2].y);
				points[0][2] = Point(points[0][1].x + tw, points[0][1].y);
				inverted = false;
			}
			else {
				points[0][0] = Point(points[0][0].x + distance, points[0][0].y);
				points[0][1] = Point(points[0][0].x + tw, points[0][0].y);
				points[0][2] = Point(points[0][2].x + distance, points[0][2].y);
				inverted = true;
			}
		}
		if (inverted) {
			points[0][0] = Point(distance, points[0][2].y + distance);
			points[0][1] = Point(horDis, points[0][2].y + distance);
			points[0][2] = Point(verDis, points[0][2].y + verDis);
		}
		else {
			points[0][0] = Point(verDis, points[0][2].y + distance);
			points[0][1] = Point(distance, points[0][2].y + verDis);
			points[0][2] = Point(horDis, points[0][2].y + verDis);
		}
	}
	return image;
}

bool smallerContour(vector<Point> contour, vector<Point> contour1) {//for sorting the contours
	Rect boundRect = boundingRect(contour);
	Rect boundRect1 = boundingRect(contour1);
	if(abs(boundRect.y - boundRect1.y) <= 5){//have to check if the triangle x and y only have small difference, then consider they are equal
	    return boundRect.x < boundRect1.x;
	}
	else if (boundRect.y < boundRect1.y) {
		return true;
	}
	else{
		return false;
	}
}

int lengthSquare(Point first, Point second)
{
	int xDiff = first.x - second.x;
	int yDiff = first.y - second.y;
	return xDiff * xDiff + yDiff * yDiff;
}

string _decodeImage(string filePath) {
    Mat imageGray, threshOutput;
	Mat image = imread(filePath);
	if (image.cols > 1800 || image.rows > 1500) {
		double maxValue = max(image.cols/1000, image.rows/700);
		resize(image, image, Size(image.cols / maxValue, image.rows / maxValue));
	}
	// sharpen image using "unsharp mask" algorithm
	Mat blurred; double sigma = 10.0, thresh = 5, amount = 1;
	GaussianBlur(image, blurred, Size(), sigma, sigma);
	Mat lowContrastMask = abs(image - blurred) < thresh;
	Mat sharpened = image * (1 + amount) + blurred * (-amount);
	image.copyTo(sharpened, lowContrastMask);
	cvtColor(sharpened, imageGray, COLOR_BGR2GRAY);
	threshold(imageGray, threshOutput, 150, 150, 0);
	vector<vector<Point>> contours;
	findContours(threshOutput, contours, RETR_TREE, CHAIN_APPROX_SIMPLE);
	contours.erase(contours.begin());
	vector<Point> upperLeftContour = contours[0];
	Rect minBoundRect = boundingRect(contours[0]);
	for (int i = 0; i < contours.size();) {
		Rect currentBoundRect = boundingRect(contours[i]);
		if (contourArea(contours[i]) < 10 ) {
			contours.erase(contours.begin() + i);
		}
		else {
			if (currentBoundRect.x < minBoundRect.x && currentBoundRect.y < minBoundRect.y) {
				upperLeftContour = contours[i];
				minBoundRect = currentBoundRect;
			}
			i++;
		}
	}
	vector<Point> triangle;
	minEnclosingTriangle(upperLeftContour, triangle);
	int line1 = lengthSquare(triangle[0], triangle[1]);
	int line2 = lengthSquare(triangle[1], triangle[2]);
	int line3 = lengthSquare(triangle[2], triangle[0]);
	double rotatedAngle = 0;

	if (line1 > line2 && line1 > line3) {//line1 is the longest side
		if (triangle[0].y < triangle[1].y) {//find lowest point, and use it to calculate angle
			Point newPoint = Point(triangle[0].x - sqrt(line1), triangle[0].y);
			double angle1 = atan2(triangle[1].y - triangle[0].y, triangle[1].x - triangle[0].x);
			double angle2 = atan2(triangle[0].y - newPoint.y, triangle[0].x - newPoint.x);
			rotatedAngle = (angle2 - angle1) * 180 / 3.14;
			if (rotatedAngle < 0) {
				rotatedAngle += 360;//the angle as compared to the inverted triangle
			}
		}
		else {
			Point newPoint = Point(triangle[1].x - sqrt(line1), triangle[1].y);
			double angle1 = atan2(triangle[0].y - triangle[1].y, triangle[0].x - triangle[1].x);
			double angle2 = atan2(triangle[1].y - newPoint.y, triangle[1].x - newPoint.x);
			rotatedAngle = (angle1 - angle2) * 180 / 3.14;
			if (rotatedAngle < 0) {
				rotatedAngle += 360;
			}
		}
	}
	else if (line2 > line1 && line2 > line3) {//line2 is the longest side
		if (triangle[1].y < triangle[2].y) {//find lowest point, and use it to calculate angle
			Point newPoint = Point(triangle[1].x - sqrt(line1), triangle[1].y);
			double angle1 = atan2(triangle[2].y - triangle[1].y, triangle[2].x - triangle[1].x);
			double angle2 = atan2(triangle[1].y - newPoint.y, triangle[1].x - newPoint.x);
			rotatedAngle = (angle2 - angle1) * 180 / 3.14;
			if (rotatedAngle < 0) {
				rotatedAngle += 360;
			}
		}
		else {
			Point newPoint = Point(triangle[2].x - sqrt(line1), triangle[2].y);
			double angle1 = atan2(triangle[1].y - triangle[2].y, triangle[1].x - triangle[2].x);
			double angle2 = atan2(triangle[2].y - newPoint.y, triangle[2].x - newPoint.x);
			rotatedAngle = (angle1 - angle2) * 180 / 3.14;
			if (rotatedAngle < 0) {
				rotatedAngle += 360;
			}
		}
	}
	else {//line3 is the longest side
		if (triangle[2].y < triangle[0].y) {//find lowest point, and use it to calculate angle
			Point newPoint = Point(triangle[2].x - sqrt(line1), triangle[2].y);
			double angle1 = atan2(triangle[0].y - triangle[2].y, triangle[0].x - triangle[2].x);
			double angle2 = atan2(triangle[2].y - newPoint.y, triangle[2].x - newPoint.x);
			rotatedAngle = (angle2 - angle1) * 180 / 3.14;
			if (rotatedAngle < 0) {
				rotatedAngle += 360;
			}
		}
		else {
			Point newPoint = Point(triangle[0].x - sqrt(line1), triangle[0].y);
			double angle1 = atan2(triangle[2].y - triangle[0].y, triangle[2].x - triangle[0].x);
			double angle2 = atan2(triangle[0].y - newPoint.y, triangle[0].x - newPoint.x);
			rotatedAngle = (angle1 - angle2) * 180 / 3.14;
			if (rotatedAngle < 0) {
				rotatedAngle += 360;
			}
		}
	}
	double angleToRotate = rotatedAngle;
	if (angleToRotate >= 30 && angleToRotate <= 330) {
		// get rotation matrix for rotating the image around its center in pixel coordinates
		Point2f center((image.cols - 1) / 2.0, (image.rows - 1) / 2.0);
		Mat rot = getRotationMatrix2D(center, angleToRotate, 1.0);
		// determine bounding rectangle, center not relevant
		Rect2f bbox = RotatedRect(cv::Point2f(), image.size(), angleToRotate).boundingRect2f();
		// adjust transformation matrix
		rot.at<double>(0, 2) += bbox.width / 2.0 - image.cols / 2.0;
		rot.at<double>(1, 2) += bbox.height / 2.0 - image.rows / 2.0;

		Mat dst;
		warpAffine(image, dst, rot, bbox.size());
		dst.copyTo(image);
		if (image.cols > 1800 || image.rows > 1500) {
			resize(image, image, Size(image.cols / 5, image.rows / 5));
		}

		// sharpen image using "unsharp mask" algorithm
		GaussianBlur(image, blurred, Size(), sigma, sigma);
		lowContrastMask = abs(image - blurred) < thresh;
		sharpened = image * (1 + amount) + blurred * (-amount);
		image.copyTo(sharpened, lowContrastMask);
		cvtColor(sharpened, imageGray, COLOR_BGR2GRAY);
		threshold(imageGray, threshOutput, 150, 150, 0);
		findContours(threshOutput, contours, RETR_TREE, CHAIN_APPROX_SIMPLE);
		contours.erase(contours.begin());
		//erase any very small contour
		for (int i = 0; i < contours.size();) {
			if (contourArea(contours[i]) < 10) {
				contours.erase(contours.begin() + i);
			}
			else {
				i++;
			}
		}
	}

	sort(contours.begin(), contours.end(), smallerContour);
	string data = "";
	for (int i = 0; i < contours.size(); i++) {
		// Create the mask with the polygon
		Rect boundRect = boundingRect(contours[i]);
		Mat mask = Mat::zeros(image.rows, image.cols, uchar(0));
		drawContours(mask, contours, i, 255, -1);
		erode(mask, mask, Mat(), Point(-1, -1), 1);
		Scalar meanValue = mean(image, mask);
		Rect contour = boundingRect(contours[i]);
		string currentData = decode(meanValue);
		if (currentData == "error finding match") {
			return "error in decoding";
		}
		data += currentData;
	}
	string secretMessage = "";
	for (int i = 0; i < data.length()/7; i++) {
		string cur = data.substr(i * 7, 7);
		cout << cur << endl;
		if (cur == EOFBinary) {
			break;
		}
		cur = binaryToStr(cur);
		secretMessage += cur;
	}
	return secretMessage;
}

long long int get_now() {
    return chrono::duration_cast<std::chrono::milliseconds>(
            chrono::system_clock::now().time_since_epoch()
    ).count();
}

// Avoiding name mangling
extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    const char* version() {
        return CV_VERSION;
        // char* r = CV_VERSION;
        // return r;
    }

    __attribute__((visibility("default"))) __attribute__((used))
	void generateImage(char* dataBytes, char* outputImagePath, char* type) {
		long long start = get_now();
		string data = string(dataBytes);
		string imageType = string(type);
		Mat outputImage = encodeImage(data, imageType);

		imwrite(outputImagePath, outputImage);

		int evalInMillis = static_cast<int>(get_now() - start);
		platform_log("Processing done in %dms\n", evalInMillis);
    }

    __attribute__((visibility("default"))) __attribute__((used))
    void decodeImage(char* inputImagePathChar, char* outputFileChar) {
        long long start = get_now();
        platform_log("Processing 1");
		string inputImagePath = string(inputImagePathChar);
        string decodedBytes = _decodeImage(inputImagePath);
		string outputFile = string(outputFileChar);
        platform_log("Processing 5");
        int evalInMillis = static_cast<int>(get_now() - start);
        platform_log("Processing done in %dms\n", evalInMillis);
		platform_log("Done: %s", decodedBytes.c_str());

		ofstream OutFile(outputFile);
        OutFile << decodedBytes;
        OutFile.close();
    }
}
