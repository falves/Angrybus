//
//  TodasLinhasViewController.h
//  Angrybus
//
//  Created by Felipe Alves on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetalhesLinhaViewController.h"

@interface TodasLinhasViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *tableViewLinhas;
}

@property (nonatomic, strong) NSArray * datasource;

@end
