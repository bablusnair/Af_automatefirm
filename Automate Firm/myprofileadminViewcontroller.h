//
//  myprofileadminViewcontroller.h
//  Automate Firm
//
//  Created by Ambu Vamadevan on 19/01/2017.
//  Copyright © 2017 leonine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"
#import "connectionclass.h"
@interface myprofileadminViewcontroller : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ELCImagePickerControllerDelegate,headerprotocol>
@property(nonatomic,retain)connectionclass *myconnection;
@property(nonatomic,retain)IBOutlet UIView *addnewPaymentmethodview;
-(IBAction)donebutton:(id)sender;
-(IBAction)cancelbutton:(id)sender;
-(IBAction)addnewpaymentMethod:(id)sender;
@property(nonatomic,retain)IBOutlet UITableView *paymentHistroytable;
@property(nonatomic,retain)IBOutlet UITableView *cartHistroytable;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIDatePicker *estDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *estmatedDatetext;

@property (weak, nonatomic) IBOutlet UITextField *dobtext;
@property(nonatomic,retain)IBOutlet UITableView *paymentMethodtableview;
@property(nonatomic,retain)NSMutableArray *imagearray;
@property(nonatomic,retain)IBOutlet UICollectionView *broswecollectionview;
@property(nonatomic,retain)NSIndexPath *myindexpath;
-(IBAction)browseaction:(id)sender;
-(IBAction)browseimagecloseaction:(id)sender;
@property(nonatomic,retain)NSIndexPath *preindexpath;

@property(nonatomic,retain)NSMutableArray *sectorArray;
@property(nonatomic,retain)NSMutableArray *agentArray;
@property(nonatomic,retain)NSMutableArray *livingInArray;
@property(nonatomic,retain)NSMutableArray *stateArray;
@property(nonatomic,retain)NSMutableArray *cityArray;
@property(nonatomic,retain)NSMutableArray *estyearArray;


@property(nonatomic,retain)IBOutlet UITableView *sectorTableview;
@property(nonatomic,retain)IBOutlet UITableView *agentTableview;
@property(nonatomic,retain)IBOutlet UITableView *livinginTableview;
@property(nonatomic,retain)IBOutlet UITableView *stateTableview;
@property(nonatomic,retain)IBOutlet UITableView *cityTableview;
@property(nonatomic,retain)IBOutlet UITableView *estdateTableview;


@property(nonatomic,retain)IBOutlet UITextField *agentTextfield;
@property(nonatomic,retain)IBOutlet UITextField *livinginTextfield;
@property(nonatomic,retain)IBOutlet UITextField *stateTextfield;
@property(nonatomic,retain)IBOutlet UITextField *cityTextfield;
@property(nonatomic,retain)IBOutlet UITextField *sectorTextfield;
@property(nonatomic,retain)IBOutlet UITextField *dateofbirthTextfield;

@property (retain, nonatomic)NSString *countryString;
@property (retain, nonatomic)NSString *stateString;
@property (retain, nonatomic)NSString *cityString;
@property (retain, nonatomic)NSString *sectorString;
@property (retain, nonatomic)NSString *agentString;

@property(nonatomic,retain)NSMutableDictionary *countrydict;
@property(nonatomic,retain)NSMutableDictionary *statedict;
@property(nonatomic,retain)NSMutableDictionary *citydict;
@property(nonatomic,retain)NSMutableDictionary *sectordict;
@property(nonatomic,retain)NSMutableDictionary *agentdict;

-(IBAction)backbutton:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *datebackgroundView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dobPicker;
- (IBAction)datepickerDoneaction:(id)sender;
@end
