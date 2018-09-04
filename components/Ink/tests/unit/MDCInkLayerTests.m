/*
 Copyright 2017-present the Material Components for iOS authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <XCTest/XCTest.h>

#import "GTCInkLayer.h"

#pragma mark - Fake classes

@interface CapturingGTCInkLayerSubclass : GTCInkLayer
@property(nonatomic, strong) NSMutableArray *addedAnimations;

@end

@implementation CapturingGTCInkLayerSubclass

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key {
  if (!self.addedAnimations) {
    self.addedAnimations = [NSMutableArray array];
  }
  [self.addedAnimations addObject:anim];
  [super addAnimation:anim forKey:key];
}

@end

@interface FakeGTCInkLayerAnimationDelegate : NSObject <GTCInkLayerDelegate, NSSecureCoding>
@property(nonatomic, strong) GTCInkLayer *inkLayer;
@end

@implementation FakeGTCInkLayerAnimationDelegate

+ (BOOL)supportsSecureCoding {
  return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    _inkLayer = [aDecoder decodeObjectOfClass:[GTCInkLayer class] forKey:@"inkLayer"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.inkLayer forKey:@"inkLayer"];
}

@end

#pragma mark - Tests

@interface GTCInkLayerTests : XCTestCase

@end

@implementation GTCInkLayerTests

- (void)testInit {
  // Given
  GTCInkLayer *inkLayer = [[GTCInkLayer alloc] init];

  // Then
  XCTAssertNil(inkLayer.delegate);
  XCTAssertFalse(inkLayer.isStartAnimationActive);
  XCTAssertEqualWithAccuracy(inkLayer.endAnimationDelay, 0, 0.0001);
  XCTAssertEqualWithAccuracy(inkLayer.initialRadius, 0, 0.0001);
  XCTAssertEqualWithAccuracy(inkLayer.finalRadius, 0, 0.0001);
  XCTAssertEqualWithAccuracy(inkLayer.maxRippleRadius, 0, 0.0001);
  XCTAssertEqualObjects(inkLayer.inkColor, [UIColor colorWithWhite:0 alpha:(CGFloat)0.08]);
}

- (void)testInitWithLayer {
  // Given
  FakeGTCInkLayerAnimationDelegate *delegate = [[FakeGTCInkLayerAnimationDelegate alloc] init];
  GTCInkLayer *inkLayer = [[GTCInkLayer alloc] init];
  delegate.inkLayer = inkLayer;
  inkLayer.delegate = delegate;
  inkLayer.endAnimationDelay = 1;
  inkLayer.initialRadius = 2;
  inkLayer.finalRadius = 3;
  inkLayer.maxRippleRadius = 4;
  inkLayer.inkColor = UIColor.magentaColor;

  // When
  GTCInkLayer *copiedLayer = [[GTCInkLayer alloc] initWithLayer:inkLayer];

  // Then
  XCTAssertNil(copiedLayer.delegate);
  XCTAssertEqualWithAccuracy(copiedLayer.endAnimationDelay, inkLayer.endAnimationDelay, 0.0001);
  XCTAssertEqualWithAccuracy(copiedLayer.initialRadius, inkLayer.initialRadius, 0.0001);
  XCTAssertEqualWithAccuracy(copiedLayer.finalRadius, inkLayer.finalRadius, 0.0001);
  XCTAssertEqualWithAccuracy(copiedLayer.maxRippleRadius, inkLayer.maxRippleRadius, 0.0001);
  XCTAssertEqualObjects(copiedLayer.inkColor, inkLayer.inkColor);
  XCTAssertEqual(copiedLayer.sublayers.count, inkLayer.sublayers.count);
}

- (void)testEncoding {
  // Given
  FakeGTCInkLayerAnimationDelegate *delegate = [[FakeGTCInkLayerAnimationDelegate alloc] init];
  GTCInkLayer *inkLayer = [[GTCInkLayer alloc] init];
  delegate.inkLayer = inkLayer;
  inkLayer.animationDelegate = delegate;
  inkLayer.endAnimationDelay = 1;
  inkLayer.initialRadius = 2;
  inkLayer.finalRadius = 3;
  inkLayer.maxRippleRadius = 4;
  inkLayer.inkColor = UIColor.magentaColor;

  // When
  NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:delegate];
  FakeGTCInkLayerAnimationDelegate *unarchivedDelegate =
      [NSKeyedUnarchiver unarchiveObjectWithData:archive];
  GTCInkLayer *unarchivedInkLayer = unarchivedDelegate.inkLayer;

  // Then
  XCTAssertEqual(unarchivedInkLayer.animationDelegate, unarchivedDelegate);
  XCTAssertEqualWithAccuracy(unarchivedInkLayer.endAnimationDelay,
                             inkLayer.endAnimationDelay,
                             0.0001);
  XCTAssertEqualWithAccuracy(unarchivedInkLayer.initialRadius, inkLayer.initialRadius, 0.0001);
  XCTAssertEqualWithAccuracy(unarchivedInkLayer.finalRadius, inkLayer.finalRadius, 0.0001);
  XCTAssertEqualWithAccuracy(unarchivedInkLayer.maxRippleRadius, inkLayer.maxRippleRadius, 0.0001);
  XCTAssertEqualObjects(unarchivedInkLayer.inkColor, inkLayer.inkColor);
  XCTAssertEqual(unarchivedInkLayer.sublayers.count, inkLayer.sublayers.count);
}

- (void)testEndAnimationTimingInTimeScaledLayer {
  // Given
  CapturingGTCInkLayerSubclass *inkLayer = [[CapturingGTCInkLayerSubclass alloc] init];
  inkLayer.bounds = CGRectMake(0, 0, 10, 10);
  inkLayer.speed = 0.5f;
  inkLayer.endAnimationDelay = (CGFloat)0.9;

  // When
  [inkLayer endAnimationAtPoint:CGPointMake(5, 5)];
  NSTimeInterval startTime = CACurrentMediaTime();

  // Then
  XCTAssertEqual(inkLayer.addedAnimations.count, 1U);
  CAAnimation *animation = inkLayer.addedAnimations.firstObject;
  if (animation) {
    startTime = [inkLayer convertTime:(startTime + 0.9) fromLayer:nil];
    XCTAssertEqualWithAccuracy(animation.beginTime, startTime, 0.010);
  }
}

- (void)testChangeAnimationTimingInTimeScaledLayer {
  // Given
  CapturingGTCInkLayerSubclass *inkLayer = [[CapturingGTCInkLayerSubclass alloc] init];
  inkLayer.bounds = CGRectMake(0, 0, 10, 10);
  inkLayer.speed = 0.5f;

  // When
  [inkLayer changeAnimationAtPoint:CGPointMake(5, 5)];
  NSTimeInterval startTime = CACurrentMediaTime();

  // Then
  XCTAssertEqual(inkLayer.addedAnimations.count, 1U);
  CAAnimation *animation = inkLayer.addedAnimations.firstObject;
  if (animation) {
    startTime = [inkLayer convertTime:startTime fromLayer:nil];
    XCTAssertEqualWithAccuracy(animation.beginTime, startTime, 0.1f);
  }
}

@end
