project('valajni', 'c', 'vala', 'java', version : '0.1.0')

javac = meson.get_compiler('java')
if not javac.version().version_compare('>= 21')
    error('JDK 21 or newer is required, found javac ' + javac.version())
endif

jni_dep = dependency('jni', modules: ['jvm'], version: '>= 21')
gio_dep = dependency('gio-2.0')

runtime_sources = files(
    'runtime/callback.vala',
    'runtime/jni.vapi',
    'runtime/jni-helpers.vala',
)
handler = jar('handler', 'runtime/java/valajni/Handler.java')

valajni_deps = [gio_dep, jni_dep]

math = executable('math','examples/math.vala', runtime_sources, dependencies : valajni_deps)
getprop = executable('getprop','examples/getprop.vala', runtime_sources, dependencies : valajni_deps)
swing = executable('swing', 'examples/swing.vala', runtime_sources, dependencies : valajni_deps)