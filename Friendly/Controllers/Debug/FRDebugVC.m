//
//  FRDebugControllerViewController.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRDebugVC.h"
#import "FRHomeScreenWireframe.h"
#import "FRAddInterestsWireframe.h"
#import "FRRecommendedUsersWireframe.h"
#import "FRLetsGoVC.h"
#import "FRProfilePolishWireframe.h"
#import "FRCreateEventWireframe.h"


#import "FRMyProfileWireframe.h"
#import "FREditProfileWireframe.h"
#import "FRSettingsTransport.h"

#import "FRSettingWireframe.h"

#import "FRIntroWireframe.h"

#import "FRUserProfileWireframe.h"

#import "FRCreateEventAgesViewController.h"
#import "FREventRequestsViewController.h"

#import "FRFriendRequestsWireframe.h"

#import "FRRequestAccessVC.h"
#import "FREventsWireframe.h"

#import "FRUploadImage.h"
#import "UIImageHelper.h"

#import "FRSearchDiscoverPeopleWireframe.h"
#import "FREventFilterWireframe.h"

#import "FRSearchEventByCategoryWireframe.h"

#import "FRWebSoketManager.h"
//#import "FRMessagesWireframe.h"
#import "FRPrivateChatWireframe.h"

#import "FRSettingsTransport.h"

#import "AdViewController.h"

#import "FRChatTransport.h"
#import "FRHomeWireframe.h"

#import "SDImageCache.h"

#import "FRFriendsEventsWireframe.h"
#import "FRMessagerWireframe.h"

@interface FRDebugVC ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) NSArray* caseArray;
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation FRDebugVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[SDImageCache sharedImageCache] clearMemory];

    
    UIImage* image = [UIImage imageNamed:@"imageEvent"];
    image = [UIImageHelper addFilter:image];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = FRLocalizedString(@"debug.vc.title", nil);

    self.caseArray = @[
                       @"IntroViewController",
                       @"FRHomeWireframe",
                       @"FRFriendsEventsWireframe",
                       @"FRLetsGoVC",
                       @"FRProfilePolishWireframe.",
                       @"FRCreateEventWireframe",
                       @"Home",
                       @"FRMessagerWireframe",
                       @"FRAddInterestsWireframe",
//                       @"FREditProfileWireframe",
//                       @"FRSettingWireframe",
//                       @"FRIntroWireframe",
//                       @"FRUserProfileWireframe",
//                       @"AnimationController",
//                       @"FRFriendRequestsWireframe",
//                       @"FRRequestAccessVC",
//                       @"FREventsWireframe",
//                       @"FRSearchDiscoverPeopleWireframe",
//                       @"FREventFilterWireframe",
//                       @"FRSearchEventByCategoryWireframe",
                       ];
    
   
   [FRSettingsTransport profileWithSuccess:^(UserEntity *userProfile, NSArray* mutualFriends) {
       
   } failure:^(NSError *error) {
       
   }];
    
    [FRChatTransport getAllRooms:^(id rooms) {
        
    } failure:^(NSError *error) {
        
    }];
    
    UIImageView* view = [UIImageView new];
    view.image = [UIImage imageNamed:@"over-featured-details.png"];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
       
//    [d sendMessage:@"DDD"];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
      
        case 0:
        {
            self.navigationController.navigationBarHidden = YES;
            [[FRIntroWireframe new] presentIntroControllerFromNavigationController:self.navigationController];
            
            
//            AdViewController* vc = [AdViewController new];
//            [self.navigationController pushViewController:vc animated:YES];
            
        } break;
            
        case 1:
        {
            self.navigationController.navigationBarHidden = true;
            
            
            [[FRHomeWireframe new] presentHomeControllerFromNavigationController:self.navigationController];
           
        }break;
        case 2:
        {
            self.navigationController.navigationBarHidden = YES;
            [[FRFriendsEventsWireframe new] presentFriendsEventsControllerFromNavigationController:self.navigationController];
        }break;
            
        case 3:
        {
            self.navigationController.navigationBarHidden = YES;

           FRLetsGoVC* vc = [FRLetsGoVC new];
            [self.navigationController pushViewController:vc animated:NO];
        } break;
        case 4:
        {
            self.navigationController.navigationBarHidden = YES;
            [[FRProfilePolishWireframe new] presentProfilePolishControllerFromNavigationController:self.navigationController interests:@[@"Tag"]];
        } break;

        case 5:{
            self.navigationController.navigationBarHidden = YES;

            [[FRCreateEventWireframe new] presentCreateEventControllerFromNavigationController:self.navigationController event:nil animation:YES];
        }
            
            case 6:
        {
            [[FRHomeScreenWireframe new] presentHomeScreenControllerFromNavigationController:self.navigationController];
        } break;
            
        case 7:
        {
            
            
            [[FRMessagerWireframe new] presentMessagerControllerFromNavigationController:self.navigationController];
//            [[FRMyProfileWireframe new] presentMyProfileControllerFromNavigationController:self.navigationController];
        } break;
            
        case 8:
        {
            
            [[FRAddInterestsWireframe new] presentAddInterestsControllerFromNavigationController:self.navigationController];
        } break;
            
        case 9:
        {
            [[FRSettingWireframe new] presentSettingControllerFromController:self.navigationController];
        } break;
            
        case 10:
        {
            [[FRIntroWireframe new] presentIntroControllerFromNavigationController:self.navigationController];
            
        } break;
            
        case 11:
        {
            self.navigationController.navigationBarHidden = YES;
        } break;
            
            case 12:
        {
            
        } break;
            
        case 13:
        {
            [[FRFriendRequestsWireframe new] presentFriendRequestsControllerFromNavigationController:self.navigationController];
        } break;
            
        case 14:
        {
            FRRequestAccessVC* vc = [FRRequestAccessVC new];
            vc.mode = FRRequestAccessViewLocation;
            [self presentViewController:vc animated:YES completion:nil];
        } break;
            
        case 15:
        {
            [[FREventsWireframe new] presentEventsControllerFromNavigationController:self.navigationController];
        } break;
        case 16:
        {
            [[FRSearchDiscoverPeopleWireframe new] presentSearchDiscoverPeopleControllerFromNavigationController:self.navigationController tag:@""];
        } break;
            
        case 17:
        {
            [[FREventFilterWireframe new] presentEventFilterControllerFromNavigationController:self.navigationController];
        } break;
        case 18:
        {
            [[FRSearchEventByCategoryWireframe new]presentSearchEventByCategoryControllerFromNavigationController:self.navigationController category:@""];
        } break;
            
            case 19:
        {
        }
            
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.caseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString* cellIdentifier = @"CellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.caseArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - Lazy Load

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [UITableView new];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

@end
