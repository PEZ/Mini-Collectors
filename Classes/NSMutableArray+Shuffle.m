//
//  NSMutableArray+Shuffle.m
//  Mini Collector
//
//  Created by Peter Stromberg on 2011-01-09.
//  Copyright 2011 NA. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"


	// Unbiased random rounding thingy.
static NSUInteger random_below(NSUInteger n) {
	NSUInteger m = 1;

	do {
		m <<= 1;
	} while(m < n);

	NSUInteger ret;

	do {
		ret = random() % m;
	} while(ret >= n);

	return ret;
}

@implementation NSMutableArray (ArchUtils_Shuffle)

- (void)shuffle {
    // http://en.wikipedia.org/wiki/Knuth_shuffle

	for(NSUInteger i = [self count]; i > 1; i--) {
		NSUInteger j = random_below(i);
		[self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
	}
}

@end
