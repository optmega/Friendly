//
//  FRPrivateChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatInteractorIO.h"

@interface FRPrivateChatInteractor : NSObject <FRPrivateChatInteractorInput>

@property (nonatomic, weak) id<FRPrivateChatInteractorOutput> output;
@property (nonatomic, strong, readonly) FREvent* eventForChat;
@property (nonatomic, strong) NSString* roomId;
@end

