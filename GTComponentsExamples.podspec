Pod::Spec.new do |s|
  s.name         = "GTComponentsExamples"
  s.version      = "1.0.0"
  s.summary      = "This spec is an aggregate of all the GTKit Components examples."
  s.homepage     = "https://github.com/your/repo"
  s.authors      = "Catalog"
  s.license      = 'Apache 2.0'
  s.source       = { :git => "https://github.com/liuxc123/GTKit.git", :tag => s.version.to_s }
  s.requires_arc = true
  
  # Conventions
  s.source_files = 'components/*/examples/*.{h,m,swift}', 'components/*/examples/supplemental/*.{h,m,swift}', 'components/private/*/examples/*.{h,m,swift}', 'components/schemes/*/examples/*.{h,m,swift}', 'components/schemes/*/examples/supplemental/*.{h,m,swift}'
  s.resources = ['components/*/examples/resources/*', 'components/private/*/examples/resources/*', 'components/schemes/*/examples/resources/*']
  s.public_header_files = 'components/*/examples/*.h', 'components/*/examples/supplemental/*.h', 'components/private/*/examples/*.h', 'components/schemes/*/examples/*.h'

  s.dependency 'GTKitComponents'

end
