//
//  FRPrivateAccountCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@interface FRPrivateAccountCellViewModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subtitle;
@property (nonatomic, assign) BOOL isPrivateAccount;

@property (nonatomic, assign) BOOL isFullSeparator;
@end
