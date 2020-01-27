//
//  UITextField+RACKeyboardSupport.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "UITextField+RACKeyboardSupport.h"
#import <ReactiveCocoa/NSObject+RACDescription.h>

@implementation UITextField (RACKeyboardSupport)

- (RACSignal *)rac_keyboardReturnSignal {
    @weakify(self);
    return [[[[RACSignal
               defer:^{
                   @strongify(self);
                   return [RACSignal return:self];
               }]
              concat:[self rac_signalForControlEvents:UIControlEventEditingDidEndOnExit]]
             takeUntil:self.rac_willDeallocSignal]
            setNameWithFormat:@"%@ -rac_keyboardReturnSignal", [self rac_description]];
}

@end
