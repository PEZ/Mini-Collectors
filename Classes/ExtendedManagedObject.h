
@interface ExtendedManagedObject : NSManagedObject {
  BOOL traversed;
}

@property (nonatomic, assign) BOOL traversed;

- (void) save;
- (NSDictionary *) toDictionary;
+ (ExtendedManagedObject *) managedObjectFromDictionary:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context;
+ (NSArray *) managedObjectsFromArray:(NSArray *)arr inContext:(NSManagedObjectContext *)context;

@end