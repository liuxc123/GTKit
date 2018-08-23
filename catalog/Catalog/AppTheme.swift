//
//  AppTheme.swift
//  Catalog
//
//  Created by liuxc on 2018/8/23.
//  Copyright © 2018年 liuxc. All rights reserved.
//

import UIKit
import GTKitComponents.GTButtons_ButtonThemer
import GTKitComponents.GTColorScheme
import GTKitComponents.GTTypographyScheme

final class AppTheme {
    let colorScheme: GTCColorScheming
    let typographyScheme: GTCTypographyScheming
    let buttonScheme: GTCButtonScheming

    init(colorScheme: GTCColorScheming, typographyScheme: GTCTypographyScheming) {
        self.colorScheme = colorScheme
        self.typographyScheme = typographyScheme
        let buttonScheme = GTCButtonScheme()
        buttonScheme.colorScheme = colorScheme
        buttonScheme.typographyScheme = typographyScheme
        self.buttonScheme = buttonScheme
    }

    static let defaultTheme: AppTheme = {
        let colorScheme = GTCSemanticColorScheme()
        colorScheme.primaryColor =  UIColor(red: CGFloat(0x21) / 255.0,
                                            green: CGFloat(0x21) / 255.0,
                                            blue: CGFloat(0x21) / 255.0,
                                            alpha: 1)
        colorScheme.primaryColorVariant = .init(white: 0.7, alpha: 1)
        colorScheme.secondaryColor = UIColor(red: CGFloat(0x00) / 255.0,
                                             green: CGFloat(0xE6) / 255.0,
                                             blue: CGFloat(0x76) / 255.0,
                                             alpha: 1)
        let typographyScheme = GTCTypographyScheme()
        typographyScheme.headline1 = UIFont.systemFont(ofSize: 20)
        typographyScheme.headline2 = UIFont.systemFont(ofSize: 18)
        typographyScheme.headline3 = UIFont.systemFont(ofSize: 15)
        return AppTheme(colorScheme: colorScheme, typographyScheme: typographyScheme)
    }()

    static var globalTheme: AppTheme = defaultTheme {
        didSet {
            NotificationCenter.default.post(name: AppTheme.didChangeGlobalThemeNotificationName,
                                            object: nil,
                                            userInfo:
                [AppTheme.globalThemeNotificationColorSchemeKey: AppTheme.globalTheme.colorScheme,
                 AppTheme.globalThemeNotificationTypographySchemeKey: AppTheme.globalTheme.typographyScheme]
            )
        }
    }

    static let didChangeGlobalThemeNotificationName =
        Notification.Name("GTCCatalogDidChangeGlobalTheme")
    static let globalThemeNotificationColorSchemeKey = "colorScheme"
    static let globalThemeNotificationTypographySchemeKey = "typographyScheme"
}
