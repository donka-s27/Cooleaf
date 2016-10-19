//
//  NPClient.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLClient.h"
#import "CLEvent.h"
#import "CLUser.h"
#import "CLInterest.h"
#import "CLQuery.h"
#import "CLFeed.h"
#import "CLComment.h"
#import "SSKeychain.h"
#import "CLRegistration.h"
#import "CLFilePreview.h"

static NSString *const BASE_API_URL = @"http://cooleaf.com";
//@"http://testorg.staging.do.cooleaf.monterail.eu";
//@"http://api.staging.do.cooleaf.monterail.eu:80"
static NSString *const API_URL = @"http://api.cooleaf.com";
//@"http://testorg.staging.do.cooleaf.monterail.eu/api";
//@"http://api.staging.do.cooleaf.monterail.eu:80";
static NSString *const X_ORGANIZATION = @"X-Organization";
//http://api.staging.do.cooleaf.monterail.eu:80/v2/users.json?page=1&per_page=25

@implementation CLClient

#pragma mark - Initialization

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:[NSURL URLWithString:API_URL]];
    if (!self)
        return nil;
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return self;
}

# pragma mark - Singleton

+ (CLClient *)getInstance {
    static CLClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:API_URL]];
    });
    return _sharedInstance;
}

# pragma mark - modelClassesByResourcePath

/**
 *  Look carefully into this method fix Mantle issues
 *
 *  @return NSDictionary 
 */
+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"v2/authorize.json": [CLUser class],
             @"v2/events/*": [CLEvent class],
             @"v2/events/ongoing.json": [CLEvent class],
             @"v2/events/user/*": [CLEvent class],
             @"v2/users/*": [CLUser class],
             @"v2/users/me.json": [CLUser class],
             @"v2/users.json": [CLUser class],
             @"v2/interests.json": [CLInterest class],
             @"v2/interests/*/memberlist.json": [CLUser class],
             @"v2/interests/*/events.json": [CLEvent class],
             @"v2/interests/*": [CLInterest class],
             @"v2/search.json": [CLQuery class],
             @"v2/feeds/*": [CLFeed class],
             @"v2/comments/*": [CLComment class],
             @"v2/file_previews.json": [CLFilePreview class]
             };
}

# pragma mark - responseClassesByResourcePath

+ (NSDictionary *)responseClassesByResourcePath {
    return @{
             
             };
}

# pragma mark - setOrganizationHeader

+ (void)setOrganizationHeader:(NSString *)header {
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:header forHTTPHeaderField:X_ORGANIZATION];
    [self getInstance].requestSerializer = requestSerializer;
}

# pragma mark - getBaseApiURL

+ (NSString *)getBaseApiURL {
    return BASE_API_URL;
}

# pragma mark - Cookie Persistence - SWITCH OVER TO SSKEYCHAIN INSTEAD OF NSUSERDEFAULTS

- (void)saveCookies {
    //NSString *username = [[SSKeychain accountsForService:@"cooleaf"] valueForKey:@"acct"];
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
}

- (void)loadCookies {
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
}

@end

