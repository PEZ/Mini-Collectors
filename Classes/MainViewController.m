//
//  TTLauncherViewController.m
//  Three20
//
//  Created by Rodrigo Mazzilli on 9/25/09.

#import <AVFoundation/AVFoundation.h>
#import "MainViewController.h"
#import "Figure.h"

BOOL scanningAvailable() {
  return [ZBarReaderViewController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

@interface MainViewController (Private)

static NSDictionary *_barcodes;
static MainViewController *_instance;

@end

@implementation MainViewController

+ (MainViewController *) getInstance {
  return _instance;
}

- (void) authenticationChanged {
  if ([GKLocalPlayer localPlayer].isAuthenticated) {
    //self.localPlayerAuthenticated = YES;
  }
  else {
    //self.gameCenterActivated = NO;
  }
}

- (void) registerForAuthenticationNotification {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver: self
         selector:@selector(authenticationChanged)
             name:GKPlayerAuthenticationDidChangeNotificationName
           object:nil];
}

- (void)showAchievmentsButton {
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"achievements.png"]
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(showAchievments)] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Mini Collector";
    if (scanningAvailable()) { 
      self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                 target:self
                                                 action:@selector(scanButtonTapped)] autorelease];
    }
    if ([AppDelegate isGameCenterAvailable]) {
      [self registerForAuthenticationNotification];
      if ([AppDelegate getInstance].gameCenterActivated) {
        [self authenticateLocalPlayer:@selector(resetAchievements)];
      }
      else {
        [self showAchievmentsButton];
      }
    }
  }
  _instance = self;
  return self;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  [_barcodes release];
  _barcodes = nil;
}

- (void)viewDidUnload {
  [_barcodes release];
}

- (void)dealloc {
  [super dealloc];
}

- (void) resetAchievements {
  [[AppDelegate getInstance] resetAchievements:self callBack:@selector(reportAchievements)];
}

- (void) reportAchievements {
  NSMutableDictionary *achievements = [NSMutableDictionary dictionaryWithCapacity:4];
  for (int series = 1; series < 3; series++) {
    for (int i = 1; i <= 16; i++) {
      NSString *key = [NSString stringWithFormat:@"%d-%d", series, i];
      Figure *figure = [Figure figureFromKey:key];
      if (figure != nil) {
        if (figure.count > 0) {
          for (GKAchievement *achievement in [figure reportAchievement]) {
            [achievements setObject:achievement forKey:achievement.identifier];
          };
        }
      }
    }
  }
  for (GKAchievement *achievement in [achievements allValues]) {
    [[AppDelegate getInstance] reportAchievementIdentifier:achievement.identifier percentComplete:achievement.percentComplete];
  }
}

- (void) authenticateLocalPlayer:(SEL)callBack {
  [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
    if (error == nil) {
      [AppDelegate getInstance].gameCenterActivated = YES;
      [self showAchievmentsButton];
      if (callBack != nil) {
        [self performSelector:callBack];
      }
    }
    else {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error contacting Game Center"
                                                      message:[NSString stringWithFormat:@"(%@)", [error localizedDescription]]
                                                     delegate:self cancelButtonTitle:@"Roger that" otherButtonTitles:nil, nil];
      [alert show];
      [alert release];
      
    }
  }];
}

- (void)showAchievments {
  GKLocalPlayer *lp = [GKLocalPlayer localPlayer];
  if (lp.authenticated) {
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != nil) {
      achievements.achievementDelegate = self;
      [self presentModalViewController: achievements animated: YES];
    }
    [achievements release];
  }
  else {
    [self authenticateLocalPlayer:@selector(showAchievments)];
  }

}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
  [self dismissModalViewControllerAnimated:YES];
}

- (NSArray *) launcherItemsForSeries:(int) series {
  NSMutableArray *items = [NSMutableArray array];
  for (int i = 1; i <= 16; i++) {
    NSString *key = [NSString stringWithFormat:@"%d-%d", series, i];
    Figure *figure = [Figure figureFromKey:key];
    if (figure != nil) {
      NSString *name = figure.name;
      NSString *image = [NSString stringWithFormat:@"bundle://%@-57.png", figure.key];
      NSString *url = [NSString stringWithFormat:@"mc://figure/%@", figure.key];
      TTLauncherItem *item = [[[TTLauncherItem alloc] initWithTitle:name image:image URL:url] autorelease];
      item.badgeNumber = figure.count;
      figure.launcherItem = item;
      [items addObject:item];
    }
  }
  return items;
}

- (NSArray *) launcherPages {
  
  return [NSArray arrayWithObjects:
          [self launcherItemsForSeries:1],[self launcherItemsForSeries:2], nil
         ];
}

- (void)loadView {
	[super loadView];

  _launcherView = [[LauncherView alloc] initWithFrame:self.view.bounds];
  
  _launcherView.backgroundColor = [UIColor blackColor];
  _launcherView.delegate = self;
  _launcherView.columnCount = 4;
  _launcherView.pages = [self launcherPages];
  [self.view addSubview:_launcherView];
}

- (void) openURLAction: (NSString *) URL  {
  TTURLAction *action = [TTURLAction actionWithURLPath:URL];
  [action setAnimated:YES];
	[[TTNavigator navigator] openURLAction:action];

}
- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	[self openURLAction: item.URL];
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
}


- (IBAction) scanButtonTapped {
  @try {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: 0
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [scanner setSymbology: ZBAR_EAN13
                   config: ZBAR_CFG_ENABLE
                       to: 1];
    
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
  }
  @catch (NSException * e) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera error"
                                                    message:@"Error initializing camera. (The camera on iPhone 3G is not supported)."
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
  }
  @finally {
  }
}

- (NSDictionary *) barcodes {
  if (_barcodes == nil) {
    _barcodes = [[NSDictionary alloc] initWithObjectsAndKeys:
                 @"2-1", @"673419146791",
                 @"2-2", @"673419146807",
                 @"2-3", @"673419146814",
                 @"2-4", @"673419146821",
                 @"2-5", @"673419146838",
                 @"2-6", @"673419146845",
                 @"2-7", @"673419146852",
                 @"2-8", @"673419146869",
                 @"2-9", @"673419146876",
                 @"2-10", @"673419146883",
                 @"2-11", @"673419146890",
                 @"2-12", @"673419147064",
                 @"2-13", @"673419147071",
                 @"2-14", @"673419147088",
                 @"2-15", @"673419147095",
                 @"2-16", @"673419147101",
                 @"2-1", @"673419146951",
                 @"2-2", @"673419146968",
                 @"2-3", @"673419146975",
                 @"2-4", @"673419146982",
                 @"2-5", @"673419146999",
                 @"2-6", @"67341947002",
                 @"2-6", @"673419147002",
                 @"2-7", @"673419147019",
                 @"2-8", @"673419147026",
                 @"2-9", @"673419147033",
                 @"2-10", @"673419147040",
                 @"2-11", @"673419147057",
                 @"2-12", @"673419146906",
                 @"2-13", @"673419146913",
                 @"2-14", @"673419146920",
                 @"2-15", @"673419146937",
                 @"2-16", @"673419146944",
                 @"1-1", @"673419133760",
                 @"1-2", @"673419133777",
                 @"1-3", @"673419133784",
                 @"1-4", @"673419133791",
                 @"1-5", @"673419133807",
                 @"1-6", @"673419133814",
                 @"1-7", @"673419133821",
                 @"1-8", @"673419133838",
                 @"1-9", @"673419133845",
                 @"1-10", @"673419133852",
                 @"1-11", @"673419133869",
                 @"1-12", @"673419133876",
                 @"1-13", @"673419133883",
                 @"1-14", @"673419133890",
                 @"1-15", @"673419133906",
                 @"1-16", @"673419134071",
                 @"1-16", @"6734191334071",
                 @"1-1", @"673419133913",
                 @"1-2", @"673419133920",
                 @"1-3", @"673419133944",
                 @"1-4", @"673419133951",
                 @"1-5", @"673419133968",
                 @"1-6", @"673419133975",
                 @"1-7", @"673419133982",
                 @"1-8", @"673419133999",
                 @"1-9", @"673419134002",
                 @"1-10", @"673419134019",
                 @"1-11", @"673419134026",
                 @"1-12", @"673419134033",
                 @"1-13", @"673419134040",
                 @"1-14", @"673419134057",
                 @"1-15", @"673419134064",
                 @"1-16", @"673419133937",                 
                 nil];
  }
  return _barcodes;
}

- (NSString *) trimLeadingZeroes:(NSString *) s {
  NSInteger i = 0;
  while ([[NSCharacterSet characterSetWithCharactersInString:@"0"] characterIsMember:[s characterAtIndex:i]]) {
    i++;
  }
  return [s substringFromIndex:i];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
  [reader dismissModalViewControllerAnimated: NO];

  id<NSFastEnumeration> results =
  [info objectForKey: ZBarReaderControllerResults];
  ZBarSymbol *symbol = nil;
  for(symbol in results)
    break;
  
  NSString *code = [self trimLeadingZeroes:symbol.data];    
  NSString *fig = [[self barcodes] valueForKey:code];
  if (fig != NULL) {
    [self openURLAction:[NSString stringWithFormat:@"mc://hidden/%@", fig]];
  }
  else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Barcode: %@", code]
                                                    message:@"That barcode doesn't match a Minifigure. (Tried the other barcode on the bag?)"
                                                   delegate:self cancelButtonTitle:@"Roger that" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
  }  
}

@end
