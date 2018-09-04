//
//  GTMAnimatableKeyPaths.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Availability.h>
#import <Foundation/Foundation.h>

// This macro is introduced in Xcode 9.
#ifndef CF_TYPED_ENUM // What follows is backwards compat for Xcode 8 and below.
#if __has_attribute(swift_wrapper)
#define CF_TYPED_ENUM __attribute__((swift_wrapper(enum)))
#else
#define CF_TYPED_ENUM
#endif
#endif

/**
 A representation of an animatable key path.

 This is NOT an exhaustive list of animatable properties; it only documents properties that are
 officially supported by the animator. If you animate unsupported properties then the resulting
 behavior is undefined.

 Each property documents whether or not it supports being animated additively. This affects the
 behavior of animations when a GTMMotionAnimator's additive property is enabled. Properties that
 support additive animations can change direction mid-way through the animation while appearing
 to preserve momentum. Properties that do not support additive animation will instantly start
 animating towards the new toValue.
 */
NS_SWIFT_NAME(AnimatableKeyPath)
typedef NSString * const GTMAnimatableKeyPath CF_TYPED_ENUM;

/**
 Anchor point.

 Equivalent UIView property: N/A
 Equivalent CALayer property: anchorPoint
 Expected value type: CGPoint or NSValue (containing a CGPoint).
 Additive animation supported: No.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathAnchorPoint NS_SWIFT_NAME(anchorPoint);

/**
 Background color.

 Equivalent UIView property: backgroundColor
 Equivalent CALayer property: backgroundColor
 Expected value type: UIColor or CGColor.
 Additive animation supported: No.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathBackgroundColor NS_SWIFT_NAME(backgroundColor);

/**
 Bounds.

 Equivalent UIView property: bounds
 Equivalent CALayer property: bounds
 Expected value type: CGRect or NSValue (containing a CGRect).
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathBounds NS_SWIFT_NAME(bounds);

/**
 Border width.

 Equivalent UIView property: N/A
 Equivalent CALayer property: borderWidth
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathBorderWidth NS_SWIFT_NAME(borderWidth);

/**
 Border color.

 Equivalent UIView property: N/A
 Equivalent CALayer property: borderColor
 Expected value type: UIColor or CGColor.
 Additive animation supported: No.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathBorderColor NS_SWIFT_NAME(borderColor);

/**
 Corner radius.

 Equivalent UIView property: N/A
 Equivalent CALayer property: cornerRadius
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathCornerRadius NS_SWIFT_NAME(cornerRadius);

/**
 Height.

 Equivalent UIView property: bounds.size.height
 Equivalent CALayer property: bounds.size.height
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathHeight NS_SWIFT_NAME(height);

/**
 Opacity.

 Equivalent UIView property: alpha
 Equivalent CALayer property: opacity
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 TODO( https://github.com/material-motion/motion-animator-objc/issues/61 ):
 Disable additive animations for opacity.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathOpacity NS_SWIFT_NAME(opacity);

/**
 Position.

 Equivalent UIView property: center if the layer's anchorPoint is 0.5, 0.5. N/A otherwise.
 Equivalent CALayer property: position
 Expected value type: CGPoint or NSValue (containing a CGPoint).
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathPosition NS_SWIFT_NAME(position);

/**
 Rotation.

 Equivalent UIView property: transform.rotation.z
 Equivalent CALayer property: transform.rotation.z
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathRotation NS_SWIFT_NAME(rotation);

/**
 Scale.

 Uniform scale along both the x and y axis.

 Equivalent UIView property: transform.scale
 Equivalent CALayer property: transform.scale
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathScale NS_SWIFT_NAME(scale);

/**
 Shadow color.

 Equivalent UIView property: N/A
 Equivalent CALayer property: shadowColor
 Expected value type: UIColor or CGColor.
 Additive animation supported: No.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathShadowColor NS_SWIFT_NAME(shadowColor);

/**
 Shadow offset.

 Equivalent UIView property: N/A
 Equivalent CALayer property: shadowOffset
 Expected value type: CGSize or NSValue (containing a CGSize).
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathShadowOffset NS_SWIFT_NAME(shadowOffset);

/**
 Shadow opacity.

 Equivalent UIView property: N/A
 Equivalent CALayer property: shadowOpacity
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathShadowOpacity NS_SWIFT_NAME(shadowOpacity);

/**
 Shadow radius.

 Equivalent UIView property: N/A
 Equivalent CALayer property: shadowRadius
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathShadowRadius NS_SWIFT_NAME(shadowRadius);

/**
 Stroke start.

 Equivalent UIView property: N/A
 Equivalent CALayer property: N/A
 Equivalent CAShapeLayer property: strokeStart
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathStrokeStart NS_SWIFT_NAME(strokeStart);

/**
 Stroke end.

 Equivalent UIView property: N/A
 Equivalent CALayer property: N/A
 Equivalent CAShapeLayer property: strokeEnd
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathStrokeEnd NS_SWIFT_NAME(strokeEnd);

/**
 Transform.

 Equivalent UIView property: transform (2d only)
 Equivalent CALayer property: transform (3d)
 Expected value type: CGAffineTransform, CATransform or NSValue with either transform type.
 CGAffineTransform value types will be converted to CATransform.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathTransform NS_SWIFT_NAME(transform);

/**
 Width.

 Equivalent UIView property: bounds.size.width
 Equivalent CALayer property: bounds.size.width
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathWidth NS_SWIFT_NAME(width);

/**
 X position.

 Equivalent UIView property: center.x if the layer's anchorPoint.x is 0.5. N/A otherwise.
 Equivalent CALayer property: position.x
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathX NS_SWIFT_NAME(x);

/**
 Y position.

 Equivalent UIView property: center.y if the layer's anchorPoint.y is 0.5. N/A otherwise.
 Equivalent CALayer property: position.y
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathY NS_SWIFT_NAME(y);

/**
 Z position.

 Equivalent UIView property: N/A
 Equivalent CALayer property: zPosition
 Expected value type: CGFloat or NSNumber.
 Additive animation supported: Yes.
 */
FOUNDATION_EXPORT GTMAnimatableKeyPath GTMKeyPathZ NS_SWIFT_NAME(z);
