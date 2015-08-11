//
//  EM+ExplorerController.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/7.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EM_ExplorerControllerDelegate;

@interface EM_ExplorerController : UIViewController

@property (nonatomic, weak) id<EM_ExplorerControllerDelegate> delegate;

@end

@protocol EM_ExplorerControllerDelegate <NSObject>

@required
@optional

- (void)didFileSelected:(NSArray *)files;
- (void)didCancel;

@end