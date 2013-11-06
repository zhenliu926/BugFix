//
//  JSTabButton.m
//
//  Created by James Addyman on 29/04/2010.
//  Copyright 2010 JamSoft. All rights reserved.
//

#import "JSTabButton.h"
#import "UIImage+JSRetinaAdditions.h"

@implementation JSTabButton

@synthesize toggled = _toggled;
@synthesize normalBg = _normalBg;
@synthesize highlightedBg = _highlightedBg;

+ (JSTabButton *)tabButtonWithTitle:(NSString *)string color:(UIColor*)color textColor:(UIColor*)textColor image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage
{	
//	NSString *imageBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"images.bundle"];
//	NSBundle *imageBundle = [NSBundle bundleWithPath:imageBundlePath];
    
	static UIImage *normalButton = nil;
	static UIImage *highlightedButton = nil;
	
//	if (!normalButton)
//	{
//		NSLog(@"setting normal button");
		normalButton = image;
//	}
	
//	if (!highlightedButton)
//	{
		
		highlightedButton = highlightedImage;
//	}
	
	JSTabButton *button = (JSTabButton *)[self buttonWithType:UIButtonTypeCustom];
	
	[button setAdjustsImageWhenHighlighted:NO];
//    [button setTitleColor:textColor forState:UIControlStateNormal];
//    [button setTitleColor:textColor forState:UIControlStateApplication];
//    [button setTitleColor:textColor forState:UIControlStateHighlighted];
//    
//    
//    [button setBackgroundColor:color];
//	[[button titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
//	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
  [button setBackgroundImage:normalButton forState:UIControlStateNormal];
  [button setBackgroundImage:highlightedButton forState:UIControlStateHighlighted];
  button.highlightedBg = highlightedButton;
  button.normalBg = normalButton;
    
	[[button titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
	
	//[button setTitle:string forState:UIControlStateNormal];
	
	[button sizeToFit];
	CGRect frame = [button frame];
	frame.size.width += 0;
	frame.size.height = 44;
	[button setFrame:frame];
	
	[button setToggled:NO];
	
	return button;
}

- (void)setToggled:(BOOL)toggled
{
	_toggled = toggled;
	
	if (_toggled)
	{
		[self setBackgroundImage:self.highlightedBg forState:UIControlStateNormal];
		[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	else
	{
		[self setBackgroundImage:self.normalBg forState:UIControlStateNormal];
		[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
}

- (void)dealloc
{
	self.highlightedBg = nil;
	self.normalBg = nil;
}


@end
