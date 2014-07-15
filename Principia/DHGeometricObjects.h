//
//  DHGeometricObjects.h
//  Euclid
//
//  Created by David Hallgren on 2014-06-23.
//  Copyright (c) 2014 David Hallgren. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;
#import "DHGeometricTransform.h"

@protocol DHGeometricObject <NSObject>
- (void)drawInContext:(CGContextRef)context withTransform:(DHGeometricTransform*)transform;
@end


@interface DHGeometricObject : NSObject
@property (nonatomic) NSUInteger id;
@property (nonatomic) BOOL highlighted;
@end


@interface DHPoint : DHGeometricObject <DHGeometricObject>
@property (nonatomic, strong) NSString* label;
@property (nonatomic) CGPoint position;
- (instancetype) initWithPositionX:(CGFloat)x andY:(CGFloat)y;
@end


@interface DHLineObject : DHGeometricObject <DHGeometricObject>
@property (nonatomic, strong) DHPoint* start;
@property (nonatomic, strong) DHPoint* end;
@property (nonatomic, readonly) CGVector vector;
@property (nonatomic) CGFloat tMin;
@property (nonatomic) CGFloat tMax;
@end


@interface DHLineSegment : DHLineObject <DHGeometricObject>
@property (nonatomic, readonly) CGFloat length;
- (instancetype)initWithStart:(DHPoint*)start andEnd:(DHPoint*)end;
@end


@interface DHLine : DHLineObject <DHGeometricObject>
- (instancetype)initWithStart:(DHPoint*)start andEnd:(DHPoint*)end;
@end


@interface DHRay : DHLineObject <DHGeometricObject>
- (instancetype)initWithStart:(DHPoint*)start andEnd:(DHPoint*)end;
@end


@interface DHCircle : DHGeometricObject <DHGeometricObject>
@property (nonatomic, strong) DHPoint* center;
@property (nonatomic, strong) DHPoint* pointOnRadius;
@property (nonatomic, readonly) CGFloat radius;
- (instancetype)initWithCenter:(DHPoint*)center andPointOnRadius:(DHPoint*)pointOnRadius;
@end


@interface DHIntersectionPointCircleCircle : DHPoint
@property (nonatomic) DHCircle* c1;
@property (nonatomic) DHCircle* c2;
@property (nonatomic) BOOL onPositiveY;

- (CGPoint)position;
@end


@interface DHIntersectionPointLineLine : DHPoint
@property (nonatomic,strong) DHLineObject* l1;
@property (nonatomic,strong) DHLineObject* l2;

- (instancetype)initWithLine:(DHLineObject*)l1 andLine:(DHLineObject*)l2;
- (CGPoint)position;
@end


@interface DHIntersectionPointLineCircle : DHPoint
@property (nonatomic) DHLineObject* l;
@property (nonatomic) DHCircle* c;
@property (nonatomic) BOOL preferEnd;
- (CGPoint)position;
@end


@interface DHTranslatedPoint : DHPoint
@property (nonatomic, strong) DHPoint* startOfTranslation;
@property (nonatomic, strong) DHPoint* translationStart;
@property (nonatomic, strong) DHPoint* translationEnd;
@end


@interface DHMidPoint : DHPoint
- (instancetype)initWithPoint1:(DHPoint*)p1 andPoint2:(DHPoint*)p2;
@property (nonatomic) DHPoint* start;
@property (nonatomic) DHPoint* end;
- (CGPoint)position;
@end


@interface DHTrianglePoint : DHPoint
@property (nonatomic) DHPoint* start;
@property (nonatomic) DHPoint* end;
- (instancetype)initWithPoint1:(DHPoint*)p1 andPoint2:(DHPoint*)p2;
- (CGPoint)position;
@end


@interface DHPointOnLine : DHPoint
@property (nonatomic, strong) DHLineObject* line;
@property (nonatomic) CGFloat tValue; // Value between 0 and 1 indicating distance from start to end
- (CGPoint)position;
@end

@interface DHPointOnCircle : DHPoint
@property (nonatomic, strong) DHCircle* circle;
@property (nonatomic) CGFloat angle; // Angle of rotation from positive x-axis to point
- (CGPoint)position;
@end


@interface DHBisectLine : DHLineObject
@property (nonatomic, strong) DHLineObject* line1;
@property (nonatomic, strong) DHLineObject* line2;
@property (nonatomic) BOOL fixedDirection;
@end


@interface DHPerpendicularLine : DHLineObject
@property (nonatomic, strong) DHLineObject* line;
@property (nonatomic, strong) DHPoint* point;
@end

@interface DHParallelLine : DHLineObject
@property (nonatomic, strong) DHLineObject* line;
@property (nonatomic, strong) DHPoint* point;
@end





