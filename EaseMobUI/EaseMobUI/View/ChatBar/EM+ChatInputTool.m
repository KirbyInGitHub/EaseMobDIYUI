//
//  EM+MessageInputTool.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatInputTool.h"
#import "EM+Common.h"
#import "EM+ChatInputView.h"

#define PADDING (5)

@interface EM_ChatInputTool()<UITextViewDelegate>

@property (nonatomic,strong) EM_ChatUIConfig *config;

@end

@implementation EM_ChatInputTool{
    EM_ChatInputView *inputView;
    UIButton *recordButton;
    UIButton *emojiButton;
    UIButton *actionButton;
    UIButton *moreStateButton;
    CGSize oldContentSize;
    UIEdgeInsets contentInsets;
}

- (instancetype)initWithConfig:(EM_ChatUIConfig *)config{
    self = [super init];
    if (self) {
        
        _config = config;
        oldContentSize = CGSizeZero;
        
        //录音按钮
        recordButton = [[UIButton alloc]init];
        recordButton.layer.masksToBounds = YES;
        recordButton.hidden = _config.hiddenOfRecord;
        recordButton.contentEdgeInsets = UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING);
        [recordButton addTarget:self action:@selector(recordClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:recordButton];
        NSDictionary *recordDictionary = _config.toolDictionary[kButtonNameRecord];
        if (recordDictionary) {
            UIFont *font = recordDictionary[kAttributeFont];
            if (font) {
                recordButton.titleLabel.font = font;
            }
            
            UIImage *normalImage = recordDictionary[kAttributeNormalImage];
            if (normalImage) {
                [recordButton setImage:normalImage forState:UIControlStateNormal];
            }else{
                [recordButton setImage:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_record")] forState:UIControlStateNormal];
            }
            
            UIImage *highlightImage = recordDictionary[kAttributeHighlightImage];
            if (highlightImage) {
                [recordButton setImage:highlightImage forState:UIControlStateHighlighted];
            }
            
            if (!normalImage && !highlightImage) {
                NSString *text = recordDictionary[kAttributeText];
                [recordButton setTitle:text forState:UIControlStateNormal];
                [recordButton setTitleColor:[UIColor colorWithHEX:TEXT_NORMAL_COLOR alpha:1.0] forState:UIControlStateNormal];
                [recordButton setTitleColor:[UIColor colorWithHEX:TEXT_SELECT_COLOR alpha:1.0] forState:UIControlStateHighlighted];
            }
            
            UIColor *backgroundColor = recordDictionary[kAttributeBackgroundColor];
            if (backgroundColor) {
                recordButton.backgroundColor = backgroundColor;
            }
            
            UIColor *borderColor = recordDictionary[kAttributeBorderColor];
            if (borderColor) {
                recordButton.layer.borderColor = borderColor.CGColor;
            }
            
            id borderWidth = recordDictionary[kAttributeBorderWidth];
            if (borderWidth) {
                recordButton.layer.borderWidth = [borderWidth floatValue];
            }
            
            id cornerRadius = recordDictionary[kAttributeCornerRadius];
            if (cornerRadius) {
                recordButton.layer.cornerRadius = [cornerRadius floatValue];
            }
        }
        
        //表情按钮
        emojiButton = [[UIButton alloc]init];
        emojiButton.layer.masksToBounds = YES;
        emojiButton.hidden = _config.hiddenOfEmoji;
        emojiButton.contentEdgeInsets = UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING);
        [emojiButton addTarget:self action:@selector(emojiClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:emojiButton];
        NSDictionary *emojiDictionary = _config.toolDictionary[kButtonNameEmoji];
        if (emojiDictionary) {
            
            UIFont *font = emojiDictionary[kAttributeFont];
            if (font) {
                emojiButton.titleLabel.font = font;
            }
            
            UIImage *normalImage = emojiDictionary[kAttributeNormalImage];
            if (normalImage) {
                [emojiButton setImage:normalImage forState:UIControlStateNormal];
            }else{
                [emojiButton setImage:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_emoji")] forState:UIControlStateNormal];
            }
            
            UIImage *highlightImage = emojiDictionary[kAttributeHighlightImage];
            if (highlightImage) {
                [emojiButton setImage:highlightImage forState:UIControlStateHighlighted];
            }
            
            if (!normalImage && !highlightImage) {
                NSString *text = emojiDictionary[kAttributeText];
                [emojiButton setTitle:text forState:UIControlStateNormal];
                [emojiButton setTitleColor:[UIColor colorWithHEX:TEXT_NORMAL_COLOR alpha:1.0] forState:UIControlStateNormal];
                [emojiButton setTitleColor:[UIColor colorWithHEX:TEXT_SELECT_COLOR alpha:1.0] forState:UIControlStateHighlighted];
            }
            
            UIColor *backgroundColor = emojiDictionary[kAttributeBackgroundColor];
            if (backgroundColor) {
                emojiButton.backgroundColor = backgroundColor;
            }
            
            UIColor *borderColor = emojiDictionary[kAttributeBorderColor];
            if (borderColor) {
                emojiButton.layer.borderColor = borderColor.CGColor;
            }
            
            id borderWidth = emojiDictionary[kAttributeBorderWidth];
            if (borderWidth) {
                emojiButton.layer.borderWidth = [borderWidth floatValue];
            }
            
            id cornerRadius = emojiDictionary[kAttributeCornerRadius];
            if (cornerRadius) {
                emojiButton.layer.cornerRadius = [cornerRadius floatValue];
            }
        }
        
        //动作按钮
        actionButton = [[UIButton alloc]init];
        actionButton.layer.masksToBounds = YES;
        actionButton.hidden = _config.actionDictionary.count == 0;
        actionButton.contentEdgeInsets = UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING);
        [actionButton addTarget:self action:@selector(actionClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:actionButton];
        NSDictionary *actionDictionary = _config.toolDictionary[kButtonNameAction];
        if (actionDictionary) {
            
            UIFont *font = actionDictionary[kAttributeFont];
            if (font) {
                actionButton.titleLabel.font = font;
            }
            
            UIImage *normalImage = actionDictionary[kAttributeNormalImage];
            if (normalImage) {
                [actionButton setImage:normalImage forState:UIControlStateNormal];
            }else{
                [actionButton setImage:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_action")] forState:UIControlStateNormal];
            }
            
            UIImage *highlightImage = actionDictionary[kAttributeHighlightImage];
            if (highlightImage) {
                [actionButton setImage:highlightImage forState:UIControlStateHighlighted];
            }
            
            if (!normalImage && !highlightImage) {
                NSString *text = actionDictionary[kAttributeText];
                [actionButton setTitle:text forState:UIControlStateNormal];
                [actionButton setTitleColor:[UIColor colorWithHEX:TEXT_NORMAL_COLOR alpha:1.0] forState:UIControlStateNormal];
                [actionButton setTitleColor:[UIColor colorWithHEX:TEXT_SELECT_COLOR alpha:1.0] forState:UIControlStateHighlighted];
            }
            
            UIColor *backgroundColor = actionDictionary[kAttributeBackgroundColor];
            if (backgroundColor) {
                actionButton.backgroundColor = backgroundColor;
            }
            
            UIColor *borderColor = actionDictionary[kAttributeBorderColor];
            if (borderColor) {
                actionButton.layer.borderColor = borderColor.CGColor;
            }
            
            id borderWidth = actionDictionary[kAttributeBorderWidth];
            if (borderWidth) {
                actionButton.layer.borderWidth = [borderWidth floatValue];
            }
            
            id cornerRadius = actionDictionary[kAttributeCornerRadius];
            if (cornerRadius) {
                actionButton.layer.cornerRadius = [cornerRadius floatValue];
            }
        }
        
        inputView = [[EM_ChatInputView alloc]init];
        inputView.delegate = self;
        [self addSubview:inputView];
        
        contentInsets = inputView.contentInset;
        
        moreStateButton = [[UIButton alloc]init];
        moreStateButton.hidden = YES;
        moreStateButton.backgroundColor = [UIColor colorWithHexRGB:0xF8F8F8];
        moreStateButton.layer.cornerRadius = 6;
        [moreStateButton setImage:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_state_normal")] forState:UIControlStateNormal];
        [moreStateButton setImage:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_state_selected")] forState:UIControlStateSelected];
        [moreStateButton addTarget:self action:@selector(stateClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreStateButton];
    }
    return self;
}

- (void)setOverrideNextResponder:(UIResponder *)overrideNextResponder{
    inputView.overrideNextResponder = overrideNextResponder;
}

- (NSString *)editor{
    return inputView.text;
}

- (void)setEditor:(NSString *)editor{
    inputView.text = editor;
}

- (BOOL)inputEditing{
    return inputView.isFirstResponder;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;

    CGFloat buttonSize = HEIGHT_INPUT_OF_DEFAULT - PADDING * 2;
    
    recordButton.frame = CGRectMake(0, size.height - buttonSize - PADDING, buttonSize, buttonSize);
    actionButton.frame = CGRectMake(size.width - buttonSize, size.height - buttonSize - PADDING, buttonSize, buttonSize);
    emojiButton.frame = CGRectMake(size.width - buttonSize * 2, size.height - buttonSize - PADDING, buttonSize, buttonSize);
    
    CGPoint inputOrigin = CGPointMake(0, PADDING);
    CGSize inputSize = CGSizeMake(size.width, size.height - PADDING * 2);
    
    if (recordButton.hidden) {
        inputOrigin.x = PADDING;
        inputSize.width -= PADDING;
    }else{
        inputOrigin.x = recordButton.frame.size.width;
        inputSize.width -= recordButton.frame.size.width;
    }
    
    if (actionButton.hidden) {
        inputSize.width -= PADDING;
    }else{
        inputSize.width -= actionButton.frame.size.width;
    }
    
    if (!emojiButton.hidden) {
        inputSize.width -= emojiButton.frame.size.width;
    }
    
    inputView.frame = CGRectMake(inputOrigin.x, inputOrigin.y, inputSize.width, inputSize.height);
    [inputView scrollRangeToVisible:NSMakeRange(inputView.text.length, 1)];
    
    moreStateButton.frame = inputView.frame;
    moreStateButton.contentEdgeInsets = UIEdgeInsetsMake(0, buttonSize, 0, 0);
}

- (CGSize)contentSize{
    CGRect contentRect = [inputView.text boundingRectWithSize:CGSizeMake(inputView.contentSize.width, HEIGHT_INPUT_OF_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:inputView.font,NSFontAttributeName, nil] context:nil];
    CGSize contentSize = contentRect.size;
    contentSize.width = self.bounds.size.width;
    contentSize.height += (inputView.textContainerInset.top + inputView.textContainerInset.bottom + PADDING * 2);
    return contentSize;
}

- (void)addMessage:(NSString *)message{
    NSString *content = inputView.text;
    inputView.text = [NSString stringWithFormat:@"%@%@",content ? content : @"",message];
    [self textViewDidChange:inputView];
}

- (void)deleteMessage{
    NSString *message = inputView.text;
    if (message && message.length > 0) {
        [message enumerateSubstringsInRange:NSMakeRange(0, message.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            if (message.length - substring.length == substringRange.location) {
                inputView.text = [message substringToIndex:substringRange.location];
                [self textViewDidChange:inputView];
            }
        }];
    }
}

- (void)sendMessage{
    
    BOOL shouldSend = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(shouldMessageSend:)]) {
        shouldSend = [_delegate shouldMessageSend:inputView.text];
    }
    
    if (shouldSend) {
        if (_delegate && [_delegate respondsToSelector:@selector(didMessageSend:)]) {
            NSString *message = [inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (message && message.length > 0) {
                [self.delegate didMessageSend:message];
            }
        }
        inputView.text = nil;
        [self textViewDidChange:inputView];
    }
}

- (void)dismissKeyboard{
    if (inputView.isFirstResponder) {
        [inputView resignFirstResponder];
    }
}

- (void)showKeyboard{
    [inputView becomeFirstResponder];
}

- (void)setStateRecord:(BOOL)stateRecord{
    _stateRecord = stateRecord;
    
    moreStateButton.hidden = !self.stateRecord;
    self.stateMore = !_stateRecord;
    
    if (_stateRecord) {
        NSDictionary *keyboardDictionary = _config.toolDictionary[kButtonNameKeyboard];
        if (keyboardDictionary) {
            UIImage *normalImage = keyboardDictionary[kAttributeNormalImage];
            if (normalImage) {
                [recordButton setImage:normalImage forState:UIControlStateNormal];
            }else{
                [recordButton setImage:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_keyboard")] forState:UIControlStateNormal];
            }
            
            UIImage *highlightImage = keyboardDictionary[kAttributeHighlightImage];
            if (highlightImage) {
                [recordButton setImage:highlightImage forState:UIControlStateHighlighted];
            }
        }
    }else{
        NSDictionary *recordDictionary = _config.toolDictionary[kButtonNameRecord];
        if (recordDictionary) {
            UIImage *normalImage = recordDictionary[kAttributeNormalImage];
            if (normalImage) {
                [recordButton setImage:normalImage forState:UIControlStateNormal];
            }else{
                [recordButton setImage:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_record")] forState:UIControlStateNormal];
            }
            
            UIImage *highlightImage = recordDictionary[kAttributeHighlightImage];
            if (highlightImage) {
                [recordButton setImage:highlightImage forState:UIControlStateHighlighted];
            }
        }
    }
}

- (void)setStateEmoji:(BOOL)stateEmoji{
    _stateEmoji = stateEmoji;
    
    if (_stateEmoji) {
        NSDictionary *keyboardDictionary = _config.toolDictionary[kButtonNameKeyboard];
        if (keyboardDictionary) {
            UIImage *normalImage = keyboardDictionary[kAttributeNormalImage];
            if (normalImage) {
                [emojiButton setImage:normalImage forState:UIControlStateNormal];
            }else{
                [emojiButton setImage:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_keyboard")] forState:UIControlStateNormal];
            }
            
            UIImage *highlightImage = keyboardDictionary[kAttributeHighlightImage];
            if (highlightImage) {
                [emojiButton setImage:highlightImage forState:UIControlStateHighlighted];
            }
        }
    }else{
        NSDictionary *emojiDictionary = _config.toolDictionary[kButtonNameEmoji];
        if (emojiDictionary) {
            UIImage *normalImage = emojiDictionary[kAttributeNormalImage];
            if (normalImage) {
                [emojiButton setImage:normalImage forState:UIControlStateNormal];
            }else{
                [emojiButton setImage:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_emoji")] forState:UIControlStateNormal];
            }
            
            UIImage *highlightImage = emojiDictionary[kAttributeHighlightImage];
            if (highlightImage) {
                [emojiButton setImage:highlightImage forState:UIControlStateHighlighted];
            }
        }
    }
}

- (void)setStateAction:(BOOL)stateAction{
    _stateAction = stateAction;
    
    if (_stateAction) {
        NSDictionary *keyboardDictionary = _config.toolDictionary[kButtonNameKeyboard];
        if (keyboardDictionary) {
            UIImage *normalImage = keyboardDictionary[kAttributeNormalImage];
            if (normalImage) {
                [actionButton setImage:normalImage forState:UIControlStateNormal];
            }else{
                [actionButton setImage:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_keyboard")] forState:UIControlStateNormal];
            }
            
            UIImage *highlightImage = keyboardDictionary[kAttributeHighlightImage];
            if (highlightImage) {
                [actionButton setImage:highlightImage forState:UIControlStateHighlighted];
            }
        }
    }else{
        NSDictionary *actionDictionary = _config.toolDictionary[kButtonNameAction];
        if (actionDictionary) {
            UIImage *normalImage = actionDictionary[kAttributeNormalImage];
            if (normalImage) {
                [actionButton setImage:normalImage forState:UIControlStateNormal];
            }else{
                [actionButton setImage:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_action")] forState:UIControlStateNormal];
            }
            
            UIImage *highlightImage = actionDictionary[kAttributeHighlightImage];
            if (highlightImage) {
                [actionButton setImage:highlightImage forState:UIControlStateHighlighted];
            }
        }
    }
}

- (void)setStateMore:(BOOL)stateMore{
    moreStateButton.selected = stateMore;
}

- (BOOL)stateMore{
    return moreStateButton.selected;
}

//录音按钮
- (void)recordClicked:(UIButton *)sender{
    self.stateRecord = !_stateRecord;
    self.stateEmoji = NO;
    self.stateAction = NO;
    
    if (_delegate) {
        [_delegate didRecordStateChanged:_stateRecord];
    }
}

//表情按钮
- (void)emojiClicked:(UIButton *)sender{
    self.stateEmoji = !_stateEmoji;
    self.stateRecord = NO;
    self.stateAction = NO;
    
    if (_delegate) {
        [_delegate didEmojiStateChanged:_stateEmoji];
    }
}

//动作按钮
- (void)actionClicked:(UIButton *)sender{
    self.stateAction = !_stateAction;
    self.stateRecord = NO;
    self.stateEmoji = NO;
    
    if (_delegate) {
        [_delegate didActionStateChanged:_stateAction];
    }
}

- (void)stateClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (_delegate) {
        [_delegate didMoreStateChanged:sender.selected];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.stateAction = NO;
    self.stateEmoji = NO;
    self.stateRecord = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if(textView && textView.text && textView.text.length > 0){
        
        CGSize contentSize = self.contentSize;
        
        if (CGSizeEqualToSize(CGSizeZero,oldContentSize)) {
            oldContentSize = contentSize;
        }
        
        if (contentSize.height != inputView.bounds.size.height
            && ((contentSize.height < HEIGHT_INPUT_OF_MAX && contentSize.height > HEIGHT_INPUT_OF_DEFAULT)
                || (contentSize.height > HEIGHT_INPUT_OF_MAX && inputView.bounds.size.height < HEIGHT_INPUT_OF_MAX))) {
            if (_delegate && [_delegate respondsToSelector:@selector(didMessageChanged:oldContentSize:newContentSize:)]) {
                [_delegate didMessageChanged:textView.text oldContentSize:oldContentSize newContentSize:contentSize];
            }
            oldContentSize = contentSize;
        }else{
            [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(didMessageChanged:oldContentSize:newContentSize:)]) {
            [_delegate didMessageChanged:nil oldContentSize:CGSizeZero newContentSize:oldContentSize];
        }
        oldContentSize = CGSizeZero;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    return YES;
}

@end