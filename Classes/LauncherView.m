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


// Disable editing
- (void)editHoldTimer:(NSTimer*)timer {
  _editHoldTimer = nil;
}

- (CGFloat)rowHeight {
  return round(_scrollView.height / 4);
}

@end
