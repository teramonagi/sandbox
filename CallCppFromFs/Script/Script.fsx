open System
open System.Runtime.InteropServices
System.Environment.CurrentDirectory <- __SOURCE_DIRECTORY__
//Import declaration
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern int addI(int x, int y)
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern float addD(float x, float y)
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern float arraySum(float[] x, int size)

addI(1, 2)
addD(1.5, 2.5)
[|1.0; 2.0; 3.0;|] |> fun x -> arraySum(x, x.Length)

