//
//  ViewController.m
//  UICustomAlertView
//
//  Created by Rahul Gunjote on xx/xx/14.
//  Copyright (c) 2014 Rahul Gunjote. All rights reserved.
//

#import "ViewController.h"
#import "UICustomAlertView.h"

@interface ViewController ()<UICustomAlertViewDelegate,UIAlertViewDelegate>

@property (nonatomic,weak)IBOutlet UIButton *alertButton;
@property (nonatomic,weak)IBOutlet UIButton *promptButton;
@property (nonatomic,weak)IBOutlet UILabel *nameLabel;

-(IBAction)showAlert:(id)sender;
-(IBAction)showPrompt:(id)sender;
@end

@implementation ViewController
@synthesize alertButton, promptButton, nameLabel;
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(IBAction)showAlert:(id)sender{
    
     UICustomAlertView *alert =[[UICustomAlertView alloc] initWithTitle:@"Welcome!." message:@"Testing UICustomAlertView." delegate:self dismissButtonTitle:@"Cancel" otherButtonTitles:nil];
     alert.alertViewStyle = UICustomAlertViewStyleDefault;
    [alert.titleLabel setFont:[UIFont fontWithName:@"TimesNewRomanPSMT" size:15]];
    [alert.messageLabel setFont:[UIFont fontWithName:@"TimesNewRomanPSMT" size:12]];
    [alert show];
}
-(IBAction)showPrompt:(id)sender{
    
    UICustomAlertView *alert =[[UICustomAlertView alloc] initWithTitle:@"Welcome!." message:@"Please enter your name." delegate:self dismissButtonTitle:@"Cancel" otherButtonTitles:@[@"Save"]];
    alert.alertViewStyle = UICustomAlertViewStylePlainTextInput;
    [alert show];

}
-(void)alertView:(UICustomAlertView *)alertView dismissWithclickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.textFields) {
        UITextField *nameTextField= [alertView.textFields firstObject];
        nameLabel.text = [NSString stringWithFormat:@"Hello %@!",nameTextField.text];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
