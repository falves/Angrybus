//
//  DetalhesLinhaViewController.h
//  Angrybus
//
//  Created by Felipe Alves on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "RotaViewController.h"
#import "DejalActivityView.h"

@interface DetalhesLinhaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *tableViewPontos;
}

@property (nonatomic, strong) NSString * numeroLinha;
@property (nonatomic, strong) NSMutableArray * dataSourcePontos;
@property (nonatomic, strong) NSMutableArray * dataSourceRotas;

@end
