//
//  FaceView.m
//  Happiness
//
//  Created by cipher on 15/10/7.
//  Copyright (c) 2015年 com.lab1411.cipher. All rights reserved.
//

#import "FaceView.h"

#define DEFAULT_SCALE 0.90

#define EYE_H 0.35
#define EYE_Y 0.35
#define EYE_RADIUS 0.10

#define MOUTH_H 0.45
#define MOUTH_Y 0.40
#define MOUTH_SMILE 0.25

@implementation FaceView

@synthesize dataSource=_dataSource;
@synthesize scale=_scale;

-(CGFloat)scale{
    if (!_scale) {
        return DEFAULT_SCALE;
    }else{
        return _scale;
    }
}

-(void)setScale:(CGFloat)scale{
    if (scale != _scale) {
      _scale=scale;
     [self setNeedsDisplay];
    }
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture{
    NSLog(@"dfsdf");
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

-(void) setup{
    
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib{
    [self setup];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
    }
    return self;
}

-(void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context{
    
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context,p.x,p.y, radius, 0, 2*M_PI, YES);
    
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}


-(void) drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //draw face circle
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size =self.bounds.size.width/2;
    if (self.bounds.size.height < self.bounds.size.width) {
        size = self.bounds.size.height/2;
    }
//    size *= DEFAULT_SCALE;
    NSLog(@"%f",self.scale);
    size *= self.scale;
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
   
    
    //draw eyes
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYE_H;
    eyePoint.y = midPoint.y - size * EYE_Y;
    [self drawCircleAtPoint:eyePoint withRadius:size*EYE_RADIUS inContext:context];
    eyePoint.x += size * EYE_H * 2;
    [self drawCircleAtPoint:eyePoint withRadius:size*EYE_RADIUS inContext:context ];
    
    //no nose
    //draw mouth
    CGPoint mouthStart;
    mouthStart.x = midPoint.x - MOUTH_H * size;
    mouthStart.y = midPoint.y + MOUTH_Y * size;
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * size * 2/3;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * size * 2/3;
    
//    float smile = 1;//this shoule be dlegated it's our view's data
    float smile = [self.dataSource smileForFaceView:self];
    if (smile < -1) {
        smile = -1;
    }
    if (smile > 1) {
        smile = 1;
    }
    
    CGFloat smileOffset = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);
    
}


@end
