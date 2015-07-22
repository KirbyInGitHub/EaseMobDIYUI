//
//  EaseMobLoginController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/1.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EaseMobLoginController.h"
#import "EaseMob.h"

@interface EaseMobLoginController ()<UITextFieldDelegate>

@end

@implementation EaseMobLoginController{
    UITextField *usernameField;
    UITextField *passwordField;
    UIButton *loginButton;
    UIButton *registerButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:scroll];
    
    CGFloat padding = 15;
    CGFloat y = padding * 6;
    CGFloat width = self.view.frame.size.width - padding * 2;
    
    usernameField = [[UITextField alloc]initWithFrame:CGRectMake(padding, y, width, 44)];
    usernameField.layer.borderWidth = 0.5;
    usernameField.layer.borderColor = [UIColor grayColor].CGColor;
    usernameField.layer.cornerRadius = 6;
    usernameField.delegate = self;
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    usernameField.placeholder = @"用户名";
    usernameField.text = @"zhouyuzhen";
    usernameField.returnKeyType = UIReturnKeyNext;
    [scroll addSubview:usernameField];
    
    y += (usernameField.frame.size.height + padding);
    
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(padding, y, width, 44)];
    passwordField.layer.borderWidth = 0.5;
    passwordField.layer.borderColor = [UIColor grayColor].CGColor;
    passwordField.layer.cornerRadius = 6;
    passwordField.delegate = self;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.secureTextEntry = YES;
    passwordField.returnKeyType = UIReturnKeyGo;
    passwordField.placeholder = @"密码";
    passwordField.text = @"123456";
    [scroll addSubview:passwordField];
    
    y += (passwordField.frame.size.height + padding);
    
    loginButton = [[UIButton alloc]initWithFrame:CGRectMake(padding, y, width, 44)];
    loginButton.layer.borderWidth = 0.5;
    loginButton.layer.borderColor = [UIColor grayColor].CGColor;
    loginButton.layer.cornerRadius = 6;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:loginButton];
    
    y += (loginButton.frame.size.height + padding);
    
    CGFloat clientHeight = self.view.frame.size.height;
    
    if (!self.navigationController.navigationBarHidden) {
        clientHeight -= self.navigationController.navigationBar.frame.size.height;
    }
    if (!self.tabBarController.tabBar.hidden) {
        clientHeight -= self.tabBarController.tabBar.frame.size.height;
    }
    
    if (y > clientHeight) {
        scroll.contentSize = CGSizeMake(0, y);
    }else{
        scroll.contentSize = CGSizeMake(0, clientHeight + 1);
    }
}

- (void)login:(id)sender{
    
    NSString *username = usernameField.text;
    NSString *password = passwordField.text;
    
    if (username && username.length > 0 && password && password.length > 0) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:password completion:^(NSDictionary *loginInfo, EMError *error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } onQueue:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == usernameField) {
        if (textField.text && textField.text.length > 0) {
            [passwordField becomeFirstResponder];
            return YES;
        }else{
            return NO;
        }
    }else if(textField == passwordField){
        if (!usernameField.text || usernameField.text.length == 0) {
            return NO;
        }
        
        if (!passwordField.text || passwordField.text.length == 0) {
            return NO;
        }
        
        [self login:nil];
        return YES;
    }
    return NO;
}

@end