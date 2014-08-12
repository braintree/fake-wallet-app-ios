#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WLTAppSwitchWalletProvider) {
    WLTAppSwitchWalletProviderUnknown = 0,
    WLTAppSwitchWalletProviderVenmo,
    WLTAppSwitchWalletProviderPayPal,
};

@interface WLTAppSwitchAuthRequest : NSObject

+ (WLTAppSwitchAuthRequest *)authRequestWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApp;

/// Bundle identifier of app requesting an app-switch based authentication
@property (nonatomic, copy, readonly) NSString *sourceApplication;

/// Human readable name of app request an app-switchb ased authentication
@property (nonatomic, copy, readonly) NSString *sourceApplicationName;

/// Return URL to pass to openURL: to report success
///
/// @param payload Payload to pass back to source app in URL
- (NSURL *)successURLWithPayload:(NSDictionary *)payload;

/// Return URL to pass to openURL: to report success
- (NSURL *)cancelURL;

/// Return URL to pass to openURL: to report success
///
/// @param code Error code to pass back to source app in URL
/// @param message Error description to pass back to source app in URL
- (NSURL *)errorURLWithCode:(NSInteger)code message:(NSString *)message;

@property (nonatomic, strong, readonly) NSString *callbackScheme;

@property (nonatomic, assign) WLTAppSwitchWalletProvider walletProvider;

@end
