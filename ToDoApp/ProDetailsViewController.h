//
//  ProDetailsViewController.h
//  ToDoApp
//
//  Created by Soha Ahmed Hamdy on 16/04/2023.
//

#import "ViewController.h"
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProDetailsViewController : ViewController



@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityDet;
@property (weak, nonatomic) IBOutlet UITextField *titleDet;
@property (weak, nonatomic) IBOutlet UITextView *descDet;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateDet;
@property Task *task;
@property long index;
@property NSUserDefaults *def;
@property BOOL isSearch;




@end

NS_ASSUME_NONNULL_END
