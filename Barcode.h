//
//  Barcode.h
//  Mini Collector
//
//  Created by PEZ on 2010-08-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Figure;

@interface Barcode :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * eu;
@property (nonatomic, retain) NSString * us;
@property (nonatomic, retain) Figure * figure;

@end



