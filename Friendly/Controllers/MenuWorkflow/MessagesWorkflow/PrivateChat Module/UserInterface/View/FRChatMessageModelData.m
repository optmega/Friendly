//
//  FRChatMessageModelData.m
//  Friendly
//
//  Created by Sergey Borichev on 20.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRChatMessageModelData.h"

@implementation FRChatMessageModelData


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.messages = [NSMutableArray new];
        
//        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
//        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor bs_colorWithHexString:@"00B4FB"]];
//        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor bs_colorWithHexString:@"EAEDF2"]];
        
    }
    return self;
}



@end
