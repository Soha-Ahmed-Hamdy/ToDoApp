//
//  ProDetailsViewController.m
//  ToDoApp
//
//  Created by Soha Ahmed Hamdy on 16/04/2023.
//

#import "ProDetailsViewController.h"
#import "DoneViewController.h"
#import "Task.h"
#import "ProgressViewController.h"

@interface ProDetailsViewController ()
@property NSMutableArray <Task*> *tasksArr;
@property NSMutableArray <Task*> *doneTasksArray;
@property Task *doneTask;

@end

@implementation ProDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleDet.text =_task.title;
    _descDet.text = _task.desc;
    _dateDet.date = _task.date;
    if([_task.priority  isEqual: @"Low"]){
        _priorityDet.selectedSegmentIndex = 0;
    }else if([_task.priority  isEqual: @"Medium"]){
        _priorityDet.selectedSegmentIndex = 1;
    }else if([_task.priority  isEqual: @"High"]){
        _priorityDet.selectedSegmentIndex = 2;
    }
    _doneTask =[Task new];
    _def = [NSUserDefaults standardUserDefaults];
    NSError *error;
    NSData *saveData = [_def objectForKey:@"inPrograssTasks" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _tasksArr = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:saveData error:&error];
    
    NSData *saveDoneData = [_def objectForKey:@"doneTasks" ];
    NSSet *doneSet = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _doneTasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:doneSet fromData:saveDoneData error:&error];
    
    
    if(_tasksArr == nil){
        _tasksArr = [NSMutableArray new];
    }
    if(_doneTasksArray == nil){
        _doneTasksArray = [NSMutableArray new];
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
- (IBAction)addToDone:(id)sender {
    if([_titleDet.text  isEqual: @""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warrning" message:@"Don't Add An Empty Task Name" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:yes];
        
        [self presentViewController:alert animated:YES completion:^{    }];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Edits" message:@"Save Edits" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->_tasksArr removeObjectAtIndex:self->_index];
            NSError *error;
            NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_tasksArr requiringSecureCoding:YES error:&error];
            [self->_def setObject:savedData forKey:@"inPrograssTasks"];

            self->_doneTask.title = self->_titleDet.text;
            self->_doneTask.desc = self->_descDet.text;
            self->_doneTask.date = self->_dateDet.date;
            switch (self->_priorityDet.selectedSegmentIndex) {
                case 0:
                    self->_doneTask.priority = @"Low";
                    break;
                case 1:
                    self->_doneTask.priority = @"Medium";
                    break;
                case 2:
                    self->_doneTask.priority = @"High";
                    break;
            }
            self->_doneTask.state = @"Done";
        
            [self->_doneTasksArray addObject:self->_doneTask];
            NSData *savedDoneData = [NSKeyedArchiver archivedDataWithRootObject:self->_doneTasksArray requiringSecureCoding:YES error:&error];
            [self->_def setObject:savedDoneData forKey:@"doneTasks"];
        
            DoneViewController *doneViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"done"];
            [doneViewController.doneTable reloadData];
            ProgressViewController *prograssViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"progress"];
            [self.navigationController pushViewController:prograssViewController animated:YES];
        }];
        [alert addAction:yes];
        [self presentViewController:alert animated:YES completion:^{    }];
    }
    
}
- (IBAction)saveEdits:(id)sender {
    
    _task.title = _titleDet.text;
    _task.desc = _descDet.text;
    
    switch(_priorityDet.selectedSegmentIndex){
        case 0:
            _task.priority = @"Low";
            break;;
        case 1:
            _task.priority = @"Medium";
            break;
        case 2:
            _task.priority = @"High";
    }
    _task.state = @"Progress";
    _task.date = _dateDet.date;
    
        
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Edits" message:@"Save Edits" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        self->_tasksArr[self->_index] = self->_task;
        NSError *error;
        NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_tasksArr requiringSecureCoding:YES error:&error];
        [self->_def setObject:savedData forKey:@"tasks"];
        [self->_def synchronize];
        ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"progress"];
        [viewController.table reloadData];

        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [alert addAction:confirm];
    [self presentViewController: alert animated:YES completion:^{
        
    }];
    

}

@end
