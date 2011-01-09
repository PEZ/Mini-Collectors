//
//  LauncherView.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Three20UI/TTLauncherView.h>

@protocol LauncherViewDelegate

-(void)pageChanged:(NSInteger)index;

@end

@interface LauncherView : TTLauncherView {
	id<LauncherViewDelegate,NSObject> _delegate2;
}

@property (nonatomic, retain) id<LauncherViewDelegate,NSObject> delegate2;

@end
