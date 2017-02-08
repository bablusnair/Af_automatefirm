//
//  leaveDocumentsClass.h
//  Automate Firm
//
//  Created by leonine on 11/20/15.
//  Copyright © 2015 leonine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentTile.h"
#import "AppDelegate.h"
#import "connectionclass.h"
@interface leaveDocumentsClass : UIView<UITextViewDelegate,headerprotocol>
{
    DocumentTile *accordion;
    AppDelegate *app;
}

@property(nonatomic,retain)connectionclass *myconnection;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;


@property(nonatomic,retain)IBOutlet UILabel *leaveNameLabel;
@property(nonatomic,retain)NSString *leaveTypeLabel;
@property(nonatomic,retain)NSString *modifiedDate;
@property(nonatomic,retain)IBOutlet UITextView *declarationText;
@property(nonatomic,retain)IBOutlet UIView *declarationView;
@property(nonatomic,retain)IBOutlet UIButton *plusButton;
@property(nonatomic,retain)IBOutlet UIButton *doneButton;
@property(nonatomic,retain)IBOutlet UIButton *cancelButton;
-(IBAction)plusButtonAction:(id)sender;
-(IBAction)doneButtonAction:(id)sender;
-(IBAction)cancelButtonAction:(id)sender;
-(void)enable;
-(void)disable;
@property(nonatomic,retain)NSString *alertFlag;
@end
