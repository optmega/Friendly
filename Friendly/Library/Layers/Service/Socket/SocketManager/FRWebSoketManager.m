//
//  FRWebSoketManager.m
//  Friendly
//
//  Created by Sergey Borichev on 16.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRWebSoketManager.h"
#import "SRWebSocket.h"
#import "FRWSPrivateRequestDomainModel.h"
#import "FRDataBaseManager.h"

@interface FRWebSoketManager () <SRWebSocketDelegate>

@property (atomic, strong) SRWebSocket* socket;

@end

static NSString* const kStatus = @"status";

@implementation FRWebSoketManager

+ (instancetype) shared
{
    static FRWebSoketManager* sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[FRWebSoketManager alloc] init];
    });
    return sharedManager;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}


#pragma mark -
#pragma mark Public

- (BOOL)canSendMessage
{
    return (self.socket && self.socket.readyState == SR_OPEN);
}

- (void)sendMessage:(id) message
{
    if([self canSendMessage])
    {
        NSLog(@"FRWSMessageSent: %@", message);
        [self.socket sendString: message];
        return;
    }
    NSLog(@"Can't send message");
}

- (void) connect
{
    if(self.socket)
    {
        [self reconnect];
        return;
    }
   
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@:%@", WEB_SOCKET_SERVER_ADDRESS, SERVER_WS_PORT]]];
        NSArray* cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString: SERVER_URL_FOR_COOKIE]];
        NSLog(@"\n\n>>>>>>>>>>>>>COOKIE>>>>>>>>>>>%@\n\n",cookieArray);
        NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
        [request setAllHTTPHeaderFields:headers];
        
        self.socket = [[SRWebSocket alloc] initWithURLRequest: request];
        self.socket.delegate = self;
        [self.socket open];
}

- (void)disconnect
{
    if(self.socket)
    {
        [self.socket closeWithCode: 60044 reason: @""];
    }
    
    self.socket = nil;
}

- (void)reconnect
{
    NSLog(@"Trying to reconnect");
    [self disconnect];
    [self connect];
}


#pragma mark -
#pragma mark SRWebSocketDelegate

- (void)webSocket:(SRWebSocket*) webSocket didReceiveMessage:(id) message {
  
    if (webSocket != self.socket)
        return;
    
    NSError* jsonError;
    NSData* objectData;
    
    objectData = [message isKindOfClass: [NSString class]] ? [message dataUsingEncoding: NSUTF8StringEncoding] : message;
 
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData: objectData
                                                         options: NSJSONReadingMutableContainers
                                                           error: &jsonError];
    
    if (jsonError)
    {
        NSLog(@"Error occured while message encoding");
        return;
    }
    
    NSLog(@"FRWSMessageRecieved1111: %@", message);
    
    NSInteger status = [json[kStatus] integerValue];
    
//    if (status != 0)
//    {
//        switch (status) {
//            case 401:
//            {
//                return;
//                break;
//            }
//            default:
//                NSLog(@"Status: %ld", (long)status);
//                break;
//        }
//        return;
//    }
    
    if (status == 200 || status == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kWSManagerMessageRecieved object:json];
    }
}

- (void) webSocketDidOpen: (SRWebSocket*) webSocket
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

        [FRDataBaseManager synchronizeMessages];
    });
    
}

- (void)webSocket:(SRWebSocket*) webSocket didFailWithError:(NSError*) error
{
    if(webSocket != self.socket)
    {
        return;
    }
    
    NSLog(@"FRWSManager: Socket didFailWithError: %@",error);
    [self performSelector: @selector(reconnect) withObject: nil afterDelay: 3.0f];
}

- (void)webSocket:(SRWebSocket*) webSocket didCloseWithCode:(NSInteger) code reason:(NSString*) reason wasClean:(BOOL) wasClean
{
    if(webSocket == self.socket)
    {
        NSLog(@"FRWSManager: Socket didCloseWithCode: %ld\n and reason: %@",(long)code, reason);
        [self performSelector: @selector(reconnect) withObject: nil afterDelay: 3.0f];
    }
}




@end
