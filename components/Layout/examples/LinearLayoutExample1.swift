//
//  LinearLayoutExample1.swift
//  GTCatalog
//
//  Created by liuxc on 2018/9/6.
//

import GTKitComponents.GTLayout

class LinearLayoutExample1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rootLayout = GTCLinearLayout(orientation: .vert)
        rootLayout?.backgroundColor = UIColor.yellow
        self.view = rootLayout

        rootLayout?.insetsPaddingFromSafeArea = .all
        rootLayout?.insetLandscapeFringePadding = false

        let vertTitleLabel = self.createSectionLabel(title: "vertical(from top to bottom)")
        vertTitleLabel.topPos.equalTo()(0)
        rootLayout?.addSubview(vertTitleLabel);


        let vertLayout = self.createVertSubviewLayout()
        vertLayout.gtc_horzMargin = 0
        rootLayout?.addSubview(vertLayout)

        let horzTitleLabel = self.createSectionLabel(title: "horizontal(from left to right)")
        horzTitleLabel.gtc_top = 10
        rootLayout?.addSubview(horzTitleLabel)

        let horzLayout = self.createHorzSubviewLayout()
        horzLayout.gtc_left = 0;
        horzLayout.gtc_right = 0;
        horzLayout.weight = 1.0;
        rootLayout?.addSubview(horzLayout)

    }



}

// MARK: - Layout Construction
extension LinearLayoutExample1 {

    func createSectionLabel(title: String) -> UILabel {
        let sectionLabel = UILabel()
        sectionLabel.text = title
        sectionLabel.font = UIFont.systemFont(ofSize: 20)
        sectionLabel.sizeToFit()
        return sectionLabel;
    }

    func createLabel(title: String, backgroundColor color: UIColor) -> UILabel  {
        let v = UILabel()
        v.text = title
        v.font = UIFont.systemFont(ofSize: 20)
        v.numberOfLines = 0;
        v.textAlignment = .center;
        v.adjustsFontSizeToFitWidth = true;
        v.backgroundColor = color;
        v.layer.shadowOffset = CGSize(width: 3, height: 3)
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowRadius = 2;
        v.layer.shadowOpacity = 0.3;
        return v
    }


    /**
     * 创建一个垂直的线性子布局。
     */
    func createVertSubviewLayout() -> GTCLinearLayout {

        //创建垂直布局视图。
        let vertLayout = GTCLinearLayout(orientation: .vert)
        vertLayout?.backgroundColor = UIColor.red

        let v1 = self.createLabel(title: "left margin", backgroundColor: UIColor.green)
        v1.gtc_top = 10
        v1.gtc_leading = 10
        v1.gtc_width = 200
        v1.gtc_height = 35
        vertLayout?.addSubview(v1)


        let v2 = self.createLabel(title: "horz center", backgroundColor: UIColor.green)
        v2.gtc_top = 10
        v2.gtc_centerX = 0
        v2.gtc_size = CGSize(width: 200, height: 35)
        vertLayout?.addSubview(v2)

        let v3 = self.createLabel(title: "right margin", backgroundColor: UIColor.green)
        v3.gtc_top = 10
        v3.gtc_trailing = 10
        v3.frame = CGRect(x: 0, y: 0, width: 200, height: 35)
        vertLayout?.addSubview(v3)

        let v4 = self.createLabel(title: "left right", backgroundColor: UIColor.green)
        v4.gtc_top = 10
        v4.gtc_bottom = 10
        v4.gtc_leading = 10
        v4.gtc_trailing = 10
        v4.gtc_height = 35
        vertLayout?.addSubview(v4)

        return vertLayout!
    }

    func createHorzSubviewLayout() -> GTCLinearLayout {

        //创建水平布局视图。
        let horzLayout = GTCLinearLayout(orientation: .horz)
        horzLayout?.backgroundColor = UIColor.red

        let v1 = self.createLabel(title: "top margin", backgroundColor: UIColor.green)
        v1.gtc_top = 10
        v1.gtc_leading = 10
        v1.gtc_width = 60
        v1.gtc_height = 60
        horzLayout?.addSubview(v1)

        let v2 = self.createLabel(title: "vert center", backgroundColor: UIColor.green)
        v2.gtc_leading = 10
        v2.gtc_centerY = 0
        v2.gtc_size = CGSize(width: 60, height: 60)
        horzLayout?.addSubview(v2)


        let v3 = self.createLabel(title: "bottom margin", backgroundColor: UIColor.green)
        v3.gtc_bottom = 10
        v3.gtc_leading = 10
        v3.gtc_trailing = 5
        v3.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        horzLayout?.addSubview(v3)

        let v4 = self.createLabel(title: "top bottom", backgroundColor: UIColor.green)
        v4.gtc_top = 10
        v4.gtc_bottom = 10
        v4.gtc_leading = 10
        v4.gtc_trailing = 5
        v4.gtc_width = 60
        horzLayout?.addSubview(v4)

        return horzLayout!
    }

}


extension LinearLayoutExample1 {
    @objc class func catalogBreadcrumbs() -> [String] {
        return [ "Layout", "LinearLayout", "LinearLayoutExample1"]
    }

    @objc class func catalogIsPrimaryDemo() -> Bool {
        return false
    }

    @objc class func catalogIsPresentable() -> Bool {
        return false
    }
}

