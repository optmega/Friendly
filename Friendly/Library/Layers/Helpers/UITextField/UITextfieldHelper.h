//
//  UITextfieldHelper.h
//  Friendly
//
//  Created by Sergey Borichev on 30.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface UITextfieldHelper : NSObject

+ (NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar;

@end
