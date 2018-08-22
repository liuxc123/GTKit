load 'scripts/generated/icons.rb'

Pod::Spec.new do |s|
  s.name         = "GTKitComponents"
  s.version      = "0.0.1"
  s.summary      = "This spec is an aggregate of all the GTKit Components."
  s.homepage     = "https://github.com/your/repo"
  s.authors      = "Catalog"
  s.license      = 'Apache 2.0'
  s.source       = { :git => "https://github.com/liuxc123/GTKit.git", :tag => s.version.to_s }
  s.requires_arc = true
  
  # Conventions
  # s.source_files = 'components/private/*/src/**/*.{h,m,swift}', 'components/*/src/**/*.{h,m,swift}'
  # s.resources = ['components/*/examples/resources/*', 'components/private/*/examples/resources/*', 'components/schemes/*/examples/resources/*']


  # AppBar

  s.subspec "AppBar" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"
    component.resources = ["components/#{component.base_name}/src/GT#{component.base_name}.bundle"]

    # Navigation bar contents
    component.dependency "GTKitComponents/HeaderStackView"
    component.dependency "GTKitComponents/NavigationBar"
    component.dependency "GTKitComponents/Typography"
    component.dependency "GTKitComponents/private/Application"
    # Flexible header + shadow
    component.dependency "GTKitComponents/FlexibleHeader"
    component.dependency "GTKitComponents/ShadowElevations"
    component.dependency "GTKitComponents/ShadowLayer"

    component.dependency "GTFInternationalization"
    # component.dependency "MaterialComponents/private/Icons/ic_arrow_back"
    component.dependency "GTKitComponents/private/UIMetrics"
  end

  # Buttons

  s.subspec "Buttons" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"

    component.dependency 'GTFInternationalization'
    component.dependency 'GTFTextAccessibility'
    component.dependency "GTKitComponents/Ink"
    component.dependency "GTKitComponents/ShadowElevations"
    component.dependency "GTKitComponents/ShadowLayer"
    component.dependency "GTKitComponents/Typography"
    component.dependency "GTKitComponents/private/Math"
    component.dependency "GTKitComponents/private/Shapes"
  end

  # ButtonBar

  s.subspec "ButtonBar" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"

    component.dependency "GTFInternationalization"
    component.dependency "GTKitComponents/Buttons"
  end

  # FlexibleHeader

  s.subspec "FlexibleHeader" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"

    component.dependency 'GTFTextAccessibility'
    component.dependency "GTKitComponents/private/Application"
    component.dependency "GTKitComponents/private/UIMetrics"
  end

    # HeaderStackView

  s.subspec "HeaderStackView" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}"
  end

  # Ink

  s.subspec "Ink" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"

    component.dependency "GTKitComponents/private/Math"
  end

  # ShadowElevations

  s.subspec "ShadowElevations" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}"
  end

  # ShadowLayer

  s.subspec "ShadowLayer" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}"

    component.dependency "GTKitComponents/ShadowElevations"
  end

    # Typography

  s.subspec "Typography" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"

    component.dependency "GTKitComponents/private/Application"
    component.dependency "GTKitComponents/private/Math"
  end

    # NavigationBar

  s.subspec "NavigationBar" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}"

    # Accessibility Configurator
    component.dependency "GTFTextAccessibility"

    component.dependency "GTKitComponents/ButtonBar"
    component.dependency "GTKitComponents/Typography"
    component.dependency "GTFInternationalization"
    component.dependency "GTKitComponents/private/Math"
  end

  # private

  s.subspec "private" do |private_spec|
    # Pull in icon dependencies
    # The implementation of this method is generated by running scripts/sync_icons.sh
    # and defined in scripts/generated/icons.rb
    registerIcons(private_spec)

    private_spec.subspec "Application" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/private/#{component.base_name}/src/*.h"
      component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"
    end

    private_spec.subspec "KeyboardWatcher" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/private/#{component.base_name}/src/*.h"
      component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"

      component.dependency "GTKitComponents/private/Application"
    end

    private_spec.subspec "Math" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/private/#{component.base_name}/src/*.h"
      component.source_files = "components/private/#{component.base_name}/src/*.{h,m}"
    end

    private_spec.subspec "Overlay" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/private/#{component.base_name}/src/*.h"
      component.source_files = "components/private/#{component.base_name}/src/*.{h,m}", "components/private/#{component.base_name}/src/private/*.{h,m}"
    end

    private_spec.subspec "ShapeLibrary" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/private/#{component.base_name}/src/*.h"
      component.source_files = "components/private/#{component.base_name}/src/*.{h,m}", "components/private/#{component.base_name}/src/private/*.{h,m}"

      component.dependency "GTKitComponents/private/Shapes"
      component.dependency "GTKitComponents/private/Math"
    end

    private_spec.subspec "Shapes" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/private/#{component.base_name}/src/*.h"
      component.source_files = "components/private/#{component.base_name}/src/*.{h,m}", "components/private/#{component.base_name}/src/private/*.{h,m}"

      component.dependency "GTKitComponents/ShadowLayer"
      component.dependency "GTKitComponents/private/Math"
    end

    private_spec.subspec "UIMetrics" do |component|
      component.ios.deployment_target = '8.0'
      component.public_header_files = "components/private/#{component.base_name}/src/*.h"
      component.source_files = "components/private/#{component.base_name}/src/*.{h,m}", "components/private/#{component.base_name}/src/private/*.{h,m}"

      component.dependency "GTKitComponents/private/Application"
    end
 end


end
