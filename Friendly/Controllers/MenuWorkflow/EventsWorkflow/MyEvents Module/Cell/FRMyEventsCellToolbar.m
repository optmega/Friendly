//
//  FRMyEventsCellToolbar.m
//  Friendly
//
//  Created by Jane Doe on 3/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsCellToolbar.h"
#import "FRStyleKit.h"
#import "FRMyEventsCellToolbarButton.h"
#import "UIImageHelper.h"

@interface FRMyEventsCellToolbar()

@property (strong, nonatomic) NSArray* hostingBarItems;
@property (strong, nonatomic) NSArray* joiningBarItems;
@property (assign, nonatomic) BOOL isHosting;
@property (strong, nonatomic) NSString* eventId;
@property (strong, nonatomic) NSMutableArray* users;
@property (strong, nonatomic) FREvent* eventModel;

@end

@implementation FRMyEventsCellToolbar

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        FRMyEventsCellToolbarButton* firstButton = [FRMyEventsCellToolbarButton new];
        firstButton.title.text = @"Edit";
        firstButton.image.image = [FRStyleKit imageOfActionBarEditEventCanvas];
        [firstButton addTarget:self action:@selector(editEvent) forControlEvents:UIControlEventTouchUpInside];
        
        FRMyEventsCellToolbarButton* secondButton = [FRMyEventsCellToolbarButton new];
        secondButton.title.text = @"Guests";
        secondButton.image.image = [FRStyleKit imageOfGroup5Canvas];
        [secondButton addTarget:self action:@selector(showMyGuests) forControlEvents:UIControlEventTouchUpInside];

        FRMyEventsCellToolbarButton* fourthButton = [FRMyEventsCellToolbarButton new];
        fourthButton.title.text = @"Chat";
        fourthButton.image.image = [FRStyleKit imageOfActionBarGroupChatCanvas];
        [fourthButton addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
                
        FRMyEventsCellToolbarButton* fifthButton = [FRMyEventsCellToolbarButton new];
        fifthButton.title.text = @"More";
        fifthButton.image.image = [FRStyleKit imageOfFeildMoreOptionsCanvas];
        [fifthButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];

        
        FRMyEventsCellToolbarButton* joiningFirstButton = [FRMyEventsCellToolbarButton new];
        joiningFirstButton.title.text = @"Share";
        [joiningFirstButton addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
        joiningFirstButton.image.image = [UIImageHelper image:[FRStyleKit imageOfActionBarShareCanvas] color:[UIColor bs_colorWithHexString:kIconsColor]];
        
        FRMyEventsCellToolbarButton* joiningFifthButton = [FRMyEventsCellToolbarButton new];
        joiningFifthButton.title.text = @"Leave";
        [joiningFifthButton addTarget:self action:@selector(leaveEvent) forControlEvents:UIControlEventTouchUpInside];

        joiningFifthButton.image.image = [FRStyleKit imageOfLeaveEventIcon];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *first = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
        UIBarButtonItem *second = [[UIBarButtonItem alloc] initWithCustomView:secondButton];
        UIBarButtonItem *fourth = [[UIBarButtonItem alloc] initWithCustomView:fourthButton];
        UIBarButtonItem *fifth = [[UIBarButtonItem alloc] initWithCustomView:fifthButton];

        UIBarButtonItem* third = [[UIBarButtonItem alloc] initWithImage:[FRStyleKit imageOfActionBarInviteCanvas] style:UIBarButtonItemStylePlain target:self action:@selector(showInvite)];
 
        UIBarButtonItem *joiningFirst = [[UIBarButtonItem alloc] initWithCustomView:joiningFirstButton];
        UIBarButtonItem *joiningFifth = [[UIBarButtonItem alloc] initWithCustomView:joiningFifthButton];

        self.hostingBarItems = [NSArray arrayWithObjects:first, flexibleItem, second, flexibleItem, third, flexibleItem, fourth, flexibleItem, fifth, nil];
        self.joiningBarItems = [NSArray arrayWithObjects:joiningFirst, flexibleItem, second, flexibleItem, third, flexibleItem, fourth, flexibleItem, joiningFifth, nil];

        self.items = self.hostingBarItems;
        
        self.translucent = NO;
        self.barTintColor = [UIColor whiteColor];
        self.tintColor = [UIColor whiteColor];

    }
    return self;
}

- (void)chat {
    [FRUserManager sharedInstance].statusBarStyle = UIStatusBarStyleDefault;
    [self.cellToolBarDelegate showChatForEvent:self.eventModel];
}

-(void)showMyGuests
{
    [self.cellToolBarDelegate guestsSelectWithUser:self.users andEvent:self.eventModel];
}

-(void)showMore
{
    [self.cellToolBarDelegate moreSelectWithEvent:self.eventId andModel:self.eventModel];
}

-(void)showInvite
{
    [self.cellToolBarDelegate showInviteWithEvent:self.eventId andEvent:self.eventModel];
}

-(void)leaveEvent
{
    [self.cellToolBarDelegate leaveEvent:self.eventId];
}

-(void)editEvent
{
    [self.cellToolBarDelegate editEvent:self.eventModel];
}

-(void)shareEvent
{
    [self.cellToolBarDelegate shareEvent:self.eventModel];
}

- (void)updateWithEvent:(FREvent*)eventModel andUsers:(NSArray*)users
{
    self.eventModel = eventModel;
    self.users = [NSMutableArray arrayWithArray:users];
    self.eventId = eventModel.eventId;
}

- (void)updateWithType:(FRMyEventsCellType)type
{
    switch (type) {
        case FRMyEventsCellTypeJoining:
        {
            self.items = self.joiningBarItems;
        }
            break;
        case FRMyEventsCellTypeHosting:
        {
            self.items = self.hostingBarItems;
        }
            break;
        default:
            break;
    }
}


@end
