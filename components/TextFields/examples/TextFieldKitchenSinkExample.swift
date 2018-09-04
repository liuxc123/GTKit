//
//  TextFieldKitchenSinkExample.swift
//  GTCatalog
//
//  Created by liuxc on 2018/9/4.
//

import UIKit

import GTKitComponents.GTTextFields
import GTKitComponents.GTAppBar
import GTKitComponents.GTButtons
import GTKitComponents.GTTypography
import GTKitComponents.GTPalettes

final class TextFieldKitchenSinkSwiftExample: UIViewController {

    let scrollView = UIScrollView()

    let controlLabel: UILabel = {
        let controlLabel = UILabel()
        controlLabel.translatesAutoresizingMaskIntoConstraints = false
        controlLabel.text = "Options"
        controlLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        controlLabel.textColor = UIColor(white: 0, alpha: GTCTypography.headlineFontOpacity())
        return controlLabel
    }()

    let singleLabel: UILabel = {
        let singleLabel = UILabel()
        singleLabel.translatesAutoresizingMaskIntoConstraints = false
        singleLabel.text = "Single-line Text Fields"
        singleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        singleLabel.textColor = UIColor(white: 0, alpha: GTCTypography.headlineFontOpacity())
        singleLabel.numberOfLines = 0
        return singleLabel
    }()

    let multiLabel: UILabel = {
        let multiLabel = UILabel()
        multiLabel.translatesAutoresizingMaskIntoConstraints = false
        multiLabel.text = "Multi-line Text Fields"
        multiLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        multiLabel.textColor = UIColor(white: 0, alpha: GTCTypography.headlineFontOpacity())
        multiLabel.numberOfLines = 0
        return multiLabel
    }()

    let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "In Error:"
        errorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        errorLabel.textColor = UIColor(white: 0, alpha: GTCTypography.subheadFontOpacity())
        errorLabel.numberOfLines = 0
        return errorLabel
    }()

    let helperLabel: UILabel = {
        let helperLabel = UILabel()
        helperLabel.translatesAutoresizingMaskIntoConstraints = false
        helperLabel.text = "Show Helper Text:"
        helperLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        helperLabel.textColor = UIColor(white: 0, alpha: GTCTypography.subheadFontOpacity())
        helperLabel.numberOfLines = 0
        return helperLabel
    }()

    let baselineTestLabel: UILabel = {
        let baselineTestLabel = UILabel()
        baselineTestLabel.text = "popopopopopop       "
        baselineTestLabel.translatesAutoresizingMaskIntoConstraints = false
        return baselineTestLabel
    }()

    var allInputControllers = [GTCTextInputController]()
    var allTextFieldControllers = [GTCTextInputController]()
    var allMultilineTextFieldControllers = [GTCTextInputController]()
    var controllersWithCharacterCount = [GTCTextInputController]()
    var controllersFullWidth = [GTCTextInputControllerFullWidth]()


    let unstyledTextField = GTCTextField()
    let unstyledMultilineTextField = GTCMultilineTextField()

    lazy var textInsetsModeButton: GTCButton = self.setupButton()
    lazy var characterModeButton: GTCButton = self.setupButton()
    lazy var clearModeButton: GTCButton = self.setupButton()
    lazy var underlineButton: GTCButton = self.setupButton()

    let attributedString = NSAttributedString(string: "This uses attributed text.")

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupExampleViews()
    }


    func setupFilledTextFields() -> [GTCTextInputControllerFilled] {
        let textFieldFilled = GTCTextField()
        textFieldFilled.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldFilled)

        textFieldFilled.delegate = self

        let textFieldControllerFilled = GTCTextInputControllerFilled(textInput: textFieldFilled)
        textFieldControllerFilled.isFloatingEnabled = false
        textFieldControllerFilled.placeholderText = "This is a filled text field"

        let textFieldFilledFloating = GTCTextField()
        textFieldFilledFloating.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldFilledFloating)

        textFieldFilledFloating.delegate = self

        let textFieldControllerFilledFloating = GTCTextInputControllerFilled(textInput: textFieldFilledFloating)
        textFieldControllerFilledFloating.placeholderText = "This is filled and floating"

        let textFieldFilledFloatingAttributed = GTCTextField()
        textFieldFilledFloatingAttributed.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldFilledFloatingAttributed)

        textFieldFilledFloatingAttributed.delegate = self

        let textFieldControllerFilledFloatingAttributed =
            GTCTextInputControllerFilled(textInput: textFieldFilledFloatingAttributed)
        textFieldControllerFilledFloatingAttributed.placeholderText = "This is filled and floating"
        textFieldFilledFloatingAttributed.attributedText = attributedString
        return [textFieldControllerFilled, textFieldControllerFilledFloating,
                textFieldControllerFilledFloatingAttributed]
    }

    func setupFullWidthTextFields() -> [GTCTextInputControllerFullWidth] {
        let textFieldFullWidthPlaceholder = GTCTextField()
        textFieldFullWidthPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldFullWidthPlaceholder)

        textFieldFullWidthPlaceholder.delegate = self
        textFieldFullWidthPlaceholder.clearButtonMode = .whileEditing

        let textFieldControllerFullWidthPlaceholder =
            GTCTextInputControllerFullWidth(textInput: textFieldFullWidthPlaceholder)
        textFieldControllerFullWidthPlaceholder.placeholderText = "This is a full width text field"

        let textFieldFullWidthCharMax = GTCTextField()
        textFieldFullWidthCharMax.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldFullWidthCharMax)

        textFieldFullWidthCharMax.delegate = self
        textFieldFullWidthCharMax.clearButtonMode = .whileEditing

        let textFieldControllerFullWidthCharMax =
            GTCTextInputControllerFullWidth(textInput: textFieldFullWidthCharMax)
        textFieldControllerFullWidthCharMax.characterCountMax = 50
        textFieldControllerFullWidthCharMax.placeholderText =
        "This is a full width text field with character count and a very long placeholder"

        controllersWithCharacterCount.append(textFieldControllerFullWidthCharMax)

        return [textFieldControllerFullWidthPlaceholder,
                textFieldControllerFullWidthCharMax]
    }

    func setupFloatingUnderlineTextFields() -> [GTCTextInputControllerUnderline] {
        let textFieldFloating = GTCTextField()
        textFieldFloating.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldFloating)

        textFieldFloating.delegate = self
        textFieldFloating.clearButtonMode = .whileEditing

        let textFieldControllerFloating = GTCTextInputControllerUnderline(textInput: textFieldFloating)
        textFieldControllerFloating.placeholderText = "This is a text field w/ floating placeholder"

        let textFieldFloatingCharMax = GTCTextField()
        textFieldFloatingCharMax.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldFloatingCharMax)

        textFieldFloatingCharMax.delegate = self
        textFieldFloatingCharMax.clearButtonMode = .whileEditing

        let textFieldControllerFloatingCharMax =
            GTCTextInputControllerUnderline(textInput: textFieldFloatingCharMax)
        textFieldControllerFloatingCharMax.characterCountMax = 50
        textFieldControllerFloatingCharMax.placeholderText = "This is floating with character count"

        controllersWithCharacterCount.append(textFieldControllerFloatingCharMax)

        baselineTestLabel.font = textFieldFloatingCharMax.font
        self.scrollView.addSubview(baselineTestLabel)

        if #available(iOSApplicationExtension 9.0, *), #available(iOS 9.0, *) {
            baselineTestLabel.trailingAnchor.constraint(equalTo: textFieldFloatingCharMax.trailingAnchor,
                                                        constant: 0).isActive = true

            baselineTestLabel.firstBaselineAnchor.constraint(equalTo: textFieldFloatingCharMax.firstBaselineAnchor).isActive = true
        } else {
            NSLayoutConstraint(item: baselineTestLabel,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: textFieldFloatingCharMax,
                               attribute: .trailing,
                               multiplier: 1,
                               constant: 0).isActive = true
            NSLayoutConstraint(item: baselineTestLabel,
                               attribute: .lastBaseline,
                               relatedBy: .equal,
                               toItem: textFieldFloatingCharMax,
                               attribute: .lastBaseline,
                               multiplier: 1,
                               constant: 0).isActive = true
        }

        return [textFieldControllerFloating, textFieldControllerFloatingCharMax]
    }

    func setupInlineUnderlineTextFields() -> [GTCTextInputControllerUnderline] {
        let textFieldUnderline = GTCTextField()
        textFieldUnderline.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldUnderline)

        textFieldUnderline.delegate = self
        textFieldUnderline.clearButtonMode = .whileEditing

        let textFieldControllerUnderline = GTCTextInputControllerUnderline(textInput: textFieldUnderline)

        textFieldControllerUnderline.isFloatingEnabled = false

        let textFieldUnderlinePlaceholder = GTCTextField()
        textFieldUnderlinePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldUnderlinePlaceholder)

        textFieldUnderlinePlaceholder.delegate = self

        textFieldUnderlinePlaceholder.clearButtonMode = .whileEditing

        let textFieldControllerUnderlinePlaceholder =
            GTCTextInputControllerUnderline(textInput: textFieldUnderlinePlaceholder)

        textFieldControllerUnderlinePlaceholder.isFloatingEnabled = false
        textFieldControllerUnderlinePlaceholder.placeholderText = "This is a text field w/ inline placeholder"

        let textFieldUnderlineCharMax = GTCTextField()
        textFieldUnderlineCharMax.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldUnderlineCharMax)

        textFieldUnderlineCharMax.delegate = self
        textFieldUnderlineCharMax.clearButtonMode = .whileEditing

        let textFieldControllerUnderlineCharMax =
            GTCTextInputControllerUnderline(textInput: textFieldUnderlineCharMax)
        textFieldControllerUnderlineCharMax.characterCountMax = 50
        textFieldControllerUnderlineCharMax.isFloatingEnabled = false
        textFieldControllerUnderlineCharMax.placeholderText = "This is a text field w/ character count"

        controllersWithCharacterCount.append(textFieldControllerUnderlineCharMax)

        return [textFieldControllerUnderline, textFieldControllerUnderlinePlaceholder,
                textFieldControllerUnderlineCharMax]
    }

    func setupSpecialTextFields() -> [GTCTextInputControllerFloatingPlaceholder] {
        let textFieldDisabled = GTCTextField()
        textFieldDisabled.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldDisabled)

        textFieldDisabled.delegate = self
        textFieldDisabled.isEnabled = false

        let textFieldControllerUnderlineDisabled =
            GTCTextInputControllerUnderline(textInput: textFieldDisabled)
        textFieldControllerUnderlineDisabled.isFloatingEnabled = false
        textFieldControllerUnderlineDisabled.placeholderText = "This is a disabled text field"

        let textFieldCustomFont = GTCTextField()
        textFieldCustomFont.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldCustomFont)

        textFieldCustomFont.font = UIFont.preferredFont(forTextStyle: .headline)
        textFieldCustomFont.delegate = self
        textFieldCustomFont.clearButtonMode = .whileEditing

        let textFieldControllerUnderlineCustomFont =
            GTCTextInputControllerUnderline(textInput: textFieldCustomFont)
        textFieldControllerUnderlineCustomFont.inlinePlaceholderFont = UIFont.preferredFont(forTextStyle: .headline)
        textFieldControllerUnderlineCustomFont.isFloatingEnabled = false
        textFieldControllerUnderlineCustomFont.placeholderText = "This is a custom font"

        let textFieldCustomFontFloating = GTCTextField()
        textFieldCustomFontFloating.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldCustomFontFloating)

        textFieldCustomFontFloating.font = UIFont.preferredFont(forTextStyle: .headline)
        textFieldCustomFontFloating.delegate = self
        textFieldCustomFontFloating.clearButtonMode = .whileEditing
        textFieldCustomFontFloating.cursorColor = .orange

        let textFieldControllerUnderlineCustomFontFloating =
            GTCTextInputControllerUnderline(textInput: textFieldCustomFontFloating)
        textFieldControllerUnderlineCustomFontFloating.characterCountMax = 40
        textFieldControllerUnderlineCustomFontFloating.placeholderText = "This is a custom font with the works"
        textFieldControllerUnderlineCustomFontFloating.helperText = "Custom Font"
        textFieldControllerUnderlineCustomFontFloating.activeColor = .green
        textFieldControllerUnderlineCustomFontFloating.normalColor = .purple
        textFieldControllerUnderlineCustomFontFloating.leadingUnderlineLabelTextColor = .cyan
        textFieldControllerUnderlineCustomFontFloating.trailingUnderlineLabelTextColor = .magenta
        textFieldControllerUnderlineCustomFontFloating.leadingUnderlineLabelFont =
            UIFont.preferredFont(forTextStyle: .headline)
        textFieldControllerUnderlineCustomFontFloating.inlinePlaceholderFont =
            UIFont.preferredFont(forTextStyle: .headline)
        textFieldControllerUnderlineCustomFontFloating.trailingUnderlineLabelFont =
            UIFont.preferredFont(forTextStyle: .subheadline)
        textFieldCustomFontFloating.clearButton.tintColor = GTCPalette.red.accent400
        textFieldControllerUnderlineCustomFontFloating.floatingPlaceholderNormalColor = .yellow
        textFieldControllerUnderlineCustomFontFloating.floatingPlaceholderActiveColor = .orange

        let bundle = Bundle(for: TextFieldKitchenSinkSwiftExample.self)
        let leadingViewImage = UIImage(named: "ic_search", in: bundle, compatibleWith: nil)!

        let textFieldLeadingView = GTCTextField()
        textFieldLeadingView.leadingViewMode = .always
        textFieldLeadingView.leadingView = UIImageView(image:leadingViewImage)

        textFieldLeadingView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldLeadingView)

        textFieldLeadingView.delegate = self
        textFieldLeadingView.clearButtonMode = .whileEditing

        let textFieldControllerUnderlineLeadingView =
            GTCTextInputControllerUnderline(textInput: textFieldLeadingView)
        textFieldControllerUnderlineLeadingView.isFloatingEnabled = false
        textFieldControllerUnderlineLeadingView.placeholderText = "This has a leading view"

        let textFieldLeadingViewAttributed = GTCTextField()
        textFieldLeadingViewAttributed.leadingViewMode = .always
        textFieldLeadingViewAttributed.leadingView = UIImageView(image:leadingViewImage)

        textFieldLeadingViewAttributed.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldLeadingViewAttributed)

        textFieldLeadingViewAttributed.delegate = self
        textFieldLeadingViewAttributed.clearButtonMode = .whileEditing

        let textFieldControllerUnderlineLeadingViewAttributed =
            GTCTextInputControllerUnderline(textInput: textFieldLeadingViewAttributed)
        textFieldControllerUnderlineLeadingViewAttributed.isFloatingEnabled = false
        textFieldControllerUnderlineLeadingViewAttributed.placeholderText = "This has a leading view"
        textFieldLeadingViewAttributed.attributedText = attributedString

        let textFieldLeadingViewFloating = GTCTextField()
        textFieldLeadingViewFloating.leadingViewMode = .always
        textFieldLeadingViewFloating.leadingView = UIImageView(image:leadingViewImage)

        textFieldLeadingViewFloating.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldLeadingViewFloating)

        textFieldLeadingViewFloating.delegate = self
        textFieldLeadingViewFloating.clearButtonMode = .whileEditing

        let textFieldControllerUnderlineLeadingViewFloating =
            GTCTextInputControllerUnderline(textInput: textFieldLeadingViewFloating)
        textFieldControllerUnderlineLeadingViewFloating.placeholderText = "This has a leading view and floats"

        let textFieldLeadingViewFloatingAttributed = GTCTextField()
        textFieldLeadingViewFloatingAttributed.leadingViewMode = .always
        textFieldLeadingViewFloatingAttributed.leadingView = UIImageView(image:leadingViewImage)

        textFieldLeadingViewFloatingAttributed.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldLeadingViewFloatingAttributed)

        textFieldLeadingViewFloatingAttributed.delegate = self
        textFieldLeadingViewFloatingAttributed.clearButtonMode = .whileEditing

        let textFieldControllerUnderlineLeadingViewFloatingAttributed =
            GTCTextInputControllerUnderline(textInput: textFieldLeadingViewFloatingAttributed)
        textFieldControllerUnderlineLeadingViewFloatingAttributed.placeholderText =
        "This has a leading view and floats"
        textFieldLeadingViewFloatingAttributed.attributedText = attributedString

        let trailingViewImage = UIImage(named: "ic_done", in: bundle, compatibleWith: nil)!

        let textFieldTrailingView = GTCTextField()
        textFieldTrailingView.trailingViewMode = .always
        textFieldTrailingView.trailingView = UIImageView(image:trailingViewImage)

        textFieldTrailingView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldTrailingView)

        textFieldTrailingView.delegate = self
        textFieldTrailingView.clearButtonMode = .whileEditing

        let textFieldControllerUnderlineTrailingView =
            GTCTextInputControllerUnderline(textInput: textFieldTrailingView)
        textFieldControllerUnderlineTrailingView.isFloatingEnabled = false
        textFieldControllerUnderlineTrailingView.placeholderText = "This has a trailing view"

        let textFieldTrailingViewFloating = GTCTextField()
        textFieldTrailingViewFloating.trailingViewMode = .always
        textFieldTrailingViewFloating.trailingView = UIImageView(image:trailingViewImage)

        textFieldTrailingViewFloating.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldTrailingViewFloating)

        textFieldTrailingViewFloating.delegate = self
        textFieldTrailingViewFloating.clearButtonMode = .whileEditing

        let textFieldControllerUnderlineTrailingViewFloating =
            GTCTextInputControllerUnderline(textInput: textFieldTrailingViewFloating)
        textFieldControllerUnderlineTrailingViewFloating.placeholderText = "This has a trailing view and floats"

        let textFieldLeadingTrailingView = GTCTextField()
        textFieldLeadingTrailingView.leadingViewMode = .whileEditing
        textFieldLeadingTrailingView.leadingView = UIImageView(image: leadingViewImage)
        textFieldLeadingTrailingView.trailingViewMode = .unlessEditing
        textFieldLeadingTrailingView.trailingView = UIImageView(image:trailingViewImage)

        textFieldLeadingTrailingView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldLeadingTrailingView)

        textFieldLeadingTrailingView.delegate = self
        textFieldLeadingTrailingView.clearButtonMode = .whileEditing

        let textFieldControllerUnderlineLeadingTrailingView =
            GTCTextInputControllerUnderline(textInput: textFieldLeadingTrailingView)
        textFieldControllerUnderlineLeadingTrailingView.isFloatingEnabled = false
        textFieldControllerUnderlineLeadingTrailingView.placeholderText =
        "This has leading & trailing views and a very long placeholder that should be truncated"

        let textFieldLeadingTrailingViewFloating = GTCTextField()
        textFieldLeadingTrailingViewFloating.leadingViewMode = .always
        textFieldLeadingTrailingViewFloating.leadingView = UIImageView(image: leadingViewImage)
        textFieldLeadingTrailingViewFloating.trailingViewMode = .whileEditing
        textFieldLeadingTrailingViewFloating.trailingView = UIImageView(image:trailingViewImage)

        textFieldLeadingTrailingViewFloating.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldLeadingTrailingViewFloating)

        textFieldLeadingTrailingViewFloating.delegate = self
        textFieldLeadingTrailingViewFloating.clearButtonMode = .whileEditing

        let textFieldControllerUnderlineLeadingTrailingViewFloating =
            GTCTextInputControllerUnderline(textInput: textFieldLeadingTrailingViewFloating)
        textFieldControllerUnderlineLeadingTrailingViewFloating.placeholderText =
        "This has leading & trailing views and floats and a very long placeholder that should be truncated"

        let textFieldBase = GTCTextField()
        textFieldBase.delegate = self
        textFieldBase.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldBase)

        let textFieldControllerBase = GTCTextInputControllerBase(textInput: textFieldBase)
        textFieldControllerBase.placeholderText = "This is the common base class for controllers"
        textFieldControllerBase.helperText = "It's expected that you'll subclass this."

        unstyledTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(unstyledTextField)

        unstyledTextField.placeholder = "This is an unstyled text field (no controller)"
        unstyledTextField.leadingUnderlineLabel.text = "Leading label"
        unstyledTextField.trailingUnderlineLabel.text = "Trailing label"
        unstyledTextField.delegate = self
        unstyledTextField.clearButtonMode = .whileEditing
        unstyledTextField.leadingView = UIImageView(image: leadingViewImage)
        unstyledTextField.leadingViewMode = .always
        unstyledTextField.trailingView = UIImageView(image: trailingViewImage)
        unstyledTextField.trailingViewMode = .always

        return [textFieldControllerUnderlineDisabled,
                textFieldControllerUnderlineCustomFont, textFieldControllerUnderlineCustomFontFloating,
                textFieldControllerUnderlineLeadingView,
                textFieldControllerUnderlineLeadingViewAttributed,
                textFieldControllerUnderlineLeadingViewFloating,
                textFieldControllerUnderlineLeadingViewFloatingAttributed,
                textFieldControllerUnderlineTrailingView,
                textFieldControllerUnderlineTrailingViewFloating,
                textFieldControllerUnderlineLeadingTrailingView,
                textFieldControllerUnderlineLeadingTrailingViewFloating,
                textFieldControllerBase]
    }

    // MARK: - Multi-line

    func setupAreaTextFields() -> [GTCTextInputControllerOutlinedTextArea] {
        let textFieldArea = GTCMultilineTextField()
        textFieldArea.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldArea)

        textFieldArea.textView?.delegate = self

        let textFieldControllerArea = GTCTextInputControllerOutlinedTextArea(textInput: textFieldArea)
        textFieldControllerArea.placeholderText = "This is a text area"

        let textFieldAreaAttributed = GTCMultilineTextField()
        textFieldAreaAttributed.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textFieldAreaAttributed)

        textFieldAreaAttributed.textView?.delegate = self

        let textFieldControllerAreaAttributed =
            GTCTextInputControllerOutlinedTextArea(textInput: textFieldAreaAttributed)
        textFieldControllerAreaAttributed.placeholderText = "This is a text area"
        textFieldAreaAttributed.attributedText = attributedString

        return [textFieldControllerArea, textFieldControllerAreaAttributed]
    }

    func setupUnderlineMultilineTextFields() -> [GTCTextInputControllerUnderline] {
        let multilineTextFieldUnderline = GTCMultilineTextField()
        multilineTextFieldUnderline.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(multilineTextFieldUnderline)

        multilineTextFieldUnderline.textView?.delegate = self

        let multilineTextFieldControllerUnderline =
            GTCTextInputControllerUnderline(textInput: multilineTextFieldUnderline)
        multilineTextFieldControllerUnderline.isFloatingEnabled = false

        let multilineTextFieldUnderlinePlaceholder = GTCMultilineTextField()
        multilineTextFieldUnderlinePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(multilineTextFieldUnderlinePlaceholder)

        multilineTextFieldUnderlinePlaceholder.textView?.delegate = self

        let multilineTextFieldControllerUnderlinePlaceholder =
            GTCTextInputControllerUnderline(textInput: multilineTextFieldUnderlinePlaceholder)
        multilineTextFieldControllerUnderlinePlaceholder.isFloatingEnabled = false
        multilineTextFieldControllerUnderlinePlaceholder.placeholderText =
        "This is a multi-line text field with placeholder"

        let multilineTextFieldUnderlineCharMax = GTCMultilineTextField()
        multilineTextFieldUnderlineCharMax.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(multilineTextFieldUnderlineCharMax)

        multilineTextFieldUnderlineCharMax.textView?.delegate = self

        let multilineTextFieldControllerUnderlineCharMax =
            GTCTextInputControllerUnderline(textInput: multilineTextFieldUnderlineCharMax)
        multilineTextFieldControllerUnderlineCharMax.characterCountMax = 140
        multilineTextFieldControllerUnderlineCharMax.isFloatingEnabled = false
        multilineTextFieldControllerUnderlineCharMax.placeholderText =
        "This is a multi-line text field with placeholder"

        controllersWithCharacterCount.append(multilineTextFieldControllerUnderlineCharMax)

        return [multilineTextFieldControllerUnderline, multilineTextFieldControllerUnderlinePlaceholder,
                multilineTextFieldControllerUnderlineCharMax]
    }

    func setupFullWidthMultilineTextFields() -> [GTCTextInputControllerFullWidth] {
        let multilineTextFieldFullWidth = GTCMultilineTextField()
        multilineTextFieldFullWidth.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(multilineTextFieldFullWidth)

        multilineTextFieldFullWidth.textView?.delegate = self

        let multilineTextFieldControllerFullWidth =
            GTCTextInputControllerFullWidth(textInput: multilineTextFieldFullWidth)
        multilineTextFieldControllerFullWidth.placeholderText =
        "This is a full width multi-line text field"

        let multilineTextFieldFullWidthCharMax = GTCMultilineTextField()
        multilineTextFieldFullWidthCharMax.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(multilineTextFieldFullWidthCharMax)

        multilineTextFieldFullWidthCharMax.textView?.delegate = self

        let multilineTextFieldControllerFullWidthCharMax =
            GTCTextInputControllerFullWidth(textInput: multilineTextFieldFullWidthCharMax)
        multilineTextFieldControllerFullWidthCharMax.placeholderText =
        "This is a full width multi-line text field with character count"

        controllersWithCharacterCount.append(multilineTextFieldControllerFullWidthCharMax)
        multilineTextFieldControllerFullWidthCharMax.characterCountMax = 140

        return [multilineTextFieldControllerFullWidth, multilineTextFieldControllerFullWidthCharMax]
    }

    func setupFloatingMultilineTextFields() -> [GTCTextInputControllerUnderline] {
        let multilineTextFieldFloating = GTCMultilineTextField()
        multilineTextFieldFloating.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(multilineTextFieldFloating)

        multilineTextFieldFloating.textView?.delegate = self

        let multilineTextFieldControllerFloating =
            GTCTextInputControllerUnderline(textInput: multilineTextFieldFloating)
        multilineTextFieldControllerFloating.placeholderText =
        "This is a multi-line text field with a floating placeholder"

        let multilineTextFieldFloatingCharMax = GTCMultilineTextField()
        multilineTextFieldFloatingCharMax.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(multilineTextFieldFloatingCharMax)

        multilineTextFieldFloatingCharMax.textView?.delegate = self

        let multilineTextFieldControllerFloatingCharMax =
            GTCTextInputControllerUnderline(textInput: multilineTextFieldFloatingCharMax)
        multilineTextFieldControllerFloatingCharMax.placeholderText =
        "This is a multi-line text field with a floating placeholder and character count"

        controllersWithCharacterCount.append(multilineTextFieldControllerFloatingCharMax)

        return [multilineTextFieldControllerFloating, multilineTextFieldControllerFloatingCharMax]
    }

    func setupSpecialMultilineTextFields() -> [GTCTextInputController] {
        let bundle = Bundle(for: TextFieldKitchenSinkSwiftExample.self)
        let trailingViewImage = UIImage(named: "ic_done", in: bundle, compatibleWith: nil)!

        let multilineTextFieldTrailingView = GTCMultilineTextField()
        multilineTextFieldTrailingView.trailingViewMode = .always
        multilineTextFieldTrailingView.trailingView = UIImageView(image:trailingViewImage)

        multilineTextFieldTrailingView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(multilineTextFieldTrailingView)

        multilineTextFieldTrailingView.textView?.delegate = self
        multilineTextFieldTrailingView.clearButtonMode = .whileEditing

        let multilineTextFieldControllerUnderlineTrailingView =
            GTCTextInputControllerUnderline(textInput: multilineTextFieldTrailingView)
        multilineTextFieldControllerUnderlineTrailingView.isFloatingEnabled = false
        multilineTextFieldControllerUnderlineTrailingView.placeholderText = "This has a trailing view"

        let multilineTextFieldCustomFont = GTCMultilineTextField()
        multilineTextFieldCustomFont.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(multilineTextFieldCustomFont)

        let multilineTextFieldControllerUnderlineCustomFont =
            GTCTextInputControllerUnderline(textInput: multilineTextFieldCustomFont)
        multilineTextFieldControllerUnderlineCustomFont.placeholderText = "This has a custom font"

        multilineTextFieldCustomFont.placeholderLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        multilineTextFieldCustomFont.font = UIFont.preferredFont(forTextStyle: .headline)

        scrollView.addSubview(unstyledMultilineTextField)
        unstyledMultilineTextField.translatesAutoresizingMaskIntoConstraints = false

        unstyledMultilineTextField.placeholder =
        "This multi-line text field has no controller (unstyled)"
        unstyledMultilineTextField.leadingUnderlineLabel.text = "Leading label"
        unstyledMultilineTextField.trailingUnderlineLabel.text = "Trailing label"
        unstyledMultilineTextField.textView?.delegate = self

        return [multilineTextFieldControllerUnderlineTrailingView,
                multilineTextFieldControllerUnderlineCustomFont]
    }



    @objc func tapDidTouch(sender: Any) {
        self.view.endEditing(true)
    }

    @objc func errorSwitchDidChange(errorSwitch: UISwitch) {
        allInputControllers.forEach { controller in
            if errorSwitch.isOn {
                controller.setErrorText("Uh oh! Try something else.", errorAccessibilityValue: nil)
            } else {
                controller.setErrorText(nil, errorAccessibilityValue: nil)
            }
        }
    }

    @objc func helperSwitchDidChange(helperSwitch: UISwitch) {
        allInputControllers.forEach { controller in
            controller.helperText = helperSwitch.isOn ? "This is helper text." : nil
        }
    }

}

extension TextFieldKitchenSinkSwiftExample: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension TextFieldKitchenSinkSwiftExample: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
    }
}

extension TextFieldKitchenSinkSwiftExample {
    @objc func contentSizeCategoryDidChange(notif: Notification) {
        controlLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        singleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        errorLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        helperLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
}


















