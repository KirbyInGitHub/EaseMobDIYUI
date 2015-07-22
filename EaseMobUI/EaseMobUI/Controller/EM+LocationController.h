//
//  EM+LocationController.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/20.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol EM_LocationControllerDelegate <NSObject>

-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address;
@end

@interface EM_LocationController : UIViewController

@property (nonatomic, assign) id<EM_LocationControllerDelegate> delegate;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate;

@end