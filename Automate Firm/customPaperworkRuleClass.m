//
//  customPaperworkRuleClass.m
//  Automate Firm
//
//  Created by leonine on 16/09/16.
//  Copyright © 2016 leonine. All rights reserved.
//

#import "customPaperworkRuleClass.h"
#import "popupTableViewCell.h"
#import "settingsViewController.h"
#import "documentationSettingsViewClass.h"

@implementation customPaperworkRuleClass
@synthesize buttonFlag,x,y,z,p,q;
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    app.ruleID=@"0";
    app.conditionID=@"0";
    app.designationFlag1=app.designationFlag2=app.designationFlag3=app.designationFlag4=app.designationFlag5=0;
    app.specificEmployeeFlag1=app.specificEmployeeFlag2=app.specificEmployeeFlag3=app.specificEmployeeFlag4=app.specificEmployeeFlag5=0;
    
    self.countString=@"0";
    
    self.myconnection=[[connectionclass alloc]init];
    self.myconnection.mydelegate=self;
    
    self.popupArray=[[NSMutableArray alloc] initWithObjects:@"Designations",@"Owners",@"Specific Individuals", nil];
    self.dropHighlightArray=[[NSMutableArray alloc]init];
    
    self.finalDict=[[NSMutableDictionary alloc]init];
    self.popupStorageDict=[[NSMutableDictionary alloc]init];
    
    self.popUpView.hidden=true;
    self.button2.userInteractionEnabled=NO;
    self.button3.userInteractionEnabled=NO;
    self.button4.userInteractionEnabled=NO;
    self.button5.userInteractionEnabled=NO;
    buttonFlag=0;x=0;y=0;z=0;p=q=0;
    [self clearView];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"ruleAction"]isEqualToString:@"update"])
    {
        app.ruleID=[[NSUserDefaults standardUserDefaults]objectForKey:@"customRuleID"];
        app.conditionID=@"0";//Staticly used for listing in the specific employee and designation list service.Actually no need of condition id in custom rule.
        [self.myconnection individualCustomPaperworkRuleView:[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedofficeId"] :app.ruleID :@"custom"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


-(void)clearView
{
    self.descriptionTextView.text=@"";
    self.button2.userInteractionEnabled=NO;
    self.button3.userInteractionEnabled=NO;
    self.button4.userInteractionEnabled=NO;
    self.button5.userInteractionEnabled=NO;
    [self.button1 setImage:[UIImage imageNamed:@"circle_4.png"] forState:UIControlStateNormal];
    [self.button2 setImage:[UIImage imageNamed:@"circle_4.png"] forState:UIControlStateNormal];
    [self.button3 setImage:[UIImage imageNamed:@"circle_4.png"] forState:UIControlStateNormal];
    [self.button4 setImage:[UIImage imageNamed:@"circle_4.png"] forState:UIControlStateNormal];
    [self.button5 setImage:[UIImage imageNamed:@"circle_4.png"] forState:UIControlStateNormal];
    self.arrowImage1.image=self.arrowImage2.image=self.arrowImage3.image=self.arrowImage4.image=[UIImage imageNamed:@"process_arrow_black.png"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.popupArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    popupTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"popupTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    if ([self.dropHighlightArray containsObject:indexPath]) {
        [cell.backImage setImage:[UIImage imageNamed:@"bottom_left buttton_selected.png"]];
    }
    else
    {
        [cell.backImage setImage:[UIImage imageNamed:@"drop_box_white.png"]];
    }
    cell.popupLabel.text=[self.popupArray objectAtIndex:indexPath.row];
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    popupTableViewCell *cell=[self.popupTableView cellForRowAtIndexPath:indexPath];
    cell.backImage.image=[UIImage imageNamed:@"drop_box_blue.png"];
    cell.popupLabel.textColor=[UIColor whiteColor];
    app.warningflag=1;
    if (indexPath.row==0) {
        [[NSUserDefaults standardUserDefaults]setObject:@"designation" forKey:@"popupAction"];
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"includeDesignation"];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"includeDesignationView" owner:self options:nil];
        [self addSubview:[nib objectAtIndex:0]];
    }
    if (indexPath.row==1) {
        if (buttonFlag==1) {
            [self.button1 setImage:[UIImage imageNamed:@"circle_1.png"] forState:UIControlStateNormal];
            self.button2.userInteractionEnabled=YES;
            x=0;
            self.popUpView.hidden=true;
        }
        else if (buttonFlag==2)
        {
            [self.button2 setImage:[UIImage imageNamed:@"circle_1.png"] forState:UIControlStateNormal];
            self.button3.userInteractionEnabled=YES;
            self.arrowImage1.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            y=0;
            self.popUpView.hidden=true;
        }
        else if (buttonFlag==3)
        {
            [self.button3 setImage:[UIImage imageNamed:@"circle_1.png"] forState:UIControlStateNormal];
            self.button4.userInteractionEnabled=YES;
            self.arrowImage2.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            z=0;
            self.popUpView.hidden=true;
        }
        else if(buttonFlag==4)
        {
            self.button5.userInteractionEnabled=YES;
            [self.button4 setImage:[UIImage imageNamed:@"circle_1.png"] forState:UIControlStateNormal];
            self.arrowImage3.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            p=0;
            self.popUpView.hidden=true;
        }
        else
        {
            [self.button5 setImage:[UIImage imageNamed:@"circle_1.png"] forState:UIControlStateNormal];
            self.arrowImage4.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        NSMutableDictionary *ownerDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"owner",@"type",app.flowAction,@"progress_id", nil ];
        [self.finalDict setObject:ownerDict forKey:app.flowAction];
        
    }
    if (indexPath.row==2) {
        [[NSUserDefaults standardUserDefaults]setObject:@"employee" forKey:@"popupAction"];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"assignToSpecificEmployeeView" owner:self options:nil];
        [self addSubview:[nib objectAtIndex:0]];
        
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    popupTableViewCell *cell=[self.popupTableView cellForRowAtIndexPath:indexPath];
    cell.backImage.image=[UIImage imageNamed:@"drop_box_white.png"];
    cell.popupLabel.textColor=[UIColor blackColor];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.abbrvText) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (textField.text.length<=4) {
            NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
            unichar u = [string characterAtIndex:0];
            if ([myCharSet characterIsMember:u])
            {
                return YES;
            }
            else{
                return NO;
            }
            
        }
        else
            return NO;
    }
    else if (textField==self.ruleNameText)
    {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (textField.text.length<=49) {
            NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "];
            unichar u = [string characterAtIndex:0];
            if ([myCharSet characterIsMember:u])
            {
                return YES;
            }
            else{
                return NO;
            }
        }
        else
            return NO;
    }
    
    
    else
    {
        return YES;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView==self.descriptionTextView) {
        if ([text isEqualToString:@""]) {
            return YES;
        }
        if (textView.text.length<=174) {
            NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_+:<>;,./?'|\" "];
            unichar u = [text characterAtIndex:0];
            if ([myCharSet characterIsMember:u])
            {
                return YES;
            }
            else{
                return NO;
            }
            
        }
        else
            return NO;
    }
    else
    {
        return YES;
    }
}
- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.frame;
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
-(IBAction)button1Action:(id)sender
{
    
    if (x%2==0) {
        
        buttonFlag=1;
        app.flowAction=@"1";
        self.popUpView.hidden=false;
        [self settingsLocalStorageValue:@"1"];
        
        [self.popupTableView reloadData];
        self.popUpView.frame=CGRectMake(-5, 334, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
        x++;
    }
    else
    {
        x++;
        self.popUpView.hidden=true;
    }
    
    
}
-(IBAction)button2Action:(id)sender
{
    if (y%2==0) {
        buttonFlag=2;
        app.flowAction=@"2";
        self.popUpView.hidden=false;
        
        [self settingsLocalStorageValue:@"2"];
        
        [self.popupTableView reloadData];
        self.popUpView.frame=CGRectMake(95, 334, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
        y++;
    }
    else
    {
        y++;
        self.popUpView.hidden=true;
    }
}
-(IBAction)button3Action:(id)sender
{
    if (z%2==0) {
        buttonFlag=3;
        app.flowAction=@"3";
        self.popUpView.hidden=false;
        
        [self settingsLocalStorageValue:@"3"];
        
        [self.popupTableView reloadData];
        self.popUpView.frame=CGRectMake(208, 334, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
        z++;
    }
    else
    {
        z++;
        self.popUpView.hidden=true;
    }
    
}
-(IBAction)button4Action:(id)sender
{
    if (p%2==0) {
        buttonFlag=4;
        app.flowAction=@"4";
        self.popUpView.hidden=false;
        
        [self settingsLocalStorageValue:@"4"];
        
        [self.popupTableView reloadData];
        self.popUpView.frame=CGRectMake(325, 334, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
    }
    else
    {
        p++;
        self.popUpView.hidden=true;
    }
    
}
-(IBAction)button5Action:(id)sender
{
    if (q%2==0) {
        buttonFlag=5;
        app.flowAction=@"5";
        self.popUpView.hidden=false;
        
        [self settingsLocalStorageValue:@"5"];
        
        [self.popupTableView reloadData];
        self.popUpView.frame=CGRectMake(425, 334, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
    }
    else
    {
        q++;
        self.popUpView.hidden=true;
    }
    
}
-(IBAction)editingChanged:(id)sender
{
    app.warningflag=1;
}
-(void)settingsLocalStorageValue:(NSString *)key
{
    [self.dropHighlightArray removeAllObjects];
    
    NSMutableDictionary *protocolDict=[[NSMutableDictionary alloc]initWithDictionary:self.finalDict];
    if ([[protocolDict allKeys]containsObject:key]) {
        
        if ([[[protocolDict objectForKey:key]objectForKey:@"type"]isEqualToString:@"designation"]) {
            
            NSIndexPath *myindexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.dropHighlightArray addObject:myindexPath];
            
            
            [[NSUserDefaults standardUserDefaults]setObject:[self.popupStorageDict objectForKey:key] forKey:@"officeDetails"];
            
        }
        else if ([[[protocolDict objectForKey:key]objectForKey:@"type"]isEqualToString:@"owner"])
        {
            NSIndexPath *myindexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.dropHighlightArray addObject:myindexPath];
            
        }
        else if ([[[protocolDict objectForKey:key]objectForKey:@"type"]isEqualToString:@"employee"])
        {
            NSIndexPath *myindexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.dropHighlightArray addObject:myindexPath];
            
            
            [[NSUserDefaults standardUserDefaults]setObject:[self.popupStorageDict objectForKey:app.flowAction] forKey:@"employeeDict"];
            
        }
        
    }
}
-(void)willRemoveSubview:(UIView *)subview
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"employee"]) {
        NSMutableArray *selectedEmployeeArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedEmployee"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedEmployee"];
        
        NSData *imageData=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedEmployeeIcon"];
        //for (customPaperworkRuleClass *myView in self.documentsContainsView.subviews) {
           // if ([myView isKindOfClass:[customPaperworkRuleClass class]]) {
                
                [self specificEmployee:selectedEmployeeArray :  imageData];
           // }
       // }
    }
    
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"popupAction"]isEqualToString:@"designation"])
    {
        NSMutableArray *selectedDesignationArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedDesig"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedDesig"];
        
        //for (customPaperworkRuleClass *myView in self.documentsContainsView.subviews) {
          //  if ([myView isKindOfClass:[customPaperworkRuleClass class]]) {
                [self assignDesignation:selectedDesignationArray];
           // }
        //}
    }
    else
    {
        
    }
}
-(void)assignDesignation:(NSMutableArray *)desigArray
{
    if (desigArray.count > 0) {
        if (buttonFlag==1) {
            x=0;
            [self.button1 setImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
            self.button2.userInteractionEnabled=YES;
            self.popUpView.hidden=true;
        }
        else if (buttonFlag==2)
        {
            y=0;
            [self.button2 setImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
            self.button3.userInteractionEnabled=YES;
            self.arrowImage1.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        else if (buttonFlag==3)
        {
            z=0;
            [self.button3 setImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
            self.button4.userInteractionEnabled=YES;
            self.arrowImage2.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        else if(buttonFlag==4)
        {
            p=0;
            [self.button4 setImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
            self.button5.userInteractionEnabled=YES;
            self.arrowImage3.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        else
        {
            q=0;
            [self.button5 setImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
            self.arrowImage4.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        NSMutableDictionary *designationDict=[[NSMutableDictionary alloc]init];
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedDesignation"] count] > 0) {
            [designationDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedDesignation"] forKey:@"selected_designation"];
        }
        else
        {
            [designationDict setObject:@"" forKey:@"selected_designation"];
        }
        
        
        
        [designationDict  setObject:@"designation" forKey:@"type"];
        [designationDict setObject:app.flowAction forKey:@"progress_id"];
        [self.finalDict setObject:designationDict forKey:app.flowAction];
        [self.popupStorageDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"officeDetails"] forKey:app.flowAction];
        
        
    }
    
    
    
}



-(void)specificEmployee:(NSMutableArray *)selectedEmployee :(NSData *)selectedEmployeeIcon
{
    if (selectedEmployee.count > 1) {
        if (buttonFlag==1) {
            x=0;
            [self.button1 setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
            self.button2.userInteractionEnabled=YES;
            self.popUpView.hidden=true;
        }
        else if (buttonFlag==2)
        {
            y=0;
            [self.button2 setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
            self.button3.userInteractionEnabled=YES;
            self.arrowImage1.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        else if (buttonFlag==3)
        {
            z=0;
            [self.button3 setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
            self.button4.userInteractionEnabled=YES;
            self.arrowImage2.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        else if(buttonFlag==4)
        {
            p=0;
            [self.button4 setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
            self.button5.userInteractionEnabled=YES;
            self.arrowImage3.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        else
        {
            q=0;
            [self.button5 setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
            self.arrowImage4.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        
    }
    else if (selectedEmployee.count == 1)
    {
        if (buttonFlag==1) {
            x=0;
            [self.button1 setImage:[UIImage imageWithData:selectedEmployeeIcon] forState:UIControlStateNormal];
            self.button1.layer.cornerRadius = self.button1.frame.size.width / 2;
            self.button1.clipsToBounds = YES;
            self.button2.userInteractionEnabled=YES;
            self.popUpView.hidden=true;
        }
        else if (buttonFlag==2)
        {
            y=0;
            [self.button2 setImage:[UIImage imageWithData:selectedEmployeeIcon] forState:UIControlStateNormal];
            self.button2.layer.cornerRadius = self.button1.frame.size.width / 2;
            self.button2.clipsToBounds = YES;
            self.button3.userInteractionEnabled=YES;
            self.arrowImage1.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        else if (buttonFlag==3)
        {
            z=0;
            [self.button3 setImage:[UIImage imageWithData:selectedEmployeeIcon] forState:UIControlStateNormal];
            self.button3.layer.cornerRadius = self.button1.frame.size.width / 2;
            self.button3.clipsToBounds = YES;
            self.button4.userInteractionEnabled=YES;
            self.arrowImage2.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        else if(buttonFlag==4)
        {
            p=0;
            [self.button4 setImage:[UIImage imageWithData:selectedEmployeeIcon] forState:UIControlStateNormal];
            self.button4.layer.cornerRadius = self.button1.frame.size.width / 2;
            self.button4.clipsToBounds = YES;
            self.button5.userInteractionEnabled=YES;
            self.arrowImage3.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        else
        {
            q=0;
            [self.button5 setImage:[UIImage imageWithData:selectedEmployeeIcon] forState:UIControlStateNormal];
            self.button5.layer.cornerRadius = self.button1.frame.size.width / 2;
            self.button5.clipsToBounds = YES;
            self.arrowImage4.image=[UIImage imageNamed:@"process_arrow_blue.png"];
            self.popUpView.hidden=true;
        }
        
    }
    NSMutableDictionary *designationDict=[[NSMutableDictionary alloc]init];
    
    [designationDict setObject:selectedEmployee forKey:@"selected_employee"];
    [designationDict setObject:@"employee" forKey:@"type"];
    [designationDict setObject:app.flowAction forKey:@"progress_id"];
    [self.finalDict setObject:designationDict forKey:app.flowAction];
    [self.popupStorageDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"employeeDict"] forKey:app.flowAction];
    
    
    
}
-(IBAction)cancelButtonAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableDocumentsCollectionView" object:Nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enabletable" object:Nil];
    
    [self removeFromSuperview];
}
-(IBAction)saveButtonAction:(id)sender
{
    
    
    self.ruleNameText.text=[self.ruleNameText.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
    self.abbrvText.text=[self.abbrvText.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
    
    if ([[self.finalDict allKeys]containsObject:@"employees"])
    {
        self.countString=[NSString stringWithFormat:@"%lu",(unsigned long)[[self.finalDict allKeys]count]-1];
    }
    else
    {
        self.countString=[NSString stringWithFormat:@"%lu",(unsigned long)[[self.finalDict allKeys]count]];
    }
    
    
    
    [self.finalDict setObject:app.conditionID forKey:@"protocol_id"];
    [self.finalDict setObject:self.countString forKey:@"progress_circle_count"];
    
    
    NSMutableDictionary *protocolDetailsDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.finalDict,@"protocol_details",self.descriptionTextView.text,@"description",self.ruleNameText.text,@"rule_name",self.abbrvText.text,@"rule_abbrv",@"custom",@"rule_type",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedofficeId"],@"o_id",app.ruleID,@"rule_id", nil];
    
    if (([self.finalDict objectForKey:@"1"])&&(self.ruleNameText.text.length > 0)&&(self.abbrvText.text.length > 0))
    {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"ruleAction"]isEqualToString:@"create"])
        {
            [self.myconnection createCustomPaperworkRule:protocolDetailsDict : @"custom"];
        }
        else
        {
            [self.myconnection updateCustomPaperworkRule:protocolDetailsDict :@"custom"];
        }
    }
    else
    {
        [self showalerviewcontroller:@"Make Sure all Mandatory Fields are Entered and Must Set Atleast One Signing Authority"];
    }
    
}


//<<<<<<<<<------------------------------Response Part----------------------------->>>>>>>>>>
-(void)viewAllResponse:(id)responseList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        app.specificEmployeeFlag1=0;
        app.specificEmployeeFlag2=0;
        app.specificEmployeeFlag3=0;
        app.specificEmployeeFlag4=0;
        app.specificEmployeeFlag5=0;
        app.designationFlag1=0;
        app.designationFlag2=0;
        app.designationFlag3=0;
        app.designationFlag4=0;
        app.designationFlag5=0;
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selected_employees"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"officeDetails"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"employeeDict"];
        
        documentationSettingsViewClass *ob = (documentationSettingsViewClass *)self.superview.superview;
        
        [ob viewAllResponse:responseList];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enableDocumentsCollectionView" object:Nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enabletable" object:Nil];
        
        [self removeFromSuperview];
        
    });
}
-(void)serviceGotResponse:(id)responseData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        self.button1.userInteractionEnabled=YES;
//        self.button2.userInteractionEnabled=YES;
//        self.button3.userInteractionEnabled=YES;
//        self.button4.userInteractionEnabled=YES;
//        self.button5.userInteractionEnabled=YES;
//        self.arrowImage1.image=[UIImage imageNamed:@"process_arrow_blue.png"];
//        self.arrowImage2.image=[UIImage imageNamed:@"process_arrow_blue.png"];
//        self.arrowImage3.image=[UIImage imageNamed:@"process_arrow_blue.png"];
//        self.arrowImage4.image=[UIImage imageNamed:@"process_arrow_blue.png"];
        
        
        NSLog(@"%@",responseData);
        
        [self.finalDict removeAllObjects];
        
        NSMutableArray *storesArray=[[NSMutableArray alloc]init];
        for(int i=0;i<[[responseData objectForKey:@"store"] count];i++)
        {
            NSMutableDictionary *storeDict=[[responseData objectForKey:@"store"]objectAtIndex:i];
            [storesArray addObject:[storeDict objectForKey:@"store_name"]];
        }
        
        NSMutableDictionary *protocolDict=[responseData objectForKey:@"protocol_details"];
        NSArray *allKeysArray=[protocolDict allKeys];
        allKeysArray = [allKeysArray sortedArrayUsingComparator:^(id str1, id str2){
            
            return [(NSString *)str1 compare:(NSString *)str2 options:NSNumericSearch];
            
        }];
        
        for (int i=0; i<allKeysArray.count; i++) {
            
            NSMutableDictionary *mydict=[protocolDict objectForKey:[allKeysArray objectAtIndex:i]];
            int key=[[allKeysArray objectAtIndex:i]intValue];
            
            
            if ([[mydict objectForKey:@"type"]isEqualToString:@"designation"]) {
                
                if (key==1)
                {
                    [self.button1 setImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
                }
                if (key==2)
                {
                    [self.button2 setImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
                }
                if (key==3)
                {
                    [self.button3 setImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
                }
                if (key==4)
                {
                    [self.button4 setImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
                }
                if (key==5)
                {
                    [self.button5 setImage:[UIImage imageNamed:@"circle_2.png"] forState:UIControlStateNormal];
                }
                
                
                
                NSMutableDictionary *desigDict=[[NSMutableDictionary alloc]init];
                [desigDict setObject:[NSString stringWithFormat:@"%d",key] forKey:@"progress_id"];
                [desigDict setObject:@"designation" forKey:@"type"];
                
                NSMutableDictionary *selectedDesignationDict=[mydict objectForKey:@"selected_designation"];
                
                NSMutableDictionary *selectedDesigDict=[[NSMutableDictionary alloc]init];
                [selectedDesigDict setObject:[selectedDesignationDict objectForKey:@"office"] forKey:@"office"];
                
                NSMutableArray *storesDesigArray=[[NSMutableArray alloc]init];
                for (int j=0; j<storesArray.count; j++) {
                    
                    [storesDesigArray addObject:[selectedDesignationDict objectForKey:[storesArray objectAtIndex:j]]];
                    
                }
                [selectedDesigDict setObject:storesDesigArray forKey:@"stores"];
                
                [desigDict setObject:selectedDesigDict forKey:@"selected_designation"];
                [self.finalDict setObject:desigDict forKey:[NSString stringWithFormat:@"%d",key]];
                
                
            }
            else if ([[mydict objectForKey:@"type"]isEqualToString:@"employee"])
            {
                NSMutableDictionary *empDict=[[NSMutableDictionary alloc]init];
                [empDict setObject:[NSString stringWithFormat:@"%d",key] forKey:@"progress_id"];
                [empDict setObject:@"employee" forKey:@"type"];
                
                NSMutableArray *selectedEmpArray=[[NSMutableArray alloc]init];
                
                
                if ([[mydict objectForKey:@"selected_employee"] count]==1)
                {
                    NSMutableDictionary *empDict=[[mydict objectForKey:@"selected_employee"] objectAtIndex:0];
                    NSData *imageData;
                    
                    if ([[empDict objectForKey:@"emp_encode_image"]isEqualToString:@""])
                    {
                        UIImage *image=[UIImage imageNamed:@"img 1.png"];
                        imageData=UIImagePNGRepresentation(image);
                    }
                    else
                    {
                         imageData= [[NSData alloc] initWithBase64EncodedString:[empDict objectForKey:@"emp_encode_image"] options:0];
                    }
                    
                    if (key==1)
                    {
                        [self.button1 setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                        self.button1.layer.cornerRadius = self.button1.frame.size.width / 2;
                        self.button1.clipsToBounds = YES;
                    }
                    if (key==2)
                    {
                        [self.button2 setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                        self.button2.layer.cornerRadius = self.button2.frame.size.width / 2;
                        self.button2.clipsToBounds = YES;
                    }
                    if (key==3)
                    {
                        [self.button3 setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                        self.button3.layer.cornerRadius = self.button3.frame.size.width / 2;
                        self.button3.clipsToBounds = YES;
                    }
                    if (key==4)
                    {
                        [self.button4 setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                        self.button4.layer.cornerRadius = self.button4.frame.size.width / 2;
                        self.button4.clipsToBounds = YES;
                    }
                    if (key==5)
                    {
                        [self.button5 setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                        self.button5.layer.cornerRadius = self.button5.frame.size.width / 2;
                        self.button5.clipsToBounds = YES;
                    }
                    
                }
                else
                {
                    if (key==1)
                    {
                        [self.button1 setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
                    }
                    if (key==2)
                    {
                        [self.button2 setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
                    }
                    if (key==3)
                    {
                        [self.button3 setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
                    }
                    if (key==4)
                    {
                        [self.button4 setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
                    }
                    if (key==5)
                    {
                        [self.button5 setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
                    }
                }
                
                for (int j=0;j<[[mydict objectForKey:@"selected_employee"] count]; j++) {
                    
                    NSMutableDictionary *emplDict=[[mydict objectForKey:@"selected_employee"]objectAtIndex:j];
                    [selectedEmpArray addObject:[emplDict objectForKey:@"emp_id"]];
                }
                
                [empDict setObject:selectedEmpArray forKey:@"selected_employee"];
                [self.finalDict setObject:empDict forKey:[NSString stringWithFormat:@"%d",key]];
                
                
            }
            else if ([[mydict objectForKey:@"type"]isEqualToString:@"owner"])
            {
                if (key==1)
                {
                    [self.button1 setImage:[UIImage imageNamed:@"circle_1.png"] forState:UIControlStateNormal];
                }
                if (key==2)
                {
                    [self.button2 setImage:[UIImage imageNamed:@"circle_1.png"] forState:UIControlStateNormal];
                }
                if (key==3)
                {
                    [self.button3 setImage:[UIImage imageNamed:@"circle_1.png"] forState:UIControlStateNormal];
                }
                if (key==4)
                {
                    [self.button4 setImage:[UIImage imageNamed:@"circle_1.png"] forState:UIControlStateNormal];
                }
                if (key==5)
                {
                    [self.button5 setImage:[UIImage imageNamed:@"circle_1.png"] forState:UIControlStateNormal];
                }
                
                NSMutableDictionary *ownerDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"owner",@"type",[NSString stringWithFormat:@"%d",key],@"progress_id", nil];
                [self.finalDict setObject:ownerDict forKey:[NSString stringWithFormat:@"%d",key]];
            }
            //FlowActiom Image Settings
            switch (key) {
                case 1:
                    self.button2.userInteractionEnabled=YES;
                    break;
                case 2:
                    self.button3.userInteractionEnabled=YES;
                    self.arrowImage1.image=[UIImage imageNamed:@"process_arrow_blue.png"];
                    break;
                case 3:
                    self.button4.userInteractionEnabled=YES;
                    self.arrowImage2.image=[UIImage imageNamed:@"process_arrow_blue.png"];
                    break;
                case 4:
                    self.button5.userInteractionEnabled=YES;
                    self.arrowImage3.image=[UIImage imageNamed:@"process_arrow_blue.png"];
                    break;
                case 5:
                    self.arrowImage4.image=[UIImage imageNamed:@"process_arrow_blue.png"];
                    
                default:
                    break;
            }
        }
        
        NSMutableDictionary *ruleDetailsDict=[[responseData objectForKey:@"rule_details"] objectAtIndex:0];
        app.conditionID=[ruleDetailsDict objectForKey:@"protocol_id"];
        self.ruleNameText.text=[ruleDetailsDict objectForKey:@"rule_name"];
        self.abbrvText.text=[ruleDetailsDict objectForKey:@"rule_abbrv"];
        self.descriptionTextView.text=[ruleDetailsDict objectForKey:@"description"];
        
        
        
    });
}

-(void)showalerviewcontroller:(NSString *)errorMessage
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Error"
                               message:[NSString stringWithFormat:@"%@",errorMessage]
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   //  [app hudStop];
                                               }];
    [alert addAction:ok];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [(settingsViewController *)[self.superview.superview.superview.superview nextResponder] presentViewController:alert animated:YES completion:nil];
    });
}

@end
