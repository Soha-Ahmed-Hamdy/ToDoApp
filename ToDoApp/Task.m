//
//  Task.m
//  ToDoApp
//
//  Created by Soha Ahmed Hamdy on 07/04/2023.
//

#import "Task.h"

@implementation Task
-(void) encodeWithCoder:(NSCoder *)encoder{
    
    [encoder encodeObject:_title forKey:@"title"];
    [encoder encodeObject:_desc forKey:@"desc"];
    [encoder encodeObject:_state forKey:@"state"];
    [encoder encodeObject:_priority forKey:@"priority"];
    [encoder encodeObject:_date forKey:@"date"];

    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]){
        _title = [decoder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _desc = [decoder decodeObjectOfClass:[NSString class] forKey:@"desc"];
        _state = [decoder decodeObjectOfClass:[NSString class] forKey:@"state"];
        _priority = [decoder decodeObjectOfClass:[NSString class] forKey:@"priority"];
        _date = [decoder decodeObjectOfClass:[NSDate class] forKey:@"date"];

        
    }
    return self;
}
+ (BOOL)supportsSecureCoding{
    return YES;
}




@end
