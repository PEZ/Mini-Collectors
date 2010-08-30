//
//  FigureViewController.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FigureViewController.h"
#import "DefaultStyleSheet.h"
#import <Three20UI/UIViewAdditions.h>

#define MARGIN 5

@implementation FigureViewController

@synthesize figure = _figure;
@synthesize imageView = _imageView;
//@synthesize downButton = _downButton;
//@synthesize upButton = _upButton;
@synthesize figureCountLabel = _figureCountLabel;
@synthesize hidden = _hidden;

- (id)initWithKey:(NSString *)key {
  if (self = [self init]) {
    self.figure = [Figure figureFromKey:key];
    self.hidden = NO;
  }
  return self;
}

- (id)initHiddenWithKey:(NSString *)key {
  if (self = [self initWithKey:key]) {
    _hidden = YES;
  }
  return self;
}

- (id)init {
  if (self = [super init]) {
  }
  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// private

//- (void)layout {
//  TTFlowLayout* flowLayout = [[[TTFlowLayout alloc] init] autorelease];
//  flowLayout.padding = MARGIN;
//  flowLayout.spacing = MARGIN;
//  CGSize size = [flowLayout layoutSubviews:self.view.subviews forView:self.view];
//  
//  UIScrollView* scrollView = (UIScrollView*)self.view;
//  scrollView.contentSize = CGSizeMake(scrollView.width, size.height);
//}


- (void)updateCountLabel {
  _figureCountLabel.text = [NSString stringWithFormat:@"Collected: %d", _figure.count];
}

- (void)decreaseFigureCount {
  [_figure decreaseCount];
  [self updateCountLabel];
}

- (void)increaseFigureCount {
  [_figure increaseCount];
  [self updateCountLabel];
}

- (void) setupButton:(TTButton *)button withSelector:(SEL)selector atX:(float)x addToView:(UIView *)aView {
  [button setFrame:CGRectMake(x, 1, 30, 30)];
  [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
  button.font = [UIFont boldSystemFontOfSize:24];
  [aView addSubview:button];
}

- (NSString *) imagePath {
  return _hidden ? [NSString stringWithFormat:@"bundle://Hidden-%d.png", _figure.series] : [NSString stringWithFormat:@"bundle://%@-320.png", _figure.key];
}

- (void) unHide {
  self.hidden = NO;
  self.title = _figure.name;
  self.navigationItem.rightBarButtonItem = nil;
  _imageView.urlPath = [self imagePath];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (void)dealloc {
  TT_RELEASE_SAFELY(_imageView);
  TT_RELEASE_SAFELY(_figureCountLabel);
	[super dealloc];
}

- (void)loadView {
  if (_hidden) {
    self.navigationItem.rightBarButtonItem
    = [[[UIBarButtonItem alloc] initWithTitle:@"Reveal" style:UIBarButtonItemStyleBordered
                                       target:self action:@selector(unHide)] autorelease];
    self.title = _figure.count > 0 ? @"You have it" : @"Not collected!";
  }
  else {
    self.title = _figure.name;
  }

  
  UIScrollView* scrollView = [[[UIScrollView alloc] initWithFrame:TTNavigationFrame()] autorelease];
	scrollView.autoresizesSubviews = YES;
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  scrollView.backgroundColor = [UIColor blackColor];
  scrollView.canCancelContentTouches = NO;
  scrollView.delaysContentTouches = NO;
  self.view = scrollView;
  
  float imageY = 30;
  
  if (!_hidden) {
    NSArray* widgets = [NSArray arrayWithObjects:
                        [TTButton buttonWithStyle:@"defaultButton:" title:@"-"],
                        [TTButton buttonWithStyle:@"defaultButton:" title:@"+"],
                        nil];
    
    [self setupButton:[widgets objectAtIndex:0] withSelector:@selector(decreaseFigureCount) atX:285 addToView:scrollView];
    [self setupButton:[widgets objectAtIndex:1] withSelector:@selector(increaseFigureCount) atX:240 addToView:scrollView];
    
    _figureCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, 200, 25)] retain];
    _figureCountLabel.font = [UIFont systemFontOfSize:20];
    _figureCountLabel.textColor = [UIColor whiteColor];
    _figureCountLabel.backgroundColor = [UIColor blackColor];
    
    [self updateCountLabel];
    
    [scrollView addSubview:_figureCountLabel];
    
    imageY = ((TTButton *)[widgets objectAtIndex:0]).frame.size.height + 20;
  }

  _imageView = [[TTImageView alloc] initWithFrame:CGRectMake(0, imageY, self.view.frame.size.width, 0)];
  _imageView.autoresizesToImage = YES;
  _imageView.urlPath = [self imagePath];
  
  [self.view addSubview:_imageView];
}

@end

