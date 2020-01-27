//
//  FRGlobalHeader.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "AppDelegate.h"

#define EVENT @"http://joinfriendlyapp.com/event/"

//#define DEBUG_CONTROLLER

//#define TEST_SERVER

#import "BSHelperFunctions.h"
#import "NSObject+BSSafeValues.h"
#import "NSObject+BSUserDefaults.h"
#import "UIColor+BSAdditions.h"
#import "FRLocalizationHeader.h"
#import "FRUserManager.h"
#import "CurrentUser.h"

#import "FRConnetctionManager.h"

//Core
#import "ReactiveCocoa.h"

//UI
#import "Masonry.h"
#import "DAKeyboardControl.h"
#import "BSEstimateCellHeight.h"


//DataBase
#import <MagicalRecord/MagicalRecord.h>
#import "FRDataBaseManager.h"
#import "UserEntity.h"
#import "FRPrivateRoom.h"


// UDID test

#define TEST_DEVICE_ARRAY @[@"a89e490b70d703fdc0aa6685464fb4581be06077", \
                        @"26dc426fc737ec3db5dcc711d2cfdebcae8daf2d",\
                        @"104e4c53f5b81b3fbcac612e06590f2f25a5bf83",\
                        @"2ab607fa23677a93fb11397cdaae1f48f26ba653",\
                        @"fb82f43ed76fd0e6b652ff52703df1f5058e0ace",\
                        @"9cbc9f4b68e82b04dbfbb80f5974ccc2a8aeec68",\
                        @"6b8c88a338e4e51b7b49e7dc4f1b227595229f9e",\
                        @"e8d5d6ff6934fc30a1a812a49e81ffd152cff88c"]


#define GOOGLE_Ad_UNID_ID  @"ca-app-pub-3940256099942544/2934735716"


//key

static NSString *const kKeychainItemName = @"Google Calendar API";
static NSString *const kGoogleAuth = @"565571189667-a6ape11q5j81ik4juu1rsfvrcq0b77r5.apps.googleusercontent.com";

static NSString* const kUsername                            = @"username";
//static NSString* const kFaceBookTokenId                     = @"kFaceBookTokenId";
static NSString* const kLocalization                        = @"keyLocalization";
static NSString* const kLocalizationChangedNotification     = @"kLocalizationChangedNotification";

static NSString* const kVenturaEddingBold                   = @"VenturaEdding-Bold";
static NSString* const kVenturaEdding                       = @"VenturaEdding-Medium";
//static NSString* const kSanFranciscoDisplayLight            = @"SFUIDisplay-Light";
static NSString* const kSanFranciscoDisplayLight            = @"ProximaNovaSoft-Regular";
//static NSString* const kSanFranciscoDisplayRegular          = @"SFUIDisplay-Regular";
static NSString* const kSanFranciscoDisplayRegular          = @"ProximaNovaSoft-Regular";
//static NSString* const kSanFranciscoDisplaySemibold         = @"SFUIDisplay-Semibold";
static NSString* const kSanFranciscoDisplaySemibold         = @"ProximaNovaSoft-Semibold";
//static NSString* const kSanFranciscoDisplayMedium           = @"SFUIDisplay-Medium";
static NSString* const kSanFranciscoDisplayMedium           = @"ProximaNovaSoft-Medium";
static NSString* const kSanFranciscoDisplayBold             = @"SFUIDisplay-Bold";
static NSString* const kSanFranciscoTextRegular             = @"SFUIText-Regular";
static NSString* const kSanFranciscoDisplayThin             = @"SFUIDisplay-Thin";


//proximaNova

static NSString* const kProximaNovaRegular                  = @"ProximaNovaSoft-Regular";
static NSString* const kProximaNovaMedium                   = @"ProximaNovaSoft-Medium";
static NSString* const kProximaNovaSemibold                 = @"ProximaNovaSoft-Semibold";

static NSString* const kProximaNovaBold                     = @"ProximaNovaSoftW03-Bold";


//static NSString* const kUserPhoto                           = @"kUserPhoto";
static NSString* const kFacebookAppID                       = @"2113606815530206";

typedef NS_ENUM(NSInteger, FRGenderType) {
    FRGenderTypeAll,
    FRGenderTypeMale,
    FRGenderTypeFemale
};

// раньше у нас был выбор из 4 статусов, сейчас только либо юзер свободен либо он занят. Изменять енам только с БЕ !!!
typedef NS_ENUM(NSInteger, FRSystemStatusType) {
    FRSystemStatusAvailableForMeet,
    FRSystemStatusBusy,
    FRSystemStatusFreeThisWeekend,
    FRSystemStatusOpenToCoHostEvent,
};

typedef NS_ENUM(NSInteger, FRIsFriendType) {
    
    FRIsFriendNo,
    FRIsFriendInvited,
    FRIsFriendYes,
};

typedef NS_ENUM(NSInteger, FRDateFilterType)
{
    FRDateFilterAnyTime,
    FRDateFilterThisWeekend,
    FRDateFilterThisWeek,
};


static NSString* const kSearchHelperFirstTime = @"kSearchHelperFirstTime";
static NSString* const kCreateEventHelperFirstTime = @"kCreateEventHelperFirstTime";

//color

static NSString* const kOpacityBlackColor           = @"#151D28";
static NSString* const kTitleColor                  = @"#2E394D";
static NSString* const kBodyColor                   = @"#536078";
static NSString* const kIconsColor                  = @"#ADB6CE";
static NSString* const kWatermarkColor              = @"#C9CEDE";
//static NSString* const kPurpleColor                 = @"#765BF8";
//static NSString* const kPurpleColor                 = @"#6849FF";
static NSString* const kPurpleColor                 = @"#6049FF";
static NSString* const kYellowColor                 = @"#FFB700";
static NSString* const kGreenColor                  = @"#4AC841";
static NSString* const kAlertsColor                 = @"#FF6868";
static NSString* const kDarkBlueColor               = @"#3F6EC2";
static NSString* const kFriendlyBlueColor           = @"#00B3FC";
static NSString* const kFriendlyPinkColor           = @"#FF75D4";
static NSString* const kFieldTextColor              = @"8B97AE";
static NSString* const kSeparatorColor              = @"E8EBF1";

static NSString* const KTextTitleColor              = @"263345";
static NSString* const kTextSubtitleColor           = @"606671";
//server

#define UPDATE_EVENT @"Update Event"
#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#ifdef TEST_SERVER

#define SERVER_URL @"http://friendlyapp-test.r-savchenko.com/api/"
#define SERVER_API_KEY @"a1d28fd2fda84a3a"
#define SERVER_API_PASS @"834edde7585cd46d"
#define SERVER_IP @"45.55.197.87"
#define SERVER_PORT @"8009"

#define WEB_SOCKET_SERVER_ADDRESS @"ws://friendlyapp-test.r-savchenko.com"
#define SERVER_URL_FOR_COOKIE @"http://friendlyapp-test.r-savchenko.com"
#define SERVER_WS_PORT @"8809"

#else

#define SERVER_URL @"http://www.joinfriendlyapp.com/api/"
#define SERVER_API_KEY @"b77fc6b92c8841b0"
#define SERVER_API_PASS @"85710297f377a156"
#define SERVER_IP @"52.40.142.80"
#define SERVER_PORT @"8000"

#define WEB_SOCKET_SERVER_ADDRESS @"ws://www.joinfriendlyapp.com"
#define SERVER_URL_FOR_COOKIE @"http://www.joinfriendlyapp.com"
#define SERVER_WS_PORT @"8888"

#endif

#define GOOGLE_MAP_API @"AIzaSyBkGdPNQeVyQhyjtqCAyVrZ6fncjXu7tLc"

#define REFERENCE_INVITE @"REFERENCE_INVITE"
#define EVENT_ID_INVITE @"EVENT_ID_INVITE"

#define PLACEMENT_ID @"2113606815530206_2113611625529725"


static CGFloat const kToolbarHeight     = 50;
static CGFloat const kNavBarHeight      = 64;


#define WELCOME_TEMP_USER @"WELCOM_TEMP_USER"

 // help define

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define REQUEST_LOCATION_WAS_CARRIED_OUT @"Request location was carried out"
#define CAN_UPDATE_CALENDAR @"CanUpdateCalendar"
//#define NSLog //





#define FONT_CUSTOM_SIZE(s) [UIFont fontWithName:kVenturaEdding size:(s)]
#define FONT_CUSTOM_BOLD_SIZE(s) [UIFont fontWithName:kVenturaEddingBold size:(s)]

#define FONT_MAIN_FONT(s) [UIFont fontWithName:kSanFranciscoDisplayLight size:(s)]
#define FONT_SF_DISPLAY_LIGHT(s) [UIFont fontWithName:kSanFranciscoDisplayLight size:(s)]
#define FONT_SF_DISPLAY_REGULAR(s) [UIFont fontWithName:kSanFranciscoDisplayRegular size:(s)]
#define FONT_SF_DISPLAY_SEMIBOLD(s) [UIFont fontWithName:kSanFranciscoDisplaySemibold size:(s)]
#define FONT_SF_DISPLAY_MEDIUM(s) [UIFont fontWithName:kSanFranciscoDisplayMedium size:(s)]
#define FONT_SF_DISPLAY_BOLD(s) [UIFont fontWithName:kSanFranciscoDisplayBold size:(s)]
#define FONT_SF_TEXT_REGULAR(s) [UIFont fontWithName:kSanFranciscoTextRegular size:(s)]
#define FONT_SF_DISPLAY_THIN(s) [UIFont fontWithName:kSanFranciscoDisplayThin size:(s)]


//Venture

#define FONT_VENTURE_EDDING_BOLD(s) [UIFont fontWithName:kVenturaEddingBold size:(s)]
#define FONT_VENTURE_EDDING(s) [UIFont fontWithName:kVenturaEdding size:(s)]

//proximaNova

#define FONT_PROXIMA_NOVA_BOLD(s) [UIFont fontWithName:kProximaNovaBold size:(s)]
#define FONT_PROXIMA_NOVA_REGULAR(s) [UIFont fontWithName:kProximaNovaRegular size:(s)]
#define FONT_PROXIMA_NOVA_MEDIUM(s) [UIFont fontWithName:kProximaNovaMedium size:(s)]
#define FONT_PROXIMA_NOVA_SEMIBOLD(s) [UIFont fontWithName:kProximaNovaSemibold size:(s)]

//Analytics

#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"


//Instagram

#define kBaseURL @"https://instagram.com/"
#define kInstagramAPIBaseURL @"https://api.instagram.com"
#define kAuthenticationURL @"oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=likes+comments+basic"  // comments
#define kClientID @"b3c594f2f12843a2898baad0bcb786f4"
//#define kRedirectURI @"ig2b00c09bc3ca472a8723d308369bc19e:\\\\authorize"
#define kRedirectURI @"52.40.142.80:8000"
#define kAccessToken @"211628685.1677ed0.4ac51b1133e74fee8194121509219bf7"

