//
//  FRUploadManager.h
//  Friendly
//
//  Created by Sergey on 02.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class CreateEvent;

#define SHOW_UPLOAD_VIEW @"SHOW_UPLOAD_VIEW"
#define HIDE_UPLOAD_VIEW @"HIDE_UPLOAD_VIEW"

@interface FRUploadManager : NSObject

+ (void)uploadEvent;
+ (void)createEvent:(CreateEvent*)ev;
+ (void)updateEvent;
@end
