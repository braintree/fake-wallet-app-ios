#import "WLTManualAuthTableViewController.h"
#import "WLTAppSwitchAuthRequestManager.h"

const NSInteger WTLManualAuthTableViewControllerActionsSectionIndex = 1;
const NSInteger WTLManualAuthTableViewControllerActionSucceedRowIndex = 0;
const NSInteger WTLManualAuthTableViewControllerActionErrorRowIndex = 1;
const NSInteger WTLManualAuthTableViewControllerActionCancelRowIndex = 2;

@interface WLTManualAuthTableViewController ()
@property (nonatomic, strong) WLTAppSwitchAuthRequest *authRequest;
@end

@implementation WLTManualAuthTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self updateAuthRequest];
    NSLog(@"---------------viewDidLoad");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"---------------viewWillAppear");
    NSLog(@"Add Observer");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateAuthRequest)
                                                 name:WLTAppSwitchAuthRequestManagerDidUpdateAuthRequestNotification
                                               object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"---------------viewWillDisappear");
    NSLog(@"Remove Observer");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:WLTAppSwitchAuthRequestManagerDidUpdateAuthRequestNotification
                                                  object:nil];
}

- (void)updateAuthRequest
{
    NSLog(@"Update Auth Request");
    self.authRequest = [[WLTAppSwitchAuthRequestManager sharedManager] currentAuthRequest];
}

- (void)setAuthRequest:(WLTAppSwitchAuthRequest *)authRequest
{
    NSLog(@"Set Auth Request");
    _authRequest = authRequest;
    if (authRequest) {
        self.statusLabel.text = @"Handling Auth Request";
        self.originatingAppLabel.text = [NSString stringWithFormat:@"%@ (%@)", authRequest.sourceApplicationName, authRequest.sourceApplication];
        self.successURLLabel.text = [[authRequest successURLWithPayload:@{ @"auth_code": @"success-1234" }] absoluteString] ?: @"(nil)";
        self.errorURLLabel.text = [[authRequest errorURLWithCode:-1 message:@"Triggered manual error"] absoluteString] ?: @"(nil)";
        self.cancelURLLabel.text = [[authRequest cancelURL] absoluteString] ?: @"(nil)";
    } else {
        self.statusLabel.text = @"Unknown";
        self.successURLLabel.text = nil;
        self.errorURLLabel.text = nil;
        self.cancelURLLabel.text = nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == WTLManualAuthTableViewControllerActionsSectionIndex) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        NSURL *returnSwitchURL;
        switch (indexPath.row) {
            case WTLManualAuthTableViewControllerActionSucceedRowIndex: {
                NSLog(@"WLT Will Succeed");
                NSString *successTemplate = @"scheme://success?payload=eyJhY2NvdW50X2NvdW50cnkiOiJVUyIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwiZW52aXJvbm1lbnQiOiJtb2NrIiwiZXhwaXJlc19pbiI6LTEsImRpc3BsYXlfbmFtZSI6Im1vY2tEaXNwbGF5TmFtZSIsInNjb3BlIjoiaHR0cHM6XC9cL3VyaS5wYXlwYWwuY29tXC9zZXJ2aWNlc1wvcGF5bWVudHNcL2Z1dHVyZXBheW1lbnRzIiwiZW1haWwiOiJtb2NrZW1haWxhZGRyZXNzQG1vY2suY29tIiwiYXV0aG9yaXphdGlvbl9jb2RlIjoibW9ja1RoaXJkUGFydHlBdXRob3JpemF0aW9uQ29kZSIsInZlcnNpb24iOjEsImxhbmd1YWdlIjoiZW5fVVMiLCJhY2Nlc3NfdG9rZW4iOiIifQ%3D%3D&x-source=com.yourcompany.PPClient";
                NSURLComponents *components = [NSURLComponents componentsWithString:successTemplate];
                components.scheme = self.authRequest.callbackScheme;
                returnSwitchURL = components.URL;
                break;
            }
            case WTLManualAuthTableViewControllerActionErrorRowIndex: {
                NSLog(@"WLT Will Error");
                returnSwitchURL = [self.authRequest errorURLWithCode:-1 message:@"Triggered manual error"];
                break;
            }
            case WTLManualAuthTableViewControllerActionCancelRowIndex: {
                NSLog(@"WLT Will Cancel");
                NSString *cancelTemplate = @"scheme://cancel";
                NSURLComponents *components = [NSURLComponents componentsWithString:cancelTemplate];
                components.scheme = self.authRequest.callbackScheme;
                returnSwitchURL = components.URL;
                break;
            }
            default:
                break;
        }

        NSLog(@"Attempting app switch to: %@", returnSwitchURL);

        BOOL appSwitchPossible = [[UIApplication sharedApplication] canOpenURL:returnSwitchURL];
        if (!appSwitchPossible) {
            [[[UIAlertView alloc] initWithTitle:@"App Switch Troubles"
                                        message:[NSString stringWithFormat:@"canOpenURL:%@ failed", returnSwitchURL]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];

            return;
        }

        BOOL appSwitchSuccess = [[UIApplication sharedApplication] openURL:returnSwitchURL];
        if (!appSwitchSuccess) {
            [[[UIAlertView alloc] initWithTitle:@"App Switch Troubles"
                                        message:[NSString stringWithFormat:@"openURL:%@ failed", returnSwitchURL]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }

        // After successful app switch, we've consumed the auth request.
        [[WLTAppSwitchAuthRequestManager sharedManager] setCurrentAuthRequest:nil];
    }
}

- (IBAction)tappedRefresh:(id)sender {
    [self.tableView reloadData];
    [self updateAuthRequest];
}

@end
