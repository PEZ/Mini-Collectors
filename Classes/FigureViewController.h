//
//  FigureViewController.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "Figure.h"

@interface FigureViewController : TTTableViewController <UIActionSheetDelegate> {
  Figure *_figure;
  TTImageView *_imageView;
  TTLabel *_figureCountLabel;
  BOOL _hidden;
  BOOL _loaded;
}

@property (nonatomic, retain) Figure *figure;
@property (nonatomic, retain) TTImageView *imageView;
@property (nonatomic, retain) TTLabel *figureCountLabel;
@property (nonatomic) BOOL hidden;

- (id)initWithKey:(NSString *)key;
- (id)initHiddenWithKey:(NSString *)key;

@end
