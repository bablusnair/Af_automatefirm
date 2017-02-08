//
//  fineDocumentsViewClass.h
//  Automate Firm
//
//  Created by Ambu Vamadevan on 29/04/2016.
//  Copyright © 2016 leonine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fineDocumentTile.h"
#import "AppDelegate.h"
@interface fineDocumentsViewClass : UIView<headerprotocol>
{
    fineDocumentTile *accordion;
    AppDelegate *app;
}
@property(nonatomic,retain)connectionclass *myconnection;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;



@property(nonatomic,retain)IBOutlet UILabel *fineNameLabel;
@property(nonatomic,retain)NSString *modifiedDate;
@property(nonatomic,retain)IBOutlet UIButton *plusButton;
@property(nonatomic,retain)IBOutlet UIButton *doneButton;
@property(nonatomic,retain)IBOutlet UIButton *cancelButton;
-(void)enable;
-(void)disable;
-(IBAction)plusButtonAction:(id)sender;
-(IBAction)doneButtonAction:(id)sender;
-(IBAction)cancelButtonAction:(id)sender;


@end
