string java_lang_system_get_property(JNI.Env env, string key) throws JavaError {
    unowned JNI.Object result = java_call_static_object(env, "java/lang/System",
            "getProperty", "(Ljava/lang/String;)Ljava/lang/String;",
            { arg_object(java_new_string(env, key)) });
    return result == null ? "(null)" : java_get_string(env, result);
}

int main() {
    var init = make_jvm_init_args(JNI.Version.V21, new JNI.VMOption[0]);
    unowned JNI.JavaVM vm;
    unowned JNI.Env env;

    if (JNI.create_java_vm(out vm, out env, &init) != JNI.Result.OK) {
        printerr("could not start the JVM\n");
        return 1;
    }

    try {
        print("java.version = %s\n", java_lang_system_get_property(env, "java.version"));
    } catch (JavaError e) {
        printerr("%s\n", e.message);
        return 1;
    }
    return 0;
}