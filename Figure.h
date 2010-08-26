//
//  Figure.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"
#import "AppDelegate.h"


@interface Figure : ExtendedManagedObject  {
}

+ (Figure *) figureFromKey:(NSString *)key;
+ (NSArray *) defaultData;
+ (NSDictionary *) figureNames;

@property (nonatomic, retain) NSNumber * series;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * name;

@end



