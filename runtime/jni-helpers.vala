errordomain JavaError {
    EXCEPTION,
    METHOD_NOT_FOUND,
    CLASS_NOT_FOUND
}

public JNI.JavaVMInitArgs make_jvm_init_args(JNI.Version version, JNI.VMOption[] opts) {
    return JNI.JavaVMInitArgs() {
        version = version,
        nOptions = opts.length,
        options = opts,
        ignoreUnrecognized = 0
    };
}


unowned JNI.Object java_new_string(JNI.Env env, string str) {
    return jni_of(env).new_string_utf(env, str);
}

string java_get_string(JNI.Env env, JNI.Object str) {
    return java_string(env, jni_of(env), str);
}

string java_string(JNI.Env env, JNI.NativeInterface* jni, JNI.Object str) {
    unowned string chars = jni.get_string_utf_chars(env, str, null);
    string result = chars.dup();
    jni.release_string_utf_chars(env, str, chars);
    return result;
}

unowned JNI.Object java_find_class(JNI.Env env, string classname) throws JavaError {
    unowned JNI.Object clazz = jni_of(env).find_class(env, classname);
    if (clazz == null || jni_of(env).exception_check(env) != 0) {
        throw new JavaError.CLASS_NOT_FOUND(classname);
    }
    return clazz;
}

unowned JNI.Object java_new_object (JNI.Env env, string classname, string sig, JNI.Value[] args) throws JavaError {
    unowned JNI.NativeInterface* jni = *((JNI.NativeInterface**) env);
    unowned JNI.Object clazz = jni.find_class (env, classname);
    unowned JNI.MethodID ctor = jni.get_method_id (env, clazz, "<init>", sig);
    unowned JNI.Object instance = jni.new_object_a (env, clazz, ctor, args);

    if (jni.exception_check (env) != 0) {
        throw new JavaError.EXCEPTION ("could not create %s".printf (classname));
    }
    return instance;
}

unowned JNI.Object java_call_object (JNI.Env env, string classname, JNI.Object instance,
        string name, string sig, JNI.Value[] args) throws JavaError {
    unowned JNI.NativeInterface* jni = *((JNI.NativeInterface**) env);
    unowned JNI.Object clazz = jni.find_class (env, classname);
    unowned JNI.MethodID method = jni.get_method_id (env, clazz, name, sig);
    if (method == null) {
        throw new JavaError.METHOD_NOT_FOUND ("%s.%s not found".printf (classname, name));
    }
    unowned JNI.Object result = jni.call_object_method_a (env, instance, method, args);

    if (jni.exception_check (env) != 0) {
        throw new JavaError.EXCEPTION ("%s.%s threw an exception".printf (classname, name));
    }
    return result;
}

int32 java_call_int(JNI.Env env, string classname, JNI.Object instance,
        string name, string sig, JNI.Value[] args) throws JavaError {
    unowned JNI.NativeInterface* jni = jni_of(env);
    unowned JNI.Object clazz = java_find_class(env, classname);
    unowned JNI.MethodID method = jni.get_method_id(env, clazz, name, sig);
    if (method == null) throw new JavaError.METHOD_NOT_FOUND("%s.%s not found".printf(classname, name));
    int32 result = jni.call_int_method_a(env, instance, method, args);
    if (jni.exception_check(env) != 0) {
        throw new JavaError.EXCEPTION("%s.%s threw an exception".printf(classname, name));
    }
    return result;
}

void java_call_void (JNI.Env env, string classname, JNI.Object instance,
        string name, string sig, JNI.Value[] args) throws JavaError {
    unowned JNI.NativeInterface* jni = *((JNI.NativeInterface**) env);
    unowned JNI.Object clazz = jni.find_class (env, classname);
    unowned JNI.MethodID method = jni.get_method_id (env, clazz, name, sig);
    if (method == null) {
        throw new JavaError.METHOD_NOT_FOUND ("%s.%s not found".printf (classname, name));
    }
    jni.call_void_method_a (env, instance, method, args);

    if (jni.exception_check (env) != 0) {
        throw new JavaError.EXCEPTION ("%s.%s threw an exception".printf (classname, name));
    }
}

unowned JNI.Object java_call_static_object(JNI.Env env, string classname,
        string name, string sig, JNI.Value[] args) throws JavaError {
    unowned JNI.NativeInterface* jni = jni_of(env);
    unowned JNI.Object clazz = java_find_class(env, classname);
    unowned JNI.MethodID method = jni.get_static_method_id(env, clazz, name, sig);
    if (method == null) throw new JavaError.METHOD_NOT_FOUND("%s.%s not found".printf(classname, name));
    unowned JNI.Object result = jni.call_static_object_method_a(env, clazz, method, args);
    if (jni.exception_check(env) != 0) {
        throw new JavaError.EXCEPTION("%s.%s threw an exception".printf(classname, name));
    }
    return result;
}

int32 java_call_static_int(JNI.Env env, string classname,
        string name, string sig, JNI.Value[] args) throws JavaError {
    unowned JNI.NativeInterface* jni = jni_of(env);
    unowned JNI.Object clazz = java_find_class(env, classname);
    unowned JNI.MethodID method = jni.get_static_method_id(env, clazz, name, sig);
    if (method == null) throw new JavaError.METHOD_NOT_FOUND("%s.%s not found".printf(classname, name));
    int32 result = jni.call_static_int_method_a(env, clazz, method, args);
    if (jni.exception_check(env) != 0) {
        throw new JavaError.EXCEPTION("%s.%s threw an exception".printf(classname, name));
    }
    return result;
}

void java_call_static_void(JNI.Env env, string classname,
        string name, string sig, JNI.Value[] args) throws JavaError {
    unowned JNI.NativeInterface* jni = jni_of(env);
    unowned JNI.Object clazz = java_find_class(env, classname);
    unowned JNI.MethodID method = jni.get_static_method_id(env, clazz, name, sig);
    if (method == null) throw new JavaError.METHOD_NOT_FOUND("%s.%s not found".printf(classname, name));
    jni.call_static_void_method_a(env, clazz, method, args);
    if (jni.exception_check(env) != 0) {
        throw new JavaError.EXCEPTION("%s.%s threw an exception".printf(classname, name));
    }
}


unowned JNI.NativeInterface* jni_of (JNI.Env env) {
    return *((JNI.NativeInterface**) env);
}

JNI.Value arg_object(JNI.Object o)   { return JNI.Value() { l = o }; }
JNI.Value arg_int(int32 v)            { return JNI.Value() { i = v }; }
JNI.Value arg_long(int64 v)          { return JNI.Value() { j = v }; }
JNI.Value arg_bool(bool v)           { return JNI.Value() { z = v ? 1 : 0 }; }