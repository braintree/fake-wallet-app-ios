#import <Foundation/Foundation.h>

extern NSString *WLTAppSwitchAuthRequestManagerDidUpdateAuthRequestNotification;

@class WLTAppSwitchAuthRequest;

@interface WLTAppSwitchAuthRequestManager : NSObject

@property (nonatomic, strong) WLTAppSwitchAuthRequest *currentAuthRequest;

+ (instancetype)sharedManager;

@end
