
  Pod::Spec.new do |s|
    # NPM package specification
    package = JSON.parse(File.read(File.join(File.dirname(__FILE__), 'package.json')))

    s.name = 'SencropCapacitorIntercom'
    s.version = package['version']
    s.summary = package['description']
    s.homepage = package['homepage']
    s.license = package['license']
    s.author = package['author']
    s.source = { :git => 'https://github.com/sencrop/capacitor-intercom', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
    s.dependency 'Intercom'
    s.static_framework = true
  end