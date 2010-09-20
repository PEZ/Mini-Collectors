//
//  Mini_CollectorAppDelegate.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-19.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "DefaultStyleSheet.h"
#import "Figure.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate

@synthesize gameCenterActivated = _gameCenterActivated;
@synthesize gameCenterObjects = _gameCenterObjects;
@synthesize achievementsDictionary = _achievementsDictionary;

static AppDelegate *_instance;

+ (AppDelegate *)getInstance {
  return _instance;
}

+ (BOOL) isGameCenterAvailable {
  Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
  
  NSString *reqSysVer = @"4.1";
  NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
  BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
  
  return (gcClass && osVersionSupported);
}

- (NSString *) archivePath {
  return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:kMiniCollectorDataFile];
}

- (void) loadAchievements {
  [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
     if (error == nil) {
       for (GKAchievement* achievement in achievements) {
         [self.achievementsDictionary setObject: achievement forKey: achievement.identifier];
       }
     }
   }];
}

- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier {
  GKAchievement *achievement = [self.achievementsDictionary objectForKey:identifier];
  if (achievement == nil) {
    achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
    [self.achievementsDictionary setObject:achievement forKey:achievement.identifier];
  }
  return [[achievement retain] autorelease];
}

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent {
  if ([AppDelegate isGameCenterAvailable]) {
    GKAchievement *achievement = [self getAchievementForIdentifier: identifier];
    if (achievement) {
      achievement.percentComplete = percent;
      [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
          NSLog(@"Error reporting achievement: %@", [error localizedDescription]);
          // Retain the achievement object and try again later (not shown).
        }
      }];
    }
  }
}

- (void) loadGameCenterInfo {
  NSDictionary *data;
  if ([[NSFileManager defaultManager] fileExistsAtPath:[self archivePath]]) {
    data = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]] retain];
    self.gameCenterActivated = [(NSNumber *)[data objectForKey:@"gameCenterActivated"] boolValue];
    self.gameCenterObjects = [data objectForKey:@"gameCenterObjects"];
  }
  else {
    self.gameCenterActivated = NO;
    self.gameCenterObjects = [NSMutableArray arrayWithObjects:nil];    
  }
}

- (void) saveGameCenterInfo {
  NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithBool:self.gameCenterActivated], @"gameCenterActivated",
                        self.gameCenterObjects, @"gameCenterObjects", nil];
  BOOL result = [NSKeyedArchiver archiveRootObject:data toFile:[self archivePath]];
  if (!result) {
    NSLog(@"FAIL: Saving figures to %@", [self archivePath]);
  }  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {
  _instance = self;
  self.achievementsDictionary = [[NSMutableDictionary alloc] init];
  [Figure loadFigures];
  [self loadGameCenterInfo];

  TTNavigator* navigator = [TTNavigator navigator];
  navigator.persistenceMode = TTNavigatorPersistenceModeNone;

  [TTStyleSheet setGlobalStyleSheet:[[[DefaultStyleSheet 
                                       alloc] init] autorelease]];
  
  TTURLMap* map = navigator.URLMap;

  [map from:@"*" toViewController:[MainViewController class]];
  [map from:@"mc://main" toViewController:[MainViewController class]];
  [map from:@"mc://figure/(initWithKey:)/" toViewController:[FigureViewController class]];
  [map from:@"mc://hidden/(initHiddenWithKey:)/" toViewController:[FigureViewController class]];
  
  if (![navigator restoreViewControllers]) {
    [navigator openURLAction:[TTURLAction actionWithURLPath:@"mc://main"]];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  [TTStyleSheet setGlobalStyleSheet:nil];
  [self.gameCenterObjects release];
	[super dealloc];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  if (self.gameCenterObjects == nil) {
    [self loadGameCenterInfo];
  }
  if (self.gameCenterActivated) {
    [[MainViewController getInstance] authenticateLocalPlayer:nil];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)navigator:(TTNavigator*)navigator shouldOpenURL:(NSURL*)URL {
  return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
  return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidEnterBackground:(UIApplication *)application {
  [Figure saveFigures];
  [self saveGameCenterInfo];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillTerminate:(UIApplication *)application {
  [Figure saveFigures];
  [self saveGameCenterInfo];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Application's documents directory


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)applicationDocumentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
    lastObject];
}


@end

