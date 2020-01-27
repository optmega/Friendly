//
//  FRMyProfileInterestsCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 26.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface FRMyProfileInterestsCellViewModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, strong) NSArray* tags;

@end
