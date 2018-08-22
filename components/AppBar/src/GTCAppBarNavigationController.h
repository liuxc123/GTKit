//
//  GTCAppBarNavigationController.h
//  GTCatalog
//
//  Created by liuxc on 2018/8/22.
//

#import <UIKit/UIKit.h>

#ifndef GTC_SUBCLASSING_RESTRICTED
#if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#define GTC_SUBCLASSING_RESTRICTED __attribute__((objc_subclassing_restricted))
#else
#define GTC_SUBCLASSING_RESTRICTED
#endif
#endif  // #ifndef GTC_SUBCLASSING_RESTRICTED

@class GTCAppBar;
@class GTCAppBarViewController;
@class GTCAppBarNavigationController;

/**
 Defines the events that an GTCAppBarNavigationController may send to a delegate.
 */
@protocol GTCAppBarNavigationControllerDelegate <UINavigationControllerDelegate>
@optional

/**
 Informs the receiver that the given App Bar will be added as a child of the given view controller.

 This event is primarily intended to allow any configuration or theming of the App Bar to occur
 before it becomes part of the view controller hierarchy.

 By the time this event has fired, the navigation controller will already have attempted to infer
 the tracking scroll view from the provided view controller.

 @note This method will only be invoked if a new App Bar instance is about to be added to the view
 controller. If a flexible header is already present in the view controller, this method will not
 be invoked.
 */
- (void)appBarNavigationController:(nonnull GTCAppBarNavigationController *)navigationController
       willAddAppBarViewController:(nonnull GTCAppBarViewController *)appBarViewController
           asChildOfViewController:(nonnull UIViewController *)viewController;

#pragma mark - Will be deprecated

/**
 Informs the receiver that the given App Bar will be added as a child of the given view controller.

 This event is primarily intended to allow any configuration or theming of the App Bar to occur
 before it becomes part of the view controller hierarchy.

 By the time this event has fired, the navigation controller will already have attempted to infer
 the tracking scroll view from the provided view controller.
 
 @note This method will only be invoked if a new App Bar instance is about to be added to the view
 controller. If a flexible header is already present in the view controller, this method will not
 be invoked.

 @warning This method will soon be deprecated. Please use
 -appBarNavigationController:willAddAppBarViewController:asChildOfViewController: instead. Learn
 more at https://github.com/material-components/material-components-ios/blob/develop/components/AppBar/docs/migration-guide-appbar-appbarviewcontroller.md
 */
- (void)appBarNavigationController:(nonnull GTCAppBarNavigationController *)navigationController
                     willAddAppBar:(nonnull GTCAppBar *)appBar
           asChildOfViewController:(nonnull UIViewController *)viewController;

@end

/**
 A custom navigation controller instance that auto-injects App Bar instances into pushed view
 controllers.

 If a pushed view controller already has an App Bar or a Flexible Header then the navigation
 controller will not inject a new App Bar.

 To theme the injected App Bar, implement the delegate's
 -appBarNavigationController:willAddAppBar:asChildOfViewController: API.

 @note If you use the initWithRootViewController: API you will not have been able to provide a
 delegate yet. In this case, use the -appBarForViewController: API to retrieve the injected App Bar
 for your root view controller and execute your delegate logic on the returned result, if any.
 */
GTC_SUBCLASSING_RESTRICTED
@interface GTCAppBarNavigationController : UINavigationController

#pragma mark - Reacting to state changes

/**
 An extension of the UINavigationController's delegate.
 */
@property(nonatomic, weak, nullable) id<GTCAppBarNavigationControllerDelegate> delegate;

#pragma mark - Getting App Bar view controller instances

/**
 Returns the injected App Bar view controller for a given view controller, if an App Bar was
 injected.
 */
- (nullable GTCAppBarViewController *)appBarViewControllerForViewController:
(nonnull UIViewController *)viewController;

@end

