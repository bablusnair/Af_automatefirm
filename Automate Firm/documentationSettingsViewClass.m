//
//  documentationSettingsViewClass.m
//  Automate Firm
//
//  Created by leonine on 11/20/15.
//  Copyright © 2015 leonine. All rights reserved.
//

#import "documentationSettingsViewClass.h"
#import "settingcell.h"
#import "rulesTableViewCell.h"
#import "settingsViewController.h"
@implementation documentationSettingsViewClass
@synthesize  k,selectedFlag,firstTimeFlag;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [ self.mycollectionview registerNib:[UINib nibWithNibName:@"settingcustumcell" bundle:nil] forCellWithReuseIdentifier:@"simplecell"];
    self.documentationIcon=[[NSMutableArray alloc]initWithObjects:@"custom.png",@"leave.png",@"advance.png", @"loan.png",@"fine.png", @"exp_reimb.png", @"PEF.png",@"promotion.png",@"terminate.png",@"retirement.png",  nil];
    
    self.documentationSelectedIcon=[[NSMutableArray alloc]initWithObjects:@"custom.png",@"leave_active.png",@"advance_active.png", @"loan_active.png",  @"fine_active.png", @"exp_reimb_active.png", @"PEF_active.png",@"promotion_active.png",@"terminate_active.png",@"retirement_active.png",  nil];
    
    self.documentationIconLabel=[[NSMutableArray alloc]initWithObjects:@"Custom",@"Leave Applications",@"Advance Pay Applications",@"Loan Applications",@"Fine Applications",@"Expense Reimbursement Form",@"Performance Evaluation Form",@"Promotion Letter",@"Termination Letter",@"Retirement all Separation Form", nil];
    
    
    self.customRuleArray=[[NSMutableArray alloc]init];
    self.customRuleIDArray=[[NSMutableArray alloc]init];
    self.leaveArray=[[NSMutableArray alloc]init];
    self.leavesIDArray=[[NSMutableArray alloc]init];
    self.advanceArray=[[NSMutableArray alloc] init];
    self.loanArray=[[NSMutableArray alloc]init];
    self.loanidarray=[[NSMutableArray alloc]init];
    self.fineArray=[[NSMutableArray alloc] init];
    self.fineIDArray=[[NSMutableArray alloc]init];
    
    self.expenseArray=[[NSMutableArray alloc]init];
    self.expenseIDArray=[[NSMutableArray alloc]init];
    self.performanceArray=[[NSMutableArray alloc] initWithObjects:@"Performance Evaluation", nil];
    self.promotionArray=[[NSMutableArray alloc] initWithObjects:@"Promotion Letter", nil];
    self.terminationArray=[[NSMutableArray alloc]initWithObjects:@"Termination Letter", nil];
    self.retirementArray=[[NSMutableArray alloc]initWithObjects:@"Retirement all Separation", nil ];
    self.selectedArray=[[NSMutableArray alloc]init];
    selectedFlag=0;
    firstTimeFlag=1;
    
    self.myconnection=[[connectionclass alloc]init];
    self.myconnection.mydelegate=self;
    
   [self.myconnection listingAllPaperworkRule:@"custom" :[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedofficeId"]];
    [self.addNewButton setTitle:@"Add New Custom Rules" forState:UIControlStateNormal];
    self.addNewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [[NSUserDefaults standardUserDefaults]setObject:@"customPaperwork" forKey:@"ruleType"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disablecollcetionview) name:@"disableDocumentsCollectionView" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enablecollcetionview) name:@"enableDocumentsCollectionView" object:Nil];

    
}

-(void)disablecollcetionview
{
    [self.mycollectionview setUserInteractionEnabled:FALSE];
    
}

-(void)enablecollcetionview
{
    [self.mycollectionview setUserInteractionEnabled:TRUE];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.documentationIcon.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    settingcell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"simplecell" forIndexPath:indexPath];
    if (firstTimeFlag==1) {
        if (indexPath.row==0) {
            [self.selectedArray addObject:indexPath];
            firstTimeFlag=0;
        }
    }
    if ([self.selectedArray containsObject:indexPath]) {
        cell.mylabel.textColor=[UIColor blueColor];
        cell.myimg.image=[UIImage imageNamed:[self.documentationSelectedIcon objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.mylabel.textColor=[UIColor blackColor];
        cell.myimg.image=[UIImage imageNamed:[self.documentationIcon objectAtIndex:indexPath.row]];
    }
    
    cell.mylabel.text=[self.documentationIconLabel objectAtIndex:indexPath.row];
    
    
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout*)self.mycollectionview.collectionViewLayout;
    flow.sectionInset = UIEdgeInsetsMake(10, 0, 14, 0);
    
    flow.minimumLineSpacing = 50;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.selectedArray removeAllObjects];
    [self.selectedArray addObject:indexPath];
    [self.mycollectionview reloadData];
    
    if (indexPath.row==0) {
        self.selectedFlag=0;
        [self.myconnection listingAllPaperworkRule:@"custom" :[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedofficeId"]];
        [self.addNewButton setTitle:@"Add New Custom Rules" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:@"customPaperwork" forKey:@"ruleType"];
        [self.mytableview reloadData];
        
    }
    
    if (indexPath.row==1) {
        self.selectedFlag=1;
        [[NSUserDefaults standardUserDefaults]setObject:@"leavePaperwork" forKey:@"ruleType"];
        [self.addNewButton setTitle:@"" forState:UIControlStateNormal];
        [self.myconnection listingAllPaperworkRule:@"leave" :[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedofficeId"]];
        
    }
    if (indexPath.row==2) {
        self.selectedFlag=2;
        [[NSUserDefaults standardUserDefaults]setObject:@"advancePaperwork" forKey:@"ruleType"];
        [self.myconnection listingAllPaperworkRule:@"advance" :[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedofficeId"]];
        [self.addNewButton setTitle:@"" forState:UIControlStateNormal];
        [self.mytableview reloadData];
        
        
    }
    
    if (indexPath.row==3) {
        self.selectedFlag=3;
        [[NSUserDefaults standardUserDefaults]setObject:@"loanPaperwork" forKey:@"ruleType"];
        [self.myconnection listingAllPaperworkRule:@"loan" :[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedofficeId"]];
        [self.addNewButton setTitle:@"" forState:UIControlStateNormal];
        [self.mytableview reloadData];
       
        
    }
    if (indexPath.row==4) {
        self.selectedFlag=4;
        [[NSUserDefaults standardUserDefaults]setObject:@"finePaperwork" forKey:@"ruleType"];
        
        [self.myconnection listingAllPaperworkRule:@"fine" :[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedofficeId"]];
        [self.addNewButton setTitle:@"" forState:UIControlStateNormal];
        [self.mytableview reloadData];
    }
    if (indexPath.row==5) {
        self.selectedFlag=5;
        [[NSUserDefaults standardUserDefaults]setObject:@"expensePaperwork" forKey:@"ruleType"];
        [self.myconnection listingAllPaperworkRule:@"expense" :[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedofficeId"]];
        [self.addNewButton setTitle:@"" forState:UIControlStateNormal];
        [self.mytableview reloadData];
    }
    if (indexPath.row==6) {
        self.selectedFlag=6;
        [self.addNewButton setTitle:@"Create New Performance Evaluation" forState:UIControlStateNormal];
        [self.mytableview reloadData];
    }
    if (indexPath.row==7) {
        self.selectedFlag=7;
        [self.addNewButton setTitle:@"" forState:UIControlStateNormal];
        [self.mytableview reloadData];
    }
    if (indexPath.row==8) {
        self.selectedFlag=8;
        [self.addNewButton setTitle:@"" forState:UIControlStateNormal];
        [self.mytableview reloadData];
    }
    if (indexPath.row==9) {
        self.selectedFlag=9;
        [self.addNewButton setTitle:@"" forState:UIControlStateNormal];
        [self.mytableview reloadData];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedFlag==0) {
        return self.customRuleArray.count;
    }
    if (self.selectedFlag==1){
        return self.leaveArray.count;
    }
    else if (self.selectedFlag==2){
        return self.advanceArray.count;
    }
    else if (self.selectedFlag==3){
        return self.loanArray.count;
    }
    else if (self.selectedFlag==4)
    {
        return self.fineArray.count;
    }
    else if (self.selectedFlag==5){
        return self.expenseArray.count;
    }
    else if (self.selectedFlag==6){
        return self.performanceArray.count;
    }
    else if (self.selectedFlag==7){
        return self.promotionArray.count;
    }
    else if (self.selectedFlag==8){
        return self.terminationArray.count;
    }
    else
    {
        return self.retirementArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"simplecell";
    rulesTableViewCell  *cell = (rulesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"rulesTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    if (selectedFlag==0) {
        NSMutableDictionary *myDict=[self.customRuleArray objectAtIndex:indexPath.row];
        cell.mainLabel.text=[myDict objectForKey:@"custom_name"];
        cell.descriLabel.text=[myDict objectForKey:@"custom_description"];
        
        if ([myDict objectForKey:@"rule_type"]!=(id)[NSNull null]) {
            if ([[myDict objectForKey:@"rule_type"]isEqualToString:@"custom"]) {
                if ([myDict objectForKey:@"modified_date"]!=(id)[NSNull null]) {
                    cell.datemodifyLabel.text=[myDict objectForKey:@"modified_date"];
                }
            }
        }
        
        
        
    }
    if (self.selectedFlag==1) {
        if (self.leaveArray.count > 0) {
            NSMutableDictionary *mydict=[self.leaveArray objectAtIndex:indexPath.row];
            cell.mainLabel.text=[mydict objectForKey:@"leave_name"];
            cell.descriMainLabel.hidden=TRUE;
            cell.descriLabel.text=@"";
            
            if ([mydict objectForKey:@"rule_type"]!=(id)[NSNull null]) {
                if ([[mydict objectForKey:@"rule_type"]isEqualToString:@"leave"]) {
                    if ([mydict objectForKey:@"modified_date"]!=(id)[NSNull null]) {
                        cell.datemodifyLabel.text=[mydict objectForKey:@"modified_date"];
                    }
                }
            }
        }
        else
        {
            cell.mainLabel.text=[self.leaveArray objectAtIndex:indexPath.row];
        }
    }
    if (self.selectedFlag==2) {
        
        cell.mainLabel.text=@"Advance";
        cell.descriLabel.text=@"The installment amounts are deducted on every payment peroid of an employee.";
        cell.datemodifyLabel.text=self.dateString;
    }
    if (self.selectedFlag==3) {
        if (self.loanArray.count > 0) {
            NSMutableDictionary *mydict = [self.loanArray objectAtIndex:indexPath.row];
            cell.mainLabel.text=[mydict objectForKey:@"loan_type"];
            cell.descriLabel.text=[mydict objectForKey:@"description"];
            
            if ([mydict objectForKey:@"rule_type"]!=(id)[NSNull null]) {
                if ([[mydict objectForKey:@"rule_type"]isEqualToString:@"loan"]) {
                    if ([mydict objectForKey:@"modified_date"]!=(id)[NSNull null]) {
                        cell.datemodifyLabel.text=[mydict objectForKey:@"modified_date"];
                    }
                }

            }
        }
    }
    if (self.selectedFlag==4) {
         NSMutableDictionary *mydict = [self.fineArray objectAtIndex:indexPath.row];
        cell.mainLabel.text=[mydict objectForKey:@"violation_name"];
        cell.descriLabel.text=[mydict objectForKey:@"description"];
        
        if ([mydict objectForKey:@"rule_type"]!=(id)[NSNull null]) {
            if ([[mydict objectForKey:@"rule_type"]isEqualToString:@"fine"]) {
                if ([mydict objectForKey:@"modified_date"]!=(id)[NSNull null]) {
                    cell.datemodifyLabel.text=[mydict objectForKey:@"modified_date"];
                }
            }
        }
    }
    if (self.selectedFlag==5) {
        if(self.expenseArray.count>0)
        {
            NSMutableDictionary *mydict = [self.expenseArray objectAtIndex:indexPath.row];
            cell.mainLabel.text=[mydict objectForKey:@"expen_name"];
            cell.descriLabel.text=[mydict objectForKey:@"expen_desc"];
            
            if ([mydict objectForKey:@"rule_type"]!=(id)[NSNull null]) {
                if ([[mydict objectForKey:@"rule_type"]isEqualToString:@"expense"]) {
                    if ([mydict objectForKey:@"modified_date"]!=(id)[NSNull null]) {
                        cell.datemodifyLabel.text=[mydict objectForKey:@"modified_date"];
                    }
                }
            }
            
        }
    }
    if (self.selectedFlag==6) {
        cell.mainLabel.text=[self.performanceArray objectAtIndex:indexPath.row];
    }
    if (self.selectedFlag==7) {
        cell.mainLabel.text=[self.promotionArray objectAtIndex:indexPath.row];
    }
    if (self.selectedFlag==8) {
        cell.mainLabel.text=[self.terminationArray objectAtIndex:indexPath.row];
    }
    if (self.selectedFlag==9) {
        cell.mainLabel.text=[self.retirementArray objectAtIndex:indexPath.row];
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableDocumentsCollectionView" object:Nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Tableview" object:Nil];
    
    if (self.selectedFlag==0) {
        [[NSUserDefaults standardUserDefaults] setObject:[self.customRuleIDArray objectAtIndex:indexPath.row] forKey:@"customRuleID"];
        [[NSUserDefaults standardUserDefaults]setObject:@"update" forKey:@"ruleAction"];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"custom PaperworkRuleView" owner:self options:nil];
        UIView *myview=[nib objectAtIndex:0];
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.5];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
        [[self.documentsContainsView layer]addAnimation:applicationLoadViewIn forKey:kCAMediaTimingFunctionEaseOut];
        [self.documentsContainsView addSubview:myview];
    }
    
    if (self.selectedFlag==1) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[self.leavesIDArray objectAtIndex:indexPath.row] forKey:@"leaveID"];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"leaveDocumentsView" owner:self options:nil];
        UIView *myview=[nib objectAtIndex:0];
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.5];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
        [[self.documentsContainsView layer]addAnimation:applicationLoadViewIn forKey:kCAMediaTimingFunctionEaseOut];
        [self.documentsContainsView addSubview:myview];
        
    }
    if (self.selectedFlag==2) {
        
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"advanceDocumentsView" owner:self options:nil];
        UIView *myview=[nib objectAtIndex:0];
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.5];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
        
        [[self.documentsContainsView layer]addAnimation:applicationLoadViewIn forKey:kCAMediaTimingFunctionEaseOut];
        [self.documentsContainsView addSubview:myview];
    }
    if (self.selectedFlag==3) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[self.loanidarray objectAtIndex:indexPath.row] forKey:@"loanID"];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"loanDocumentView" owner:self options:nil];
        UIView *myview=[nib objectAtIndex:0];
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.5];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
        
        
        [[self.documentsContainsView layer]addAnimation:applicationLoadViewIn forKey:kCAMediaTimingFunctionEaseOut];
        [self.documentsContainsView addSubview:myview];
    }
    
    if (self.selectedFlag==4)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[self.fineIDArray objectAtIndex:indexPath.row] forKey:@"fineID"];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"fineDocumentsView" owner:self options:nil];
        UIView *myview=[nib objectAtIndex:0];
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.5];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
        
        [[self.documentsContainsView layer]addAnimation:applicationLoadViewIn forKey:kCAMediaTimingFunctionEaseOut];
        [self.documentsContainsView addSubview:myview];
    }
    if (self.selectedFlag==5) {
        [[NSUserDefaults standardUserDefaults] setObject:[self.expenseIDArray objectAtIndex:indexPath.row] forKey:@"expenseID"];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"expenseDocumentView" owner:self options:nil];
        UIView *myview=[nib objectAtIndex:0];
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.5];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
        
        [[self.documentsContainsView layer]addAnimation:applicationLoadViewIn forKey:kCAMediaTimingFunctionEaseOut];
        [self.documentsContainsView addSubview:myview];
    }
    if (self.selectedFlag==6) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"performanceEvaluationView" owner:self options:nil];
        UIView *myview=[nib objectAtIndex:0];
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.5];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
        rulesTableViewCell  *cell=[self.mytableview cellForRowAtIndexPath:indexPath];
        
        
        [[NSUserDefaults standardUserDefaults]setObject:cell.mainLabel.text forKey:@"LeaveName"];
        [[NSUserDefaults standardUserDefaults]setObject:cell.descriLabel.text forKey:@"description"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leavePaperwork" object:Nil];
        [[self.documentsContainsView layer]addAnimation:applicationLoadViewIn forKey:kCAMediaTimingFunctionEaseOut];
        [self.documentsContainsView addSubview:myview];
    }


}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        if (self.selectedFlag==0) {
            
            
            
            UIAlertController *alert= [UIAlertController
                                       alertControllerWithTitle:@"Delete?"
                                       message:@"Are you sure you want to delete?"
                                       preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           NSString *rid=[self.customRuleIDArray objectAtIndex:indexPath.row];
                                                           [self.myconnection deleteCustomPaperworkRule:rid];
                                                           [self.customRuleIDArray removeObjectAtIndex:indexPath.row];
                                                           [self.customRuleArray removeObjectAtIndex:indexPath.row];
                                                           [self.mytableview reloadData];
                                                           
                                                       }];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action){
                                                               [self.mytableview setEditing:false animated:YES];
                                                           }];
            [alert addAction:ok];
            [alert addAction:cancel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [(settingsViewController *)[self.superview.superview nextResponder] presentViewController:alert animated:YES completion:nil];
            });
            
            
        }
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    
    if (selectedFlag==0)
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
        
        return UITableViewCellEditingStyleNone;
    
}
//-(void)willRemoveSubview:(UIView *)subview
//{
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"employee"]) {
//        NSMutableArray *selectedEmployeeArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedEmployee"];
//        
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedEmployee"];
//        
//        NSData *imageData=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedEmployeeIcon"];
//        for (customPaperworkRuleClass *myView in self.documentsContainsView.subviews) {
//            if ([myView isKindOfClass:[customPaperworkRuleClass class]]) {
//                
//                [myView specificEmployee:selectedEmployeeArray :  imageData];
//            }
//        }
//    }
//    
//    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"designation"])
//    {
//        NSMutableArray *selectedDesignationArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedDesig"];
//        
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedDesig"];
//        
//        for (customPaperworkRuleClass *myView in self.documentsContainsView.subviews) {
//            if ([myView isKindOfClass:[customPaperworkRuleClass class]]) {
//                [myView assignDesignation:selectedDesignationArray];
//            }
//        }
//    }
//    else
//    {
//        
//    }
//}

-(IBAction)createAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableDocumentsCollectionView" object:Nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Tableview" object:Nil];
    if (selectedFlag==0)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"create" forKey:@"ruleAction"];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"custom PaperworkRuleView" owner:self options:nil];
        UIView *myview=[nib objectAtIndex:0];
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.5];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
        [[self.documentsContainsView layer]addAnimation:applicationLoadViewIn forKey:kCAMediaTimingFunctionEaseOut];
        [self.documentsContainsView addSubview:myview];
    }
    if (selectedFlag==6) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults]setObject:@"create" forKey:@"ruleAction"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"leavePaperwork" object:Nil];
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"performanceEvaluationView" owner:self options:nil];
            UIView *myview=[nib objectAtIndex:0];
            CATransition *applicationLoadViewIn =[CATransition animation];
            [applicationLoadViewIn setDuration:0.5];
            [applicationLoadViewIn setType:kCATransitionReveal];
            [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
            [[self.documentsContainsView layer]addAnimation:applicationLoadViewIn forKey:kCAMediaTimingFunctionEaseOut];
            [self.documentsContainsView addSubview:myview];
        });
    }
}


-(void)viewAllResponse:(id)responseList
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ruleType"]isEqualToString:@"customPaperwork"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseList count] > 0) {
                [self.customRuleArray removeAllObjects];
                [self.customRuleIDArray removeAllObjects];
                for (int i=0; i<[responseList count]; i++) {
                    NSMutableDictionary *leaveDict=[responseList objectAtIndex:i];
                    [self.customRuleIDArray addObject:[leaveDict objectForKey:@"custom_id"]];
                }
                [self.customRuleArray addObjectsFromArray:responseList];
                
                [self.mytableview reloadData];
            }
        });
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ruleType"]isEqualToString:@"leavePaperwork"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseList count] > 0) {
                [self.leaveArray removeAllObjects];
                [self.leavesIDArray removeAllObjects];
                for (int i=0; i<[responseList count]; i++) {
                    NSMutableDictionary *leaveDict=[responseList objectAtIndex:i];
                    [self.leavesIDArray addObject:[leaveDict objectForKey:@"leave_id"]];
                }
                [self.leaveArray addObjectsFromArray:responseList];
                
                [self.mytableview reloadData];
            }
        });
        
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"ruleType"]isEqualToString:@"advancePaperwork"])
    {
        [self.advanceArray removeAllObjects];
        if ([responseList count]>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setObject:[[responseList objectAtIndex:0]objectForKey:@"advance_id"] forKey:@"advance_ruleId"];
                [self.advanceArray addObjectsFromArray:responseList];
                
                
                if ([[responseList objectAtIndex:0]objectForKey:@"rule_type"]!=(id)[NSNull null])
                {
                    if ([[[responseList objectAtIndex:0]objectForKey:@"rule_type"]isEqualToString:@"advance"]) {
                        if ([[responseList objectAtIndex:0]objectForKey:@"modified_date"]!=(id)[NSNull null]) {
                            self.dateString=[[responseList objectAtIndex:0]objectForKey:@"modified_date"];
                        }
                    }
                }
                
                [self.mytableview reloadData];
                
            });
            
            
        }
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ruleType"]isEqualToString:@"loanPaperwork"])
    {
        [self.loanArray removeAllObjects];
        [self.loanidarray removeAllObjects];
        
        for (int i=0; i<[responseList count]; i++) {
            NSMutableDictionary *holyDict=[responseList objectAtIndex:i];
            [self.loanidarray addObject:[holyDict objectForKey:@"loan_id"]];
        }
        [self.loanArray addObjectsFromArray:responseList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mytableview reloadData];
            
        });
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ruleType"]isEqualToString:@"finePaperwork"])
    {
        [self.fineArray removeAllObjects];
        [self.fineIDArray removeAllObjects];
        for (int i=0; i<[responseList count]; i++) {
            NSMutableDictionary *holyDict=[responseList objectAtIndex:i];
            [self.fineIDArray addObject:[holyDict objectForKey:@"fine_id"]];
        }
        [self.fineArray addObjectsFromArray:responseList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mytableview reloadData];
            
        });
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"ruleType"]isEqualToString:@"expensePaperwork"])
    {
        [self.expenseIDArray removeAllObjects];
        [self.expenseArray removeAllObjects];
        if ([responseList count] > 0) {
            for (int i=0; i<[responseList count]; i++) {
                NSMutableDictionary *expenseDict=[responseList objectAtIndex:i];
                [self.expenseIDArray addObject:[expenseDict objectForKey:@"expen_id"]];
            }
            [self.expenseArray addObjectsFromArray:responseList];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.mytableview reloadData];
                
            });
            
        }
    }
    
}



@end
