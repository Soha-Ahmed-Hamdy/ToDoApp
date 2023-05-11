//
//  EditViewController.m
//  ToDoApp
//
//  Created by Soha Ahmed Hamdy on 07/04/2023.
//

#import "EditViewController.h"
#import "ProgressViewController.h"
#import "DoneViewController.h"

@interface EditViewController ()
@property NSMutableArray <Task*> *tasksArr;
@property NSMutableArray <Task*> *doneTasksArray;
@property NSMutableArray <Task*> *inPrograssTasksArray;
@property Task *inPrograssTask;
@property Task *doneTask;



@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error;
        
    _titleData.text = _task.title;
    _descData.text = _task.desc;
    _dateData.date = _task.date;
    if([_task.priority  isEqual: @"Low"]){
        _priorityData.selectedSegmentIndex = 0;
    }else if([_task.priority  isEqual: @"High"]){
        _priorityData.selectedSegmentIndex = 2;
    }else{
        _priorityData.selectedSegmentIndex = 1;
    }
    
    
    _inPrograssTask =[Task new];
    _doneTask =[Task new];
    _def = [NSUserDefaults standardUserDefaults];
    
    NSData *saveData = [_def objectForKey:@"todoTasks" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _tasksArr = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:saveData error:&error];
    
    NSData *saveInPrograssData = [_def objectForKey:@"inPrograssTasks" ];
    NSSet *inPrograssSet = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _inPrograssTasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:inPrograssSet fromData:saveInPrograssData error:&error];

    
    NSData *saveDoneData = [_def objectForKey:@"doneTasks" ];
    NSSet *doneSet = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _doneTasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:doneSet fromData:saveDoneData error:&error];
    
    if(_tasksArr == nil){
        _tasksArr = [NSMutableArray new];
    }
    if(_inPrograssTasksArray == nil){
        _inPrograssTasksArray = [NSMutableArray new];
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
- (IBAction)saveEdits:(id)sender {
    
    
    _task.title = _titleData.text;
    _task.desc = _descData.text;
    
    switch(_priorityData.selectedSegmentIndex){
        case 0:
            _task.priority = @"Low";
            break;;
        case 1:
            _task.priority = @"Medium";
            break;
        case 2:
            _task.priority = @"High";
    }
    _task.state = @"Todo";
    _task.date = _dateData.date;
    
        
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Edits" message:@"Save Edits" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        self->_tasksArr[self->_index] = self->_task;
        NSError *error;
        NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_tasksArr requiringSecureCoding:YES error:&error];
        [self->_def setObject:savedData forKey:@"tasks"];
        [self->_def synchronize];
        ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"todo"];
        [viewController.table reloadData];

        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [alert addAction:confirm];
    [self presentViewController: alert animated:YES completion:^{
        
    }];
    

}


- (IBAction)addToProgress:(id)sender {
    if([_titleData.text  isEqual: @""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warrning" message:@"Don't Add An Empty Task Name" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:yes];
        
        [self presentViewController:alert animated:YES completion:^{    }];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Edits" message:@"Do You Want To Save Edits" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self->_tasksArr removeObjectAtIndex:self->_index];
                NSError *error;
                NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_tasksArr requiringSecureCoding:YES error:&error];
                [self->_def setObject:savedData forKey:@"todoTasks"];

                self->_inPrograssTask.title = self->_titleData.text;
                self->_inPrograssTask.desc = self->_descData.text;
                self->_inPrograssTask.date = self->_dateData.date;
                switch (self->_priorityData.selectedSegmentIndex) {
                    case 0:
                        self->_inPrograssTask.priority = @"Low";
                        break;
                    case 1:
                        self->_inPrograssTask.priority = @"Medium";
                        break;
                    case 2:
                        self->_inPrograssTask.priority = @"High";
                        break;
                }
                self->_inPrograssTask.state = @"Progress";
        
                [self->_inPrograssTasksArray addObject: self->_inPrograssTask];
                NSData *savedInPrograssData = [NSKeyedArchiver archivedDataWithRootObject:self->_inPrograssTasksArray requiringSecureCoding:YES error:&error];
                [self->_def setObject:savedInPrograssData forKey:@"inPrograssTasks"];
        
            ProgressViewController *inPrograssViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"progress"];
            [inPrograssViewController.proTable reloadData];
        
            ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"todo"];
            [viewController.table reloadData];
            [self.navigationController pushViewController:viewController animated:YES];
            }];
            [alert addAction:yes];
            [self presentViewController:alert animated:YES completion:^{    }];
    }
}



- (IBAction)addToDone:(id)sender {
    
    if([_titleData.text  isEqual: @""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warrning" message:@"Don't Add An Empty Task Name" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:yes];
        
        [self presentViewController:alert animated:YES completion:^{    }];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Edits" message:@"Do You Want To Save Edits" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->_tasksArr removeObjectAtIndex:self->_index];
            NSError *error;
            NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_tasksArr requiringSecureCoding:YES error:&error];
            [self->_def setObject:savedData forKey:@"todoTasks"];

            self->_doneTask.title = self->_titleData.text;
            self->_doneTask.desc = self->_descData.text;
            self->_doneTask.date = self->_dateData.date;
            switch (self->_priorityData.selectedSegmentIndex) {
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
        
            ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"todo"];
            [viewController.table reloadData];
            [self.navigationController pushViewController:viewController animated:YES];
            }];
            [alert addAction:yes];
            [self presentViewController:alert animated:YES completion:^{    }];
        }
}


@end
