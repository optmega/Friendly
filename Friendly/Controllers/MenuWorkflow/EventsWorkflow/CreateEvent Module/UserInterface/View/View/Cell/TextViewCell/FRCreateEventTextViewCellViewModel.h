//
//  FRCreateEventTextViewCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventViewConstants.h"

@protocol FRCreateEventTextViewCellViewModelDelegate <NSObject>

- (void)changeTextContent:(NSString*)text type:(FRCreateEventCellType)type;

@end

@interface FRCreateEventTextViewCellViewModel : NSObject

@property (nonatomic, weak) id<FRCreateEventTextViewCellViewModelDelegate> delegate;
@property (nonatomic, strong) NSString* placeholder;
@property (nonatomic, assign) FRCreateEventCellType type;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, assign) NSInteger maxCharacter;

- (void)changeText:(NSString*)text;

@end
