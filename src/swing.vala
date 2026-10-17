unowned JNI.Object java_new_object (JNI.Env env, string classname, string sig, JNI.Value[] args) throws JavaError {
    unowned JNI.NativeInterface* jni = *((JNI.NativeInterface**) env);
    unowned JNI.Object clazz = jni.find_class (env, classname);
    unowned JNI.MethodID init_method = jni.get_method_id (env, clazz, "<init>", sig);
    unowned JNI.Object instance = jni.new_object_a (env, clazz, init_method, args);

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
    unowned JNI.Object result = jni.call_object_method_a (env, instance, method, args);

    if (jni.exception_check (env) != 0) {
        throw new JavaError.EXCEPTION ("%s.%s threw an exception".printf (classname, name));
    }
    return result;
}

void java_call_void (JNI.Env env, string classname, JNI.Object instance,
        string name, string sig, JNI.Value[] args) throws JavaError {
    unowned JNI.NativeInterface* jni = *((JNI.NativeInterface**) env);
    unowned JNI.Object clazz = jni.find_class (env, classname);
    unowned JNI.MethodID method = jni.get_method_id (env, clazz, name, sig);
    jni.call_void_method_a (env, instance, method, args);

    if (jni.exception_check (env) != 0) {
        throw new JavaError.EXCEPTION ("%s.%s threw an exception".printf (classname, name));
    }
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
        unowned JNI.NativeInterface* jni = *((JNI.NativeInterface**) env);

        JNI.Value[] frame_args = { JNI.Value () { l = jni.new_string_utf (env, "Hello World") } };
        unowned JNI.Object frame = java_new_object (env, "javax/swing/JFrame", "(Ljava/lang/String;)V", frame_args);

        JNI.Value[] label_args = { JNI.Value () { l = jni.new_string_utf (env, "Hi from Vala") } };
        unowned JNI.Object label = java_new_object (env, "javax/swing/JLabel", "(Ljava/lang/String;)V", label_args);

        unowned JNI.Object pane = java_call_object (env, "javax/swing/JFrame", frame,
                "getContentPane", "()Ljava/awt/Container;", {});
        JNI.Value[] add_args = { JNI.Value () { l = label } };
        java_call_object (env, "java/awt/Container", pane,
                "add", "(Ljava/awt/Component;)Ljava/awt/Component;", add_args);

        JNI.Value[] size_args = { JNI.Value () { i = 250 }, JNI.Value () { i = 250 } };
        java_call_void (env, "java/awt/Component", frame, "setSize", "(II)V", size_args);

        JNI.Value[] visible_args = { JNI.Value () { z = 1 } };
        java_call_void (env, "java/awt/Window", frame, "setVisible", "(Z)V", visible_args);

        var loop = new GLib.MainLoop ();
        loop.run ();
    } catch (JavaError e) {
        printerr ("%s\n", e.message);
        return 1;
    }
    return 0;
}