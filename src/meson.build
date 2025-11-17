smartestai_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
]

smartestai_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
]

smartestai_sources += gnome.compile_resources('smartestai-resources',
  'smartestai.gresource.xml',
  c_name: 'smartestai'
)

executable('smartestai', smartestai_sources,
  dependencies: smartestai_deps,
       install: true,
)
