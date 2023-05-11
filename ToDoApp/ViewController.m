//
//  ViewController.m
//  ToDoApp
//
//  Created by Soha Ahmed Hamdy on 06/04/2023.
//

#import "ViewController.h"
#import "AddViewController.h"
#import "Task.h"
#import "EditViewController.h"

@interface ViewController (){
    NSArray <Task*> *taskess;
    NSMutableArray <Task*> *filteredTasks;
    BOOL isFiltered;
}

@property NSUserDefaults *def;
@property NSMutableArray <Task*> *tasksArr;
@property Task *selectedTask;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [_table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _def = [NSUserDefaults standardUserDefaults];
    _selectedTask = [Task new];
    NSError *error;
    
    NSData *savedData = [_def objectForKey:@"todoTasks" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _tasksArr = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];
    isFiltered = false;
    self.searchBar.delegate = self;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"TODO";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isFiltered){
        return  filteredTasks.count;
    }
    return _tasksArr.count;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if(isFiltered){
        cell.textLabel.text = [filteredTasks objectAtIndex:indexPath.row].title;
    }else{
        cell.textLabel.text = [_tasksArr objectAtIndex:indexPath.row].title;
    }
    
    if([[_tasksArr objectAtIndex:indexPath.row].priority  isEqual: @"Low"]){
        cell.imageView.image = [UIImage imageNamed:@"2"];
    }else if([[_tasksArr objectAtIndex:indexPath.row].priority  isEqual: @"High"]){
        cell.imageView.image = [UIImage imageNamed:@"1"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"0"];
    }
            
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditViewController *editViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
    if(isFiltered == true){
        _selectedTask =[filteredTasks objectAtIndex:indexPath.row];

    }else{
        _selectedTask =[_tasksArr objectAtIndex:indexPath.row];
    }
    editViewController.task = _selectedTask;
    editViewController.index = indexPath.row;

    [self.navigationController pushViewController:editViewController animated:YES];
                
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        isFiltered = false;
    }else{
        isFiltered = true;
        filteredTasks = [[NSMutableArray alloc] init];
        for(Task *loopedTask in _tasksArr){
            NSRange nameRange = [loopedTask.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound){
                [filteredTasks addObject:loopedTask];
            }
        }
    }
    [self.table reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Do You Want To Delete This Task?" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
                [self->_tasksArr removeObjectAtIndex:indexPath.row];
                NSError *error;
                NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_tasksArr requiringSecureCoding:YES error:&error];
                [self->_def setObject:savedData forKey:@"todoTasks"];

                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        }
        [self.table reloadData];
    }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
    [_table reloadData];
}


- (IBAction)navToAdd:(id)sender {
    AddViewController *addViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"add"];
    [self.navigationController pushViewController:addViewController animated:YES];

}







@end
