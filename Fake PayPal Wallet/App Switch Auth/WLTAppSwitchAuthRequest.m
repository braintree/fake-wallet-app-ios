#import "WLTAppSwitchAuthRequest.h"

#import <NSURL+QueryDictionary.h>

@interface WLTAppSwitchAuthRequest ()

@property (nonatomic, copy) NSString *sourceApplication;
@property (nonatomic, copy) NSString *sourceApplicationName;
@property (nonatomic, strong) NSURL *successURL;
@property (nonatomic, strong) NSURL *cancelURL;
@property (nonatomic, strong) NSURL *errorURL;

@end

@implementation WLTAppSwitchAuthRequest

+ (WLTAppSwitchAuthRequest *)authRequestWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApp {
    WLTAppSwitchAuthRequest *authRequest = [[WLTAppSwitchAuthRequest alloc] initWithURL:url sourceApplication:sourceApp];

    return authRequest;
}

- (instancetype)initWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    self = [super init];
    if (self) {
        self.sourceApplication = sourceApplication;
        self.sourceApplicationName = [url uq_queryDictionary][@"x-source"];

        self.successURL = [NSURL URLWithString:[url uq_queryDictionary][@"x-success"]];
        self.cancelURL = [NSURL URLWithString:[url uq_queryDictionary][@"x-cancel"]];
        self.errorURL = [NSURL URLWithString:[url uq_queryDictionary][@"x-error"]];

        if ([url.scheme isEqualToString:@"com.venmo.touch.v1"]) {
            self.walletProvider = WLTAppSwitchWalletProviderVenmo;
        } else if ([url.scheme isEqualToString:@"com.paypal.ppclient.touch.v1"]) {
            self.walletProvider = WLTAppSwitchWalletProviderPayPal;
        }
    }
    return self;
}

- (NSURL *)successURLWithPayload:(NSDictionary *)payload {
    return [self.successURL uq_URLByAppendingQueryDictionary:payload];
}

- (NSURL *)errorURLWithCode:(NSInteger)code message:(NSString *)message {
    if (!message) {
        return nil;
    }

    return [self.errorURL uq_URLByAppendingQueryDictionary:@{ @"errorCode": @(code), @"errorMessage": message }];
}

- (NSString *)callbackScheme {
    return self.successURL.scheme;
}

@end
