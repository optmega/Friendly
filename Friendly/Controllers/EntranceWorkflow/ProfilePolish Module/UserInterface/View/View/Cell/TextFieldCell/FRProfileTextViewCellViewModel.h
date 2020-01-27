//
//  FRProfileTextFieldCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

typedef NS_ENUM(NSInteger, FRProfileTextViewKeyType) {
    FRProfileTextViewKeyTypeText,
    FRProfileTextViewKeyTypeNumber,
};



@interface FRProfileTextViewCellViewModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subtitle;
@property (nonatomic, strong) NSString* dataString;
@property (nonatomic, assign) FRProfileTextViewKeyType keyType;
@property (nonatomic, assign) BOOL isRequiredField;
@property (nonatomic, assign) BOOL isInterestCell;
@property (nonatomic, assign) NSInteger countCharacter;
@property (nonatomic, assign) NSInteger maxCountCharacter;

@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isHideMode;
@end
