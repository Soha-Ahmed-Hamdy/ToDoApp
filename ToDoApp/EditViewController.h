//
//  EditViewController.h
//  ToDoApp
//
//  Created by Soha Ahmed Hamdy on 07/04/2023.
//

#import "ViewController.h"
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : ViewController
@property Task *task;
@property long index;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityData;
@property (weak, nonatomic) IBOutlet UITextView *descData;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateData;
@property (weak, nonatomic) IBOutlet UITextField *titleData;
@property NSUserDefaults *def;
@property BOOL isSearch;


@end

NS_ASSUME_NONNULL_END
