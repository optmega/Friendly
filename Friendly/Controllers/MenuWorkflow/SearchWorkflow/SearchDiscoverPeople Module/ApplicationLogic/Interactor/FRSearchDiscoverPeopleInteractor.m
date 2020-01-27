//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchDiscoverPeopleInteractor.h"
#import "FRSearchTransportService.h"

@implementation FRSearchDiscoverPeopleInteractor

- (void)loadData
{
    [self.output dataLoaded];
}

- (void)loadUsersForString:(NSString*)string
{
    [FRSearchTransportService searchUsersWithString:string success:^(FRSearchUsers *users) {
        
        [self.output usersLoaded:users];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

@end
