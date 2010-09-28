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
  _figureCountLabel.text = [NSString stringWithFormat:@"%d", _figure.count];
}

- (void)decreaseFigureCount {
  [_figure decreaseCount];
  [self updateCountLabel];
}

- (void)increaseFigureCount {
  [_figure increaseCount];
  [self updateCountLabel];
}

- (void) setupButton:(TTButton *)button withSelector:(SEL)selector atX:(float)x atY:(float)y addToView:(UIView *)aView {
  [button setFrame:CGRectMake(x, y, 30, 30)];
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

- (TTStyle*)labelWithFontSize:(CGFloat)fontSize {
  return
  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:3] next:
   [TTInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) next:
    [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.8) blur:3 offset:CGSizeMake(0, 4) next:
     [TTReflectiveFillStyle styleWithColor:RGBACOLOR(12,140,21,0.9) next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) next:
       [TTSolidBorderStyle styleWithColor:[UIColor whiteColor] width:2 next:
        [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(1, 7, 2, 7) next:
         [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:fontSize]
                              color:[UIColor whiteColor] next:nil]]]]]]]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (void)dealloc {
  TT_RELEASE_SAFELY(_imageView);
  TT_RELEASE_SAFELY(_figureCountLabel);
	[super dealloc];
}

- (void)loadView {
  if (!_loaded) {
    _loaded = YES;

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
    
    float imageY = 5;
    _imageView = [[TTImageView alloc] initWithFrame:CGRectMake(0, imageY, self.view.frame.size.width, 0)];
    _imageView.autoresizesToImage = YES;
    _imageView.urlPath = [self imagePath];
    
    [self.view addSubview:_imageView];
    
    if (!_hidden) {
      float imageBottom = _imageView.frame.size.height + imageY;
      NSArray* widgets = [NSArray arrayWithObjects:
                          [TTButton buttonWithStyle:@"defaultButton:" title:@"-"],
                          [TTButton buttonWithStyle:@"defaultButton:" title:@"+"],
                          [[TTLabel alloc] initWithFrame:CGRectMake(135, imageBottom + 22, 50, 40)],
                          nil];
      [self setupButton:[widgets objectAtIndex:0] withSelector:@selector(decreaseFigureCount) atX:90 atY:imageBottom + 20 addToView:scrollView];
      [self setupButton:[widgets objectAtIndex:1] withSelector:@selector(increaseFigureCount) atX:200 atY:imageBottom + 20 addToView:scrollView];
      _figureCountLabel = [widgets objectAtIndex:2];
      _figureCountLabel.style = [self labelWithFontSize:25];
      
      [self updateCountLabel];
      
      [scrollView addSubview:_figureCountLabel];
    }
  }
}

@end

