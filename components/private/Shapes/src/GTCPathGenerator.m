//
//  GTCPathGenerator.m
//  GTCatalog
//
//  Created by liuxc on 2018/8/17.
//

#import "GTCPathGenerator.h"

#import "GTMath.h"

@interface GTCPathCommand : NSObject
- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform;
@end

@interface GTCPathLineCommand : GTCPathCommand
@property(nonatomic, assign) CGPoint point;
@end

@interface GTCPathArcCommand : GTCPathCommand
@property(nonatomic, assign) CGPoint point;
@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, assign) CGFloat startAngle;
@property(nonatomic, assign) CGFloat endAngle;
@property(nonatomic, assign) BOOL clockwise;
@end

@interface GTCPathArcToCommand : GTCPathCommand
@property(nonatomic, assign) CGPoint start;
@property(nonatomic, assign) CGPoint end;
@property(nonatomic, assign) CGFloat radius;
@end

@interface GTCPathCurveCommand : GTCPathCommand
@property(nonatomic, assign) CGPoint control1;
@property(nonatomic, assign) CGPoint control2;
@property(nonatomic, assign) CGPoint end;
@end

@interface GTCPathQuadCurveCommand : GTCPathCommand
@property(nonatomic, assign) CGPoint control;
@property(nonatomic, assign) CGPoint end;
@end

@implementation GTCPathGenerator {
    NSMutableArray *_operations;
    CGPoint _startPoint;
    CGPoint _endPoint;
}

+ (nonnull instancetype)pathGenerator {
    return [[self alloc] initWithStartPoint:CGPointZero];
}

+ (instancetype)pathGeneratorWithStartPoint:(CGPoint)start {
    return [[self alloc] initWithStartPoint:start];
}

- (instancetype)initWithStartPoint:(CGPoint)start {
    if (self = [super init]) {
        _operations = [NSMutableArray array];

        _startPoint = start;
        _endPoint = start;
    }
    return self;
}

- (void)addLineToPoint:(CGPoint)point {
    GTCPathLineCommand *op = [[GTCPathLineCommand alloc] init];
    op.point = point;
    [_operations addObject:op];

    _endPoint = point;
}

- (void)addArcWithCenter:(CGPoint)center
                  radius:(CGFloat)radius
              startAngle:(CGFloat)startAngle
                endAngle:(CGFloat)endAngle
               clockwise:(BOOL)clockwise {
    GTCPathArcCommand *op = [[GTCPathArcCommand alloc] init];
    op.point = center;
    op.radius = radius;
    op.startAngle = startAngle;
    op.endAngle = endAngle;
    op.clockwise = clockwise;
    [_operations addObject:op];

    _endPoint = CGPointMake(center.x + radius * GTCCos(endAngle),
                            center.y + radius * GTCSin(endAngle));
}

- (void)addArcWithTangentPoint:(CGPoint)tangentPoint
                       toPoint:(CGPoint)toPoint
                        radius:(CGFloat)radius {
    GTCPathArcToCommand *op = [[GTCPathArcToCommand alloc] init];
    op.start = tangentPoint;
    op.end = toPoint;
    op.radius = radius;
    [_operations addObject:op];

    _endPoint = toPoint;
}

- (void)addCurveWithControlPoint1:(CGPoint)controlPoint1
                    controlPoint2:(CGPoint)controlPoint2
                          toPoint:(CGPoint)toPoint {
    GTCPathCurveCommand *op = [[GTCPathCurveCommand alloc] init];
    op.control1 = controlPoint1;
    op.control2 = controlPoint2;
    op.end = toPoint;
    [_operations addObject:op];

    _endPoint = toPoint;
}

- (void)addQuadCurveWithControlPoint:(CGPoint)controlPoint
                             toPoint:(CGPoint)toPoint {
    GTCPathQuadCurveCommand *op = [[GTCPathQuadCurveCommand alloc] init];
    op.control = controlPoint;
    op.end = toPoint;
    [_operations addObject:op];

    _endPoint = toPoint;
}

- (void)appendToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
    for (GTCPathCommand *op in _operations) {
        [op applyToCGPath:cgPath transform:transform];
    }
}

@end

@implementation GTCPathCommand

- (void)applyToCGPath:(CGMutablePathRef)__unused cgPath
            transform:(CGAffineTransform *)__unused transform {
    // no-op
}

@end

@implementation GTCPathLineCommand

- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
    CGPathAddLineToPoint(cgPath, transform, self.point.x, self.point.y);
}

@end

@implementation GTCPathArcCommand
- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
    CGPathAddArc(cgPath,
                 transform,
                 self.point.x,
                 self.point.y,
                 self.radius,
                 self.startAngle,
                 self.endAngle,
                 self.clockwise);
}
@end

@implementation GTCPathArcToCommand

- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
    CGPathAddArcToPoint(cgPath,
                        transform,
                        self.start.x,
                        self.start.y,
                        self.end.x,
                        self.end.y,
                        self.radius);
}

@end

@implementation GTCPathCurveCommand

- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
    CGPathAddCurveToPoint(cgPath,
                          transform,
                          self.control1.x,
                          self.control1.y,
                          self.control2.x,
                          self.control2.y,
                          self.end.x,
                          self.end.y);
}

@end

@implementation GTCPathQuadCurveCommand

- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
    CGPathAddQuadCurveToPoint(cgPath,
                              transform,
                              self.control.x,
                              self.control.y,
                              self.end.x,
                              self.end.y);
}

@end
