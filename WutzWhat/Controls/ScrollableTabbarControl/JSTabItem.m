//
//  JSTabItem.m
//  ScrollableTabBar
//
//  Created by James Addyman on 20/10/2010.
//  Copyright 2010 JamSoft. All rights reserved.
//

#import "JSTabItem.h"
#import <UIKit/uikit.h>

@implementation JSTabItem
    
@synthesize title = _title;
@synthesize color = _color;
@synthesize textColor = _textColor;
@synthesize image=_image;
@synthesize highlightedImage=_highlightedImage;

- (id)initWithTitle:(NSString *)title color:(UIColor*)color textColor:(UIColor *)textColor image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage;
{
	if ((self = [super init]))
	{
		self.title = title;
        self.textColor = textColor;
        self.color = color;
        self.image = image;
        self.highlightedImage = highlightedImage;
	}
	
	return self;
}

- (void)dealloc
{
	self.title = nil;
    self.textColor = nil;
    self.color = nil;
    self.image = nil;
    self.highlightedImage = nil;
}

@end
