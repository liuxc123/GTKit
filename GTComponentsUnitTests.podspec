Pod::Spec.new do |s|
  s.name         = "GTComponentsUnitTests"
  s.version      = "1.0.0"
  s.summary      = "This spec is an aggregate of all the GTKit Components unit tests."
  s.homepage     = "https://github.com/your/repo"
  s.authors      = "liuxc123"
  s.license      = 'Apache 2.0'
  s.source       = { :git => "https://github.com/your/repo.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.framework    = 'XCTest'

  s.source_files = 'components/*/tests/unit/*.{h,m,swift}', 'components/private/*/tests/unit/*.{h,m,swift}', 'components/*/tests/unit/supplemental/*.{h,m,swift}', 'components/private/*/tests/unit/supplemental/*.{h,m,swift}', 'components/schemes/*/tests/unit/*.{h,m,swift}'
  s.resources = ['components/*/tests/unit/resources/*', 'components/private/*/tests/unit/resources/*']

  s.dependency 'GTKitComponents'
end
