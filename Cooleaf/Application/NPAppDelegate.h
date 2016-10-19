//
//  NPAppDelegate.h
//  Cooleaf
//
//  Created by Bazyli Zygan on 14.12.2013.
//  Copyright (c) 2013 Nova Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMDrawerController.h>
#import "CLBaseNotificationRegistry.h"
#import "CLUser.h"


@interface NPAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (nonatomic) CLBaseNotificationRegistry *registry;
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) MMDrawerController *drawerController;
@property (nonatomic, assign) CLUser *user;

- (void)openDrawer;
- (void)setUserInDrawer:(CLUser *)user;
- (NSString*)calTimeDifference:(NSString*)startTime;
+ (NPAppDelegate*)sharedInstance;

@end
