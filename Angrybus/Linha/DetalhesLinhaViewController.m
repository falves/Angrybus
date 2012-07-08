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
    proximo.rotas = self.dataSourceRotas;
    proximo.pontos = self.dataSourcePontos;
    proximo.numeroLinha = self.numeroLinha;
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pontoCell"];
    
    NSDictionary * ponto = [[self.dataSourcePontos objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    NSLog(@"%@",ponto);
    
    NSString * ordem = [NSString stringWithFormat:@"%d", [[ponto objectForKey:@"ordem"] intValue]];
//    NSString * lat = [NSString stringWithFormat:@"%f", [[ponto objectForKey:@"lat"] doubleValue]];

    
    cell.textLabel.text = [ponto objectForKey:@"endereco"];
    cell.detailTextLabel.text = ordem;
    // ALTERAR PARA O DETAILLABEL CERTA
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self performSegueWithIdentifier:@"DetalhesLinha" sender:[self.datasource objectAtIndex:indexPath.row]];
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSourcePontos objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSourceRotas count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataSourceRotas objectAtIndex:section];
}

#pragma mark - Getters/Setters

- (NSMutableArray*) dataSourcePontos {
    
    if (!_dataSourcePontos) {
        _dataSourcePontos = [NSMutableArray new];
    }
    
    return _dataSourcePontos;
}

@end
