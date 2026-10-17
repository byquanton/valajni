[CCode (cheader_filename = "jni.h")]
namespace JNI {
    [Compact]
    [CCode (cname = "struct _jobject")]
    public class Object {}

    [Compact]
    [CCode (cname = "struct _jmethodID")]
    public class MethodID {}

    [CCode (cname = "jvalue")]
    public struct Value {
        public int32 i;
    }

    [Compact]
    [CCode (cname = "JavaVM")]
    public class JavaVM {}

    [Compact]
    [CCode (cname = "JNIEnv")]
    public class Env {}

    [CCode (cname = "JavaVMInitArgs")]
    public struct JavaVMInitArgs {
        public int32 version;
        public int32 nOptions;
        public void* options;
        public uint8 ignoreUnrecognized;
    }

    [CCode (cname = "JNI_CreateJavaVM")]
    public int32 create_java_vm (
            out unowned JNI.JavaVM vm,
            [CCode (type = "void **")] out unowned JNI.Env env,
            JavaVMInitArgs* args
    );

    [CCode (cname = "struct JNINativeInterface_")]
    public struct NativeInterface {
        [CCode (cname = "FindClass")]
        public FindClassFunc find_class;
        [CCode (cname = "GetStaticMethodID")]
        public GetStaticMethodIDFunc get_static_method_id;
        [CCode (cname = "CallStaticIntMethodA")]
        public CallStaticIntMethodAFunc call_static_int_method_a;
        [CCode (cname = "ExceptionCheck")]
        public ExceptionCheckFunc exception_check;
    }

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->FindClass)")]
    public delegate unowned Object? FindClassFunc (Env env, string name);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->GetStaticMethodID)")]
    public delegate unowned MethodID? GetStaticMethodIDFunc (Env env, Object clazz, string name, string sig);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->CallStaticIntMethodA)")]
    public delegate int32 CallStaticIntMethodAFunc (Env env, Object clazz, MethodID m, [CCode (array_length = false)] Value[] args);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->ExceptionCheck)")]
    public delegate uint8 ExceptionCheckFunc (Env env);


    [CCode (cname = "JNI_VERSION_21")]
    public const int32 VERSION_21;

}
