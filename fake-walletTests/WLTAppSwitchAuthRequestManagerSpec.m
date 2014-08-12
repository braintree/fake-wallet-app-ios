#import "WLTAppSwitchAuthRequestManager.h"

SpecBegin(WLTAppSwitchAuthRequestManager)

it(@"holds one auth request", ^{
    WLTAppSwitchAuthRequest *authRequest;
    WLTAppSwitchAuthRequestManager *manager = [[WLTAppSwitchAuthRequestManager alloc] init];
    [manager setCurrentAuthRequest:authRequest];
    expect(manager.currentAuthRequest).to.equal(authRequest);
});

it(@"acts as a singleton", ^{
    expect([WLTAppSwitchAuthRequestManager sharedManager]).to.beIdenticalTo([WLTAppSwitchAuthRequestManager sharedManager]);
});

SpecEnd