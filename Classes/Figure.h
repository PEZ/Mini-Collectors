//
//  Figure.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Three20UI/Three20UI.h>

#define kTotalSeries 5

@interface Figure : NSObject <NSCoding> {
  int _series;
  NSString *_key;
  int _count;
  NSString *_name;
  TTLauncherItem *_launcherItem;
}
@property (nonatomic) int series;
@property (nonatomic, retain) NSString *key;
@property (nonatomic) int count;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) TTLauncherItem *launcherItem;
@property (readonly)  NSInteger number;

+ (Figure *) figureFromKey:(NSString *)key;
+ (Figure *) figureFromSeries:(uint)series withNum:(uint)num;
+ (NSDictionary *) figures;
+ (void) saveFigures;
+ (void) loadFigures;

- (void) increaseCount;
- (void) decreaseCount;
- (NSString *) achievmentIdentifier;
- (NSArray *) reportAchievements:(BOOL)isInteractive;

@end
