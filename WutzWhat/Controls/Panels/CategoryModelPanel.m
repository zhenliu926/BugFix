//
//  CategoryModelPanel.m
//  WutzWhat
//
//  Created by Rafay on 11/16/12.
//
//

#import "CategoryModelPanel.h"
#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation CategoryModelPanel

@synthesize viewLoadedFromXib;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
	if ((self = [super initWithFrame:frame])) {
		
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
			
		[[NSBundle mainBundle] loadNibNamed:@"CategoryModelView" owner:self options:nil];
		
		NSArray *contentArray = [NSArray arrayWithObject:viewLoadedFromXib];
		
        //	int i = arc4random() % [contentArray count];
		v = [[contentArray objectAtIndex:0] retain];
		[self.contentView addSubview:v];
		
	}	
	return self;
}

- (void)dealloc {
    [v release];
	[viewLoadedFromXib release];
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[v setFrame:self.contentView.bounds];
}

@end
