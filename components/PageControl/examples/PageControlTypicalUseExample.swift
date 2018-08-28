//
//  PageControlTypicalUseExample.swift
//  GTCatalog
//
//  Created by liuxc on 2018/8/28.
//

import UIKit

import GTKitComponents.GTPageControl
import GTKitComponents.GTPalettes

class PageControlSwiftExampleViewController: UIViewController, UIScrollViewDelegate {

    static let pageColors = [
        GTCPalette.cyan.tint300,
        GTCPalette.cyan.tint500,
        GTCPalette.cyan.tint700,
        GTCPalette.cyan.tint300,
        GTCPalette.cyan.tint500,
        GTCPalette.cyan.tint700
    ]

    let pageControl = GTCPageControl()
    let scrollView = UIScrollView()
    let pageLabels: [UILabel] = PageControlSwiftExampleViewController.pageColors.enumerated().map {
        enumeration in
        let (i, pageColor) = enumeration
        let pageLabel = UILabel()
        pageLabel.text = "Page \(i + 1)"
        pageLabel.font = pageLabel.font.withSize(50)
        pageLabel.textColor = UIColor(white: 0, alpha: 0.8)
        pageLabel.backgroundColor = pageColor
        pageLabel.textAlignment = NSTextAlignment.center
        pageLabel.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        return pageLabel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        scrollView.frame = self.view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(pageLabels.count),
                                        height: view.bounds.height)
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)

        // Add pages to scrollView.
        for (i, pageLabel) in pageLabels.enumerated() {
            let pageFrame = view.bounds.offsetBy(dx: CGFloat(i) * view.bounds.width, dy: 0)
            pageLabel.frame = pageFrame
            scrollView.addSubview(pageLabel)
        }

        pageControl.numberOfPages = pageLabels.count

        pageControl.addTarget(self, action: #selector(didChangePage), for: .valueChanged)
        pageControl.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(pageControl)
    }

    // MARK: - Frame changes

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let pageBeforeFrameChange = pageControl.currentPage
        for (i, pageLabel) in pageLabels.enumerated() {
            pageLabel.frame = view.bounds.offsetBy(dx: CGFloat(i) * view.bounds.width, dy: 0)
        }
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(pageLabels.count),
                                        height: view.bounds.height)
        var offset = scrollView.contentOffset
        offset.x = CGFloat(pageBeforeFrameChange) * view.bounds.width
        // This non-anmiated change of offset ensures we keep the same page
        scrollView.contentOffset = offset

        var edgeInsets = UIEdgeInsets.zero;
        #if swift(>=3.2)
        if #available(iOS 11, *) {
            edgeInsets = self.view.safeAreaInsets
        }
        #endif
        let pageControlSize = pageControl.sizeThatFits(view.bounds.size)
        let yOffset = self.view.bounds.height - pageControlSize.height - 8 - edgeInsets.bottom;
        pageControl.frame =
            CGRect(x: 0, y: yOffset, width: view.bounds.width, height: pageControlSize.height)
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidScroll(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidEndDecelerating(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidEndScrollingAnimation(scrollView)
    }

    // MARK: - User events

    @objc func didChangePage(_ sender: GTCPageControl) {
        var offset = scrollView.contentOffset
        offset.x = CGFloat(sender.currentPage) * scrollView.bounds.size.width
        scrollView.setContentOffset(offset, animated: true)
    }

    // MARK: - CatalogByConvention

    @objc class func catalogBreadcrumbs() -> [String] {
        return [ "Page Control", "Swift example"]
    }

    @objc class func catalogIsPrimaryDemo() -> Bool {
        return false
    }
}
