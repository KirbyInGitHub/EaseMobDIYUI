//
//  EM+LocationController.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/20.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EM_LocationControllerDelegate <NSObject>

-(void)sendLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address;

@end

@interface EM_LocationController : UIViewController

@property (nonatomic, assign) id<EM_LocationControllerDelegate> delegate;

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude;

@end