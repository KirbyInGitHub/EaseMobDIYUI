//
//  EM+CallController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/14.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+CallController.h"
#import "EaseMobUIClient.h"
#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+ChatMessageExtend.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <EaseMobSDKFull/EaseMob.h>
#import <FXBlurView/FXBlurView.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <AVFoundation/AVFoundation.h>

#define TimeInterval (1)

@interface EM_CallController ()<AVCaptureVideoDataOutputSampleBufferDelegate,EMCallManagerDelegate>

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) FXBlurView *blurView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *contentLabel;//昵称,时间,状态,原因
@property (nonatomic, strong) UIButton *interruptButton;//挂断
@property (nonatomic, strong) UIButton *rejectButton;//拒绝
@property (nonatomic, strong) UIButton *agreeButton;//同意
@property (nonatomic, strong) UIButton *silenceButton;//静音
@property (nonatomic, strong) UIButton *expandButton;//免提

@property (nonatomic, strong) OpenGLView20 *oppositeView;//对方的画面
@property (nonatomic, strong) UIView *hereView;//自己的画面
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *captureInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *captureOutput;

@property (nonatomic, strong) EM_ChatBuddy *buddy;

@end

@implementation EM_CallController{
    NSTimer *_timer;
    int _duration;
    BOOL _interrupt;
    BOOL _reject;
    BOOL _agree;
    BOOL _hangup;
    EMCallStatusChangedReason _reason;
    AVAudioPlayer *_ringPlayer;
    UInt8 *_imageDataBuffer;
    
    BOOL showControl;
}

- (instancetype)initWithSession:(EMCallSession *)session type:(EMChatCallType)type action:(EMChatCallAction)action{
    self = [super init];
    if (self) {
        _callSession = session;
        _callType = type;
        _callAction = action;
        
        id<EM_ChatOppositeDelegate> userDelegate = [EaseMobUIClient sharedInstance].oppositeDelegate;
        if (userDelegate && [userDelegate respondsToSelector:@selector(buddyInfoWithChatter:)]) {
            _buddy = [userDelegate buddyInfoWithChatter:_callSession.sessionChatter];
        }else{
            _buddy = [[EM_ChatBuddy alloc]init];
            _buddy.uid = _callSession.sessionChatter;
            _buddy.displayName = _callSession.sessionChatter;
            
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *callType;
    if (_callType == EMChatCallTypeVoice) {
        callType = kEMCallTypeVoice;
    }else{
        callType = kEMCallTypeVideo;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationCallShow object:nil userInfo:@{kEMCallChatter:self.callSession.sessionChatter,kEMCallType:callType}];
    
    _backgroundView = [[UIImageView alloc]initWithFrame:self.view.frame];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backgroundView];
    [FXBlurView setBlurEnabled:YES];
    _blurView = [[FXBlurView alloc]init];
    _blurView.backgroundColor = [UIColor whiteColor];
    _blurView.frame = self.view.frame;
    [self.view addSubview:_blurView];
    
    if (self.callType == EMChatCallTypeVideo) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        _oppositeView = [[OpenGLView20 alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _oppositeView.backgroundColor = [UIColor clearColor];
        _oppositeView.sessionPreset = AVCaptureSessionPreset640x480;
        [self.view addSubview:_oppositeView];
        
        CGFloat width = 80;
        CGFloat height = _oppositeView.frame.size.height / _oppositeView.frame.size.width * width;
        
        _hereView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - width,
                                                             self.view.frame.size.height - height, width, height)];
        _hereView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_hereView];
        
        //创建会话层
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:_oppositeView.sessionPreset];
        
        AVCaptureDevice *device;
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *tmp in devices){
            if (tmp.position == AVCaptureDevicePositionFront){
                device = tmp;
                break;
            }
        }
        
        NSError *error = nil;
        _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        [_session beginConfiguration];
        if(!error){
            [_session addInput:_captureInput];
        }else{
            NSLog(@"无法开启摄像头");
        }
        
        dispatch_queue_t outQueue = dispatch_queue_create("com.zhou.em", NULL);
        _captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        _captureOutput.videoSettings = _oppositeView.outputSettings;
        _captureOutput.minFrameDuration = CMTimeMake(1, 15);
        _captureOutput.alwaysDiscardsLateVideoFrames = YES;
        [_captureOutput setSampleBufferDelegate:self queue:outQueue];
        [_session addOutput:_captureOutput];
        [_session commitConfiguration];
        
        //6.小窗口显示层
        AVCaptureVideoPreviewLayer *hereCaptureLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        hereCaptureLayer.frame = CGRectMake(0, 0, width, height);
        hereCaptureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_hereView.layer addSublayer:hereCaptureLayer];
        
        [_session startRunning];
        _callSession.displayView = _oppositeView;
    }
    
    
    _avatarImageView = [[UIImageView alloc]init];
    _avatarImageView.backgroundColor = [UIColor greenColor];
    _avatarImageView.bounds = CGRectMake(0, 0, 80, 80);
    _avatarImageView.center = CGPointMake(self.view.frame.size.width / 2, 100);
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width / 2;
    _avatarImageView.image = [EM_ChatResourcesUtils defaultAvatarImage];
    [self.view addSubview:_avatarImageView];
    if (_buddy.avatar) {
        [_avatarImageView sd_setImageWithURL:_buddy.avatar];
    }
    _backgroundView.image = _avatarImageView.image;
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.bounds = CGRectMake(0, 0, self.view.frame.size.width, 150);
    _contentLabel.center = CGPointMake(self.view.frame.size.width / 2,_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10 + _contentLabel.frame.size.height / 2);
    [self.view addSubview:_contentLabel];
    
    _interruptButton = [[UIButton alloc]init];
    _interruptButton.backgroundColor = [UIColor redColor];
    _interruptButton.bounds = CGRectMake(0, 0, 60, 60);
    _interruptButton.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 100);
    _interruptButton.layer.masksToBounds = YES;
    _interruptButton.layer.cornerRadius = _interruptButton.frame.size.width / 2;
    _interruptButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:16];
    [_interruptButton setTitle:kEMChatIconCallHangup forState:UIControlStateNormal];
    [_interruptButton addTarget:self action:@selector(interruptCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_interruptButton];
    
    _rejectButton = [[UIButton alloc]init];
    _rejectButton.backgroundColor = [UIColor redColor];
    _rejectButton.bounds = CGRectMake(0, 0, 60, 60);
    _rejectButton.center = CGPointMake(_interruptButton.center.x - _interruptButton.frame.size.width / 2 - _rejectButton.frame.size.width / 2, _interruptButton.center.y);
    _rejectButton.layer.masksToBounds = YES;
    _rejectButton.layer.cornerRadius = _rejectButton.frame.size.width / 2;
    _rejectButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:16];
    [_rejectButton setTitle:kEMChatIconCallHangup forState:UIControlStateNormal];
    [_rejectButton addTarget:self action:@selector(rejectCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rejectButton];
    
    _agreeButton = [[UIButton alloc]init];
    _agreeButton.backgroundColor = [UIColor greenColor];
    _agreeButton.bounds = CGRectMake(0, 0, 60, 60);
    _agreeButton.center = CGPointMake(_interruptButton.center.x + _interruptButton.frame.size.width / 2 + _agreeButton.frame.size.width / 2, _interruptButton.center.y);
    _agreeButton.layer.masksToBounds = YES;
    _agreeButton.layer.cornerRadius = _agreeButton.frame.size.width / 2;
    _agreeButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:16];
    [_agreeButton setTitle:kEMChatIconCallConnect forState:UIControlStateNormal];
    [_agreeButton addTarget:self action:@selector(agreeCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_agreeButton];
    
    _silenceButton = [[UIButton alloc]init];
    _silenceButton.backgroundColor = [UIColor greenColor];
    _silenceButton.bounds = CGRectMake(0, 0, 40, 40);
    _silenceButton.center = CGPointMake(_agreeButton.center.x + _agreeButton.frame.size.width, _agreeButton.center.y);
    _silenceButton.layer.masksToBounds = YES;
    _silenceButton.layer.cornerRadius = _silenceButton.bounds.size.width / 2;
    _silenceButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:12];
    [_silenceButton setTitle:kEMChatIconCallSilence forState:UIControlStateNormal];
    [_silenceButton addTarget:self action:@selector(silenceCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_silenceButton];
    
    _expandButton = [[UIButton alloc]init];
    _expandButton.backgroundColor = [UIColor greenColor];
    _expandButton.bounds = CGRectMake(0, 0, 40, 40);
    _expandButton.center = CGPointMake(_rejectButton.center.x - _rejectButton.frame.size.width, _agreeButton.center.y);
    _expandButton.layer.masksToBounds = YES;
    _expandButton.layer.cornerRadius = _expandButton.bounds.size.width / 2;
    _expandButton.titleLabel.font = [EM_ChatResourcesUtils iconFontWithSize:12];
    [_expandButton setTitle:kEMChatIconCallExpand forState:UIControlStateNormal];
    [_expandButton addTarget:self action:@selector(expandCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_expandButton];
    
    [self setCallState:EMChatCallStateWait];
    
    [[EaseMob sharedInstance].callManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    
    [[CTCallCenter alloc] init].callEventHandler = ^(CTCall* call){
        if([call.callState isEqualToString:CTCallStateIncoming]){
            //来电话了
            _hangup = YES;
            _interrupt = YES;
            [[EaseMob sharedInstance].callManager asyncEndCall:self.callSession.sessionId reason:eCallReason_Hangup];
        }
    };
    
    showControl = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)dealloc{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self timerInvalidate];
    if (_ringPlayer) {
        [_ringPlayer stop];
    }
    _ringPlayer = nil;
    if (_session) {
        [_session stopRunning];
    }
    _session = nil;
    
    _oppositeView = nil;
    _hereView = nil;
    
    [[EaseMob sharedInstance].callManager removeDelegate:self];
    NSString *callType;
    if (_callType == EMChatCallTypeVoice) {
        callType = kEMCallTypeVoice;
    }else{
        callType = kEMCallTypeVideo;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationCallDismiss object:nil userInfo:@{kEMCallChatter:self.callSession.sessionChatter,kEMCallType:callType}];
}

#pragma mark - private
- (void)viewTap:(id)sender{
    if (self.callType == EMChatCallTypeVideo && self.callState == EMChatCallStateIn) {
        if (showControl) {
            _avatarImageView.hidden = YES;
            _interruptButton.hidden = YES;
            _silenceButton.hidden = YES;
            _expandButton.hidden = YES;
        }else{
            _avatarImageView.hidden = NO;
            _interruptButton.hidden = NO;
            _silenceButton.hidden = NO;
            _expandButton.hidden = NO;
        }
        showControl = !showControl;
    }
}

- (void)setCallState:(EMChatCallState)callState{
    switch (callState) {
        case EMChatCallStateWait:{
            if (self.callAction == EMChatCallActionIn) {
                _contentLabel.text = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.in"],_buddy.displayName];
                _interruptButton.hidden = YES;
                _rejectButton.hidden = NO;
                _agreeButton.hidden = NO;
                NSError *error;
                NSString *ringPath = [[NSBundle mainBundle] pathForResource:@"callRing" ofType:@"mp3" inDirectory:@"EM_Resource.bundle/media"];
                _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:ringPath] error:&error];
                if (_ringPlayer && !error) {
                    _ringPlayer.volume = 0.8;
                    _ringPlayer.numberOfLoops = -1;
                    if([_ringPlayer prepareToPlay]){
                        [_ringPlayer play];
                    }
                }
            }else{
                _contentLabel.text = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.out"],_buddy.displayName];
                _interruptButton.hidden = NO;
                _rejectButton.hidden = YES;
                _agreeButton.hidden = YES;
            }
            [_contentLabel sizeToFit];
            _contentLabel.center = CGPointMake(self.view.frame.size.width / 2,_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10 + _contentLabel.frame.size.height / 2);
            _silenceButton.hidden = YES;
            _expandButton.hidden = YES;
        }
            break;
        case EMChatCallStateIn:{
            if (_callState == EMChatCallStateWait) {
                _contentLabel.text = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.ongoing"],_buddy.displayName,[self stringWithTime]];
                [_contentLabel sizeToFit];
                _contentLabel.center = CGPointMake(self.view.frame.size.width / 2,_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10 + _contentLabel.frame.size.height / 2);
                _interruptButton.hidden = NO;
                _rejectButton.hidden = YES;
                _agreeButton.hidden = YES;
                _silenceButton.hidden = NO;
                _expandButton.hidden = NO;
                
                if (_ringPlayer) {
                    [_ringPlayer stop];
                }
                _ringPlayer = nil;
            }
        }
            break;
        case EMChatCallStatePause:{
            
        }
            break;
        case EMChatCallStateEnd:{
            NSString *content;
            NSString *hintMessage;
            //接入
            if (_callAction == EMChatCallActionIn) {
                if (_callState == EMChatCallStateWait) {
                    if (_reject) {
                        //等待中拒绝
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.interrupt"],_buddy.displayName];
                        hintMessage = [EM_ChatResourcesUtils stringWithName:@"call.message.hint.reject"];
                    }else{
                        if (_reason == eCallReason_NoResponse) {
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.no_answer"],_buddy.displayName];
                            hintMessage = [EM_ChatResourcesUtils stringWithName:@"call.message.hint.no_response"];
                        }else{
                            //等待中对方挂断
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.hangup"],_buddy.displayName];
                            hintMessage = [EM_ChatResourcesUtils stringWithName:@"call.message.hint.opposite_cancel"];
                        }
                    }
                }else{
                    if (_interrupt) {
                        //通话中挂断
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.end"],_buddy.displayName,[self stringWithTime]];
                    }else{
                        //通话中对方挂断
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.end"],_buddy.displayName,[self stringWithTime]];
                    }
                    hintMessage = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.message.hint.end"],[self stringWithTime]];
                }
                
            }else{
                if (_callState == EMChatCallStateWait) {
                    if (_interrupt) {
                        //等待中挂断
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.interrupt"],_buddy.displayName];
                        hintMessage = [EM_ChatResourcesUtils stringWithName:@"call.message.hint.own_cancel"];
                    }else{
                        if (_reason == eCallReason_Offline) {
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.offline"],_buddy.displayName];
                        }else if(_reason == eCallReason_NoResponse || _reason == eCallReason_Null){
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.no_response"],_buddy.displayName];
                        }else if(_reason == eCallReason_Busy){
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.busy"],_buddy.displayName];
                        }else{
                            //等待中对方拒绝
                            content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.reject"],_buddy.displayName];
                        }
                        hintMessage = [EM_ChatResourcesUtils stringWithName:@"call.message.hint.opposite_no_response"];
                    }
                }else{
                    if (_interrupt) {
                        //通话中挂断
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.end"],_buddy.displayName,[self stringWithTime]];
                    }else{
                        //通话中对方挂断
                        content = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.end"],_buddy.displayName,[self stringWithTime]];
                    }
                    hintMessage = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.message.hint.end"],[self stringWithTime]];
                }
            }
            
            _contentLabel.text = content;
            
            [_contentLabel sizeToFit];
            _contentLabel.center = CGPointMake(self.view.frame.size.width / 2,_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10 + _contentLabel.frame.size.height / 2);
            _interruptButton.hidden = YES;
            _rejectButton.hidden = YES;
            _agreeButton.hidden = YES;
            _silenceButton.hidden = YES;
            _expandButton.hidden = YES;
            
            if (_ringPlayer) {
                [_ringPlayer stop];
            }
            _ringPlayer = nil;
            
            BACK(^{
            
                EM_ChatMessageExtend *extend = [[EM_ChatMessageExtend alloc]init];
                extend.isCallMessage = YES;
                
                EMChatText *chatText = [[EMChatText alloc] initWithText:hintMessage];
                EMTextMessageBody *textBody = [[EMTextMessageBody alloc] initWithChatObject:chatText];
                EMMessage *message = [[EMMessage alloc] initWithReceiver:_callSession.sessionChatter bodies:@[textBody]];
                message.isRead = YES;
                message.deliveryState = eMessageDeliveryState_Delivered;
                message.ext = [extend toDictionary];
                
                [[EaseMob sharedInstance].chatManager insertMessagesToDB:@[message] forChatter:_callSession.sessionChatter append2Chat:YES];
                sleep(3);
                MAIN(^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            });
        }
            break;
    }
    _callState = callState;
}

- (NSString *)stringWithTime{
    int h = _duration / 3600;
    int m = (_duration - h * 3600) / 60;
    int s = _duration - h * 3600 - m * 60;
    
    NSMutableString *timeStr = [[NSMutableString alloc]init];
    if (h > 0) {
        [timeStr appendFormat:@"%i:",h];
    }
    if (m >= 10) {
        [timeStr appendFormat:@"%i:",m];
    }else{
        [timeStr appendFormat:@"0%i:",m];
    }
    if (s >= 10) {
        [timeStr appendFormat:@"%i",s];
    }else{
        [timeStr appendFormat:@"0%i",s];
    }
    
    return timeStr;
}

- (void)timerInit{
    [self timerInvalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)timerInvalidate{
    if (_timer) {
        [_timer invalidate];
    }
    _timer = nil;
}

- (void)timerAction:(id)sender{
    _duration += 1;
    _contentLabel.text = [NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"call.ongoing"],_buddy.displayName,[self stringWithTime]];
    [_contentLabel sizeToFit];
    _contentLabel.center = CGPointMake(self.view.frame.size.width / 2,_avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 10 + _contentLabel.frame.size.height / 2);
    
    if (self.callAction == EMChatCallTypeVideo) {
        _avatarImageView.hidden = YES;
        _interruptButton.hidden = YES;
        _silenceButton.hidden = YES;
        _expandButton.hidden = YES;
    }
}

/**
 *  挂断
 *
 *  @param sender
 */
- (void)interruptCall:(id)sender{
    _interrupt = YES;
    _hangup = YES;
    [[EaseMob sharedInstance].callManager asyncEndCall:self.callSession.sessionId reason:eCallReason_Hangup];
}

/**
 *  拒绝
 *
 *  @param sender
 */
- (void)rejectCall:(id)sender{
    if (_callState != EMChatCallStateWait) {
        return;
    }
    _reject = YES;
    _hangup = YES;
    [[EaseMob sharedInstance].callManager asyncEndCall:self.callSession.sessionId reason:eCallReason_Reject];
}

/**
 *  同意
 *
 *  @param sender
 */
- (void)agreeCall:(id)sender{
    if (_callState != EMChatCallStateWait) {
        return;
    }
    _agree = YES;
    [[EaseMob sharedInstance].callManager asyncAnswerCall:self.callSession.sessionId];
}

/**
 *  静音
 *
 *  @param sender
 */
- (void)silenceCall:(UIButton *)sender{
    sender.selected = !sender.selected;
    [[EaseMob sharedInstance].callManager markCallSession:self.callSession.sessionId asSilence:sender.selected];
}

/**
 *  免提
 *
 *  @param sender
 */
- (void)expandCall:(UIButton *)sender{
    sender.selected = !sender.selected;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (sender.selected) {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }else {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
    [audioSession setActive:YES error:nil];
}

#pragma mark - EMCallManagerDelegate
- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error{
    if (![callSession.sessionId isEqualToString:self.callSession.sessionId]) {
        [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReason_Busy];
        return;
    }
    if (callSession.status == eCallSessionStatusAccepted){
        [self timerInit];
        [self setCallState:EMChatCallStateIn];
    }else if (callSession.status == eCallSessionStatusDisconnected){
        _reason = reason;
        [self timerInvalidate];
        [self setCallState:EMChatCallStateEnd];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (_callSession.status != eCallSessionStatusAccepted) {
        return;
    }
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess){
        //UInt8 *bufferbasePtr = (UInt8 *)CVPixelBufferGetBaseAddress(imageBuffer);
        UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
        UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 1);
        
        //        size_t buffeSize = CVPixelBufferGetDataSize(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        //        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t bytesrow0 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
        size_t bytesrow1  = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 1);
        //        size_t bytesrow2 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 2);
        //        printf("buffeSize:%d,width:%d,height:%d,bytesPerRow:%d,bytesrow0 :%d,bytesrow1 :%d,bytesrow2 :%d\n",buffeSize,width,height,bytesPerRow,bytesrow0,bytesrow1,bytesrow2);
        
        if (_imageDataBuffer == nil) {
            _imageDataBuffer = (UInt8 *)malloc(width * height * 3 / 2);
        }
        UInt8 *pY = bufferPtr;
        UInt8 *pUV = bufferPtr1;
        UInt8 *pU = _imageDataBuffer + width * height;
        UInt8 *pV = pU + width * height / 4;
        for(int i =0; i < height; i++){
            memcpy(_imageDataBuffer + i * width, pY + i * bytesrow0, width);
        }
        
        for(int j = 0; j < height / 2; j++){
            for(int i = 0; i < width / 2; i++){
                *(pU++) = pUV[i<<1];
                *(pV++) = pUV[(i<<1) + 1];
            }
            pUV += bytesrow1;
        }
        
        YUV420spRotate90(bufferPtr, _imageDataBuffer, width, height);
        [[EaseMob sharedInstance].callManager processPreviewData:(char *)bufferPtr width:width height:height];
        
        /*We unlock the buffer*/
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
}

void YUV420spRotate90(UInt8 *  dst, UInt8* src, size_t srcWidth, size_t srcHeight){
    size_t wh = srcWidth * srcHeight;
    size_t uvHeight = srcHeight >> 1;//uvHeight = height / 2
    size_t uvWidth = srcWidth >> 1;
    size_t uvwh = wh >> 2;
    //旋转Y
    int k = 0;
    for(int i = 0; i < srcWidth; i++) {
        int nPos = wh - srcWidth;
        for(int j = 0; j < srcHeight; j++) {
            dst[k] = src[nPos + i];
            k++;
            nPos -= srcWidth;
        }
    }
    for(int i = 0; i < uvWidth; i++) {
        int nPos = wh+uvwh-uvWidth;
        for(int j = 0; j < uvHeight; j++) {
            dst[k] = src[nPos + i];
            dst[k+uvwh] = src[nPos + i+uvwh];
            k++;
            nPos -= uvWidth;
        }
    }
}

@end