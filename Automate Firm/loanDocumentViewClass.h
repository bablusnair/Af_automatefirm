//
//  loanDocumentViewClass.h
//  Automate Firm
//
//  Created by Ambu Vamadevan on 28/04/2016.
//  Copyright © 2016 leonine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loanDocumentTile.h"
#import "AppDelegate.h"
#import "connectionclass.h"
#import "loanDocumentTile.h"
#import "settingsViewController.h"

@interface loanDocumentViewClass : UIView<UITextViewDelegate,headerprotocol>
{
    loanDocumentTile *accordion;
    AppDelegate *app;
}

@property(nonatomic,retain)connectionclass *myconnection;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet UILabel *loanLabel;
@property(nonatomic,retain)NSString *modifiedDate;
@property(nonatomic,retain)IBOutlet UITextView *declarationText;
@property(nonatomic,retain)IBOutlet UIView *declarationView;
@property(nonatomic,retain)IBOutlet UIButton *plusButton;
@property(nonatomic,retain)IBOutlet UIButton *doneButton;
@property(nonatomic,retain)IBOutlet UIButton *cancelButton;
-(void)enable;
-(void)disable;
-(IBAction)AddNewTile:(id)sender;
-(IBAction)doneButtonAction:(id)sender;
-(IBAction)cancelButtonAction:(id)sender;
@property(nonatomic,assign)int alertFlag;


@end
