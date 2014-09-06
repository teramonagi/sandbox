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
[<Struct; StructLayout(LayoutKind.Sequential)>]
type Complex =
    val mutable re : double
    val mutable im : double
    new(r, i) = {re = r; im = i}
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern Complex add_complex(Complex c1, Complex c2)
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern Complex sub_complex(Complex* c1, Complex* c2)
//F#3.1 specification says that we do not use UnmanagedFunctionPointerAttribute attribution
type Func = delegate of float * float -> float
[<DllImport(@"../Debug/CppDLL.dll", CallingConvention = CallingConvention.Cdecl)>]
extern float reduce(float[] x, int size, Func func)

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
//struct call
let mutable c1 = Complex(1.0, 1.0)
let mutable c2 = Complex(2.0, 1.0)
let mutable c3 = add_complex(c1, c2)
printfn "c3 = c1 + c2 = %f + %fi\n" c3.re c3.im
let mutable c4 = sub_complex(&&c1, &&c2)
printfn "c4 = c1 - c2 = %f + %fi\n" c4.re c4.im
//function pointer call
let array = [|1.0; 2.0; 3.0|]
printf "%f\n" (reduce(array, array.Length, new Func(fun x y -> x + y)))
