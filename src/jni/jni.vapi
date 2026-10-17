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
        public uint8 z;
        public int8 b;
        public uint16 c;
        public int16 s;
        public int32 i;
        public int64 j;
        public float f;
        public unowned Object? l;
    }


    [CCode (cname = "JNI_TRUE")]
    public const bool TRUE;
    [CCode (cname = "JNI_FALSE")]
    public const bool FALSE;


    [CCode (cname = "jint")]
    public enum Result {
        [CCode (cname = "JNI_OK")] OK, // success
        [CCode (cname = "JNI_ERR")] ERR, // unknown error
        [CCode (cname = "JNI_EDETACHED")] EDETACHED, // thread detached from the VM
        [CCode (cname = "JNI_EVERSION")] EVERSION, // JNI version error
        [CCode (cname = "JNI_ENOMEM")] ENOMEM, // not enough memory
        [CCode (cname = "JNI_EEXIST")] EEXIST, // VM already created
        [CCode (cname = "JNI_EINVAL")] EINVAL // invalid arguments
    }

    [Compact]
    [CCode (cname = "JavaVM")]
    public class JavaVM {}

    [Compact]
    [CCode (cname = "JNIEnv")]
    public class Env {}

    [CCode (cname = "JavaVMInitArgs")]
    public struct JavaVMInitArgs {
        public JNI.Version version;
        public int32 nOptions;
        public void* options;
        public uint8 ignoreUnrecognized;
    }

    [CCode (cname = "JNI_CreateJavaVM")]
    public JNI.Result create_java_vm (
            out unowned JNI.JavaVM vm,
            [CCode (type = "void **")] out unowned JNI.Env env,
            JavaVMInitArgs* args
    );

    [CCode (cname = "struct JNINativeInterface_")]
    public struct NativeInterface {
        [CCode (cname = "FindClass")]
        public FindClassFunc find_class;

        [CCode (cname = "GetMethodID")]
        public GetMethodIDFunc get_method_id;

        [CCode (cname = "GetStaticMethodID")]
        public GetStaticMethodIDFunc get_static_method_id;

        [CCode (cname = "CallObjectMethodA")]
        public CallObjectMethodAFunc call_object_method_a;
        [CCode (cname = "CallIntMethodA")]
        public CallIntMethodAFunc call_int_method_a;
        [CCode (cname = "CallVoidMethodA")]
        public CallVoidMethodAFunc call_void_method_a;
        [CCode (cname = "CallStaticObjectMethodA")]
        public CallStaticObjectMethodAFunc call_static_object_method_a;
        [CCode (cname = "CallStaticIntMethodA")]
        public CallStaticIntMethodAFunc call_static_int_method_a;

        [CCode (cname = "NewStringUTF")]
        public NewStringUTFFunc new_string_utf;
        [CCode (cname = "GetStringUTFChars")]
        public GetStringUTFCharsFunc get_string_utf_chars;
        [CCode (cname = "ReleaseStringUTFChars")]
        public ReleaseStringUTFCharsFunc release_string_utf_chars;

        [CCode (cname = "NewObjectA")]
        public NewObjectAFunc new_object_a;

        [CCode (cname = "ExceptionCheck")]
        public ExceptionCheckFunc exception_check;
    }

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->FindClass)")]
    public delegate unowned Object? FindClassFunc (Env env, string name);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->GetMethodID)")]
    public delegate unowned MethodID? GetMethodIDFunc (Env env, Object clazz, string name, string sig);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->GetStaticMethodID)")]
    public delegate unowned MethodID? GetStaticMethodIDFunc (Env env, Object clazz, string name, string sig);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->CallObjectMethodA)")]
    public delegate unowned Object? CallObjectMethodAFunc (Env env, Object obj, MethodID m, [CCode (array_length = false)] Value[] args);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->CallIntMethodA)")]
    public delegate int32 CallIntMethodAFunc (Env env, Object obj, MethodID m, [CCode (array_length = false)] Value[] args);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->CallVoidMethodA)")]
    public delegate void CallVoidMethodAFunc (Env env, Object obj, MethodID m, [CCode (array_length = false)] Value[] args);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->CallStaticObjectMethodA)")]
    public delegate unowned Object? CallStaticObjectMethodAFunc (Env env, Object clazz, MethodID m, [CCode (array_length = false)] Value[] args);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->CallStaticIntMethodA)")]
    public delegate int32 CallStaticIntMethodAFunc (Env env, Object clazz, MethodID m, [CCode (array_length = false)] Value[] args);


    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->NewStringUTF)")]
    public delegate unowned Object? NewStringUTFFunc (Env env, string str);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->GetStringUTFChars)")]
    public delegate unowned string? GetStringUTFCharsFunc (Env env, Object str, void* is_copy);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->ReleaseStringUTFChars)")]
    public delegate void ReleaseStringUTFCharsFunc (Env env, Object str, string chars);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->NewObjectA)")]
    public delegate unowned Object? NewObjectAFunc (Env env, Object clazz, MethodID m, [CCode (array_length = false)] Value[] args);

    [CCode (has_target = false, cname = "__typeof__ (((struct JNINativeInterface_ *) 0)->ExceptionCheck)")]
    public delegate uint8 ExceptionCheckFunc (Env env);


    [CCode (cname = "jint")]
    public enum Version {
        [CCode (cname = "JNI_VERSION_1_1")] V1_1,
        [CCode (cname = "JNI_VERSION_1_2")] V1_2,
        [CCode (cname = "JNI_VERSION_1_4")] V1_4,
        [CCode (cname = "JNI_VERSION_1_6")] V1_6,
        [CCode (cname = "JNI_VERSION_1_8")] V1_8,
        [CCode (cname = "JNI_VERSION_9")]   V9,
        [CCode (cname = "JNI_VERSION_10")]  V10,
        [CCode (cname = "JNI_VERSION_19")]  V19,
        [CCode (cname = "JNI_VERSION_20")]  V20,
        [CCode (cname = "JNI_VERSION_21")]  V21,
        [CCode (cname = "JNI_VERSION_24")]  V24
    }

    string convert_string_from_java (JNI.Env env, JNI.NativeInterface* jni, JNI.Object java_string) {
        unowned string chars = jni.get_string_utf_chars (env, java_string, null);
        string result = chars.dup ();
        jni.release_string_utf_chars (env, java_string, chars);
        return result;
    }
}
