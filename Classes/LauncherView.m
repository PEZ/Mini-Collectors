//
//  LauncherView.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LauncherView.h"
#import <Three20UI/UIViewAdditions.h>


@implementation LauncherView

@synthesize delegate2 = _delegate2;

- (void)dealloc {
  TT_RELEASE_SAFELY(_delegate2);

  [super dealloc];
}

// Disable editing
- (void)editHoldTimer:(NSTimer*)timer {
  _editHoldTimer = nil;
}

- (CGFloat)rowHeight {
  return round(_scrollView.height / 4);
}

#pragma mark -
#pragma mark UIPageControlDelegate

-(void)updatePagerWithContentOffset:(CGPoint)contentOffset {
	[super updatePagerWithContentOffset:contentOffset];
	if (self.delegate2 != nil) {
		[_delegate2 pageChanged:self.currentPageIndex];
	}
}

@end
