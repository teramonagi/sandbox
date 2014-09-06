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
//structure
typedef struct _Complex {
	double re;
	double im;
} Complex;
extern "C" __declspec(dllexport) Complex __cdecl add_complex(Complex c1, Complex c2)
{
	Complex res;
	res.re = c1.re + c2.re;
	res.im = c1.im + c2.im;
	return res;
}
extern "C" __declspec(dllexport) Complex __cdecl sub_complex(Complex* c1, Complex* c2)
{
	Complex res;
	res.re = c1->re - c2->re;
	res.im = c1->im - c2->im;
	return res;
}
//function pointer
typedef double(__stdcall *Function)(double, double);
extern "C" __declspec(dllexport) double __cdecl reduce(double* x, int size, Function func)
{
	double res = 0;
	for(int i = 0; i < size; i++)
	{
		res += func(res, x[i]);
	}
	return res;
}
