public delegate void ActionFunc ();

class ActionHandler {
    public ActionFunc func;

    public ActionHandler (owned ActionFunc f) {
        func = (owned) f;
    }
}

class ActionRegistry {
    static GLib.HashTable<int64?, ActionHandler>? table = null;
    public static GLib.Mutex mutex;
    public static int64 next_peer = 1;

    public static GLib.HashTable<int64?, ActionHandler> handlers () {
        if (table == null) {
            table = new GLib.HashTable<int64?, ActionHandler> (GLib.int64_hash, GLib.int64_equal);
        }
        return table;
    }
}

public int callback_count () {
    ActionRegistry.mutex.lock ();
    int count = (int) ActionRegistry.handlers ().size ();
    ActionRegistry.mutex.unlock ();
    return count;
}

public unowned JNI.Object? valajni_native_invoke (JNI.Env env, JNI.Object cls, int64 peer, JNI.Object key, JNI.Object args) {
    ActionRegistry.mutex.lock ();
    unowned ActionHandler handler = ActionRegistry.handlers ().lookup (peer);
    ActionRegistry.mutex.unlock ();
    if (handler != null) {
        handler.func ();
    }
    return null;
}

public void valajni_native_release (JNI.Env env, JNI.Object cls, int64 peer) {
    ActionRegistry.mutex.lock ();
    ActionRegistry.handlers ().remove (peer);
    ActionRegistry.mutex.unlock ();
}

unowned JNI.Object find_handler_class (JNI.Env env) throws JavaError {
    var jni = jni_of (env);
    unowned JNI.Object cls = jni.find_class (env, "valajni/Handler");
    if (cls == null || jni.exception_check (env) != 0) {
        throw new JavaError.CLASS_NOT_FOUND ("valajni/Handler not on the class path");
    }

    JNI.NativeMethod[] methods = {
        JNI.NativeMethod () {
            name = "nativeInvoke",
            signature = "(JLjava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;",
            fnPtr = (void*) valajni_native_invoke
        },
        JNI.NativeMethod () {
            name = "nativeRelease",
            signature = "(J)V",
            fnPtr = (void*) valajni_native_release
        }
    };
    if (jni.register_natives (env, cls, methods, methods.length) != 0) {
        throw new JavaError.EXCEPTION ("RegisterNatives failed for valajni/Handler");
    }
    return cls;
}

unowned JNI.Object make_action_listener (JNI.Env env, JNI.Object handler_class, owned ActionFunc func) throws JavaError {
    ActionRegistry.mutex.lock ();
    int64 peer = ActionRegistry.next_peer++;
    ActionRegistry.handlers ().insert (peer, new ActionHandler ((owned) func));
    ActionRegistry.mutex.unlock ();

    var jni = jni_of (env);
    unowned JNI.MethodID create = jni.get_static_method_id (env, handler_class, "create",
            "(Ljava/lang/ClassLoader;Ljava/lang/Class;J)Ljava/lang/Object;");
    if (create == null) {
        throw new JavaError.METHOD_NOT_FOUND ("valajni/Handler.create not found");
    }
    unowned JNI.Object action_listener = jni.find_class (env, "java/awt/event/ActionListener");

    JNI.Value[] args = { JNI.Value () { l = null }, arg_object (action_listener), arg_long (peer) };
    unowned JNI.Object listener = jni.call_static_object_method_a (env, handler_class, create, args);
    if (jni.exception_check (env) != 0) {
        jni.exception_describe (env);
        throw new JavaError.EXCEPTION ("Handler.create threw an exception");
    }
    return listener;
}