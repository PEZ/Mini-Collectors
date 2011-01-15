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
#import "InAppPurchaseManager.h"
#import "SKProduct+LocalizedPrice.h"

#define MARGIN 5

@implementation FigureViewController

@synthesize figure = _figure;
@synthesize imageView = _imageView;
@synthesize figureCountLabel = _figureCountLabel;
@synthesize hidden = _hidden;

static TTButton *_purchaseButton;

- (BOOL)isSeries3Enabled {
  //[prefs synchronize];
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  return [prefs boolForKey:kIsSeries3ProductUnlocked];
}

- (void)createPurchaseActivityLabel {
	if (_purchaseActivityLabel == nil) {
		_purchaseActivityLabel = [[[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleBlackBox] retain];
		_purchaseActivityLabel.text = @"Purchase in progress...";
		[_purchaseActivityLabel sizeToFit];
		_purchaseActivityLabel.frame = CGRectMake(0, _imageView.bottom+20, self.view.width, _purchaseActivityLabel.height);
		[self.view addSubview:_purchaseActivityLabel];
	}
}

- (void)purchaseSeries3 {
	[self createPurchaseActivityLabel];
	_purchaseActivityLabel.hidden = NO;
	_purchaseButton.hidden = YES;
	InAppPurchaseManager *purchaseManager = [InAppPurchaseManager getInstance];
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(series3ContentProvided)
																							 name:kInAppPurchaseManagerSeries3ContentProvidedNotification
																						 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(purchaseFailed)
																							 name:kInAppPurchaseManagerTransactionFailedNotification
																						 object:nil];	
	if ([purchaseManager canMakePurchases]) {
		[purchaseManager purchaseSeries3];		
	}
	else {
		TTAlert(@"Purchases are not available.");
#if TARGET_IPHONE_SIMULATOR
		[purchaseManager provideContent:kInAppPurchaseSeries3UpgradeProductId];
#endif
	}
}

+ (void)createPurchaseButton {
	if (_purchaseButton == nil) {
		_purchaseButton = [[TTButton buttonWithStyle:@"defaultButton:" title:@"Unlock Series 3 support"] retain];
	}
}

+ (void)sizePurchaseButton {
	_purchaseButton.font = [UIFont systemFontOfSize:18];
	[_purchaseButton sizeToFit];
	_purchaseButton.width += 40;
	_purchaseButton.height += 15;
	_purchaseButton.left = (320 - _purchaseButton.width) / 2;
}

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

- (void)dealloc {
  TT_RELEASE_SAFELY(_imageView);
  TT_RELEASE_SAFELY(_figureCountLabel);
	//TT_RELEASE_SAFELY(_purchaseButton);
	TT_RELEASE_SAFELY(_purchaseActivityLabel);
	[super dealloc];
}

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
	if (self.figure.series != 3 || [self isSeries3Enabled]) {
		if (!_hidden || _figure.count > 0) {
			return [NSString stringWithFormat:@"bundle://%@-320.png", _figure.key];
		}
		else {
			return [NSString stringWithFormat:@"bundle://Hidden-%d.png", _figure.series];
		}
	}
	else {
		return [NSString stringWithFormat:@"bundle://Locked-%d.png", _figure.series];
	}
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
       [TTSolidBorderStyle styleWithColor:RGBACOLOR(12,140,21,0.9) width:1 next:
        [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(1, 7, 2, 7) next:
         [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:fontSize]
                              color:[UIColor whiteColor] next:nil]]]]]]]];
}

- (void)loadView {
  if (!_loaded) {
    _loaded = YES;

		if (self.figure.series != 3 || [self isSeries3Enabled]) {			
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
		}
		else {
			self.title = @"Series 3 is locked";
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

		if (self.figure.series == 3 && ![self isSeries3Enabled]) {
			[[self class] createPurchaseButton];
			[[self class] sizePurchaseButton];
			_purchaseButton.hidden = NO;
			_purchaseButton.top = _imageView.bottom + 20;
			[_purchaseButton removeTarget:nil action:@selector(purchaseSeries3) forControlEvents:UIControlEventTouchUpInside];
			[_purchaseButton addTarget:self action:@selector(purchaseSeries3) forControlEvents:UIControlEventTouchUpInside];			
			[scrollView addSubview:_purchaseButton];
		}
    else if (!_hidden) {
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

#pragma mark -
#pragma mark Notifications

-(void)series3ContentProvided {
	_loaded = NO;
	[self loadView];
}

-(void)purchaseFailed {
	_purchaseActivityLabel.hidden = YES;
	_purchaseButton.hidden = NO;
}

+(void)purchaseProductFetched {
	[[self class]createPurchaseButton];
	[_purchaseButton setTitle:[NSString stringWithFormat:@"%@",
														 [[[InAppPurchaseManager getInstance] series3Product] localizedPrice]]  forState:UIControlStateNormal];
	[self sizePurchaseButton];
}

@end

