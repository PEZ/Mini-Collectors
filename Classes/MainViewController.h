#import <Three20UI/TTModelViewController.h>
#import "LauncherView.h"

@interface MainViewController : TTViewController <TTLauncherViewDelegate, ZBarReaderDelegate> {
	LauncherView *_launcherView;
  NSArray *_launcherItems;
}

@end
