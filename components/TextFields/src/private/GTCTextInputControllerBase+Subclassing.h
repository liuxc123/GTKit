//
//  GTCTextInputControllerBase+Subclassing.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/3.
//

#import "GTCTextInputControllerBase.h"

@interface GTCTextInputControllerBase (Subclassing)

@property(nonatomic, assign, readonly, getter=isDisplayingCharacterCountError)
BOOL displayingCharacterCountError;
@property(nonatomic, assign, readonly, getter=isDisplayingErrorText) BOOL displayingErrorText;

/** Refreshes the layout and style of the border view. Called within updateLayout. */
- (void)updateBorder;

/** Refreshes the geometry and style of the component. */
- (void)updateLayout;

/** Refreshes the layout and style of the placeholder label. Called within updateLayout. */
- (void)updatePlaceholder;

/** Refreshes the layout and style of the border view. Called within updateLayout. */
- (BOOL)isPlaceholderUp;

@end
