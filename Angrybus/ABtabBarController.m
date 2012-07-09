//
//  ABtabBarController.m
//  Angrybus
//
//  Created by Mariana Meirelles on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABtabBarController.h"

@interface ABtabBarController ()

-(void) adicionaElementos;

@end

@implementation ABtabBarController

@synthesize mapaButton;
@synthesize linhasButton;
@synthesize imagemMapa;
@synthesize imagemLinhas;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self adicionaElementos];
}

-(void)adicionaElementos
{
    UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar"]];
    bgView.frame = CGRectMake(0, 430, 320, 50);
    [self.view addSubview:bgView];
    
    UIImage *btnImage = nil;
    UIImage *btnImageSelected = [UIImage imageNamed:@"tabseletor"];
    
    self.mapaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapaButton.frame = CGRectMake(5, 434, 155, 45);
    [mapaButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    [mapaButton setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [mapaButton setTag:101];
    
    imagemMapa = [UIImageView new];
    imagemMapa.frame = CGRectMake(70, 437, 25, 40);
    imagemMapa.image = [UIImage imageNamed:@"mapa_on"];
    
    [mapaButton setSelected:true];
    
    self.linhasButton = [UIButton buttonWithType:UIButtonTypeCustom];
    linhasButton.frame = CGRectMake(160, 434, 155, 45);
    [linhasButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    [linhasButton setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [linhasButton setTag:102];
    
    imagemLinhas = [UIImageView new];
    imagemLinhas.frame = CGRectMake(221, 437, 32, 40);
    imagemLinhas.image = [UIImage imageNamed:@"linhas_off"];

    
    
    [self.view addSubview:mapaButton];
    [self.view addSubview:imagemMapa];
    
    [self.view addSubview:linhasButton];
    [self.view addSubview:imagemLinhas];
    
    [mapaButton addTarget:self action:@selector(buttonClicked:)forControlEvents:UIControlEventTouchUpInside];
    [linhasButton addTarget:self action:@selector(buttonClicked:)forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked:(id)sender
{
    int tagNum = [sender tag];
    [self selectTab:tagNum];
}

- (void)selectTab:(int)tabID
{
    switch(tabID)
    {
        case 101:
            [mapaButton setSelected:true];
            imagemMapa.image = [UIImage imageNamed:@"mapa_on"];
            [linhasButton setSelected:false];
            imagemLinhas.image = [UIImage imageNamed:@"linhas_off"];
            [self setSelectedViewController:[[self viewControllers] objectAtIndex:0]];
            break;
        case 102:
            [mapaButton setSelected:false];
            imagemMapa.image = [UIImage imageNamed:@"mapa_off"];
            [linhasButton setSelected:true];
            imagemLinhas.image = [UIImage imageNamed:@"linhas_on"];
            [self setSelectedViewController:[[self viewControllers] objectAtIndex:1]];
            break;
    }
    self.selectedIndex = tabID;
}

@end
