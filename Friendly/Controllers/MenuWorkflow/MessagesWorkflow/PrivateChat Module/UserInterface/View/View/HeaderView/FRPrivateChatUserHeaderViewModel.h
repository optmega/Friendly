//
//  FRPrivateChatUserHeaderViewModel.h
//  Friendly
//
//  Created by Dmitry on 11.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRUserModel;

@interface FRPrivateChatUserHeaderViewModel : NSObject

+ (instancetype)initWithModel:(UserEntity*)model;

- (void)updateImage:(UIImageView*)imageView;
- (NSAttributedString*)title;
- (NSString*)subtitle;

@end
