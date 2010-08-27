//
//  FigureViewController.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FigureViewController.h"
#import "Three20Style/TTBevelBorderStyle.h"

#define MARGIN 30

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FigureViewController

@synthesize figure = _figure;
@synthesize imageView = _imageView;
@synthesize downButton = _downButton;
@synthesize upButton = _upButton;

- (id)initWithKey:(NSString *)key {
  if (self = [self init]) {
    self.figure = [Figure figureFromKey:key];
    self.title = self.figure.name;
    self.imageView.urlPath = [NSString stringWithFormat:@"bundle://%@-250.png", self.figure.key];
  }
  return self;
}

- (id)init {
  if (self = [super init]) {
    self.title = @"Minifigure";
    _downButton = [TTButton buttonWithStyle:nil title:@"-"];
    [_downButton addTarget:self action:@selector(decreaseFigureCount) forControlEvents:UIControlEventTouchUpInside];
    [_downButton sizeToFit];
    //_upButton = [[TTButton buttonWithStyle:"bevelStyle" title:@"+"]];
    [self.view addSubview:_downButton];
    _imageView = [[TTImageView alloc] initWithFrame:CGRectMake(MARGIN, 100, self.view.frame.size.width - 20, 50)];
    _imageView.autoresizesToImage = YES;
    self.imageView.center = CGPointMake(self.view.frame.size.width/2, 150);
    [self.view addSubview:_imageView];
  }
  return self;
}

- (void)dealloc {
  //TT_RELEASE_SAFELY(_downButton);
  TT_RELEASE_SAFELY(_imageView);
  [super dealloc];
}

@end

