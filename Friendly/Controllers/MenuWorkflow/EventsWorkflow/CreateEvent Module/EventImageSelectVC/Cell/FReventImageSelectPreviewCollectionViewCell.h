//
//  FReventImageSelectPreviewCollectionViewCell.h
//  Friendly
//
//  Created by User on 30.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FReventImageSelectPreviewCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView* previewView;

-(void)updateWithUrl:(NSString*)url;

@end
