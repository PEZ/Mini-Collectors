//
//  Figure.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


@interface Figure : NSObject <NSCoding> {
  int _series;
  NSString *_key;
  int _count;
  NSString *_name;
}
@property (nonatomic) int series;
@property (nonatomic, retain) NSString *key;
@property (nonatomic) int count;
@property (nonatomic, retain) NSString *name;

+ (Figure *) figureFromKey:(NSString *)key;
+ (NSDictionary *) figures;
+ (void) saveFigures;
+ (void) loadFigures;

@end
