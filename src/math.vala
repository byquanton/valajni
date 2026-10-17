int32 java_math_abs (JNI.Env env, int32 value) throws JavaError.EXCEPTION{
    unowned JNI.NativeInterface* jni = *((JNI.NativeInterface**) env);
    unowned JNI.Object clazz = jni.find_class (env, "java/lang/Math");
    unowned JNI.MethodID method = jni.get_static_method_id (env, clazz, "abs", "(I)I");

    JNI.Value[] args = { JNI.Value () { i = value } };
    int32 result = jni.call_static_int_method_a (env, clazz, method, args);
    if (jni.exception_check (env) != 0) {
        throw new JavaError.EXCEPTION ("Java threw an exception");
    }
    return result;
}


int main () {
    var init = JNI.JavaVMInitArgs () { version = JNI.Version.V21 };
    unowned JNI.JavaVM vm;
    unowned JNI.Env env;

    if (JNI.create_java_vm (out vm, out env, &init) != JNI.Result.OK) {
        printerr ("could not start the JVM\n");
        return 1;
    }
    try {
        print ("Math.abs(-42) = %d\n", java_math_abs (env, -42));
    } catch (JavaError.EXCEPTION e) {
        printerr (e.message);
        return 0;
    }
    return 1;
}