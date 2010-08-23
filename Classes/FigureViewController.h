//
//  FigureViewController.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Figure.h"

@interface FigureViewController : TTModelViewController {
  NSString *_key;
  TTImageView *_imageView;
  NSManagedObjectContext *_managedObjectContext;
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) TTImageView *imageView;
@property (nonatomic, copy) NSManagedObjectContext *managedObjectContext;

@end
