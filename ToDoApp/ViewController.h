//
//  ViewController.h
//  ToDoApp
//
//  Created by Soha Ahmed Hamdy on 06/04/2023.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;


@end

