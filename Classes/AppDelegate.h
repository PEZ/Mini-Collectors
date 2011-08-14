//
//  Mini_CollectorAppDelegate.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-19.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MainViewController.h"
#import "FigureViewController.h"
#import "BumpCodesViewController.h"

#define kMiniCollectorDataFile @"MiniCollector.data"
#define kNumStartsKey @"kNumStartsKey5"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
  BOOL _gameCenterActivated;
  NSArray *_gameCenterObjects;
  NSMutableDictionary *_achievementsDictionary;
}

@property (nonatomic) BOOL gameCenterActivated;
@property (nonatomic, retain) NSArray *gameCenterObjects;
@property(nonatomic, retain) NSMutableDictionary *achievementsDictionary;

+ (AppDelegate *)getInstance;
+ (BOOL) isGameCenterAvailable;
- (NSString *)applicationDocumentsDirectory;
- (void) loadAchievements;
- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier;
- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
- (void) resetAchievements:(NSObject *)target callBack:(SEL)callBack;
@end

