#include <opencv2/opencv.hpp>
#include <chrono>
#include <bitset>
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */

#ifdef __ANDROID__
#include <android/log.h>
#endif

using namespace cv;
using namespace std;

const string EOFBinary = "000000000000001111111";

map<std::string, cv::Scalar> colours = {
	{"0000", cv::Scalar(0, 0, 128)},
	{"0001", cv::Scalar(0, 0, 255)},
	{"0010", cv::Scalar(0, 128, 0)},
	{"0011", cv::Scalar(0, 128, 128)},
	{"0100", cv::Scalar(0, 128, 255)},
	{"0101", cv::Scalar(128, 0, 0)},
	{"0110", cv::Scalar(128, 0, 128)},
	{"0111", cv::Scalar(128, 0, 255)},
	{"1000", cv::Scalar(128, 128, 0)},
	{"1001", cv::Scalar(128, 128, 128)},
	{"1010", cv::Scalar(128, 128, 255)},
	{"1011", cv::Scalar(128, 255, 0)},
	{"1100", cv::Scalar(255, 0, 0)},
	{"1101", cv::Scalar(255, 0, 128)},
	{"1110", cv::Scalar(255, 0, 255)},
	{"1111", cv::Scalar(255, 128, 0)}
};

Scalar encode(string data) {
	return colours[data];
}

string decode(Scalar colour) {
	for (std::map<std::string, cv::Scalar>::iterator itr = colours.begin(); itr != colours.end(); ++itr) {
		if (itr->second == colour) {
			return itr->first;
		}
	}
}

// utility function
string strToBinary(string s)
{
	int n = s.length();
	string binData = "";

	for (int i = 0; i <= n; i++)
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

Mat encodeImage(string data) {
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
    	numOfColumn = numOfRow;
    	if (numOfColumn % 2 != 1) {//the number of row is set as odd number so the picture is balance
    		numOfColumn += 1;
    	}
    }
    else {
    	int min = int(ceil(sqrt(dataLength / 4.0 / 2.0)));
    	numOfRow = rand() % int(ceil(sqrt(dataLength / 4.0))) + min;
    	if (numOfRow < 1) {
    		numOfRow = 1;
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
					int randIndex = rand() % dataLength;
					currentData += data.substr(randIndex, 4 - currentData.length());
				}
			}
			else {
				int randIndex = rand() % dataLength;
				currentData = data.substr(randIndex, 4); //get random 4 bit data for encoding
			}
			Scalar colour = Colour::encode(currentData);
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
	if (boundRect.y < boundRect1.y) {
		return true;
	}
	else if (boundRect1.y < boundRect.y) {
		return false;
	}
	else {
		return boundRect.x < boundRect1.x;
	}
}

string decodeImage(string filePath) {
	Mat imageGray, threshOutput;
	Mat image = imread(filePath);
	cvtColor(image, imageGray, COLOR_BGR2GRAY);
	threshold(imageGray, threshOutput, 200, 200, 0);
	//imshow("thresh", threshOutput);
	//waitKey(0);
	vector<vector<Point>> contours;
	findContours(threshOutput, contours, RETR_TREE, CHAIN_APPROX_SIMPLE);
	sort(contours.begin(), contours.end(), smallerContour);
	contours.erase(contours.begin());
	string data = "";
	for (int i = 0; i < contours.size(); i++) {
		Rect contour = boundingRect(contours[i]);
		Vec3b colour = image.at<Vec3b>(Point(contour.x + (contour.width/2), contour.y + (contour.height/2)));
		string currentData = Colour::decode(colour);
		data += currentData;
	}
	int index = data.find(EOFBinary);
	data = data.substr(0, index);
	string secretMessage = "";
	for (int i = 0; i < data.length()/7; i++) {
		string cur = binaryToStr(data.substr(i * 7, 7));
		secretMessage += cur;
	}
	return secretMessage;
}

long long int get_now() {
    return chrono::duration_cast<std::chrono::milliseconds>(
            chrono::system_clock::now().time_since_epoch()
    ).count();
}

void platform_log(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
#ifdef __ANDROID__
    __android_log_vprint(ANDROID_LOG_VERBOSE, "ndk", fmt, args);
#else
    vprintf(fmt, args);
#endif
    va_end(args);
}

// Avoiding name mangling
extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    const char* version() {
        return CV_VERSION;
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
    string decodeImage(char* inputImagePath) {
        long long start = get_now();
        
        string decodedBytes = decodeImage(inputImagePath);
        
        int evalInMillis = static_cast<int>(get_now() - start);
        platform_log("Processing done in %dms\n", evalInMillis);

        return decodedBytes;
    }
}
