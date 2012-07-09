//
//  ABtabBarController.h
//  Angrybus
//
//  Created by Mariana Meirelles on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABtabBarController : UITabBarController

{
    UIButton *mapaButton;
    UIButton *linhasButton;
    
    UIImageView * imagemMapa;
    UIImageView * imagemLinhas;
}

@property (nonatomic, retain) UIButton *mapaButton;
@property (nonatomic, retain) UIButton *linhasButton;

@property (nonatomic, retain) UIImageView *imagemMapa;
@property (nonatomic, retain) UIImageView *imagemLinhas;

-(void) selectTab:(int)tabID;

@end
