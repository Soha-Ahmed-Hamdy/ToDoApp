//
//  Task.h
//  ToDoApp
//
//  Created by Soha Ahmed Hamdy on 07/04/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCoding,NSSecureCoding>

@property NSString *title;
@property NSString *desc;
@property NSString *priority;
@property NSDate *date;
@property NSString *state;
-(void) encodeWithCoder:(NSCoder *)coder;


@end

NS_ASSUME_NONNULL_END
