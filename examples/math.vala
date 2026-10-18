int32 java_math_abs(JNI.Env env, int32 value) throws JavaError {
    return java_call_static_int(env, "java/lang/Math", "abs", "(I)I", { arg_int(value) });
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
        print("Math.abs(-42) = %d\n", java_math_abs(env, -42));
    } catch (JavaError e) {
        printerr("%s\n", e.message);
        return 1;
    }
    return 0;
}