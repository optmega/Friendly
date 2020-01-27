//
//  FRProfileDomainModel.h
//  Friendly
//
//  Created by Sergey Borichev on 23.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRBaseDomainModel.h"

@interface FRProfileDomainModel : FRBaseDomainModel


@property (nonatomic, strong) NSString* first_name;
@property (nonatomic, strong) NSString* last_name;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* job_title;
@property (nonatomic, strong) NSString* your_bio;
@property (nonatomic, strong) NSString* why_are_you_here;
@property (nonatomic, strong) NSString* mobile_number;
@property (nonatomic, strong) NSString* interests;
@property (nonatomic, strong) NSString* photo;
@property (nonatomic, strong) NSString* wall;
@property (nonatomic, strong) UIImage* photoImage;
@property (nonatomic, strong) UIImage* wallImage;
@property (nonatomic, strong) NSString* instagram_id;
@property (nonatomic, assign) BOOL private_account;
@property (nonatomic, assign) BOOL available_for_meet;

@end
