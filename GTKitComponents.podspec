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

  # ActivityIndicator

  s.subspec "ActivityIndicator" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"
    component.resources = ["components/#{component.base_name}/src/Material#{component.base_name}.bundle"]

    component.dependency "GTFInternationalization"
    component.dependency "GTKitComponents/Palettes"
    component.dependency "GTKitComponents/private/Application"
    component.dependency "GTMotionAnimator"
  end

  s.subspec "ActivityIndicator+ColorThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"

    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/schemes/Color"
  end

  # AnimationTiming

  s.subspec "AnimationTiming" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"
  end

  s.subspec "IBAnimatable" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/**/*.{h,m}"

    component.dependency "GTFInternationalization"
    component.dependency "GTKitComponents/Palettes"
    component.dependency "GTKitComponents/private/Application"
    component.dependency "GTMotionAnimator"
    component.dependency "GTMotionTransitioning"
  end

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
    component.dependency "GTKitComponents/private/Icons/ic_arrow_back"
    component.dependency "GTKitComponents/private/UIMetrics"
  end

  s.subspec "AppBar+ColorThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}", "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/private/*.{h,m}"
    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/FlexibleHeader+ColorThemer"
    extension.dependency "GTKitComponents/NavigationBar+ColorThemer"
    extension.dependency "GTKitComponents/Themes"
  end

  s.subspec "AppBar+TypographyThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}", "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/private/*.{h,m}"
    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/NavigationBar+TypographyThemer"
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

  s.subspec "Buttons+ColorThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}", "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/private/*.{h,m}"
    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/schemes/Color"
  end

  s.subspec "Buttons+TitleColorAccessibilityMutator" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}", "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/private/*.{h,m}"

    extension.dependency 'GTFTextAccessibility'
    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
  end

  s.subspec "Buttons+TypographyThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"

    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/schemes/Typography"
  end

  s.subspec "Buttons+ButtonThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}", "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/private/*.{h,m}"
    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/Buttons+ColorThemer"
    extension.dependency "GTKitComponents/Buttons+TypographyThemer"
  end

  # ButtonBar

  s.subspec "ButtonBar" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"

    component.dependency "GTFInternationalization"
    component.dependency "GTKitComponents/Buttons"
  end

  s.subspec "ButtonBar+ColorThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"

    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/Themes"
  end

  s.subspec "ButtonBar+TypographyThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"

    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/schemes/Typography"
  end

    # CollectionCells

  s.subspec "CollectionCells" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"
    component.resources = ["components/#{component.base_name}/src/GT#{component.base_name}.bundle"]
    component.framework = "CoreGraphics", "QuartzCore"

    component.dependency "GTFInternationalization"
    component.dependency "GTKitComponents/CollectionLayoutAttributes"
    component.dependency "GTKitComponents/Ink"
    component.dependency "GTKitComponents/Typography"
    component.dependency "GTKitComponents/Palettes"
    component.dependency "GTKitComponents/private/Icons/ic_check"
    component.dependency "GTKitComponents/private/Icons/ic_check_circle"
    component.dependency "GTKitComponents/private/Icons/ic_chevron_right"
    component.dependency "GTKitComponents/private/Icons/ic_info"
    component.dependency "GTKitComponents/private/Icons/ic_radio_button_unchecked"
    component.dependency "GTKitComponents/private/Icons/ic_reorder"
    component.dependency "GTKitComponents/private/Math"
  end

  # CollectionLayoutAttributes

  s.subspec "CollectionLayoutAttributes" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}"
  end

  # Collections

  s.subspec "Collections" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"
    component.resources = ["components/#{component.base_name}/src/GT#{component.base_name}.bundle"]
    component.framework = "CoreGraphics", "QuartzCore"

    component.dependency "GTKitComponents/CollectionCells"
    component.dependency "GTKitComponents/CollectionLayoutAttributes"
    component.dependency "GTKitComponents/Ink"
    component.dependency "GTKitComponents/Palettes"
    component.dependency "GTKitComponents/ShadowElevations"
    component.dependency "GTKitComponents/ShadowLayer"
    component.dependency "GTKitComponents/Typography"
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

  s.subspec "FlexibleHeader+ColorThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"

    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/schemes/Color"
  end

  # HeaderStackView

  s.subspec "HeaderStackView" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}"
  end

  s.subspec "HeaderStackView+ColorThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"

    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/Themes"
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

  s.subspec "NavigationBar+ColorThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"

    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/schemes/Color"
  end

  s.subspec "NavigationBar+TypographyThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"

    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/schemes/Typography"
  end

  # OverlayWindow

  s.subspec "OverlayWindow" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"

    component.dependency "GTKitComponents/private/Application"
  end

  # PageControl

  s.subspec "PageControl" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"
    component.resources = ["components/#{component.base_name}/src/GT#{component.base_name}.bundle"]
  end

  s.subspec "PageControl+ColorThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"

    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/Themes"
  end

  # Palettes

  s.subspec "Palettes" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"
  end

  # TextFields

  s.subspec "TextFields" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"

    component.dependency "GTKitComponents/AnimationTiming"
    component.dependency "GTKitComponents/Palettes"
    component.dependency "GTKitComponents/Typography"
    component.dependency "GTFInternationalization"
    component.dependency "GTKitComponents/private/Math"
    component.dependency "GTFInternationalization"
  end

  s.subspec "TextFields+ColorThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"

    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/Themes"
  end

  s.subspec "TextFields+TypographyThemer" do |extension|
    extension.ios.deployment_target = '8.0'
    extension.public_header_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.h"
    extension.source_files = "components/#{extension.base_name.split('+')[0]}/src/#{extension.base_name.split('+')[1]}/*.{h,m}"

    extension.dependency "GTKitComponents/#{extension.base_name.split('+')[0]}"
    extension.dependency "GTKitComponents/schemes/Typography"
  end

  # Themes

  s.subspec "Themes" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"

    component.dependency "GTKitComponents/schemes/Color"
    component.dependency "GTKitComponents/schemes/Typography"
  end

  # Typography

  s.subspec "Typography" do |component|
    component.ios.deployment_target = '8.0'
    component.public_header_files = "components/#{component.base_name}/src/*.h"
    component.source_files = "components/#{component.base_name}/src/*.{h,m}", "components/#{component.base_name}/src/private/*.{h,m}"

    component.dependency "GTKitComponents/private/Application"
    component.dependency "GTKitComponents/private/Math"
  end

  # schemes

  s.subspec "schemes" do |scheme_spec|
    scheme_spec.subspec "Color" do |scheme|
      scheme.ios.deployment_target = '8.0'
      scheme.public_header_files = "components/schemes/#{scheme.base_name}/src/*.h"
      scheme.source_files = "components/schemes/#{scheme.base_name}/src/*.{h,m}"
    end
    scheme_spec.subspec "Typography" do |scheme|
      scheme.ios.deployment_target = '8.0'
      scheme.public_header_files = "components/schemes/#{scheme.base_name}/src/*.h"
      scheme.source_files = "components/schemes/#{scheme.base_name}/src/*.{h,m}"
    end
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
