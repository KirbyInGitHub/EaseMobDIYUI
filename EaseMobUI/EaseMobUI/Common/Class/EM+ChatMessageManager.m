//
//  EM+ChatMessageRead.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/22.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageManager.h"
#import "MWPhotoBrowser.h"
#import "EM+ChatMessageModel.h"
#import "EMCDDeviceManager.h"

static EM_ChatMessageManager *detailInstance = nil;

@interface EM_ChatMessageManager()<MWPhotoBrowserDelegate>

@property (strong, nonatomic) UIWindow *keyWindow;
@property (nonatomic,strong) UINavigationController *photoNavigationController;
@property (nonatomic,strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic,strong) NSMutableArray *photoArray;

@property (nonatomic,strong) NSMutableArray *voiceArray;

@end

@implementation EM_ChatMessageManager{
    NSInteger playIndex;
}

+ (instancetype)defaultManager{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            detailInstance = [[self alloc] init];
        });
    }
    
    return detailInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _photoArray = [[NSMutableArray alloc]init];
        _voiceArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (UIWindow *)keyWindow{
    if(!_keyWindow){
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    return _keyWindow;
}

- (UINavigationController *)photoNavigationController{
    if (!_photoNavigationController) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

- (MWPhotoBrowser *)photoBrowser{
    if (!_photoBrowser) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    return _photoBrowser;
}

- (BOOL)isPlaying{
    return [EMCDDeviceManager sharedInstance].isPlaying;
}

- (void)showBrowserWithImagesMessage:(NSArray *)imageMessageArray index:(NSInteger)index{
    [_photoArray removeAllObjects];
    for (int i = 0; i < imageMessageArray.count; i++) {
        EM_ChatMessageModel *messageModel = imageMessageArray[i];
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageModel.messageBody;
        
        MWPhoto *photo;
        if (messageModel.sender) {
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:imageBody.localPath]];
        }else{
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:imageBody.remotePath]];
        }
        photo.caption = imageBody.displayName;
        [_photoArray addObject:photo];
    }
    [self.photoBrowser setCurrentPhotoIndex:index];
    UIViewController *rootController = [self.keyWindow rootViewController];
    [rootController presentViewController:self.photoNavigationController animated:YES completion:nil];
}

- (void)showBrowserWithVideoMessage:(EM_ChatMessageModel *)videoMessage{
    [_photoArray removeAllObjects];
    EMVideoMessageBody *videoBody = (EMVideoMessageBody *)videoMessage.messageBody;
    MWPhoto *video;
    if (videoMessage.sender) {
        video = [MWPhoto videoWithURL:[NSURL fileURLWithPath:videoBody.localPath]];
    }else{
        video = [MWPhoto videoWithURL:[NSURL URLWithString:videoBody.remotePath]];
    }
    video.caption = videoBody.displayName;
    [_photoArray addObject:video];
    UIViewController *rootController = [self.keyWindow rootViewController];
    [rootController presentViewController:self.photoNavigationController animated:YES completion:nil];
}

- (void)playVoice:(NSArray *)voiceMessageArray index:(NSInteger)index{
    if (index < 0 || index >= voiceMessageArray.count) {
        return;
    }
    [self stopVoice];
    [_voiceArray addObjectsFromArray:voiceMessageArray];
    playIndex = index;
    [self playNextVoice];
    if (_delegate) {
        [_delegate playStartWithMessage:_voiceArray[index]];
    }
}

- (void)playNextVoice{
    if (playIndex >= 0 && playIndex < _voiceArray.count) {
        for (int i = 0; i < _voiceArray.count; i++) {
            EM_ChatMessageModel *messageModel = _voiceArray[i];
            messageModel.messageData.checking = i == playIndex;
        }
        
        __block EM_ChatMessageModel *messageModel = _voiceArray[playIndex];
        EMVoiceMessageBody *messageBody = (EMVoiceMessageBody *)messageModel.messageBody;
        
        [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:messageBody.localPath completion:^(NSError *error) {
            
            messageModel.messageData.checking = NO;
            playIndex ++;
            EM_ChatMessageModel *nextMessageModel;
            
            if (playIndex < _voiceArray.count && _voiceArray.count > 1) {
                nextMessageModel = _voiceArray[playIndex];
                if (nextMessageModel.sender) {
                    playIndex ++;
                    if (playIndex < _voiceArray.count) {
                        nextMessageModel = _voiceArray[playIndex];
                    }else{
                        nextMessageModel = nil;
                    }
                }
                if (nextMessageModel && !nextMessageModel.messageData.details) {
                    [self playNextVoice];
                }
            }
            
            if(_delegate){
                [_delegate playCompletionWithMessage:messageModel nextMessage:nextMessageModel];
            }
        }];
    }
    
}

- (void)stopVoice{
    [_voiceArray removeAllObjects];
    if (self.isPlaying) {
        [[EMCDDeviceManager sharedInstance] stopPlaying];
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return _photoArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    return _photoArray[index];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
    
}

- (void)dealloc{
    _photoArray = nil;
}

@end