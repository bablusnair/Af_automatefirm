//
//  customPaperworkRuleClass.h
//  Automate Firm
//
//  Created by leonine on 16/09/16.
//  Copyright © 2016 leonine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "connectionclass.h"
@interface customPaperworkRuleClass : UIView<headerprotocol,UITextFieldDelegate,UITextViewDelegate>
{
    AppDelegate *app;
}

@property(nonatomic,retain)connectionclass *myconnection;
@property(nonatomic,retain)IBOutlet UIView *popUpView;
@property(nonatomic,retain)IBOutlet UITableView *popupTableView;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet UITextField *activeField;

-(IBAction)saveButtonAction:(id)sender;
-(IBAction)cancelButtonAction:(id)sender;

-(IBAction)button1Action:(id)sender;
-(IBAction)button2Action:(id)sender;
-(IBAction)button3Action:(id)sender;
-(IBAction)button4Action:(id)sender;
-(IBAction)button5Action:(id)sender;

@property(nonatomic,retain)IBOutlet UIButton *button1;
@property(nonatomic,retain)IBOutlet UIButton *button2;
@property(nonatomic,retain)IBOutlet UIButton *button3;
@property(nonatomic,retain)IBOutlet UIButton *button4;
@property(nonatomic,retain)IBOutlet UIButton *button5;
@property(nonatomic,retain)IBOutlet UIImageView *arrowImage1;
@property(nonatomic,retain)IBOutlet UIImageView *arrowImage2;
@property(nonatomic,retain)IBOutlet UIImageView *arrowImage3;
@property(nonatomic,retain)IBOutlet UIImageView *arrowImage4;

@property(nonatomic,retain)IBOutlet UITextField *ruleNameText;
@property(nonatomic,retain)IBOutlet UITextField *abbrvText;
@property(nonatomic,retain)IBOutlet UITextView *descriptionTextView;


@property(nonatomic,assign)int x;
@property(nonatomic,assign)int y;
@property(nonatomic,assign)int z;
@property(nonatomic,assign)int p;
@property(nonatomic,assign)int q;
@property(nonatomic,assign)int buttonFlag;

@property(nonatomic,retain)NSString *countString;

@property(nonatomic,retain)NSMutableArray *popupArray;
@property(nonatomic,retain)NSMutableArray *dropHighlightArray;

@property(nonatomic,retain)NSMutableDictionary *finalDict;
@property(nonatomic,retain)NSMutableDictionary *popupStorageDict;


-(IBAction)editingChanged:(id)sender;

-(void)assignDesignation:(NSMutableArray *)desigArray;
-(void)specificEmployee:(NSMutableArray *)selectedEmployee : (NSData *)selectedEmployeeIcon;
@end
