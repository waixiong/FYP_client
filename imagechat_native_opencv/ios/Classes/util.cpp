#include <chrono>
#include <bitset>
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */

#ifdef __ANDROID__
#include <android/log.h>
#endif


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