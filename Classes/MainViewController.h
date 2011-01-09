#import <Three20UI/TTModelViewController.h>
#import <GameKit/GameKit.h>
#import "LauncherView.h"
#import "AppDelegate.h"

@interface MainViewController : TTViewController <TTLauncherViewDelegate, LauncherViewDelegate, ZBarReaderDelegate, GKAchievementViewControllerDelegate> {
	LauncherView *_launcherView;
  NSArray *_launcherItems;
	NSInteger _currentPageIndex;
}

+ (MainViewController *) getInstance;

- (void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
- (void) authenticateLocalPlayer:(SEL)callBack;

@end
