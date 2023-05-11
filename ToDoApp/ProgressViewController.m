//
//  ProgressViewController.m
//  ToDoApp
//
//  Created by Soha Ahmed Hamdy on 07/04/2023.
//

#import "ProgressViewController.h"
#import "Task.h"
#import "ProDetailsViewController.h"

@interface ProgressViewController ()
@property NSUserDefaults *def;
@property NSMutableArray <Task*> *tasksArr;
@property Task *selectedTask;
@property BOOL isfilered;
@property NSInteger secNum;
@property NSMutableArray<Task*> *lowList;
@property NSMutableArray<Task*> *medList;
@property NSMutableArray<Task*> *highList;
@property NSMutableArray<Task*> *todo;


@end

@implementation ProgressViewController

- (void)viewWillAppear:(BOOL)animated{
    _def = [NSUserDefaults standardUserDefaults];
    _secNum = 1;
    _isfilered = false;
    NSError *error;
    NSData *savedData = [_def objectForKey:@"inPrograssTasks" ];
    NSSet *set = [NSSet setWithArray:
                  @[[NSArray class],
                [Task class]
                  ]];
    _tasksArr = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];

    _lowList = [NSMutableArray new];
    _medList = [NSMutableArray new];
    _highList = [NSMutableArray new];
    _todo = [NSMutableArray new];
    for(Task *loopedTask in _tasksArr){
            [_todo addObject:loopedTask];
        
    }

    
    for(Task *loopedTask in _todo){
        if([loopedTask.priority  isEqual: @"Low"]){
            [_lowList addObject:loopedTask];
        }else if([loopedTask.priority  isEqual: @"High"]){
            [_highList addObject:loopedTask];
        }else{
            [_medList addObject:loopedTask];
        }
        
    }

    

    [self.table reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _def = [NSUserDefaults standardUserDefaults];
    _secNum = 1;
    _isfilered = false;
    NSError *error;
    NSData *savedData = [_def objectForKey:@"inPrograssTasks" ];
    NSSet *set = [NSSet setWithArray:
                  @[[NSArray class],
                [Task class]
                  ]];
    _tasksArr = (NSArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];

    _lowList = [NSMutableArray new];
    _medList = [NSMutableArray new];
    _highList = [NSMutableArray new];
    _todo = [NSMutableArray new];
    for(Task *loopedTask in _tasksArr){
            [_todo addObject:loopedTask];
        
    }

    
    for(Task *loopedTask in _todo){
        if([loopedTask.priority  isEqual: @"Low"]){
            [_lowList addObject:loopedTask];
        }else if([loopedTask.priority  isEqual: @"High"]){
            [_highList addObject:loopedTask];
        }else{
            [_medList addObject:loopedTask];
        }
        
    }

    

    [self.table reloadData];

    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedTask =[_tasksArr objectAtIndex:indexPath.row];

    ProDetailsViewController *editViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"proDetails"];
    _selectedTask =[_tasksArr objectAtIndex:indexPath.row];
    editViewController.task = _selectedTask;
    editViewController.index = indexPath.row;
    [self.navigationController pushViewController:editViewController animated:YES];
    

                
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _secNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_secNum == 1){
        return _todo.count;

    }else{
        switch (section) {
            case 0:
                return _lowList.count;
                break;
            case 1:
                return _medList.count;
                break;
            case 2:
                return _highList.count;
                break;

        }

    }
    return _secNum;

}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(_secNum == 3){
        switch (section) {
            case 0:
                return @"Low";
                break;
            case 1:
                return @"Medium";
                break;
            case 2:
                return @"High";
                break;

        }

    }
    return @"";
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    

    
    if(_secNum == 1){
        if([[_todo objectAtIndex:indexPath.row].priority  isEqual: @"Low"] ){
            cell.imageView.image = [UIImage imageNamed:@"2"];
        }else if([[_todo objectAtIndex:indexPath.row].priority  isEqual: @"High"]){
            cell.imageView.image = [UIImage imageNamed:@"1"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"0"];
        }

        cell.textLabel.text = [_todo objectAtIndex:indexPath.row].title;

    }else if(_secNum == 3){
        switch(indexPath.section){
            case 0:
                cell.textLabel.text = [_lowList objectAtIndex:indexPath.row].title;
                cell.imageView.image = [UIImage imageNamed:@"2"];
                break;
            case 1:
                cell.textLabel.text = [_medList objectAtIndex:indexPath.row].title;                cell.imageView.image = [UIImage imageNamed:@"0"];

                break;
            case 2:
                cell.textLabel.text = [_highList objectAtIndex:indexPath.row].title;
                cell.imageView.image = [UIImage imageNamed:@"1"];

                break;
        }

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Do You Want To Delete This Task?" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
                [self->_todo removeObjectAtIndex:indexPath.row];
                NSError *error;
                NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_todo requiringSecureCoding:YES error:&error];
                [self->_def setObject:savedData forKey:@"inPrograssTasks"];

                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        }
        [self.proTable reloadData];
    }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
    [_proTable reloadData];
}


- (IBAction)filterProgress:(id)sender {
    if(_isfilered == false){
        _isfilered = true;

        _secNum = 1;
        [_proTable reloadData];
    }else{
        _isfilered = false;

        _secNum = 3;
        [_proTable reloadData];
    }
}



@end
