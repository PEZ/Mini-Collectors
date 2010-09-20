// 
//  Figure.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Figure.h"
#import "AppDelegate.h"

#define kArchiveFile @"Figures.archive"

@implementation Figure 

@synthesize series = _series;
@synthesize key = _key;
@synthesize count = _count;
@synthesize name = _name;
@synthesize launcherItem = _launcherItem;

static NSDictionary *_figures;

- (Figure *) initFromDict:(NSDictionary *)dict {
  if (self = [super init]) {
    self.series = [[dict objectForKey:@"series"] intValue];
    self.key = [dict objectForKey:@"key"];
    self.count = [[dict objectForKey:@"count"] intValue];
    self.name = [dict objectForKey:@"name"];
  }
  return self;
}

- (void) countChanged {
  self.launcherItem.badgeNumber = self.count;
  [Figure saveFigures];  
}

- (NSString *) achievmentIdentifier {
  return [NSString stringWithFormat:@"F_%@", [self.key stringByReplacingOccurrencesOfString:@"-" withString:@"_"]];
}

- (void) increaseCount {
  self.count++;
  [[AppDelegate getInstance] reportAchievementIdentifier:[self achievmentIdentifier] percentComplete:100.0];
  [self countChanged];
}

- (void) decreaseCount {
  self.count = self.count == 0 ? 0 : self.count - 1;
  if (self.count == 0) {
    [[AppDelegate getInstance] reportAchievementIdentifier:[self achievmentIdentifier] percentComplete:0.0];
  }
  [self countChanged];
}

+ (NSString *) archivePath {
  AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  return [[delegate applicationDocumentsDirectory] stringByAppendingPathComponent:kArchiveFile];
}

+ (Figure *) figureFromKey:(NSString *)key {
  return [[self figures] objectForKey:key];
}

+ (Figure *) figureFromDict:(NSDictionary *)dict {
  return [[self alloc] initFromDict:dict];
}

+ (NSDictionary *) figures {
  return _figures;
}

+ (void) saveFigures {
  BOOL result = [NSKeyedArchiver archiveRootObject:_figures toFile:[self archivePath]];
  if (!result) {
    NSLog(@"FAIL: Saving figures to %@", [self archivePath]);
  }
}

+ (void) loadFigures {
  if ([[NSFileManager defaultManager] fileExistsAtPath:[self archivePath]]) {
    _figures = [[NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]] retain];
  }
  else {
    NSNumber *zero = [NSNumber numberWithInt: 0];
    NSNumber *one = [NSNumber numberWithInt: 1];
    NSNumber *two = [NSNumber numberWithInt: 2];
    _figures =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-1", @"key", @"Robot", @"name", zero, @"count", nil]] retain], @"1-1",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-2", @"key", @"Zombie", @"name", zero, @"count", nil]] retain], @"1-2",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-3", @"key", @"Ninja", @"name", zero, @"count", nil]] retain], @"1-3",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-4", @"key", @"Deep Sea Diver", @"name", zero, @"count", nil]] retain], @"1-4",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-5", @"key", @"Space Man", @"name", zero, @"count", nil]] retain], @"1-5",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-6", @"key", @"Forestman", @"name", zero, @"count", nil]] retain], @"1-6",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-7", @"key", @"Cowboy", @"name", zero, @"count", nil]] retain], @"1-7",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-8", @"key", @"Tribal Hunter", @"name", zero, @"count", nil]] retain], @"1-8",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-9", @"key", @"Magician", @"name", zero, @"count", nil]] retain], @"1-9",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-10", @"key", @"Wrestler", @"name", zero, @"count", nil]] retain], @"1-10",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-11", @"key", @"Cheerleader", @"name", zero, @"count", nil]] retain], @"1-11",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-12", @"key", @"Circus Clown", @"name", zero, @"count", nil]] retain], @"1-12",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-13", @"key", @"Demolition Dummy", @"name", zero, @"count", nil]] retain], @"1-13",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-14", @"key", @"Caveman", @"name", zero, @"count", nil]] retain], @"1-14",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-15", @"key", @"Skater", @"name", zero, @"count", nil]] retain], @"1-15",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-16", @"key", @"Nurse", @"name", zero, @"count", nil]] retain], @"1-16",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-1", @"key", @"Pharaoh", @"name", zero, @"count", nil]] retain], @"2-1",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-2", @"key", @"Vampire", @"name", zero, @"count", nil]] retain], @"2-2",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-3", @"key", @"Spartan", @"name", zero, @"count", nil]] retain], @"2-3",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-4", @"key", @"Disco Stu", @"name", zero, @"count", nil]] retain], @"2-4",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-5", @"key", @"Pop Star", @"name", zero, @"count", nil]] retain], @"2-5",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-6", @"key", @"Ringmaster", @"name", zero, @"count", nil]] retain], @"2-6",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-7", @"key", @"Lifeguard", @"name", zero, @"count", nil]] retain], @"2-7",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-8", @"key", @"Adventurer", @"name", zero, @"count", nil]] retain], @"2-8",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-9", @"key", @"Karate Master", @"name", zero, @"count", nil]] retain], @"2-9",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-10", @"key", @"Surfer", @"name", zero, @"count", nil]] retain], @"2-10",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-11", @"key", @"Witch", @"name", zero, @"count", nil]] retain], @"2-11",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-12", @"key", @"Mime", @"name", zero, @"count", nil]] retain], @"2-12",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-13", @"key", @"Motorcycle Cop", @"name", zero, @"count", nil]] retain], @"2-13",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-14", @"key", @"Mr. Maracas", @"name", zero, @"count", nil]] retain], @"2-14",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-15", @"key", @"Downhill Skier", @"name", zero, @"count", nil]] retain], @"2-15",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-16", @"key", @"Weightlifter", @"name", zero, @"count", nil]] retain], @"2-16",
     nil];
    [self saveFigures];
  }
}


#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)coder {
  //[super encodeWithCoder:coder];
  [coder encodeObject:_key forKey:@"key"];
  [coder encodeInteger:_series forKey:@"series"];
  [coder encodeObject:_name forKey:@"name"];
  [coder encodeInteger:_count forKey:@"count"];
}

- (id)initWithCoder:(NSCoder *)coder {
  self = [super init];
  _key = [[coder decodeObjectForKey:@"key"] retain];
  _series  = [coder decodeIntegerForKey:@"series"];
  _name = [[coder decodeObjectForKey:@"name"] retain];
  _count  = [coder decodeIntegerForKey:@"count"];
  return self;
}

@end
