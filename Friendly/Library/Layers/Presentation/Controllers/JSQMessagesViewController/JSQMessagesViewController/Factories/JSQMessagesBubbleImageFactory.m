//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesBubbleImageFactory.h"

#import "UIImage+JSQMessages.h"
#import "UIColor+JSQMessages.h"
#import "FRStyleKit.h"


@interface JSQMessagesBubbleImageFactory ()

@property (strong, nonatomic, readonly) UIImage *bubbleImage;
@property (assign, nonatomic, readonly) UIEdgeInsets capInsets;

- (UIEdgeInsets)jsq_centerPointEdgeInsetsForImageSize:(CGSize)bubbleImageSize;

- (JSQMessagesBubbleImage *)jsq_messagesBubbleImageWithColor:(UIColor *)color flippedForIncoming:(BOOL)flippedForIncoming;

- (UIImage *)jsq_horizontallyFlippedImageFromImage:(UIImage *)image;

- (UIImage *)jsq_stretchableImageFromImage:(UIImage *)image withCapInsets:(UIEdgeInsets)capInsets;

@end



@implementation JSQMessagesBubbleImageFactory

#pragma mark - Initialization

- (instancetype)initWithBubbleImage:(UIImage *)bubbleImage capInsets:(UIEdgeInsets)capInsets
{
	NSParameterAssert(bubbleImage != nil);
    
	self = [super init];
	if (self) {
		_bubbleImage = bubbleImage;
        
//        if (UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsetsZero)) {
         if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsMake(29, 25, 29, 25), UIEdgeInsetsZero)) {
            _capInsets = [self jsq_centerPointEdgeInsetsForImageSize: CGSizeMake(bubbleImage.size.width, bubbleImage.size.height )];//bubbleImage.size];
        }
        else {
            _capInsets = UIEdgeInsetsMake(20, 23, 27, 20);//capInsets;
        }
	}
	return self;
}

- (instancetype)init
{
    return [self initWithBubbleImage:[UIImage jsq_bubbleCompactImage] capInsets:UIEdgeInsetsZero];
}

- (void)dealloc
{
    _bubbleImage = nil;
}

#pragma mark - Public

- (JSQMessagesBubbleImage *)outgoingMessagesBubbleImageWithColor:(UIColor *)color
{
    return [self jsq_messagesBubbleImageWithColor:color flippedForIncoming:NO];
}

- (JSQMessagesBubbleImage *)incomingMessagesBubbleImageWithColor:(UIColor *)color
{
    return [self jsq_messagesBubbleImageWithColor:color flippedForIncoming:YES];
}

#pragma mark - Private

- (UIEdgeInsets)jsq_centerPointEdgeInsetsForImageSize:(CGSize)bubbleImageSize
{
    // make image stretchable from center point
    CGPoint center = CGPointMake(bubbleImageSize.width / 2.0f, bubbleImageSize.height / 2.0f);
    return UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
}

- (JSQMessagesBubbleImage *)jsq_messagesBubbleImageWithColor:(UIColor *)color flippedForIncoming:(BOOL)flippedForIncoming
{
    NSParameterAssert(color != nil);
    
//    UIImage *normalBubble = [self.bubbleImage jsq_imageMaskedWithColor:color];
    
    
    
    UIImage *normalBubble = [[[FRStyleKit imageOfMessagesNewBlueBubble] jsq_imageMaskedWithColor:color] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//    UIImage *highlightedBubble = [self.bubbleImage jsq_imageMaskedWithColor:[color jsq_colorByDarkeningColorWithValue:0.12f]];
    
    
    
//    [[UIImage imageNamed:@"bubbleImageName.png"]
//     stretchableImageWithLeftCapWidth:15 topCapHeight:13];
    
     UIImage *highlightedBubble = [[[FRStyleKit imageOfMessagesNewBlueBubble] jsq_imageMaskedWithColor:color] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    
    if (flippedForIncoming) {
        normalBubble = [self jsq_horizontallyFlippedImageFromImage:normalBubble];
        highlightedBubble = [self jsq_horizontallyFlippedImageFromImage:highlightedBubble];
    }
    
    normalBubble = [self jsq_stretchableImageFromImage:normalBubble withCapInsets:self.capInsets];
    highlightedBubble = [self jsq_stretchableImageFromImage:highlightedBubble withCapInsets:self.capInsets];
    
    return [[JSQMessagesBubbleImage alloc] initWithMessageBubbleImage:normalBubble highlightedImage:highlightedBubble];
}

- (UIImage *)jsq_horizontallyFlippedImageFromImage:(UIImage *)image
{
    return [UIImage imageWithCGImage:image.CGImage
                               scale:image.scale
                         orientation:UIImageOrientationUpMirrored];
}

- (UIImage *)jsq_stretchableImageFromImage:(UIImage *)image withCapInsets:(UIEdgeInsets)capInsets
{
    return [image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
}

@end
