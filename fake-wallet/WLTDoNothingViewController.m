#import "WLTDoNothingViewController.h"

@implementation WLTDoNothingViewController

- (IBAction)tappedURL:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"wlt://x-callback-url/auth?x-success=http://placehold.it/320x300/fff/0e2%26text%3Dsuccess&x-error=http://placehold.it/320x300/fff/e13%26text%3Derror&x-cancel=http://placehold.it/320x300/fff/ddd%26text%3Dcancel"];
    [[UIApplication sharedApplication] openURL:url];
}

@end
