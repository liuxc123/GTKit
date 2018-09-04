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

#import "MaterialInk.h"

#pragma mark - Fake classes

@interface FakeGTCInkViewAnimationDelegate : NSObject <GTCInkViewDelegate, NSCoding>
@property(nonatomic, strong) GTCInkView *inkView;
@end

@implementation FakeGTCInkViewAnimationDelegate

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
  [aCoder encodeObject:self.inkView forKey:@"inkView"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    _inkView = [aDecoder decodeObjectForKey:@"inkView"];
  }
  return self;
}

@end

#pragma mark - Tests

@interface GTCInkViewTests : XCTestCase

@end

@implementation GTCInkViewTests

- (void)testInit {
  // Given
  GTCInkView *inkView = [[GTCInkView alloc] init];

  // Then
  XCTAssertTrue(inkView.usesLegacyInkRipple);
  XCTAssertFalse(inkView.usesCustomInkCenter);
  XCTAssertTrue(CGPointEqualToPoint(inkView.customInkCenter, CGPointZero),
                @"%@ is not equal to %@",
                NSStringFromCGPoint(inkView.customInkCenter),
                NSStringFromCGPoint(CGPointZero));
  XCTAssertNil(inkView.animationDelegate);
  XCTAssertEqualObjects(inkView.inkColor, inkView.defaultInkColor);
  XCTAssertEqual(inkView.inkStyle, GTCInkStyleBounded);
  XCTAssertEqualWithAccuracy(inkView.maxRippleRadius, 0.0, 0.0001);
}

- (void)testNewInkUsesMaxRippleRadiusWhenUnbounded {
  // Given
  GTCInkView *inkViewStyleThenRadius = [[GTCInkView alloc] init];
  GTCInkView *inkViewRadiusThenStyle = [[GTCInkView alloc] init];
  inkViewStyleThenRadius.usesLegacyInkRipple = NO;
  inkViewRadiusThenStyle.usesLegacyInkRipple = NO;

  // When
  inkViewStyleThenRadius.inkStyle = GTCInkStyleUnbounded;
  inkViewStyleThenRadius.maxRippleRadius = 12;
  inkViewRadiusThenStyle.maxRippleRadius = 12;
  inkViewRadiusThenStyle.inkStyle = GTCInkStyleUnbounded;


  // Then
  XCTAssertEqualWithAccuracy(inkViewStyleThenRadius.maxRippleRadius, 12, 0.0001);
  XCTAssertEqualWithAccuracy(inkViewRadiusThenStyle.maxRippleRadius, 12, 0.0001);
}

- (void)testLegacyInkUsesMaxRippleRadiusWhenUnbounded {
  // Given
  GTCInkView *inkViewStyleThenRadius = [[GTCInkView alloc] init];
  GTCInkView *inkViewRadiusThenStyle = [[GTCInkView alloc] init];
  inkViewStyleThenRadius.usesLegacyInkRipple = YES;
  inkViewRadiusThenStyle.usesLegacyInkRipple = YES;

  // When
  inkViewStyleThenRadius.inkStyle = GTCInkStyleUnbounded;
  inkViewStyleThenRadius.maxRippleRadius = 12;
  inkViewRadiusThenStyle.maxRippleRadius = 12;
  inkViewRadiusThenStyle.inkStyle = GTCInkStyleUnbounded;


  // Then
  XCTAssertEqualWithAccuracy(inkViewStyleThenRadius.maxRippleRadius, 12, 0.0001);
  XCTAssertEqualWithAccuracy(inkViewRadiusThenStyle.maxRippleRadius, 12, 0.0001);
}

- (void)testNewInkIgnoresMaxRippleRadiusWhenBounded {
  // Given
  GTCInkView *inkViewStyleThenRadius = [[GTCInkView alloc] init];
  GTCInkView *inkViewRadiusThenStyle = [[GTCInkView alloc] init];
  inkViewStyleThenRadius.usesLegacyInkRipple = NO;
  inkViewRadiusThenStyle.usesLegacyInkRipple = NO;

  // When
  inkViewStyleThenRadius.inkStyle = GTCInkStyleBounded;
  inkViewStyleThenRadius.maxRippleRadius = 12;
  inkViewRadiusThenStyle.maxRippleRadius = 12;
  inkViewRadiusThenStyle.inkStyle = GTCInkStyleBounded;


  // Then
  XCTAssertEqualWithAccuracy(inkViewStyleThenRadius.maxRippleRadius, 0, 0.0001);
  XCTAssertEqualWithAccuracy(inkViewRadiusThenStyle.maxRippleRadius, 0, 0.0001);
}

- (void)testLegacyInkUsesMaxRippleRadiusWhenBounded {
  // Given
  GTCInkView *inkViewStyleThenRadius = [[GTCInkView alloc] init];
  GTCInkView *inkViewRadiusThenStyle = [[GTCInkView alloc] init];
  inkViewStyleThenRadius.usesLegacyInkRipple = YES;
  inkViewRadiusThenStyle.usesLegacyInkRipple = YES;

  // When
  inkViewStyleThenRadius.inkStyle = GTCInkStyleBounded;
  inkViewStyleThenRadius.maxRippleRadius = 12;
  inkViewRadiusThenStyle.maxRippleRadius = 12;
  inkViewRadiusThenStyle.inkStyle = GTCInkStyleBounded;


  // Then
  XCTAssertEqualWithAccuracy(inkViewStyleThenRadius.maxRippleRadius, 12, 0.0001);
  XCTAssertEqualWithAccuracy(inkViewRadiusThenStyle.maxRippleRadius, 12, 0.0001);
}

@end
