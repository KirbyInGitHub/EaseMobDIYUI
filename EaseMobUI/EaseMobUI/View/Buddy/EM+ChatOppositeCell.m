//
//  EM+ChatOppositeCell.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatOppositeCell.h"
#import "EM+Common.h"
#import "UIColor+Hex.h"

@implementation EM_ChatOppositeCell{

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setName:(NSString *)name{
    _name = name;
    self.textLabel.text = _name;
}

- (void)setDetails:(NSString *)details{
    _details = details;
    self.detailTextLabel.text = _details;
}

- (void)setAvatarImage:(UIImage *)avatarImage{
    _avatarImage = avatarImage;
    if (!self.avatarURL) {
        self.imageView.image = _avatarImage;
    }
}

- (void)setAvatarURL:(NSURL *)avatarURL{
    _avatarURL = avatarURL;
}

@end