//
//  GTCButtonBar.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/22.
//

#import "GTCButtonBar.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTButtons.h"
#import "private/GTCAppBarButtonBarBuilder.h"

static const CGFloat kButtonBarMaxHeight = 56;
static const CGFloat kButtonBarMaxPadHeight = 64;
static const CGFloat kButtonBarMinHeight = 24;

// KVO contexts
static char *const kKVOContextGTCButtonBar = "kKVOContextGTCButtonBar";

// This is required because @selector(enabled) throws a compiler warning of unrecognized selector.
static NSString *const kEnabledSelector = @"enabled";

@implementation GTCButtonBar{
    id _buttonItemsLock;
    NSArray<__kindof UIView *> *_buttonViews;

    GTCAppBarButtonBarBuilder *_defaultBuilder;
}

- (void)dealloc {
    self.items = nil;
}

- (void)commonGTCButtonBarInit {
    _buttonItemsLock = [[NSObject alloc] init];
    _layoutPosition = GTCButtonBarLayoutPositionNone;

    _defaultBuilder = [[GTCAppBarButtonBarBuilder alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTCButtonBarInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonGTCButtonBarInit];
    }
    return self;
}

- (void)alignButtonBaseline:(UIButton *)button {
    CGRect contentRect = [button contentRectForBounds:button.bounds];
    CGRect titleRect = [button titleRectForContentRect:contentRect];

    // Calculate baseline information based on frame that the title text appears in.
    CGFloat baseline = CGRectGetMaxY(titleRect) + button.titleLabel.font.descender;
    CGFloat buttonBaseline = button.frame.origin.y + baseline;

    // When modifying insets, be sure to add/subtract equal amounts on opposite sides.
    UIEdgeInsets insets = button.titleEdgeInsets;
    CGFloat baselineOffset = _buttonTitleBaseline - buttonBaseline;

    insets.top += baselineOffset;
    insets.bottom -= baselineOffset;
    button.titleEdgeInsets = insets;
}

- (CGSize)sizeThatFits:(CGSize)size shouldLayout:(BOOL)shouldLayout {
    CGFloat totalWidth = 0;

    CGFloat edge;
    switch (self.gtf_effectiveUserInterfaceLayoutDirection) {
        case UIUserInterfaceLayoutDirectionLeftToRight:
            edge = 0;
            break;
        case UIUserInterfaceLayoutDirectionRightToLeft:
            edge = size.width;
            break;
    }

    BOOL shouldAlignBaselines = _buttonTitleBaseline > 0;

    NSEnumerator<__kindof UIView *> *positionedButtonViews =
    self.layoutPosition == GTCButtonBarLayoutPositionTrailing
    ? [_buttonViews reverseObjectEnumerator]
    : [_buttonViews objectEnumerator];

    for (UIView *view in positionedButtonViews) {
        CGFloat width = view.frame.size.width;
        switch (self.gtf_effectiveUserInterfaceLayoutDirection) {
            case UIUserInterfaceLayoutDirectionLeftToRight:
                break;
            case UIUserInterfaceLayoutDirectionRightToLeft:
                edge -= width;
                break;
        }
        if (shouldLayout) {
            view.frame = CGRectMake(edge, 0, width, size.height);

            if (shouldAlignBaselines && [view isKindOfClass:[UIButton class]]) {
                if ([(UIButton *)view titleForState:UIControlStateNormal].length > 0) {
                    [self alignButtonBaseline:(UIButton *)view];
                }
            }
        }
        switch (self.gtf_effectiveUserInterfaceLayoutDirection) {
            case UIUserInterfaceLayoutDirectionLeftToRight:
                edge += width;
                break;
            case UIUserInterfaceLayoutDirectionRightToLeft:
                break;
        }
        totalWidth += width;
    }

    CGFloat maxHeight = [self usePadHeight] ? kButtonBarMaxPadHeight : kButtonBarMaxHeight;
    CGFloat minHeight = kButtonBarMinHeight;
    CGFloat height = MIN(MAX(size.height, minHeight), maxHeight);
    return CGSizeMake(totalWidth, height);
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self sizeThatFits:size shouldLayout:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self sizeThatFits:self.bounds.size shouldLayout:YES];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];

    _defaultBuilder.buttonTitleColor = self.tintColor;
    [self updateButtonTitleColors];
}

// If the horizontal size class changes, check if reloading button views is needed since their
// horizontal padding may need to change
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    const BOOL isPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    if (!isPad ||
        self.traitCollection.horizontalSizeClass == previousTraitCollection.horizontalSizeClass) {
        return;
    } else {
        [self reloadButtonViews];
    }
}

#pragma mark - Private

// Used to determine whether or not to apply height relevant for iPad or use smaller iPhone size
// Only the height is affected so we use the verticalSizeClass
- (BOOL)usePadHeight {
    const BOOL isPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    if (isPad && self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
        return YES;
    }
    return NO;
}

- (void)updateButtonTitleColors {
    for (UIView *viewObj in _buttonViews) {
        if ([viewObj isKindOfClass:[GTCButton class]]) {
            GTCButton *buttonView = (GTCButton *)viewObj;
            [buttonView setTitleColor:self.tintColor forState:UIControlStateNormal];
        }
    }
}

- (void)updateButtonsWithInkColor:(UIColor *)inkColor {
    for (UIView *viewObj in _buttonViews) {
        if ([viewObj isKindOfClass:[GTCButton class]]) {
            GTCButton *buttonView = (GTCButton *)viewObj;
            buttonView.inkColor = inkColor;
        }
    }
}

- (NSArray<UIView *> *)viewsForItems:(NSArray<UIBarButtonItem *> *)barButtonItems {
    if (![barButtonItems count]) {
        return nil;
    }
    id<GTCButtonBarDelegate> delegate = _defaultBuilder;

    NSMutableArray<UIView *> *views = [NSMutableArray array];
    [barButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *item,
                                                 NSUInteger idx,
                                                 __unused BOOL *stop) {
        GTCBarButtonItemLayoutHints hints = GTCBarButtonItemLayoutHintsNone;
        if (idx == 0) {
            hints |= GTCBarButtonItemLayoutHintsIsFirstButton;
        }
        if (idx == [barButtonItems count] - 1) {
            hints |= GTCBarButtonItemLayoutHintsIsLastButton;
        }
        UIView *view = [delegate buttonBar:self viewForItem:item layoutHints:hints];
        if (!view) {
            return;
        }

        [view sizeToFit];
        if (item.width > 0) {
            CGRect frame = view.frame;
            frame.size.width = item.width;
            view.frame = frame;
        }

        [self addSubview:view];
        [views addObject:view];
    }];
    return views;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == kKVOContextGTCButtonBar) {
        void (^mainThreadWork)(void) = ^{
            @synchronized(self->_buttonItemsLock) {
                NSUInteger itemIndex = [self.items indexOfObject:object];
                if (itemIndex == NSNotFound || itemIndex > [self->_buttonViews count]) {
                    return;
                }
                UIButton *button = self->_buttonViews[itemIndex];

                id newValue = [object valueForKey:keyPath];
                if (newValue == [NSNull null]) {
                    newValue = nil;
                }

                if ([keyPath isEqualToString:kEnabledSelector]) {
                    if ([button respondsToSelector:@selector(setEnabled:)]) {
                        [button setValue:newValue forKey:keyPath];
                    }

                } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(accessibilityHint))]) {
                    button.accessibilityHint = newValue;

                } else if ([keyPath isEqualToString:
                            NSStringFromSelector(@selector(accessibilityIdentifier))]) {
                    button.accessibilityIdentifier = newValue;

                } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(accessibilityLabel))]) {
                    button.accessibilityLabel = newValue;

                } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(accessibilityValue))]) {
                    button.accessibilityValue = newValue;

                } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(image))]) {
                    [button setImage:newValue forState:UIControlStateNormal];

                } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(tag))]) {
                    button.tag = [newValue integerValue];

                } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(tintColor))]) {
                    button.tintColor = newValue;

                } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))]) {
                    [button setTitle:newValue forState:UIControlStateNormal];

                } else {
                    NSLog(@"Unknown key path notification received by %@ for %@.",
                          NSStringFromClass([self class]), keyPath);
                }
            }
        };

        // Ensure that UIKit modifications occur on the main thread.
        if ([NSThread isMainThread]) {
            mainThreadWork();
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:mainThreadWork];
        }

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Button target selector

- (void)didTapButton:(UIButton *)button event:(UIEvent *)event {
    NSUInteger buttonIndex = [_buttonViews indexOfObject:button];
    if (buttonIndex == NSNotFound || buttonIndex > [self.buttonItems count]) {
        return;
    }

    UIBarButtonItem *item = self.buttonItems[buttonIndex];

    if (item.action == nil) {
        return;
    }

    id target = item.target;

    // As per Apple's documentation on UIBarButtonItem:
    // https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIBarButtonItem_Class/#//apple_ref/occ/instp/UIBarButtonItem/action
    // "If nil, the action message is passed up the responder chain where it may be handled by any
    // object implementing a method corresponding to the selector held by the action property."
    if (target == nil) {
        target = [self targetForAction:item.action withSender:self];
    }

    // If we ultimately couldn't find a target, bail out.
    if (!target) {
        return;
    }

    if (![target respondsToSelector:item.action]) {
        return;
    }

    NSMethodSignature *signature = [target methodSignatureForSelector:item.action];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = item.action;

    if ([invocation.methodSignature numberOfArguments] > 2) {
        [invocation setArgument:&item atIndex:2];
    }
    if ([invocation.methodSignature numberOfArguments] > 3) {
        [invocation setArgument:&event atIndex:3];
    }

    // UIKit methods that present from a UIBarButtonItem will not work with our items because we
    // can't set the necessary private ivars that associate the item with the button. So we pass the
    // button as well so that clients can present from the button's frame instead.
    // This is not part of the standard UIKit method signature.
    if ([invocation.methodSignature numberOfArguments] > 4) {
        [invocation setArgument:&button atIndex:4];
    }

    [invocation invokeWithTarget:target];
}

#pragma mark - Public

- (NSArray<UIBarButtonItem *> *)buttonItems {
    return self.items;
}

- (void)setButtonItems:(NSArray<UIBarButtonItem *> *)buttonItems {
    self.items = buttonItems;
}

- (void)setItems:(NSArray<UIBarButtonItem *> *)items {
    @synchronized(_buttonItemsLock) {
        if (_items == items || [_items isEqualToArray:items]) {
            return;
        }

        NSArray<NSString *> *keyPaths = @[
                                          NSStringFromSelector(@selector(accessibilityHint)),
                                          NSStringFromSelector(@selector(accessibilityIdentifier)),
                                          NSStringFromSelector(@selector(accessibilityLabel)),
                                          NSStringFromSelector(@selector(accessibilityValue)),
                                          kEnabledSelector,
                                          NSStringFromSelector(@selector(image)),
                                          NSStringFromSelector(@selector(tag)),
                                          NSStringFromSelector(@selector(tintColor)),
                                          NSStringFromSelector(@selector(title))
                                          ];

        // Remove old observers
        for (UIBarButtonItem *item in _items) {
            for (NSString *keyPath in keyPaths) {
                [item removeObserver:self forKeyPath:keyPath context:kKVOContextGTCButtonBar];
            }
        }

        _items = [items copy];

        // Register new observers
        for (UIBarButtonItem *item in _items) {
            for (NSString *keyPath in keyPaths) {
                [item addObserver:self
                       forKeyPath:keyPath
                          options:NSKeyValueObservingOptionNew
                          context:kKVOContextGTCButtonBar];
            }
        }

        [self reloadButtonViews];
    }
}

- (void)setButtonsTitleFont:(UIFont *)font forState:(UIControlState)state {
    [_defaultBuilder setTitleFont:font forState:state];

    for (NSUInteger i = 0; i < [_buttonViews count]; ++i) {
        UIView *viewObj = _buttonViews[i];
        if ([viewObj isKindOfClass:[UIButton class]]) {
            GTCButton *button = (GTCButton *)viewObj;
            [button setTitleFont:font forState:state];

            if (i < [_items count]) {
                UIBarButtonItem *item = _items[i];

                CGRect frame = button.frame;
                if (item.width > 0) {
                    frame.size.width = item.width;
                } else {
                    frame.size.width = [button sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
                }
                button.frame = frame;

                [self setNeedsLayout];
            }
        }
    }
}

- (nullable UIFont *)buttonsTitleFontForState:(UIControlState)state {
    return [_defaultBuilder titleFontForState:state];
}

- (void)setButtonsTitleColor:(nullable UIColor *)color forState:(UIControlState)state {
    [_defaultBuilder setTitleColor:color forState:state];

    for (UIView *viewObj in _buttonViews) {
        if ([viewObj isKindOfClass:[UIButton class]]) {
            GTCButton *button = (GTCButton *)viewObj;
            [button setTitleColor:color forState:state];
        }
    }
}

- (UIColor *)buttonsTitleColorForState:(UIControlState)state {
    return [_defaultBuilder titleColorForState:state];
}

// UISemanticContentAttribute was added in iOS SDK 9.0 but is available on devices running earlier
// version of iOS. We ignore the partial-availability warning that gets thrown on our use of this
// symbol.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
- (void)gtf_setSemanticContentAttribute:(UISemanticContentAttribute)semanticContentAttribute {
    [super gtf_setSemanticContentAttribute:semanticContentAttribute];
    [self reloadButtonViews];
}
#pragma clang diagnostic pop

- (void)setButtonTitleBaseline:(CGFloat)buttonTitleBaseline {
    _buttonTitleBaseline = buttonTitleBaseline;

    [self setNeedsLayout];
}

- (void)setInkColor:(UIColor *)inkColor {
    if (_inkColor == inkColor) {
        return;
    }
    _inkColor = inkColor;
    [self updateButtonsWithInkColor:_inkColor];
}

- (void)reloadButtonViews {
    // TODO(featherless): Recycle buttons.
    for (UIView *view in _buttonViews) {
        [view removeFromSuperview];
    }
    _buttonViews = [self viewsForItems:_items];

    [self setNeedsLayout];
}



@end
