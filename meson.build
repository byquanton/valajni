project('valajni', 'c', 'vala',
  version: '0.1.0',
)

jdk = get_option('jdk')
jvm_dir = jdk / 'lib' / 'server'

jni_dep = declare_dependency(compile_args: [
                               '-I' + jdk / 'include',
                               '-I' + jdk / 'include' / 'linux',
                             ])

libjvm = meson.get_compiler('c').find_library('jvm', dirs: jvm_dir)

gio_dep = dependency('gio-2.0')

executable('math',
           'src/math.vala', 'src/jni.vapi',
           dependencies: [gio_dep, jni_dep, libjvm],
           build_rpath: jvm_dir,
           install: true,
)