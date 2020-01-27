//
//  FRProfileDomainModel.m
//  Friendly
//
//  Created by Sergey Borichev on 23.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRProfileDomainModel.h"


static const struct
{
    __unsafe_unretained NSString *first_name;
    __unsafe_unretained NSString *last_name;
    __unsafe_unretained NSString *email;
    __unsafe_unretained NSString *job_title;
    __unsafe_unretained NSString *your_bio;
    __unsafe_unretained NSString *why_are_you_here;
    __unsafe_unretained NSString *mobile_number;
    __unsafe_unretained NSString *private_account;
    __unsafe_unretained NSString *interests;
    __unsafe_unretained NSString *photo;
    __unsafe_unretained NSString *wall;
    __unsafe_unretained NSString *instagram_id;
    __unsafe_unretained NSString* available_for_meet;
//    __unsafe_unretained NSString *instagram_images;
    
} FRProfileParametr =
{
    .first_name             = @"first_name",
    .last_name              = @"last_name",
    .email                  = @"email",
    .job_title              = @"job_title",
    .your_bio               = @"your_bio",
    .why_are_you_here       = @"why_are_you_here",
    .mobile_number          = @"mobile_number",
    .private_account        = @"private_account",
    .interests              = @"interests",
    .photo                  = @"photo",
    .wall                   = @"wall",
    .instagram_id           = @"instagram_id",
    .available_for_meet     = @"available_for_meet",
//    .instagram_images       = @"instagram_images",
};


@implementation FRProfileDomainModel

- (NSDictionary*)domainModelDictionary
{
    return @{
             
                FRProfileParametr.first_name : [NSObject bs_safeString:self.first_name],
                 FRProfileParametr.last_name : [NSObject bs_safeString:self.last_name],
                     FRProfileParametr.email : [NSObject bs_safeString:self.email],
                 FRProfileParametr.job_title : [NSObject bs_safeString:self.job_title],
                  FRProfileParametr.your_bio : [NSObject bs_safeString:self.your_bio],
          FRProfileParametr.why_are_you_here : [NSObject bs_safeString:self.why_are_you_here],
             FRProfileParametr.mobile_number : [NSObject bs_safeString:self.mobile_number],
           FRProfileParametr.private_account : @(self.private_account),
                 FRProfileParametr.interests : [NSObject bs_safeString:self.interests],
                      FRProfileParametr.wall : [NSObject bs_safeString:self.wall],
                     FRProfileParametr.photo : [NSObject bs_safeString:self.photo],
              FRProfileParametr.instagram_id : [NSObject bs_safeString:self.instagram_id],
        FRProfileParametr.available_for_meet : @(self.available_for_meet),
//          FRProfileParametr.instagram_images : self.instagram_images,
             };
}

@end
