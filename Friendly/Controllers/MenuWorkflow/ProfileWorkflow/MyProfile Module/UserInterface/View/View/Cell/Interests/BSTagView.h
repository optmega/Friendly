//
//  BSTagView.h
//  OAStackView
//
//  Created by Sergey Borichev on 26.03.16.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//


@interface BSTagView : UIView

- (void)updateWithTags:(NSArray*)tags;
+ (CGFloat)heightTagViewWithWidth:(CGFloat)width tags:(NSArray*)tags;

@property (nonatomic, assign) NSInteger countStack;
@property (nonatomic, assign) CGFloat labelHeight;

@end
