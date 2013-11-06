//
//  TintView.h
//  McTrackMobile
//
//  Created by Yunas Qazi on 12/31/11.
//  Copyright (c) 2011 Style360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessingView : NSObject{

	UIView *tintView;
    BOOL keepOnShowing;
    BOOL keepOnShowingFood;
    BOOL keepOnShowingShopping;
    BOOL keepOnShowingEvents;
    BOOL keepOnShowingNightlife;
    BOOL keepOnShowingServices;
    BOOL keepOnShowingConcierge;
}

+(ProcessingView *) instance ;
-(void) showTintView;
-(void) hideTintView;
-(void) forceHideTintView;
-(void) forceShowTintView;

-(void) showTintViewWithUserInteractionEnabled;
@end
