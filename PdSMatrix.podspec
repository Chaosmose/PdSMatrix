Pod::Spec.new do |s|
  s.name        = 'PdSMatrix'
  s.version     = '1.0'
  s.authors     = { 'Benoit Pereira da Silva' => 'benoit@pereira-da-silva.com' }
  s.homepage    = 'https://github.com/benoit-pereira-da-silva/PdSMatrix'
  s.summary     = 'A view controller to display a full screen matrix of cells (view controller)'
  s.source      = { :git => 'https://github.com/benoit-pereira-da-silva/PdSMatrix.git'}
  s.license     = { :type => "LGPL", :file => "LICENSE" }

  s.ios.deployment_target = '5.0'
  s.requires_arc = true
  s.source_files =  'PdSMatrix/*.{h,m}'
  s.public_header_files = 'PdSMatrix/**/*.h'
end