//
//  FRPrivateChatUserHeaderViewModel.m
//  Friendly
//
//  Created by Dmitry on 11.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatUserHeaderViewModel.h"
#import "FRUserModel.h"
#import "UIImageView+WebCache.h"
#import "FRDateManager.h"

@interface FRPrivateChatUserHeaderViewModel ()

@property (nonatomic, strong) UserEntity* model;
@property (nonatomic, strong) NSAttributedString* title;
@property (nonatomic, strong) NSString* subtitle;

@end

@implementation FRPrivateChatUserHeaderViewModel

+ (instancetype)initWithModel:(UserEntity*)model
{
    FRPrivateChatUserHeaderViewModel* viewModel = [FRPrivateChatUserHeaderViewModel new];
    viewModel.model = [[NSManagedObjectContext MR_defaultContext] objectWithID:model.objectID];
    
    return viewModel;
}

- (void)updateImage:(UIImageView*)imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:self.model.userPhoto]]];
}

- (NSAttributedString*)title
{
    
    if (!_title)
    {
        NSString* string = [NSString stringWithFormat:@"Friends with %@", self.model.firstName];
        NSRange range = [string rangeOfString:self.model.firstName];
        NSMutableAttributedString* attr = [[NSMutableAttributedString alloc]initWithString:string];
        [attr addAttribute:NSFontAttributeName value:FONT_PROXIMA_NOVA_BOLD(20) range:range];
        _title = attr;
    }
    return _title;
}

- (NSString*)subtitle
{
    if (!_subtitle)
    {
        _subtitle = self.model.friends_since != nil ? [NSString stringWithFormat:@"Friends since %@", [FRDateManager dateStringFromDate:self.model.friends_since withFormat:@"MM/dd/yyyy"]] : @"";
    }
    
    return _subtitle;
}

@end
