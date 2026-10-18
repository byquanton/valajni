int main (string[] argv) {
    if (argv.length < 2) {
        printerr ("usage: %s <handler.jar>\n", argv[0]);
        return 1;
    }

    string class_path = "-Djava.class.path=" + argv[1];
    JNI.VMOption[] options = { JNI.VMOption () { optionString = class_path } };
    var init = make_jvm_init_args (JNI.Version.V21, options);
    unowned JNI.JavaVM vm;
    unowned JNI.Env env;

    if (JNI.create_java_vm (out vm, out env, &init) != JNI.Result.OK) {
        printerr ("could not start the JVM\n");
        return 1;
    }

    try {
        var jni = jni_of (env);
        unowned JNI.Object handler_class = find_handler_class (env);

        unowned JNI.Object frame = java_new_object (env, "javax/swing/JFrame",
                "(Ljava/lang/String;)V", { arg_object (java_new_string (env, "Hello World")) });

        unowned JNI.Object button = java_new_object (env, "javax/swing/JButton",
                "(Ljava/lang/String;)V", { arg_object (java_new_string (env, "Click me")) });

        int clicks = 0;
        unowned JNI.Object listener = make_action_listener (env, handler_class, () => {
            clicks++;
            print ("Button clicked %d times\n", clicks);
        });

        java_call_void (env, "javax/swing/AbstractButton", button,
                "addActionListener", "(Ljava/awt/event/ActionListener;)V", { arg_object (listener) });

        unowned JNI.Object pane = java_call_object (env, "javax/swing/JFrame", frame,
                "getContentPane", "()Ljava/awt/Container;", {});
        java_call_object (env, "java/awt/Container", pane,
                "add", "(Ljava/awt/Component;)Ljava/awt/Component;", { arg_object (button) });

        java_call_void (env, "java/awt/Component", frame, "setSize", "(II)V",
                { arg_int (300), arg_int (200) });
        java_call_void (env, "javax/swing/JFrame", frame,
                "setDefaultCloseOperation", "(I)V", { arg_int (3) }); // EXIT_ON_CLOSE
        java_call_void (env, "java/awt/Window", frame, "setVisible", "(Z)V", { arg_bool (true) });

        var loop = new GLib.MainLoop();
        loop.run ();

        java_call_void (env, "javax/swing/AbstractButton", button,
                "removeActionListener", "(Ljava/awt/event/ActionListener;)V", { arg_object (listener) });
        jni.delete_local_ref (env, listener);
    } catch (JavaError e) {
        printerr ("%s\n", e.message);
        return 1;
    }
    return 0;
}