//
//  ViewController.m
//  Happiness
//
//  Created by cipher on 15/10/7.
//  Copyright (c) 2015年 com.lab1411.cipher. All rights reserved.
//

#import "ViewController.h"
#import "FaceView.h"

//协议放这<FaceViewDataSource> 私有的
@interface ViewController () <FaceViewDataSource>
@property(nonatomic,weak) IBOutlet FaceView *faceView;
@end


@implementation ViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;

-(void)setHappiness:(int)happiness{
    _happiness=happiness;
    [self.faceView setNeedsDisplay];
}

-(void)setFaceView:(FaceView *)faceView{
    
    _faceView = faceView;
    //这里增加的target 一定是UIPinchGestureRecognizer，UIGestureRecognizer无法捕捉
    [self.faceView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceView action:@selector(pinch:)]];
    
    //控制笑脸
    [self.faceView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHappinessGesture:)]];
    
    self.faceView.dataSource = self;
}

-(void)handleHappinessGesture:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [gesture translationInView:self.faceView];
        self.happiness -= translation.y / 2;
        [gesture setTranslation:CGPointZero inView:self.faceView];
    }
}

-(float)smileForFaceView:(FaceView *)sender{
    
    return (self.happiness - 50) / 50.0;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return  YES;
}

@end
