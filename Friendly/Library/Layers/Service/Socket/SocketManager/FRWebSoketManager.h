//
//  FRWebSoketManager.h
//  Friendly
//
//  Created by Sergey Borichev on 16.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#define kWSManagerMessageRecieved @"kWSManagerMessageRecieved"

@class FRWebSoketManager;

@protocol FRWSManagerDelegate <NSObject>

@required

- (void)wsManager:(FRWebSoketManager*) manager didRecieveMessage:(id) message;

@end

@interface FRWebSoketManager : NSObject

@property (nonatomic, weak) id<FRWSManagerDelegate> delegate;

+ (instancetype) shared;

- (BOOL) canSendMessage;
- (void) sendMessage: (id) message;
- (void) connect;
- (void) disconnect;
//- (void) reconnect;

@end
