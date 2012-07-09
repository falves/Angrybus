//
//  DetalhesLinhaViewController.m
//  Angrybus
//
//  Created by Felipe Alves on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetalhesLinhaViewController.h"

@interface DetalhesLinhaViewController ()

@end

@implementation DetalhesLinhaViewController
@synthesize numeroLinha = _numeroLinha;
@synthesize dataSourcePontos = _dataSourcePontos;
@synthesize dataSourceRotas = _dataSourceRotas;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"Linha %@",self.numeroLinha];
    
    NSString * rotasRequestString = [NSString stringWithFormat:@"%@/Angryadmin/ListaRotasDaLinha?linha=%@",SERVIDOR,self.numeroLinha];
    NSURLRequest * rotasRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:rotasRequestString]];
    NSError * erro;
    NSURLResponse * response;
    
    NSData * dataRotas = [NSURLConnection sendSynchronousRequest:rotasRequest returningResponse:&response error:&erro];
    
    self.dataSourceRotas = [[NSJSONSerialization JSONObjectWithData:dataRotas options:NSJSONReadingAllowFragments error:&erro] objectForKey:@"rotas"];
    
    for (NSString * rota in self.dataSourceRotas) {
        
        NSString * rotasRequestString = [NSString stringWithFormat:@"%@/Angryadmin/ListaPontosDaRota?linha=%@&rota=%@",SERVIDOR,self.numeroLinha,rota];
        NSURLRequest * rotasRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:rotasRequestString]];
        
        NSData * pontoData = [NSURLConnection sendSynchronousRequest:rotasRequest returningResponse:&response error:&erro];
        NSArray * pontosArray = [NSJSONSerialization JSONObjectWithData:pontoData options:NSJSONReadingMutableContainers error:&erro];
        
        [self.dataSourcePontos addObject:pontosArray];
        
    }
    
    [tableViewPontos reloadData];

}

- (void)viewDidUnload
{
    tableViewPontos = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    RotaViewController * proximo = (RotaViewController*) segue.destinationViewController;
//    proximo.rotas = self.dataSourceRotas;
    NSIndexPath * indexPath = (NSIndexPath*)sender;
    proximo.pontos = [self.dataSourcePontos objectAtIndex:indexPath.section];
    proximo.numeroLinha = self.numeroLinha;
}

//- (void) clicou

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != [[self.dataSourcePontos objectAtIndex:indexPath.section] count]) {
        
        
        
        CustomCell * cell = (CustomCell*) [tableView dequeueReusableCellWithIdentifier:@"pontoCell"];
        
        NSDictionary * ponto = [[self.dataSourcePontos objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        //    NSString * ordem = [NSString stringWithFormat:@"%d", [[ponto objectForKey:@"ordem"] intValue]];
        //    NSString * lat = [NSString stringWithFormat:@"%f", [[ponto objectForKey:@"lat"] doubleValue]];
        
        
        cell.title.text = [ponto objectForKey:@"endereco"];
        cell.title.font = [UIFont fontWithName:@"MuseoSans-300" size:17];
        cell.title.textColor = AZUL;
        
        return cell;
    } else {
        UITableViewCell * cell = [UITableViewCell new];
        UIImageView * backGround = [UIImageView new];
        backGround.frame = CGRectMake(0, 0, 320, 43);
        backGround.image = [UIImage imageNamed:@"celula"];
        [cell addSubview:backGround];
        
        UIImage * imagem = [UIImage imageNamed:@"btnverposicao"];
        
        UIImageView * imageViewBotao = [UIImageView new];
        imageViewBotao.frame = CGRectMake(60, 6, 200, 32);
        
        [imageViewBotao setImage:imagem];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell addSubview:imageViewBotao];
        
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0, 0, 0);
//        [button setBackgroundImage:imagem forState:UIControlStateNormal];
//        [button setBackgroundImage:imagem forState:UIControlStateSelected];
//        [button setTag:indexPath.section];
//        
//        [cell addSubview:button];
//        
//        [button addTarget:self action:@selector(clicouBotao:)forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [[self.dataSourcePontos objectAtIndex:indexPath.section] count]) {
        [self performSegueWithIdentifier:@"Rota" sender:indexPath];
    }
//    [self performSegueWithIdentifier:@"DetalhesLinha" sender:[self.datasource objectAtIndex:indexPath.row]];
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSourcePontos objectAtIndex:section] count]+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSourceRotas count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [self.dataSourceRotas objectAtIndex:section];
//}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [UIView new];
    view.frame = CGRectMake(0, 0, 320, 25);
    
    UILabel * label = [UILabel new];
    label.frame = CGRectMake(20, 2, 280, 21);
    label.font = [UIFont fontWithName:@"MuseoSans-700" size:18];
    label.textColor = CINZA;
    label.text = [self.dataSourceRotas objectAtIndex:section];
    label.backgroundColor = [UIColor clearColor];
    
    UIImageView * imageView = [UIImageView new];
    imageView.frame = view.frame;
    imageView.image = [UIImage imageNamed:@"header"];

    [view addSubview:imageView];
    [view addSubview:label];
    
    return view;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0;
}

#pragma mark - Getters/Setters

- (NSMutableArray*) dataSourcePontos {
    
    if (!_dataSourcePontos) {
        _dataSourcePontos = [NSMutableArray new];
    }
    
    return _dataSourcePontos;
}

@end
