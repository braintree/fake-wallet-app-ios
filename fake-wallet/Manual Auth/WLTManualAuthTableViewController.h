#import <UIKit/UIKit.h>
#import "WLTAppSwitchAuthRequest.h"

@interface WLTManualAuthTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *originatingAppLabel;
@property (strong, nonatomic) IBOutlet UILabel *successURLLabel;
@property (strong, nonatomic) IBOutlet UILabel *cancelURLLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorURLLabel;
@end
