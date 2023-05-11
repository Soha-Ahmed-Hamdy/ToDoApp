//
//  AddViewController.m
//  ToDoApp
//
//  Created by Soha Ahmed Hamdy on 07/04/2023.
//

#import "AddViewController.h"
#import "Task.h"



@interface AddViewController (){
}
@property NSUserDefaults *def;
@property (weak, nonatomic) IBOutlet UITextField *titleData;
@property (weak, nonatomic) IBOutlet UITextView *descData;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateData;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityData;
@property Task *task;
@property NSMutableArray <Task*> *tasksArr;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _task = [Task new];
    _def = [NSUserDefaults standardUserDefaults];
    NSError *error;
    NSData *saveData = [_def objectForKey:@"todoTasks" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _tasksArr = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:saveData error:&error];
    if(_tasksArr == nil){
        _tasksArr = [NSMutableArray new];
    }
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)saveData:(id)sender {
    if([_titleData.text  isEqual: @""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warrning" message:@"Don't Add An Empty Task Name" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:yes];
        
        [self presentViewController:alert animated:YES completion:^{    }];
    }else{
        _task.title = _titleData.text;
        _task.desc = _descData.text;
        _task.date = _dateData.date;
        switch (_priorityData.selectedSegmentIndex) {
            case 0:
                _task.priority = @"Low";
                break;
             case 1:
                _task.priority = @"Medium";
                break;
             case 2:
                _task.priority = @"High";
                break;
        }
        _task.state = @"ToDo";
        [_tasksArr addObject:_task];
        
        NSError *error;
        NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:_tasksArr requiringSecureCoding:YES error:&error];
        [_def setObject:savedData forKey:@"todoTasks"];
        ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"todo"];
        [viewController.table reloadData];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
