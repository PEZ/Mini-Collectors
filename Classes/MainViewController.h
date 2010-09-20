#import <Three20UI/TTModelViewController.h>
#import <GameKit/GameKit.h>
#import "LauncherView.h"
#import "AppDelegate.h"

@interface MainViewController : TTViewController <TTLauncherViewDelegate, ZBarReaderDelegate, GKAchievementViewControllerDelegate> {
	LauncherView *_launcherView;
  NSArray *_launcherItems;
}

+ (MainViewController *) getInstance;

- (void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
- (void) authenticateLocalPlayer:(SEL)callBack;

@end
