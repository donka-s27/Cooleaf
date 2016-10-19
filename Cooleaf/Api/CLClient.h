//
//  NPClient.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "OVCHTTPRequestOperationManager.h"

@interface CLClient : OVCHTTPRequestOperationManager

@property (nonatomic, strong) NSString *notificationUDID;

+ (CLClient *)getInstance;
+ (void)setOrganizationHeader:(NSString *)header;
+ (NSString *)getBaseApiURL;
- (void)saveCookies;
- (void)loadCookies;

@end

