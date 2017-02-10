//
//  resetpasswordsignupViewController.h
//  Automate Firm
//
//  Created by Ambu Vamadevan on 28/01/2017.
//  Copyright © 2017 leonine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "connectionclass.h"
@interface resetpasswordsignupViewController : UIViewController<headerprotocol,UITextFieldDelegate>
@property(nonatomic,retain)connectionclass *myconnection;
-(IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldpassword;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *Newpassword;

@property (weak, nonatomic) IBOutlet UITextField *confirmpassword;

-(IBAction)skipbuttonaction:(id)sender;
-(IBAction)resendbuttonaction:(id)sender;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic)UITextField *activeField;

-(IBAction)backbuttonaction:(id)sender;
@end
