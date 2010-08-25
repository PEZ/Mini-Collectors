// 
//  Figure.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Figure.h"


@implementation Figure 

@dynamic series;
@dynamic key;
@dynamic count;
@dynamic name;

static NSArray *_defaultData;
static NSDictionary *_figureNames;

+ (NSArray *) defaultData {
  if (_defaultData == nil) {
    NSNumber *zero = [NSNumber numberWithInt: 0];
    NSNumber *one = [NSNumber numberWithInt: 1];
    NSNumber *two = [NSNumber numberWithInt: 2];
    _defaultData =
    [NSArray arrayWithObjects:
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-1", @"key", @"Robot", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-2", @"key", @"Zombie", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-3", @"key", @"Ninja", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-4", @"key", @"Deep Sea Diver", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-5", @"key", @"Space Man", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-6", @"key", @"Forestman", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-7", @"key", @"Cowboy", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-8", @"key", @"Tribal Hunter", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-9", @"key", @"Magician", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-10", @"key", @"Wrestler", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-11", @"key", @"Cheerleader", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-12", @"key", @"Circus Clown", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-13", @"key", @"Demolition Dummy", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-14", @"key", @"Caveman", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-15", @"key", @"Skater", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", one, @"series", @"1-16", @"key", @"Nurse", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-1", @"key", @"Pharaoh", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-2", @"key", @"Vampire", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-3", @"key", @"Spartan", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-4", @"key", @"Disco Stu", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-5", @"key", @"Pop Star", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-6", @"key", @"Ringmaster", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-7", @"key", @"Lifeguard", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-8", @"key", @"Adventurer", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-9", @"key", @"Karate Master", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-10", @"key", @"Surfer", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-11", @"key", @"Witch", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-12", @"key", @"Mime", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-13", @"key", @"Motorcycle Cop", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-14", @"key", @"Mr. Maracas", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-15", @"key", @"Downhill Skier", @"name", zero, @"count", nil],
     [NSDictionary dictionaryWithObjectsAndKeys:@"Figure", @"class", two, @"series", @"2-16", @"key", @"Weightlifter", @"name", zero, @"count", nil],
     nil];
  }
  return _defaultData;
}

+ (NSDictionary *) figureNames {
  if (_figureNames == nil) {
    _figureNames = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"Robot", @"1-1",
                    @"Zombie", @"1-2",
                    @"Ninja", @"1-3",
                    @"Deep Sea Diver", @"1-4",
                    @"Space Man", @"1-5",
                    @"Forestman", @"1-6",
                    @"Cowboy", @"1-7",
                    @"Tribal Hunter", @"1-8",
                    @"Magician", @"1-9",
                    @"Wrestler", @"1-10",
                    @"Cheerleader", @"1-11",
                    @"Circus Clown", @"1-12",
                    @"Demolition Dummy", @"1-13",
                    @"Caveman", @"1-14",
                    @"Skater", @"1-15",
                    @"Nurse", @"1-16",
                    @"Pharaoh", @"2-1",
                    @"Vampire", @"2-2",
                    @"Spartan", @"2-3",
                    @"Disco Stu", @"2-4",
                    @"Pop Star", @"2-5",
                    @"Ringmaster", @"2-6",
                    @"Lifeguard", @"2-7",
                    @"Adventurer", @"2-8",
                    @"Karate Master", @"2-9",
                    @"Surfer", @"2-10",
                    @"Witch", @"2-11",
                    @"Mime", @"2-12",
                    @"Motorcycle Cop", @"2-13",
                    @"Mr. Maracas", @"2-14",
                    @"Downhill Skier", @"2-15",
                    @"Weightlifter", @"2-16",
                    nil];    
  }
  return _figureNames;
}

@end
