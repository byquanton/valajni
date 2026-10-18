package valajni;

import java.lang.invoke.MethodType;
import java.lang.ref.Cleaner;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public final class Handler implements InvocationHandler {
    private static final Cleaner CLEANER = Cleaner.create();
    private final long peer;

    private Handler(long peer) {
        this.peer = peer;
    }

    public static Object create(ClassLoader loader, Class<?> iface, long peer) {
        Handler handler = new Handler(peer);
        CLEANER.register(handler, () -> nativeRelease(peer));
        return Proxy.newProxyInstance(loader, new Class<?>[] { iface }, handler);
    }

    private static String descriptor(Method method) {
        return MethodType.methodType(method.getReturnType(), method.getParameterTypes()).toMethodDescriptorString();
    }

    private static native Object nativeInvoke(long peer, String key, Object[] args) throws Throwable;

    private static native void nativeRelease(long peer);

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        if (method.getDeclaringClass() == Object.class) {
            switch (method.getName()) {
                case "hashCode":
                    return System.identityHashCode(proxy);
                case "equals":
                    return proxy == args[0];
                case "toString":
                    return "valajni.Proxy@" + Integer.toHexString(System.identityHashCode(proxy));
                default:
                    break;
            }
        }
        return nativeInvoke(peer, method.getName() + descriptor(method), args);
    }
}