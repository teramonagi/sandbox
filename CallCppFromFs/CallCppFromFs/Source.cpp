#include <numeric>      // std::accumulate
//add for integer
extern "C" __declspec(dllexport) int __cdecl addI(int x, int y){ return x + y; }
//add for double
extern "C" __declspec(dllexport) double __cdecl addD(double x, double y){ return x+y; }
//
extern "C" __declspec(dllexport) double __cdecl arraySum(double *x, int size){ return std::accumulate(x, x + size, 0.0); }
