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

#include "delaunator_pattern.cpp"

using namespace cv;
using namespace std;

int main() {
    string input = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"; // 445
    string file = "./test.webp";

    int correct = 0;
    int wrong = 0;
    cout << "test 445 bytes data, with 512 data colors";
    for(int i = 0; i < 100; i++) {
        _encode(input, file, 0, 0, 8);
        string output = _decode(file, 0, 0);
        if(output.compare(input) == 0) {
            correct ++;
            cout << "\t" << i << ": true\n";
        } else {
            wrong ++;
            cout << "\t" << i << ": false\n";
        }
    }
    cout << "correct: " << correct;
    cout << "wrong:   " << wrong;

    correct = 0;
    wrong = 0;
    cout << "test 445 bytes data, with 64 data colors";
    for(int i = 0; i < 100; i++) {
        int r = rand() % 3;
        _encode(input, file, 1, r, 8);
        string output = _decode(file, 1, r);
        if(output.compare(input) == 0) {
            correct ++;
            cout << "\t" << i << ": true\n";
        } else {
            wrong ++;
            cout << "\t" << i << ": false\n";
        }
    }
    cout << "correct: " << correct;
    cout << "wrong:   " << wrong;

    input = "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains."; // 996
    correct = 0;
    wrong = 0;
    cout << "test 996 bytes data, with 512 data colors";
    for(int i = 0; i < 100; i++) {
        _encode(input, file, 0, 0, 8);
        string output = _decode(file, 0, 0);
        if(output.compare(input) == 0) {
            correct ++;
            cout << "\t" << i << ": true\n";
        } else {
            wrong ++;
            cout << "\t" << i << ": false\n";
        }
    }
    cout << "correct: " << correct;
    cout << "wrong:   " << wrong;

    correct = 0;
    wrong = 0;
    cout << "test 996 bytes data, with 64 data colors";
    for(int i = 0; i < 100; i++) {
        int r = rand() % 3;
        _encode(input, file, 1, r, 8);
        string output = _decode(file, 1, r);
        if(output.compare(input) == 0) {
            correct ++;
            cout << "\t" << i << ": true\n";
        } else {
            wrong ++;
            cout << "\t" << i << ": false\n";
        }
    }
    cout << "correct: " << correct;
    cout << "wrong:   " << wrong;

    input = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi dignissim lorem dui, quis facilisis dolor dapibus quis. Nullam semper purus et nunc hendrerit viverra. Aliquam quis nisl posuere, mollis magna sagittis, scelerisque libero. Quisque ac dui interdum est dignissim hendrerit sed non tellus. Pellentesque nibh purus, pulvinar in dignissim nec, ullamcorper id nisi. Ut et arcu nec nisi varius ultrices. Nullam in iaculis mi. Nam a sem hendrerit, ultrices metus condimentum, porttitor lacus. Quisque ipsum sapien, iaculis consectetur sapien ut, ornare bibendum justo. Sed vitae est cursus, efficitur mauris ut, auctor justo. Duis sit amet eros iaculis, maximus sapien a, viverra ipsum. Aliquam pulvinar, ante eget suscipit interdum, libero mi dapibus velit, a aliquam quam justo feugiat ante. Praesent at risus neque. In ultrices purus lorem, sed placerat nunc tincidunt ut. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quis ipsum consectetur, malesuada nibh quis, luctus leo. In nec dolor enim. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Morbi placerat erat nec metus viverra mollis. Nulla euismod congue lacus ut gravida. Proin tempor dui sed augue mattis, eu laoreet dui rhoncus. Maecenas ullamcorper vel enim vitae congue. Proin nunc massa, dictum eget risus et, mattis suscipit urna. Quisque tempus, nisi vel sodales porta, dui lorem blandit nunc, vel vestibulum quam nisl vestibulum lacus. Sed auctor ultricies tempor. Suspendisse non accumsan augue, in euismod enim. Etiam ac auctor turpis, non ullamcorper augue. Nam semper nisi eu lorem pharetra accumsan. Nam et aliquet felis, quis scelerisque urna. Etiam id nulla at arcu efficitur aliquam. Donec accumsan, nulla id sollicitudin faucibus, massa dui fermentum justo, vel dictum libero neque eget nulla. Donec venenatis libero ut ligula faucibus, non tristique ex dignissim. Sed ultricies nibh non ipsum pellentesque, eget dignissim magna efficitur. Aenean sit amet velit mauris. Pellentesque lectus justo, tincidunt sit amet arcu a, bibendum pharetra nisi. Donec pharetra, lorem a iaculis venenatis, neque dolor blandit ante, ut viverra est nisl faucibus augue. Pellentesque convallis rutrum nisi, a mattis ipsum sodales a. Quisque at mauris dapibus, facilisis massa vitae, gravida turpis. Quisque hendrerit mauris sed tristique laoreet. Pellentesque vulputate malesuada arcu, non laoreet tortor lacinia vel. In at sapien porttitor eros ultricies egestas efficitur a turpis. Sed vitae leo euismod nibh interdum scelerisque. Phasellus sodales venenatis viverra. Mauris placerat ipsum eget lacinia fringilla. Nam nisi diam, scelerisque id finibus ac, vulputate et lorem. Ut ac enim venenatis, luctus augue ornare, tincidunt nisl. Praesent sodales neque massa, cursus volutpat urna vulputate sed. Duis laoreet nisl vitae quam pharetra, aliquet porttitor eros faucibus. Curabitur cursus fringilla est. Etiam finibus magna luctus facilisis tempor. Donec eget odio et mi tempor semper nec ut massa. Nullam dictum turpis vel diam porta rhoncus. Vivamus mattis, magna quis iaculis facilisis, nibh orci malesuada metus, ut pellentesque sapien mi nec massa. Etiam sollicitudin arcu id nisl sodales venenatis sit amet quis erat. Donec ac tellus gravida, porta est eu, bibendum ex. Morbi nec lectus leo. Phasellus metus lacus, ullamcorper in purus non, eleifend malesuada urna. Proin pellentesque elit et justo suscipit finibus. Aliquam erat tellus, vehicula et ipsum at, volutpat varius ligula. Etiam egestas cursus laoreet. Aenean eu porttitor nulla. Aliquam non scelerisque ante. Nullam vulputate nisl urna, vel sodales mauris lobortis non. Cras pellentesque, nulla at posuere efficitur, ante massa gravida neque, a pharetra lectus felis et leo. Sed eget velit non nisi hendrerit blandit. Donec quam purus, imperdiet nec placerat et, aliquet ut est. Quisque vitae elit fringilla, ullamcorper urna id, dignissim neque. In vel commodo diam. Sed finibus tortor et sapien eleifend placerat. Nulla facilisi. Quisque sit amet sapien ac nulla egestas pulvinar a et purus. Donec et aliquet metus. Cras non felis accumsan eros maximus molestie. In tempus urna dolor, non bibendum elit cursus ut. Nullam sollicitudin erat vitae ex viverra luctus. Suspendisse odio dolor, vulputate eu justo vel, rhoncus facilisis orci. Suspendisse aliquam nibh vel libero sagittis facilisis. Suspendisse sagittis elit ut pretium condimentum. Vestibulum consectetur arcu hendrerit placerat dapibus. Cras eget gravida nunc, id lacinia tortor. Nunc vestibulum, dui vel gravida dignissim, lorem magna laoreet justo, ac vestibulum urna lorem vel risus. Vivamus ut ligula tempus, dictum eros bibendum, faucibus metus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Sed ornare ultricies eros in efficitur. Morbi fringilla pulvinar diam, a efficitur libero gravida eu. Nunc consectetur euismod felis, sed tempor neque efficitur vitae. Quisque id risus sit amet lectus sagittis iaculis ac ac mauris. Ut elementum molestie ipsum, vel tempor sem elementum sed. In lacinia mauris id metus vehicula ultricies. Nulla tincidunt risus velit, et elementum lorem venenatis sed. In gravida nisi velit, et finibus felis euismod nec. Cras lobortis magna sem, vel efficitur mi porttitor ut. Donec tellus libero, posuere ac neque ullamcorper, interdum tempus orci. Sed ultricies, turpis vitae vulputate sagittis, magna lacus vestibulum odio, sed ullamcorper est metus eleifend neque. In molestie ac turpis quis laoreet. Etiam ut justo lobortis, eleifend tortor et, fringilla est. Nulla vel mollis mauris. Duis est justo, suscipit eget pellentesque vitae, porta in dui. Vestibulum nec leo fermentum, cursus purus ac, accumsan ex. Donec bibendum venenatis augue venenatis molestie. Ut et pellentesque enim. Pellentesque porttitor lacinia metus, a rutrum sem tincidunt egestas. Vestibulum sed libero scelerisque eros egestas tempus. Morbi in vehicula nibh. In vitae metus eu arcu mattis pulvinar ut sit amet lorem. Suspendisse quis mauris in magna volutpat tempus. Ut viverra ex et nisi consectetur gravida. Nulla eget ipsum sed ligula aliquam congue id nec augue. Curabitur ultrices lectus sit amet sapien vulputate, vitae congue eros rutrum. Maecenas risus lorem, vehicula interdum accumsan vel, pharetra in leo. Cras accumsan lacus a pulvinar vestibulum. Cras accumsan lacus et neque molestie tincidunt. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut ut lectus vitae turpis tincidunt auctor. Aliquam auctor sapien dolor, non cursus lectus vulputate et. Suspendisse aliquam leo non turpis ullamcorper suscipit. Integer eu odio eros. Quisque vitae ligula massa. Pellentesque nec laoreet erat, a aliquam justo. Nullam scelerisque, sapien in aliquam aliquet, velit massa egestas tortor, ac lacinia mi turpis sit amet erat. Duis facilisis felis sed accumsan mattis. Cras suscipit dapibus volutpat. Morbi scelerisque tellus tortor, in porta orci feugiat vel. Pellentesque pretium orci purus, sit amet facilisis augue molestie laoreet. Etiam et mi lectus. Morbi posuere libero non interdum varius. Aliquam efficitur massa ac metus lobortis, eu suscipit arcu dapibus. Aenean et orci erat. Vivamus in dignissim massa. Sed accumsan rhoncus erat sed consequat. Quisque rutrum ullamcorper lorem id finibus. Aenean vel condimentum turpis. Sed nec dolor ligula. Vestibulum at ullamcorper velit. Pellentesque suscipit convallis posuere. Pellentesque semper eleifend risus at congue. Nullam porttitor ipsum quis erat vehicula fringilla. Etiam lobortis, orci sed auctor semper, risus sem euismod mi, sed ultrices risus nulla non magna. Nullam orci lorem, auctor vel auctor ac, placerat sit amet nibh. Etiam convallis ornare arcu, eu cursus ligula imperdiet ut. Nulla leo tellus, sollicitudin non elementum at, vestibulum nec risus. Quisque maximus gravida lorem, ut scelerisque libero facilisis sit amet. Fusce sed leo sit amet quam tincidunt posuere non tristique arcu. Morbi interdum facilisis est, non auctor elit tincidunt et. Integer efficitur posuere lectus, vitae porta lectus tempus facilisis. Aenean nec egestas leo, quis rhoncus metus. Vivamus non lobortis elit. Sed ultricies cras. ";
    correct = 0;
    wrong = 0;
    cout << "test 8192 bytes data, with 512 data colors";
    for(int i = 0; i < 100; i++) {
        _encode(input, file, 0, 0, 8);
        string output = _decode(file, 0, 0);
        if(output.compare(input) == 0) {
            correct ++;
            cout << "\t" << i << ": true\n";
        } else {
            wrong ++;
            cout << "\t" << i << ": false\n";
        }
    }
    cout << "correct: " << correct;
    cout << "wrong:   " << wrong;

    correct = 0;
    wrong = 0;
    cout << "test 8192 bytes data, with 64 data colors";
    for(int i = 0; i < 100; i++) {
        int r = rand() % 3;
        _encode(input, file, 1, r, 8);
        string output = _decode(file, 1, r);
        if(output.compare(input) == 0) {
            correct ++;
            cout << "\t" << i << ": true\n";
        } else {
            wrong ++;
            cout << "\t" << i << ": false\n";
        }
    }
    cout << "correct: " << correct;
    cout << "wrong:   " << wrong;
    return 0;
}