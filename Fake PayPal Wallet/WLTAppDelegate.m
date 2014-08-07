#import "WLTAppDelegate.h"

#import "WLTAppSwitchAuthRequest.h"
#import "WLTAppSwitchAuthRequestManager.h"

@implementation WLTAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"---------------application:openURL");
    WLTAppSwitchAuthRequest *request = [WLTAppSwitchAuthRequest authRequestWithURL:url sourceApplication:sourceApplication];
    if (request) {
        [[WLTAppSwitchAuthRequestManager sharedManager] setCurrentAuthRequest:request];
        [self.window setRootViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WLTHandleAppSwitchAuth"]];
    }

    return YES;
}

@end
