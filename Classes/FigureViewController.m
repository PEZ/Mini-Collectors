//
//  FigureViewController.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Three20UI/UIViewAdditions.h>

#import "FigureViewController.h"
#import "DefaultStyleSheet.h"
#import "AppDelegate.h"

#define MARGIN 5
#define kHaveAskedForReview @"kHaveAskedForReview8"
#define kAskForReviewThreshold 10


@implementation FigureViewController

@synthesize figure = _figure;
@synthesize imageView = _imageView;
@synthesize figureCountLabel = _figureCountLabel;
@synthesize hidden = _hidden;


- (id)initWithKey:(NSString *)key {
  if ((self = [self init])) {
    self.figure = [Figure figureFromKey:key];
    self.hidden = NO;
  }
  return self;
}

- (id)initHiddenWithKey:(NSString *)key {
  if ((self = [self initWithKey:key])) {
    _hidden = YES;
  }
  return self;
}

- (id)init {
  if ((self = [super init])) {
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_imageView);
  TT_RELEASE_SAFELY(_figureCountLabel);
	[super dealloc];
}

- (void)updateCountLabel {
  _figureCountLabel.text = [NSString stringWithFormat:@"%d", _figure.count];
}

- (void)decreaseFigureCount {
  [_figure decreaseCount];
  [self updateCountLabel];
}

-(void)considerAskForReview {
	if (![[NSUserDefaults standardUserDefaults] boolForKey:kHaveAskedForReview]) {
		if ([[NSUserDefaults standardUserDefaults] integerForKey:kNumStartsKey] >= kAskForReviewThreshold) {
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHaveAskedForReview];
			[[NSUserDefaults standardUserDefaults] synchronize];
			UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Thanks for using Mini Collector! Please consider rating this version on the App Store."
																												 delegate:self
																								cancelButtonTitle:@"Cancel"
																					 destructiveButtonTitle:nil
																								otherButtonTitles:@"Yes, I'll do it right now", nil];
			[sheet showInView:self.view];
		}
	}
}

-(void)gotoReviews {
	NSString *str = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=390113980&mt=8";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
		[self gotoReviews];
  }
}

- (void)increaseFigureCount {
  [_figure increaseCount];
  [self updateCountLabel];
	[self considerAskForReview];
}

- (void) setupButton:(TTButton *)button withSelector:(SEL)selector atX:(float)x atY:(float)y addToView:(UIView *)aView {
  [button setFrame:CGRectMake(x, y, 30, 30)];
  [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
  button.font = [UIFont boldSystemFontOfSize:24];
  [aView addSubview:button];
}

- (NSString *) imagePath {
  if (!_hidden || _figure.count > 0) {
    return [NSString stringWithFormat:@"bundle://%@-320.png", _figure.key];
  }
  else {
    return [NSString stringWithFormat:@"bundle://Hidden-%d.png", _figure.series];
  }
}

- (void) unHide {
  self.hidden = NO;
  self.title = _figure.name;
  self.navigationItem.rightBarButtonItem = nil;
  _imageView.urlPath = [self imagePath];
}

- (TTStyle*)figureCountLabelStyleWithFontSize:(CGFloat)fontSize {
  return
  [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:3] next:
   [TTInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) next:
    [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.8) blur:3 offset:CGSizeMake(0, 4) next:
     [TTReflectiveFillStyle styleWithColor:RGBACOLOR(12,140,21,0.9) next:
      [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) next:
       [TTSolidBorderStyle styleWithColor:RGBACOLOR(12,140,21,0.9) width:1 next:
        [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(1, 7, 2, 7) next:
         [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:fontSize]
                              color:[UIColor whiteColor] next:nil]]]]]]]];
}

- (void)loadView {
  if (!_loaded) {
    _loaded = YES;

    if (!_hidden) {
      self.title = _figure.name;
    }
    else {
      if (_figure.count == 0) {
        self.navigationItem.rightBarButtonItem
        = [[[UIBarButtonItem alloc] initWithTitle:@"Reveal" style:UIBarButtonItemStyleBordered
                                           target:self action:@selector(unHide)] autorelease];
      }
      self.title = _figure.count > 0 ? @"You have it" : @"Not collected!";
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
		float imageBottom = _imageView.frame.size.height + imageY;

    if (!_hidden) {
      NSArray* widgets = [NSArray arrayWithObjects:
                          [TTButton buttonWithStyle:@"defaultButton:" title:@"-"],
                          [TTButton buttonWithStyle:@"defaultButton:" title:@"+"],
                          [[TTLabel alloc] initWithFrame:CGRectMake(135, imageBottom + 22, 50, 40)],
                          nil];
      [self setupButton:[widgets objectAtIndex:0] withSelector:@selector(decreaseFigureCount) atX:90 atY:imageBottom + 20 addToView:scrollView];
      [self setupButton:[widgets objectAtIndex:1] withSelector:@selector(increaseFigureCount) atX:200 atY:imageBottom + 20 addToView:scrollView];
      _figureCountLabel = [widgets objectAtIndex:2];
      _figureCountLabel.style = [self figureCountLabelStyleWithFontSize:25];

      [self updateCountLabel];

      [scrollView addSubview:_figureCountLabel];
    }
  }
}


@end

