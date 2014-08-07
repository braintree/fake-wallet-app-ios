#import "WLTAppSwitchAuthRequestManager.h"

NSString *WLTAppSwitchAuthRequestManagerDidUpdateAuthRequestNotification = @"com.braintreepayments.wlt.WLTAppSwitchAuthRequestManagerDidEnqueueAuthRequestNotification";

@interface WLTAppSwitchAuthRequestManager ()
@end

@implementation WLTAppSwitchAuthRequestManager

+ (instancetype)sharedManager
{
    static WLTAppSwitchAuthRequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setCurrentAuthRequest:(WLTAppSwitchAuthRequest *)currentAuthRequest
{
    _currentAuthRequest = currentAuthRequest;
    NSLog(@"Post Notification");
    [[NSNotificationCenter defaultCenter] postNotificationName:WLTAppSwitchAuthRequestManagerDidUpdateAuthRequestNotification
                                                        object:nil];
}

@end