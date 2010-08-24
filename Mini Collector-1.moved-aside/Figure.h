//
//  Figure.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Figure :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * series;

@end



