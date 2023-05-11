//
//  ProgressViewController.h
//  ToDoApp
//
//  Created by Soha Ahmed Hamdy on 07/04/2023.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProgressViewController : ViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *proTable;

@end

NS_ASSUME_NONNULL_END
