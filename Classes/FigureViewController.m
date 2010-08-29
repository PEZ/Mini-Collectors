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

#define MARGIN 30

@implementation FigureViewController

@synthesize figure = _figure;
@synthesize imageView = _imageView;
//@synthesize downButton = _downButton;
//@synthesize upButton = _upButton;
@synthesize figureCountLabel = _figureCountLabel;

- (id)initWithKey:(NSString *)key {
  if (self = [self init]) {
    self.figure = [Figure figureFromKey:key];
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

- (void)layout {
  TTFlowLayout* flowLayout = [[[TTFlowLayout alloc] init] autorelease];
  flowLayout.padding = 2;
  flowLayout.spacing = 2;
  CGSize size = [flowLayout layoutSubviews:self.view.subviews forView:self.view];
  
  UIScrollView* scrollView = (UIScrollView*)self.view;
  scrollView.contentSize = CGSizeMake(scrollView.width, size.height);
}


- (void)updateCountLabel {
  _figureCountLabel.text = [NSString stringWithFormat:@"Collected: %d", _figure.count];
  [_figureCountLabel sizeToFit];
}

- (void)decreaseFigureCount {
  [_figure decreaseCount];
  [self updateCountLabel];
  [_figureCountLabel sizeToFit];
}

- (void)increaseFigureCount {
  [_figure increaseCount];
  [self updateCountLabel];
  [_figureCountLabel sizeToFit];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (void)dealloc {
  TT_RELEASE_SAFELY(_imageView);
	[super dealloc];
}

- (void) setupButton:(TTButton *)button withSelector:(SEL)selector addToView:(UIView *)aView {
  [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
  button.font = [UIFont boldSystemFontOfSize:20];
  [button sizeToFit];
  [aView addSubview:button];
}

- (void)loadView {
//  self.navigationItem.rightBarButtonItem
//  = [[[UIBarButtonItem alloc] initWithTitle:@"Increase Font" style:UIBarButtonItemStyleBordered
//                                     target:self action:@selector(increaseFont)] autorelease];
  
  UIScrollView* scrollView = [[[UIScrollView alloc] initWithFrame:TTNavigationFrame()] autorelease];
	scrollView.autoresizesSubviews = YES;
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  scrollView.backgroundColor = [UIColor blackColor];
  scrollView.canCancelContentTouches = NO;
  scrollView.delaysContentTouches = NO;
  self.view = scrollView;
  
  NSArray* widgets = [NSArray arrayWithObjects:
                      [TTButton buttonWithStyle:@"defaultButton:" title:@"-"],
                      [TTButton buttonWithStyle:@"defaultButton:" title:@"+"],
                      nil];

  [self setupButton:[widgets objectAtIndex:0] withSelector:@selector(decreaseFigureCount) addToView:scrollView];
  [self setupButton:[widgets objectAtIndex:1] withSelector:@selector(increaseFigureCount) addToView:scrollView];

  _figureCountLabel = [[TTLabel alloc] initWithText:@"0"],
  _figureCountLabel.font = [UIFont boldSystemFontOfSize:14];
  _figureCountLabel.backgroundColor = [UIColor whiteColor];
  [self updateCountLabel];
  [scrollView addSubview:_figureCountLabel];

  
  [self layout];

  _imageView = [[TTImageView alloc] initWithFrame:CGRectMake(MARGIN, ((TTButton *)[widgets objectAtIndex:0]).frame.size.height + 20, self.view.frame.size.width - 20, 50)];
  _imageView.autoresizesToImage = YES;
  _imageView.urlPath = [NSString stringWithFormat:@"bundle://%@-250.png", _figure.key];
  //self.imageView.center = CGPointMake(self.view.frame.size.width/2, 150);
  [self.view addSubview:_imageView];
}

@end

