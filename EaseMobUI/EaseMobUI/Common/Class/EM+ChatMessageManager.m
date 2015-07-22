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

- (BOOL)isIsPlaying{
    return [EMCDDeviceManager sharedInstance].isPlaying;
}

- (void)showBrowserWithImagesMessage:(NSArray *)imageMessageArray index:(NSInteger)index{
    _currentImageMessage = nil;
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
    _currentVideoMessage = nil;
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
    _currentVideoMessage = videoMessage;
}

- (void)playVoice:(NSArray *)voiceMessageArray index:(NSInteger)index{
    [self stopVoice];
    [_voiceArray addObjectsFromArray:voiceMessageArray];
    for (int i = 0; i < _voiceArray.count; i++) {
        EM_ChatMessageModel *messageModel = _voiceArray[i];
        messageModel.playing = NO;
    }
    _currentVoiceMessage = _voiceArray[index];
}

- (void)playNextVoice{
    
}

- (void)stopVoice{
    _currentVoiceMessage = nil;
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
    if (index < _photoArray.count) {
        _currentImageMessage = _photoArray[index];
    }
}
- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser{
    _currentImageMessage = nil;
    _currentVideoMessage = nil;
    
    [_photoArray removeAllObjects];
}

- (void)dealloc{
    _photoArray = nil;
    _currentImageMessage = nil;
    _currentVideoMessage = nil;
    _currentVoiceMessage = nil;
}

@end