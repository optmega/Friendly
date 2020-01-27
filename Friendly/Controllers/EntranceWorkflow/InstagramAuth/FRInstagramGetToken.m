//
//  FRInstagramGetToken.m
//  Friendly
//
//  Created by User on 01.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRInstagramGetToken.h"


@implementation FRInstagramGetToken
//
//+ (NSString*) getRequest
//{
////    https://api.instagram.com/oauth/authorize?client_id=b3c594f2f12843a2898baad0bcb786f4&response_type=code&client=touch&redirect_uri=http://google.com
//    NSString* InstagramAuthURL = @"https://api.instagram.com/oauth/authorize?client_id=";
//    NSString *loginURLString = [NSString stringWithFormat:@"%@%@%@%@",
//                                InstagramAuthURL,
//                                kClientID, @"response_type=code&client=touch&redirect_uri=",
//                                kRedirectURI];
//    return loginURLString;
//}
//
//- (NSDictionary *)queryStringParametersFromString:(NSString*)string {
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [[string componentsSeparatedByString:@"&"] enumerateObjectsUsingBlock:^(NSString * param, NSUInteger idx, BOOL *stop) {
//        NSArray *pairs = [param componentsSeparatedByString:@"="];
//        if ([pairs count] != 2) return;
//        
//        NSString *key = [pairs[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSString *value = [pairs[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [dict setObject:value forKey:key];
//    }];
//    return dict;
//}
//
//
//+ (NSString*)receivedValidAccessTokenFromURL:(NSURLRequest *)request
//                                  error:(NSError *__autoreleasing *)error
//{
//    
////        NSURL *appRedirectURL = [NSURL URLWithString:self.appRedirectURL];
//        NSURL *url = request.URL;
//        NSString *token = [self queryStringParametersFromString:url.fragment][@"access_token"];
//        if (token)
//        {
//            return token;
//        }
//        else
//        {
//            NSString *localizedDescription = NSLocalizedString(@"Authorization not granted.", @"Error notification to indicate Instagram OAuth token was not provided.");
////            *error = [NSError errorWithDomain:InstagramKitErrorDomain
////                                         code:InstagramKitAuthenticationFailedError
////                                     userInfo:@{NSLocalizedDescriptionKey: localizedDescription}];
////            success = NO;
//            return @"";
//        }
//    
//}
//
//
//
@end
