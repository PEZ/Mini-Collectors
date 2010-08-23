//
//  Mini_CollectorAppDelegate.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-19.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#import "MainViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
  NSManagedObjectModel*         _managedObjectModel;
  NSManagedObjectContext*       _managedObjectContext;
  NSPersistentStoreCoordinator* _persistentStoreCoordinator;

  // App State
  BOOL                          _modelCreated;
  BOOL                          _resetModel;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, readonly)         NSString*               applicationDocumentsDirectory;


@end

