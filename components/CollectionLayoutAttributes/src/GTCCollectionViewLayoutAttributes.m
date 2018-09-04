//
//  GTCCollectionViewLayoutAttributes.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/28.
//

#import "GTCCollectionViewLayoutAttributes.h"

@implementation GTCCollectionViewLayoutAttributes

- (id)copyWithZone:(NSZone *)zone {
    GTCCollectionViewLayoutAttributes *attributes =
    (GTCCollectionViewLayoutAttributes *)[super copyWithZone:zone];
    attributes->_editing = _editing;
    attributes->_shouldShowReorderStateMask = _shouldShowReorderStateMask;
    attributes->_shouldShowSelectorStateMask = _shouldShowSelectorStateMask;
    attributes->_shouldShowGridBackground = _shouldShowGridBackground;
    attributes->_sectionOrdinalPosition = _sectionOrdinalPosition;
    attributes->_backgroundImage = _backgroundImage;
    attributes->_backgroundImageViewInsets = _backgroundImageViewInsets;
    attributes->_isGridLayout = _isGridLayout;
    attributes->_separatorColor = _separatorColor;
    attributes->_separatorInset = _separatorInset;
    attributes->_separatorLineHeight = _separatorLineHeight;
    attributes->_shouldHideSeparators = _shouldHideSeparators;
    attributes->_willAnimateCellsOnAppearance = _willAnimateCellsOnAppearance;
    attributes->_animateCellsOnAppearanceDuration = _animateCellsOnAppearanceDuration;
    attributes->_animateCellsOnAppearanceDelay = _animateCellsOnAppearanceDelay;
    return attributes;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if (!object || ![[object class] isEqual:[self class]]) {
        return NO;
    }

    // Compare custom properties that affect layout.
    GTCCollectionViewLayoutAttributes *otherAttrs = (GTCCollectionViewLayoutAttributes *)object;
    BOOL backgroundImageIdentity = NO;
    if (self.backgroundImage && otherAttrs.backgroundImage) {
        backgroundImageIdentity = [self.backgroundImage isEqual:otherAttrs.backgroundImage];
    } else if (!self.backgroundImage && !otherAttrs.backgroundImage) {
        backgroundImageIdentity = YES;
    }

    BOOL separatorColorIdentity = NO;
    if (self.separatorColor && otherAttrs.separatorColor) {
        separatorColorIdentity = [self.separatorColor isEqual:otherAttrs.separatorColor];
    } else if (!self.separatorColor && !otherAttrs.separatorColor) {
        separatorColorIdentity = YES;
    }

    if ((otherAttrs.editing != self.editing) ||
        (otherAttrs.shouldShowReorderStateMask != self.shouldShowReorderStateMask) ||
        (otherAttrs.shouldShowSelectorStateMask != self.shouldShowSelectorStateMask) ||
        (otherAttrs.shouldShowGridBackground != self.shouldShowGridBackground) ||
        (otherAttrs.sectionOrdinalPosition != self.sectionOrdinalPosition) ||
        !backgroundImageIdentity ||
        (!UIEdgeInsetsEqualToEdgeInsets(otherAttrs.backgroundImageViewInsets,
                                        self.backgroundImageViewInsets)) ||
        (otherAttrs.isGridLayout != self.isGridLayout) || !separatorColorIdentity ||
        (!UIEdgeInsetsEqualToEdgeInsets(otherAttrs.separatorInset, self.separatorInset)) ||
        (otherAttrs.separatorLineHeight != self.separatorLineHeight) ||
        (otherAttrs.shouldHideSeparators != self.shouldHideSeparators) ||
        (!CGRectEqualToRect(otherAttrs.frame, self.frame))) {
        return NO;
    }

    return [super isEqual:object];
}

- (NSUInteger)hash {
    return (NSUInteger)self.editing ^ (NSUInteger)self.shouldShowReorderStateMask ^
    (NSUInteger)self.shouldShowSelectorStateMask ^ (NSUInteger)self.shouldShowGridBackground ^
    (NSUInteger)self.sectionOrdinalPosition ^ (NSUInteger)self.backgroundImage ^
    (NSUInteger)self.isGridLayout ^ (NSUInteger)self.separatorColor ^
    (NSUInteger)self.separatorLineHeight ^ (NSUInteger)self.shouldHideSeparators;
}

@end
