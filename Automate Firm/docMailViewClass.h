//
//  docMailViewClass.h
//  Automate Firm
//
//  Created by Ambu Vamadevan on 24/11/2016.
//  Copyright © 2016 leonine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "connectionclass.h"

@interface docMailViewClass : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,headerprotocol>
@property (weak, nonatomic) IBOutlet UICollectionView *attachDocCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *reciverCollection;
@property(nonatomic,retain)NSMutableArray *attachmentArary;
@property(nonatomic,retain)NSMutableArray *receiverAray;
@property (weak, nonatomic) IBOutlet UITextField *mailidText;
@property(nonatomic,retain)connectionclass *myconnection;
@property(nonatomic,retain)AppDelegate *app;
-(IBAction)sendmail:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *subjecttextField;
@property (weak, nonatomic) IBOutlet UITextView *composeletterttextField;
@property (weak, nonatomic) IBOutlet UITextField *frommailtext;
@end
