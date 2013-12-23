#import "CBKlasses.h"
@implementation CBKlasses
+ (NSArray *) all {
	
	NSMutableArray *array = [NSMutableArray array];
	
	int numClasses;
	Class *classes = NULL;
	
	numClasses = objc_getClassList(NULL, 0);
	if (numClasses > 0 )
	{
	    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
	    numClasses = objc_getClassList(classes, numClasses);
	    NSString *klass = nil;
	    for (int i = 0; i < numClasses; i++) {
	        klass = [NSString stringWithCString:class_getName(classes[i]) encoding:NSUTF8StringEncoding];
	        [array addObject:klass];
	    }
	    free(classes);
	}
	NSArray *retArray = [NSArray arrayWithArray: array];
	return retArray;
} 
@end