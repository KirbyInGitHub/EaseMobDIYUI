//
//  EM+ExplorerController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/7.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ExplorerController.h"
#import "EM+ChatFileUtils.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+Common.h"
#import "UIColor+Hex.h"

#import "EM+ChatWifiView.h"

#define HEIGHT_HEADER   (44)
#define HEIGHT_FOOTER   (44)

@interface EM_ExplorerController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation EM_ExplorerController{
    UIScrollView *_headerView;
    UIView *_footerView;
    UITableView *_tableView;
    NSArray *_folderArray;
    NSArray *_buttonArray;
    NSInteger _currentFolderIndex;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _folderArray = [EM_ChatFileUtils folderArray];
        self.title = [EM_ChatResourcesUtils stringWithName:@"common.file"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentInset = UIEdgeInsetsMake(HEIGHT_HEADER, 0, HEIGHT_FOOTER, 0);
    [self.view addSubview:_tableView];
    
    _headerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_FRAME.size.height + NAVIGATION_BAR_FRAME.size.height, self.view.frame.size.width, HEIGHT_HEADER)];
    CGFloat buttonWidth = self.view.frame.size.width / _folderArray.count;
    for (int i = 0; i < _folderArray.count; i++) {
        NSDictionary *dic = _folderArray[i];
        NSString *title = dic[kFolderTitle];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonWidth * i, 0, buttonWidth, HEIGHT_HEADER)];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(folderClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.selected = _currentFolderIndex == i;
        [_headerView addSubview:button];
    }
    _buttonArray = [NSArray arrayWithArray:_headerView.subviews];
    
    UIView *headerLine = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.frame.size.height - LINE_HEIGHT, _headerView.frame.size.width, LINE_HEIGHT)];
    headerLine.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
    [_headerView addSubview:headerLine];
    [self.view addSubview:_headerView];
    
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - HEIGHT_FOOTER, self.view.frame.size.width, HEIGHT_FOOTER)];
    UIView *footerLine = [[UIView alloc]initWithFrame:CGRectMake(0, -LINE_HEIGHT, _headerView.frame.size.width, LINE_HEIGHT)];
    footerLine.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
    [_footerView addSubview:footerLine];
    [self.view addSubview:_footerView];
    
    UIButton *cancel = [[UIButton alloc]init];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitle:[EM_ChatResourcesUtils stringWithName:@"common.cancel"] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateHighlighted];
    [cancel sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    
    UIButton *wifi = [[UIButton alloc]init];
    [wifi addTarget:self action:@selector(wifiUpload:) forControlEvents:UIControlEventTouchUpInside];
    [wifi setTitle:[EM_ChatResourcesUtils stringWithName:@"file.wifi_upload"] forState:UIControlStateNormal];
    [wifi setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateNormal];
    [wifi setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateHighlighted];
    [wifi sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:wifi];
}

- (void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)wifiUpload:(id)sender{
    EM_ChatWifiView *wifiView = [[EM_ChatWifiView alloc]init];
    [wifiView show:UAlertPosition_Bottom offestY:0];
}

- (void)folderClicked:(UIButton *)sender{
    _currentFolderIndex = sender.tag;
    for (UIButton *button in _buttonArray) {
        button.selected = _currentFolderIndex == button.tag;
    }
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *contentArray = _folderArray[_currentFolderIndex][kFolderContent];
    return contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
@end