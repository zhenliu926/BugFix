//
//  tintView.m
//  McTrackMobile
//
//  Created by Yunas Qazi on 12/31/11.
//  Copyright (c) 2011 Style360. All rights reserved.
//

#import "ProcessingView.h"
#import <QuartzCore/QuartzCore.h>

static ProcessingView *processingView;

@implementation ProcessingView


-(void) setBasicConstants
{
	
	CGRect frame= CGRectMake(85, 175, 32, 32);
	
	UIActivityIndicatorView * activitySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activitySpinner.hidden = NO;
	activitySpinner.center = CGPointMake(frame.size.width/2, (frame.size.height/2));
	activitySpinner.hidesWhenStopped = YES;
	[activitySpinner setBackgroundColor:[UIColor clearColor]];
	
	tintView = [[UIView alloc]initWithFrame:frame];
	tintView.backgroundColor = [UIColor blackColor];
	tintView.alpha = 0.4;
	tintView.clipsToBounds =  YES;
	
	[tintView.layer setCornerRadius:5.0f];
	
	[tintView addSubview:activitySpinner];
	[activitySpinner startAnimating];
}


+(ProcessingView *) instance 
{
	if (!processingView) {

		processingView = [[ProcessingView alloc]init];
		[processingView setBasicConstants];
	}
	return processingView;
}

-(void) showTintView
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
    {
        return;
    }
    
	UIWindow *window = 	[[[UIApplication sharedApplication] delegate] window];
	[[[[UIApplication sharedApplication] delegate] window] addSubview:tintView];
	[tintView setCenter:CGPointMake(window.center.x, window.center.y)];
    UIWindow* mWindow = [[UIApplication sharedApplication] keyWindow];
    [mWindow setUserInteractionEnabled:NO];
}

-(void) hideTintView
{
    if (!keepOnShowing)
    {
        UIWindow* mWindow = [[UIApplication sharedApplication] keyWindow];
        [mWindow setUserInteractionEnabled:YES];
        [tintView removeFromSuperview];
    }
}

-(void) forceHideTintView
{
    keepOnShowing = NO;
    UIWindow* mWindow = [[UIApplication sharedApplication] keyWindow];
    [mWindow setUserInteractionEnabled:YES];
	[tintView removeFromSuperview];
}

-(void) forceShowTintView
{
    if (![[SharedManager sharedManager] isNetworkAvailable])
    {
        return;
    }
    
    keepOnShowing = YES;
    
    UIWindow *window = 	[[[UIApplication sharedApplication] delegate] window];
	[[[[UIApplication sharedApplication] delegate] window] addSubview:tintView];
	[tintView setCenter:CGPointMake(window.center.x, window.center.y)];
    UIWindow* mWindow = [[UIApplication sharedApplication] keyWindow];
    [mWindow setUserInteractionEnabled:NO];
}

-(void) showTintViewWithUserInteractionEnabled
{
    UIWindow *window = 	[[[UIApplication sharedApplication] delegate] window];
	[[[[UIApplication sharedApplication] delegate] window] addSubview:tintView];
	[tintView setCenter:CGPointMake(window.center.x, window.center.y)];
    UIWindow* mWindow = [[UIApplication sharedApplication] keyWindow];
    [mWindow setUserInteractionEnabled:YES];
}

@end
