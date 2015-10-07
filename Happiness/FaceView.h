//
//  FaceView.h
//  Happiness
//
//  Created by cipher on 15/10/7.
//  Copyright (c) 2015年 com.lab1411.cipher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceView;
@protocol FaceViewDataSource

//这里的FaceView变量未定义，在下面菜才定义，用class解决，前向引用
-(float)smileForFaceView:(FaceView *)sender;

@end



@interface FaceView : UIView

@property (nonatomic) CGFloat scale;

//让该方法成为public
-(void)pinch:(UIPinchGestureRecognizer *)gesture;

//协议
@property (nonatomic,weak) IBOutlet id<FaceViewDataSource> dataSource;

@end
