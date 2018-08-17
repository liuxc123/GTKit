//
//  GTCShadowElevations.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#ifdef NS_TYPED_EXTENSIBLE_ENUM // This macro is introduced in Xcode 9.
#define GTC_SHADOW_ELEVATION_TYPED_EXTENSIBLE_ENUM NS_TYPED_EXTENSIBLE_ENUM
#elif __has_attribute(swift_wrapper) // Backwards compatibility for Xcode 8.
#define GTC_SHADOW_ELEVATION_TYPED_EXTENSIBLE_ENUM __attribute__((swift_wrapper(struct)))
#else
#define GTC_SHADOW_ELEVATION_TYPED_EXTENSIBLE_ENUM
#endif

/**
 Constants for elevation: the relative depth, or distance, between two surfaces along the z-axis.
 https://material.io/go/design-elevation
 */
NS_SWIFT_NAME(ShadowElevation)
typedef CGFloat GTCShadowElevation GTC_SHADOW_ELEVATION_TYPED_EXTENSIBLE_ENUM;

/** The shadow elevation of the app bar. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationAppBar;

/** The shadow elevation of the Bottom App Bar. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationBottomNavigationBar;

/** The shadow elevation of a card in its picked up state. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationCardPickedUp;

/** The shadow elevation of a card in its resting state. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationCardResting;

/** The shadow elevation of dialogs. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationDialog;

/** The shadow elevation of the floating action button in its pressed state. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationFABPressed;

/** The shadow elevation of the floating action button in its resting state. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationFABResting;

/** The shadow elevation of a menu. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationMenu;

/** The shadow elevation of a modal bottom sheet. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationModalBottomSheet;

/** The shadow elevation of the navigation drawer. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationNavDrawer;

/** No shadow elevation at all. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationNone;

/** The shadow elevation of a picker. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationPicker;

/** The shadow elevation of the quick entry in the scrolled state. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationQuickEntry;

/** The shadow elevation of the quick entry in the resting state. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationQuickEntryResting;

/** The shadow elevation of a raised button in the pressed state. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationRaisedButtonPressed;

/** The shadow elevation of a raised button in the resting state. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationRaisedButtonResting;

/** The shadow elevation of a refresh indicator. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationRefresh;

/** The shadow elevation of the right drawer. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationRightDrawer;

/** The shadow elevation of the search bar in the resting state. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationSearchBarResting;

/** The shadow elevation of the search bar in the scrolled state. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationSearchBarScrolled;

/** The shadow elevation of the snackbar. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationSnackbar;

/** The shadow elevation of a sub menu (+1 for each additional sub menu). */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationSubMenu;

/** The shadow elevation of a switch. */
FOUNDATION_EXPORT const GTCShadowElevation GTCShadowElevationSwitch;

