//
//  FRMyProfileUserBioCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface FRMyProfileUserBioCellViewModel : NSObject

@property (nonatomic, strong) NSString* content;
@property (nonatomic, assign, readonly) CGFloat heightCell;

- (NSAttributedString*)attributedString;

@end
