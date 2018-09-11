//
//  TextFieldManualLayoutLegacyExample.swift
//  GTCatalog
//
//  Created by liuxc on 2018/9/5.
//

import GTKitComponents.GTTextFields

final class TextFieldManualLayoutLegacySwiftExample: UIViewController {

    private enum LayoutConstants {
        static let largeMargin: CGFloat = 16
        static let smallMargin: CGFloat = 8

        static let floatingHeight: CGFloat = 84
        static let defaultHeight: CGFloat = 62

        static let stateWidth: CGFloat = 80
    }

    let scrollView = UIScrollView()

    let name: GTCTextField = {
        let name = GTCTextField()
        name.autocapitalizationType = .words
        return name
    }()

    let address: GTCTextField = {
        let address = GTCTextField()
        address.autocapitalizationType = .words
        return address
    }()

    let city: GTCTextField = {
        let city = GTCTextField()
        city.autocapitalizationType = .words
        return city
    }()
    let cityController: GTCTextInputControllerLegacyDefault

    let state: GTCTextField = {
        let state = GTCTextField()
        state.autocapitalizationType = .allCharacters
        return state
    }()

    let zip: GTCTextField = {
        let zip = GTCTextField()
        return zip
    }()
    let zipController: GTCTextInputControllerLegacyDefault

    let phone: GTCTextField = {
        let phone = GTCTextField()
        return phone
    }()

    let stateZip = UIView()

    var allTextFieldControllers = [GTCTextInputControllerLegacyDefault]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        cityController = GTCTextInputControllerLegacyDefault(textInput: city)
        zipController = GTCTextInputControllerLegacyDefault(textInput: zip)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white:0.97, alpha: 1.0)

        title = "Legacy Manual Text Fields"

        setupScrollView()
        setupTextFields()

        updateLayout()

        registerKeyboardNotifications()
        addGestureRecognizer()

        let styleButton = UIBarButtonItem(title: "Style",
                                          style: .plain,
                                          target: self,
                                          action: #selector(buttonDidTouch(sender: )))
        self.navigationItem.rightBarButtonItem = styleButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.frame = view.bounds
    }

    func setupTextFields() {
        scrollView.addSubview(name)
        let nameController = GTCTextInputControllerLegacyDefault(textInput: name)
        name.delegate = self
        nameController.placeholderText = "Name"
        allTextFieldControllers.append(nameController)

        scrollView.addSubview(address)
        let addressController = GTCTextInputControllerLegacyDefault(textInput: address)
        address.delegate = self
        addressController.placeholderText = "Address"
        allTextFieldControllers.append(addressController)

        scrollView.addSubview(city)
        city.delegate = self
        cityController.placeholderText = "City"
        allTextFieldControllers.append(cityController)

        scrollView.addSubview(stateZip)

        stateZip.addSubview(state)
        let stateController = GTCTextInputControllerLegacyDefault(textInput: state)
        state.delegate = self
        stateController.placeholderText = "State"
        allTextFieldControllers.append(stateController)

        stateZip.addSubview(zip)
        zip.delegate = self
        zipController.placeholderText = "Zip Code"
        zipController.helperText = "XXXXX"
        allTextFieldControllers.append(zipController)

        scrollView.addSubview(phone)
        let phoneController = GTCTextInputControllerLegacyDefault(textInput: phone)
        phone.delegate = self
        phoneController.placeholderText = "Phone Number"
        allTextFieldControllers.append(phoneController)

        var tag = 0
        for controller in allTextFieldControllers {
            guard let textField = controller.textInput as? GTCTextField else { continue }
            textField.tag = tag
            tag += 1
        }

    }

    func setupScrollView() {
        view.addSubview(scrollView)

        scrollView.contentSize =
            CGSize(width: scrollView.bounds.width - 2 * LayoutConstants.largeMargin,
                   height: 500.0)
    }

    func addGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(tapDidTouch(sender: )))
        self.scrollView.addGestureRecognizer(tapRecognizer)
    }

    func updateLayout() {
        let commonWidth = view.bounds.width - 2 * LayoutConstants.largeMargin
        var height = LayoutConstants.floatingHeight
        if let controller = allTextFieldControllers.first {
            height = controller.isFloatingEnabled ?
                LayoutConstants.floatingHeight : LayoutConstants.defaultHeight
        }

        name.frame = CGRect(x: LayoutConstants.largeMargin,
                            y: LayoutConstants.smallMargin,
                            width: commonWidth,
                            height: height)

        address.frame = CGRect(x: LayoutConstants.largeMargin,
                               y: name.frame.minY + height + LayoutConstants.smallMargin,
                               width: commonWidth,
                               height: height)

        city.frame = CGRect(x: LayoutConstants.largeMargin,
                            y: address.frame.minY + height + LayoutConstants.smallMargin,
                            width: commonWidth,
                            height: height)

        stateZip.frame = CGRect(x: LayoutConstants.largeMargin,
                                y: city.frame.minY + height + LayoutConstants.smallMargin,
                                width: commonWidth,
                                height: height)

        state.frame = CGRect(x: 0,
                             y: 0,
                             width: LayoutConstants.stateWidth,
                             height: height)

        zip.frame = CGRect(x: LayoutConstants.stateWidth + LayoutConstants.smallMargin,
                           y: 0,
                           width: stateZip.bounds.width - LayoutConstants.stateWidth -
                            LayoutConstants.smallMargin,
                           height: height)

        phone.frame = CGRect(x: LayoutConstants.largeMargin,
                             y: stateZip.frame.minY + height + LayoutConstants.smallMargin,
                             width: commonWidth,
                             height: height)
    }

    // MARK: - Actions

    @objc func tapDidTouch(sender: Any) {
        self.view.endEditing(true)
    }

    @objc func buttonDidTouch(sender: Any) {
        let alert = UIAlertController(title: "Floating Enabled",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Default (Yes)", style: .default) { _ in
            self.allTextFieldControllers.forEach({ (controller) in
                controller.isFloatingEnabled = true
            })
            self.updateLayout()
        }
        alert.addAction(defaultAction)
        let floatingAction = UIAlertAction(title: "No", style: .default) { _ in
            self.allTextFieldControllers.forEach({ (controller) in
                controller.isFloatingEnabled = false
            })
            self.updateLayout()
        }
        alert.addAction(floatingAction)
        present(alert, animated: true, completion: nil)
    }
}

extension TextFieldManualLayoutLegacySwiftExample: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let rawText = textField.text else {
            return true
        }

        let fullString = NSString(string: rawText).replacingCharacters(in: range, with: string)

        if textField == zip {
            if let range = fullString.rangeOfCharacter(from: CharacterSet.letters),
                String(fullString[range]).characterCount > 0 {
                zipController.setErrorText("Error: Zip can only contain numbers",
                                           errorAccessibilityValue: nil)
            } else if fullString.characterCount > 5 {
                zipController.setErrorText("Error: Zip can only contain five digits",
                                           errorAccessibilityValue: nil)
            } else {
                zipController.setErrorText(nil, errorAccessibilityValue: nil)
            }
        } else if textField == city {
            if let range = fullString.rangeOfCharacter(from: CharacterSet.decimalDigits),
                String(fullString[range]).characterCount > 0 {
                cityController.setErrorText("Error: City can only contain letters",
                                            errorAccessibilityValue: nil)
            } else {
                cityController.setErrorText(nil, errorAccessibilityValue: nil)
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let index = textField.tag
        if index + 1 < allTextFieldControllers.count,
            let nextField = allTextFieldControllers[index + 1].textInput {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return false
    }
}

// MARK: - Keyboard Handling

extension TextFieldManualLayoutLegacySwiftExample {
    func registerKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(notif:)),
            name: .UIKeyboardWillShow,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(notif:)),
            name: .UIKeyboardWillChangeFrame,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide(notif:)),
            name: .UIKeyboardWillHide,
            object: nil)
    }

    @objc func keyboardWillShow(notif: Notification) {
        guard let frame = notif.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        scrollView.contentInset = UIEdgeInsets(top: 0.0,
                                               left: 0.0,
                                               bottom: frame.height,
                                               right: 0.0)
    }

    @objc func keyboardWillHide(notif: Notification) {
        scrollView.contentInset = UIEdgeInsets()
    }
}

// MARK: - Status Bar Style

extension TextFieldManualLayoutLegacySwiftExample {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - CatalogByConvention
extension TextFieldManualLayoutLegacySwiftExample {
    @objc class func catalogBreadcrumbs() -> [String] {
        return ["Text Field", "[Legacy] Manual Layout (Swift)"]
    }

    @objc class func catalogIsPrimaryDemo() -> Bool {
        return false
    }
}

