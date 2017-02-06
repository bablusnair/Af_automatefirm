//
//  resetpasswordsignupViewController.m
//  Automate Firm
//
//  Created by Ambu Vamadevan on 28/01/2017.
//  Copyright © 2017 leonine. All rights reserved.
//

#import "resetpasswordsignupViewController.h"

@interface resetpasswordsignupViewController ()

@end

@implementation resetpasswordsignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.myconnection=[[connectionclass alloc]init];
    self.myconnection.mydelegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];


}

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
        
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
        
    }
    
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submit:(id)sender
{
    
    if ([self.Newpassword.text isEqualToString:self.confirmpassword.text]) {
        
        [self.myconnection ResetpasswordSubmissionscreenUsername:self.usernameField.text oldpassword:self.oldpassword.text newpassword:self.Newpassword.text userid:[[NSUserDefaults standardUserDefaults] objectForKey:@"signeduserId"]];
    }
    else
    {
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"Error"
                                   message:[NSString stringWithFormat:@"%@",@"Password Incorrect"]
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       
                                                   }];
        [alert addAction:ok];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:alert animated:YES completion:nil];
        });

        
    }

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    self.activeField=textField;
    return  YES;
}

-(IBAction)resendbuttonaction:(id)sender
{
    [self.myconnection resendmailinsignUpScreen:[[NSUserDefaults standardUserDefaults] objectForKey:@"signeduserId"]];
}

-(void)resetpasswordserviceResponse:(id)details
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSLog(@"%@",details);
        
        if ([[details objectForKey:@"message"]isEqualToString:@"Added a resource!, New Password Created!"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[details objectForKey:@"userid"] forKey:@"signeduserId"];
            
            
            UIAlertController *alert= [UIAlertController
                                       alertControllerWithTitle:@"Error"
                                       message:[NSString stringWithFormat:@"%@",@"Password Reset Successfully now you Can Login Here"]
                                       preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           
                                                       }];
            [alert addAction:ok];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self presentViewController:alert animated:YES completion:nil];
            });
            

             [self dismissViewControllerAnimated:YES completion:Nil];
            
        }
        else
        {
            
            UIAlertController *alert= [UIAlertController
                                       alertControllerWithTitle:@"Error"
                                       message:[NSString stringWithFormat:@"%@",@"Reset Password Failed"]
                                       preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           
                                                       }];
            [alert addAction:ok];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self presentViewController:alert animated:YES completion:nil];
            });
            
        }
        
    });

    
}

-(void)resendmail:(id)details
{
    
    NSLog(@"%@",details);
    
    
     dispatch_async(dispatch_get_main_queue(), ^{
    
    if ([[details objectForKey:@"message"]isEqualToString:@"Added a resource!, Signup Success"]) {
        
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"Error"
                                   message:[NSString stringWithFormat:@"%@",@"Details Send Successfully"]
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       
                                                   }];
        [alert addAction:ok];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:alert animated:YES completion:nil];
        });

    }
    else
    {
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"Error"
                                   message:[NSString stringWithFormat:@"%@",@"Mail Sending Failed"]
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       
                                                   }];
        [alert addAction:ok];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:alert animated:YES completion:nil];
        });

    }
         
 });
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{

    return YES;
}

-(void)showalerviewcontroller:(NSString *)errorMessage
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Error"
                               message:[NSString stringWithFormat:@"%@",errorMessage]
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   
                                               }];
    [alert addAction:ok];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}

-(IBAction)skipbuttonaction:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}

@end
