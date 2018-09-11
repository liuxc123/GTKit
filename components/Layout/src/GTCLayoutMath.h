//
//  GTCLayoutMath.h
//  GTCatalog
//
//  Created by liuxc on 2018/9/10.
//

#import <UIKit/UIKit.h>


extern BOOL _gtcCGFloatErrorEqual(CGFloat f1, CGFloat f2, CGFloat error);
extern BOOL _gtcCGFloatErrorNotEqual(CGFloat f1, CGFloat f2, CGFloat error);


extern BOOL _gtcCGFloatLess(CGFloat f1, CGFloat f2);
extern BOOL _gtcCGFloatGreat(CGFloat f1, CGFloat f2);
extern BOOL _gtcCGFloatEqual(CGFloat f1, CGFloat f2);
extern BOOL _gtcCGFloatNotEqual(CGFloat f1, CGFloat f2);
extern BOOL _gtcCGFloatLessOrEqual(CGFloat f1, CGFloat f2);
extern BOOL _gtcCGFloatGreatOrEqual(CGFloat f1, CGFloat f2);
extern BOOL _gtcCGSizeEqual(CGSize sz1, CGSize sz2);
extern BOOL _gtcCGPointEqual(CGPoint pt1, CGPoint pt2);
extern BOOL _gtcCGRectEqual(CGRect rect1, CGRect rect2);


extern CGFloat _gtcCGFloatRound(CGFloat f);
extern CGRect _gtcCGRectRound(CGRect rect);
extern CGSize _gtcCGSizeRound(CGSize size);
extern CGPoint _gtcCGPointRound(CGPoint point);
extern CGRect _gtcLayoutCGRectRound(CGRect rect);

extern CGFloat _gtcCGFloatMax(CGFloat a, CGFloat b);
extern CGFloat _gtcCGFloatMin(CGFloat a, CGFloat b);

//a*b + c
extern CGFloat _gtcCGFloatFma(CGFloat a, CGFloat b, CGFloat c);
