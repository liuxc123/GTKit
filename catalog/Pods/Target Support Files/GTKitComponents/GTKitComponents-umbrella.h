#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GTCShadowElevations.h"
#import "GTShadowElevations.h"
#import "GTCShadowLayer.h"
#import "GTShadowLayer.h"
#import "GTCFontTextStyle.h"
#import "GTCTypography.h"
#import "GTTypography.h"
#import "UIFont+GTCSimpleEquality.h"
#import "UIFont+GTCTypography.h"
#import "UIFontDescriptor+GTCTypography.h"
#import "GTApplication.h"
#import "UIApplication+AppExtensions.h"
#import "GTCKeyboardWatcher.h"
#import "GTKeyboardWatcher.h"
#import "GTCMath.h"
#import "GTMath.h"
#import "GTCOverlayImplementor.h"
#import "GTCOverlayObserver.h"
#import "GTCOverlayTransitioning.h"
#import "GTOverlay.h"
#import "GTCCurvedCornerTreatment.h"
#import "GTCCurvedRectShapeGenerator.h"
#import "GTCCutCornerTreatment.h"
#import "GTCPillShapeGenerator.h"
#import "GTCRoundedCornerTreatment.h"
#import "GTCSlantedRectShapeGenerator.h"
#import "GTCTriangleEdgeTreatment.h"
#import "GTShapeLibrary.h"
#import "GTCCornerTreatment.h"
#import "GTCEdgeTreatment.h"
#import "GTCPathGenerator.h"
#import "GTCRectangleShapeGenerator.h"
#import "GTCShapedShadowLayer.h"
#import "GTCShapedView.h"
#import "GTCShapeGenerating.h"
#import "GTShapes.h"
#import "GTCLayoutMetrics.h"
#import "GTUIMetrics.h"

FOUNDATION_EXPORT double GTKitComponentsVersionNumber;
FOUNDATION_EXPORT const unsigned char GTKitComponentsVersionString[];

