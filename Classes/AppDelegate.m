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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [Figure loadFigures];

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
	[super dealloc];
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
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillTerminate:(UIApplication *)application {
  [Figure saveFigures];
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

