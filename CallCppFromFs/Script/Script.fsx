open System
open System.Runtime.InteropServices
open Microsoft.FSharp.Core
open Microsoft.FSharp.NativeInterop 
System.Environment.CurrentDirectory <- __SOURCE_DIRECTORY__
//Import declaration
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern int addI(int x, int y)
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern float addD(float x, float y)
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern float arraySum(float[] x, int size)
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern char string1(char x)
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern int string2(string x)
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern nativeint allocate_memory(int size)
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern void release_memory(double *x)
//test code
addI(1, 2)
addD(1.5, 2.5)
[|1.0; 2.0; 3.0;|] |> fun x -> arraySum(x, x.Length)
'A' |> string1
"Hello" |> string2 
"Aello" |> string2 
//memory allocation, get value, and release it.
let ptr : nativeptr<double> = NativePtr.ofNativeInt(allocate_memory(10))
[0..9] |> List.iter (fun i -> printfn "%f" (NativePtr.get ptr i))
release_memory ptr
[0..9] |> List.iter (fun i -> printfn "%f" (NativePtr.get ptr i)) //alread released...
