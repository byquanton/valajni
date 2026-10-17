string java_lang_system_get_property (JNI.Env env, string key) throws JavaError.EXCEPTION {
    unowned JNI.NativeInterface* jni = *((JNI.NativeInterface**) env);
    unowned JNI.Object clazz = jni.find_class (env, "java/lang/System");
    unowned JNI.MethodID method = jni.get_static_method_id (env, clazz, "getProperty", "(Ljava/lang/String;)Ljava/lang/String;");

    unowned JNI.Object arg = jni.new_string_utf (env, key);
    JNI.Value[] args = { JNI.Value () { l = arg } };
    unowned JNI.Object result = jni.call_static_object_method_a (env, clazz, method, args);

    if (jni.exception_check (env) != 0) {
        throw new JavaError.EXCEPTION ("Java threw an exception");
    }
    if (result == null) {
        return "(null)";
    }

    return JNI.convert_string_from_java (env, jni, result);
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
        print ("java.version = %s\n", java_lang_system_get_property (env, "java.version"));
    } catch (JavaError.EXCEPTION e) {
        printerr ("%s\n", e.message);
        return 1;
    }
    return 0;
}