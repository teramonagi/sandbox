#include <numeric>      // std::accumulate
//simple value
extern "C" __declspec(dllexport) int __cdecl addI(int x, int y){ return x + y; }
extern "C" __declspec(dllexport) double __cdecl addD(double x, double y){ return x+y; }
//float array sum
extern "C" __declspec(dllexport) double __cdecl arraySum(double *x, int size){ return std::accumulate(x, x + size, 0.0); }
//string
extern "C" __declspec(dllexport) char __cdecl string1(char x){ return ++x; }
extern "C" __declspec(dllexport) int __cdecl string2(char* x)
{ 
	if (x[0] == 'H')
	{
		return 1;
	}
	return 0;
}
//allocate and release memory 
extern "C" __declspec(dllexport) double* __cdecl allocate_memory(int size)
{
	double *res = new double[size];
	for (int i = 0; i < size; ++i){ res[i] = i; }
	return res;
}
extern "C" __declspec(dllexport) void __cdecl release_memory(double *x){delete[] x;}