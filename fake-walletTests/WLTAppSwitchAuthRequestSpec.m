#import "WLTAppSwitchAuthRequest.h"

SpecBegin(WLTAppSwitchAuthRequest)

describe(@"authRequestWithURL:sourceApplication", ^{
    it(@"retains the source application", ^{
        NSURL *url = [NSURL URLWithString:@"wlt-switch://x-callback-url/auth"];
        WLTAppSwitchAuthRequest *request = [WLTAppSwitchAuthRequest authRequestWithURL:url sourceApplication:@"com.example.app.source"];
        expect(request.sourceApplication).to.equal(@"com.example.app.source");
    });

    it(@"parses the application name", ^{
        NSURL *url = [NSURL URLWithString:@"com.braintreepayments.wlt.auth.v1://x-callback-url/auth?x-source=Some%20App"];
        WLTAppSwitchAuthRequest *request = [WLTAppSwitchAuthRequest authRequestWithURL:url sourceApplication:@"com.example.merchant-app"];
        expect([request sourceApplicationName]).to.equal(@"Some App");
    });

    it(@"parses the success return URL", ^{
        NSURL *url = [NSURL URLWithString:@"com.braintreepayments.wlt.auth.v1://x-callback-url/auth?x-success=merchant-app://wlt-switch-return/auth-success"];
        WLTAppSwitchAuthRequest *request = [WLTAppSwitchAuthRequest authRequestWithURL:url sourceApplication:@"com.example.merchant-app"];
        NSURL *expectedSuccessReturnURL = [NSURL URLWithString:@"merchant-app://wlt-switch-return/auth-success?auth_code=1234"];
        expect([request successURLWithPayload:@{ @"auth_code": @(1234) }]).to.equal(expectedSuccessReturnURL);
    });

    it(@"parses the cancel return URL", ^{
        NSURL *url = [NSURL URLWithString:@"com.braintreepayments.wlt.auth.v1://x-callback-url/auth?x-cancel=merchant-app://wlt-switch-return/auth-cancel"];
        WLTAppSwitchAuthRequest *request = [WLTAppSwitchAuthRequest authRequestWithURL:url sourceApplication:@"com.example.merchant-app"];
        NSURL *expectedCancelReturnURL = [NSURL URLWithString:@"merchant-app://wlt-switch-return/auth-cancel"];
        expect([request cancelURL]).to.equal(expectedCancelReturnURL);
    });

    it(@"parses the failure return URL", ^{
        NSURL *url = [NSURL URLWithString:@"com.braintreepayments.wlt.auth.v1://x-callback-url/auth?x-error=merchant-app://wlt-switch-return/auth-error"];
        WLTAppSwitchAuthRequest *request = [WLTAppSwitchAuthRequest authRequestWithURL:url sourceApplication:@"com.example.merchant-app"];
        NSURL *expectedErrorReturnURL = [NSURL URLWithString:@"merchant-app://wlt-switch-return/auth-error?errorMessage=Something%20failed&errorCode=1"];
        expect([request errorURLWithCode:1 message:@"Something failed"]).to.equal(expectedErrorReturnURL);
    });


    it(@"parses the absurd PayPal Wallet URL", ^{
        NSURL *url = [NSURL URLWithString:@"com.paypal.ppclient.touch.v1://authenticate?payload=eyJlbnZpcm9ubWVudF91cmwiOiJodHRwczpcL1wvd3d3LnN0YWdlMnN0ZDA0MS5zdGFnZS5wYXlwYWwuY29tOjExODg4IiwiYWdyZWVtZW50X3VybCI6Imh0dHA6XC9cL3d3dy5leGFtcGxlLmNvbVwvcHJpdmFjeV9wb2xpY3kiLCJhcHBfZ3VpZCI6IjBGRDFFMDlFLTAyNzQtNENGMi04QjkzLTNDODM3N0UxNkEzOSIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwic2NvcGUiOiJodHRwczpcL1wvdXJpLnBheXBhbC5jb21cL3NlcnZpY2VzXC9wYXltZW50c1wvZnV0dXJlcGF5bWVudHMiLCJlbnZpcm9ubWVudCI6ImN1c3RvbSIsInZlcnNpb24iOjEsInByaXZhY3lfdXJsIjoiaHR0cDpcL1wvd3d3LmV4YW1wbGUuY29tXC9wcml2YWN5X3BvbGljeSIsImNsaWVudF9pZCI6IkFUbFJ5UkJDUFpWM3RtVWlhdWJ5T0FKWlRjMWIwbThrd25WZldXSEtySlNfMmtTUWhrUEZyM0tlSVlCUiIsImFwcF9uYW1lIjoiMTQwd2luZG93cyJ9&x-source=com.braintreepayments.Braintree-Demo&x-success=com.braintreepayments.Braintree-Demo.payments://success&x-cancel=com.braintreepayments.Braintree-Demo.payments://cancel"];
        WLTAppSwitchAuthRequest *request = [WLTAppSwitchAuthRequest authRequestWithURL:url sourceApplication:@"com.braintreepayments.Braintree-Demo"];

        expect(request).to.beKindOf([WLTAppSwitchAuthRequest class]);
    });
});

SpecEnd