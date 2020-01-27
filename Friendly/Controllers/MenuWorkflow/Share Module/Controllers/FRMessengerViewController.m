//
//  FRMessengerViewController.m
//  Friendly
//
//  Created by User on 28.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessengerViewController.h"
#import "FRMessengerContactCell.h"
#import "FRMessengerSendToView.h"
#import "APAddressBook.h"
#import "BSHudHelper.h"

@interface FRMessengerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UIButton* sendButton;
@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) FRMessengerSendToView* sendToView;

@end

static NSString* kCell = @"ContactCell";

@implementation FRMessengerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    APAddressBook *addressBook = [[APAddressBook alloc] init];
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];

    addressBook.fieldsMask = APContactFieldName | APContactFieldThumbnail | APContactFieldBirthday;
    [addressBook loadContacts:^(NSArray <APContact *> *contacts, NSError *error)
    {
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
        if (!error)
        {
            // do something with contacts array
        }
        else
        {
            [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
        }
    }];

    [self tableView];
    [self.tableView registerClass:[FRMessengerContactCell class] forCellReuseIdentifier:kCell];
    self.titleLabel.text = @"Invite friends";
    [self sendButton];
    [self separator];
    [self sendToView];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell;
    FRMessengerContactCell *contactCell= (FRMessengerContactCell*)[tableView dequeueReusableCellWithIdentifier:kCell];
    returnCell = contactCell;
    return returnCell;
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - LazyLoad

-(UITableView*) tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = YES;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.top.equalTo(self.sendToView.mas_bottom);
        }];
        
    }
    return _tableView;
}

-(UIButton*) sendButton
{
    if (!_sendButton)
    {
        _sendButton = [UIButton new];
        [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(18);
        [_sendButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
        [self.toolbar addSubview:_sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.toolbar).offset(-15);
            make.right.equalTo(self.toolbar).offset(-15);
            make.height.equalTo(@18);
            make.width.equalTo(@50);
        }];
    }
    return _sendButton;
}

-(UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.toolbar addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.toolbar);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

-(FRMessengerSendToView*)sendToView
{
    if (!_sendToView)
    {
        _sendToView = [FRMessengerSendToView new];
        [self.view addSubview:_sendToView];
        [_sendToView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolbar.mas_bottom);
            make.left.right.equalTo(self.tableView);
            make.height.equalTo(@60);
        }];
    }
    return _sendToView;
}


@end
