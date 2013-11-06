//
//  InitialViewController.h
//  ViewDeckStoryboardExample
//
//  Created by Simon Rice on 10/10/2012.
//  Copyright (c) 2012 Simon Rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "CityViewController.h"
#import "WutzWhatListViewController.h"
#import "PerksViewController.h"
#import "TalksListViewController.h"
#import "CreditViewController.h"
#import "NotificationsViewController.h"
#import "FavouritesViewController.h"
#import "ProfileViewController.h"
#import "MenuViewController.h"
#import "TourViewController.h"

@interface InitialViewController : IIViewDeckController
{
    int type;
}

@property (nonatomic) int type;

@end
