//
//  FigureViewController.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FigureViewController.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FigureViewController

@synthesize key = _key;
@synthesize imageView = _imageView;

- (id)initWithKey:(NSString*)key {
  if (self = [self init]) {
    self.key = key;
    self.title = key;
    self.imageView.urlPath = [NSString stringWithFormat:@"bundle://%@-250.png", self.key];
//    NSManagedObjectContext *context = [AppDelegate instance].managedObjectContext;
//    if (context != NULL) {
//      Figure *figure = (Figure *)[NSEntityDescription insertNewObjectForEntityForName:@"Figure" inManagedObjectContext:context];
//    }
//    [context release];
  }
  return self;
}

- (id)init {
  if (self = [super init]) {
    self.title = @"Minifigure";
    _imageView = [[TTImageView alloc] initWithFrame:CGRectMake(30, 30, 0, 0)];
    _imageView.autoresizesToImage = YES;
    //self.imageView.center = CGPointMake(self.view.width/2, 150);
    [self.view addSubview:_imageView];
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_key);
  TT_RELEASE_SAFELY(_imageView);
  [super dealloc];
}

@end

