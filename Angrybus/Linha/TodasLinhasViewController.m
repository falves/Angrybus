//
//  TodasLinhasViewController.m
//  Angrybus
//
//  Created by Felipe Alves on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TodasLinhasViewController.h"

@interface TodasLinhasViewController ()

@end

@implementation TodasLinhasViewController

@synthesize datasource = _datasource;

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
	
    self.title = @"Todas as linhas";
    
    NSString * requestString = [NSString stringWithFormat:@"%@/Angryadmin/ListaLinhas",SERVIDOR];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         NSError * erro;
         NSDictionary * linhasDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&erro];
         
         self.datasource = [linhasDict objectForKey:@"linhas"];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [tableViewLinhas reloadData];
         });
         
     }];

}

- (void)viewDidUnload
{
    tableViewLinhas = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DetalhesLinhaViewController * proximo = (DetalhesLinhaViewController*) segue.destinationViewController;
    proximo.numeroLinha = sender;
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCell * cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:@"linhaCell"];
    cell.title.text = [self.datasource objectAtIndex:indexPath.row];
    cell.title.font = [UIFont fontWithName:@"MuseoSans-300" size:17];
    cell.title.textColor = AZUL;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"DetalhesLinha" sender:[self.datasource objectAtIndex:indexPath.row]];
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datasource count];
}

@end
