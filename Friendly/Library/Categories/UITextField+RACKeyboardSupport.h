//
//  UITextField+RACKeyboardSupport.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@interface UITextField (RACKeyboardSupport)

- (RACSignal *)rac_keyboardReturnSignal;

@end
