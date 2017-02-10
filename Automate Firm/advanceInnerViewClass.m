//
//  advanceInnerViewClass.m
//  Automate Firm
//
//  Created by leonine on 11/4/16.
//  Copyright © 2016 leonine. All rights reserved.
//

#import "advanceInnerViewClass.h"
#import "groupcollceioncellclass.h"
#import "popupTableViewCell.h"
#import "advanceDocumentTile.h"
#import "settingsViewController.h"
#import "advanceDocumentsViewClass.h"

@implementation advanceInnerViewClass

@synthesize buttonFlag,x,y,z,p,q;
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
    [self.mycollectionview registerNib:[UINib nibWithNibName:@"Groupcollectioncell" bundle:nil] forCellWithReuseIdentifier:@"simplecell"];
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.myconnection=[[connectionclass alloc]init];
    self.myconnection.mydelegate=self;
    
    self.grouparray=[[NSMutableArray alloc]init];
    self.popupArray=[[NSMutableArray alloc] initWithObjects:@"Designations",@"Owners",@"Specific Individuals", nil];
    self.dropHighlightArray=[[NSMutableArray alloc]init];
    
    self.finalDict=[[NSMutableDictionary alloc]init];
    self.popupStorageDict=[[NSMutableDictionary alloc]init];
    
    self.popUpView.hidden=true;
    self.button2.userInteractionEnabled=NO;
    self.button3.userInteractionEnabled=NO;
    self.button4.userInteractionEnabled=NO;
    self.button5.userInteractionEnabled=NO;
    buttonFlag=0;
    x=0;
    y=0;
    z=0;
    p=q=0;
    self.countString=@"0";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewLoad) name:@"advancePaperworkProtocol" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)viewLoad
{
    [self clearView];
    
    if (!([app.conditionID isEqualToString:@"0"])) {
        
        [self.myconnection viewIndividualPaperworkProtocol:[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedofficeId"] :app.ruleID :app.conditionID :@"advance"];
    }
    
}
-(void)clearView
{
    self.descriptionText.text=@"";
    [self.grouparray removeAllObjects];
    [self.mycollectionview reloadData];
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
    [self.finalDict removeAllObjects];
    [self.popupStorageDict removeAllObjects];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.grouparray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"simplecell";
    groupcollceioncellclass *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (self.grouparray.count>0) {
        cell.grouplabel.text=[self.grouparray objectAtIndex:indexPath.row];
        
    }
    return cell;
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
    app.warningflag=1;
    popupTableViewCell *cell=[self.popupTableView cellForRowAtIndexPath:indexPath];
    cell.backImage.image=[UIImage imageNamed:@"drop_box_blue.png"];
    cell.popupLabel.textColor=[UIColor whiteColor];
    if (indexPath.row==0) {
        [[NSUserDefaults standardUserDefaults]setObject:@"designation" forKey:@"popupAction"];
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"includeDesignation"];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"includeDesignationView" owner:self options:nil];
        [self.superview.superview.superview.superview addSubview:[nib objectAtIndex:0]];
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
        [self.superview.superview.superview.superview addSubview:[nib objectAtIndex:0]];
        
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
    if (textField==self.descriptionText)
    {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (textField.text.length<=69) {
            NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_+:<>,./?|\" "];
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
- (void) keyboardDidShow:(NSNotification *)notification
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"keyboardAction"]isEqualToString:@"keyboardEnable"]) {
        
    }
    else
    {
        NSDictionary* info = [notification userInfo];
        CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        kbRect = [self convertRect:kbRect fromView:nil];
        
        
        advanceDocumentsViewClass *ob = (advanceDocumentsViewClass *)self.superview.superview.superview.superview;
        [ob.scrollView setContentOffset:CGPointMake(ob.scrollView.frame.origin.x,100) animated:YES];
        
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
        // ob.scrollView.contentInset = contentInsets;
        //  ob.scrollView.scrollIndicatorInsets = contentInsets;
        
        CGRect aRect = self.frame;
        aRect.size.height -= kbRect.size.height;
        
        if (!CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
            
            [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
        }
    }
    
}
- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    advanceDocumentsViewClass *ob = (advanceDocumentsViewClass *)self.superview.superview.superview.superview;
    [ob.scrollView setContentOffset:CGPointMake(ob.scrollView.frame.origin.x,0) animated:YES];
    
}

-(IBAction)editingChanged:(id)sender
{
    app.warningflag=1;
}
-(IBAction)button1Action:(id)sender
{
    if (x%2==0) {
        buttonFlag=1;
        app.flowAction=@"1";
        self.popUpView.hidden=false;
        [self settingsLocalStorageValue:@"1"];
        
        [self.popupTableView reloadData];
        self.popUpView.frame=CGRectMake(-5, 126, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
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
        self.popUpView.frame=CGRectMake(95, 126, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
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
        self.popUpView.frame=CGRectMake(208, 126, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
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
        self.popUpView.frame=CGRectMake(325, 126, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
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
        self.popUpView.frame=CGRectMake(425, 126, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
    }
    else
    {
        q++;
        self.popUpView.hidden=true;
    }
    
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
-(IBAction)includeDesignationAction:(id)sender
{
    app.warningflag=1;
    [[NSUserDefaults standardUserDefaults]setObject:@"includedesignation" forKey:@"popupAction"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"includeEmployeePopup" owner:self options:nil];
    [self.superview.superview.superview.superview addSubview:[nib objectAtIndex:0]];
    
}
-(void)collectionViewReload:(NSMutableArray *)desigArray
{
    [self.grouparray removeAllObjects];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"selected_employees"] count] > 0) {
        [self.finalDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"selected_employees"] forKey:@"employees"];
    }
    else
    {
        [self.finalDict setObject:@"" forKey:@"employees"];
    }
    
    
    
    self.mycollectionview.hidden=false;
    [self.grouparray addObjectsFromArray:desigArray];
    [self.mycollectionview reloadData];
    
    
    
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
-(IBAction)removegroupfromcollectionview:(id)sender
{
    groupcollceioncellclass *clickedCell = (groupcollceioncellclass *)[[sender superview] superview];
    self.indexpath = [self.mycollectionview indexPathForCell:clickedCell];
    [self.grouparray removeObjectAtIndex:self.indexpath.row];
    [self.mycollectionview reloadData];
}
-(IBAction)saveButtonAction:(id)sender
{
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
    NSMutableDictionary *protocolDetailsDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.finalDict,@"protocol_details",app.ruleID,@"rule_id",self.descriptionText.text,@"description",@"advance",@"rule_type",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedofficeId"],@"o_id", nil];
    
    if ([self.finalDict objectForKey:@"1"])
    {
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"paperworkAction"]isEqualToString:@"create"])
        {
            if ([app.conditionID isEqualToString:@"0"]) {
                [self.myconnection saveIndividualProtocol:protocolDetailsDict];
            }
            else
            {
                [self.myconnection updateIndividualProtocol:protocolDetailsDict];
            }
            
        }
        else
        {
            if ([app.conditionID isEqualToString:@"0"]) {
                [self.myconnection saveIndividualProtocol:protocolDetailsDict];
            }
            else
            {
                [self.myconnection updateIndividualProtocol:protocolDetailsDict];
            }
        }
    }
    else
    {
        [self showalerviewcontroller:@"Must Set Atleast One Signing Authority"];
    }
    
    
}


//<<<<<<<<<------------------------------Response Part----------------------------->>>>>>>>>>
-(void)createResponse:(id)Response
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"%@",Response);
        
        app.designationFlag=0;
        app.warningflag=0;
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
            
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"officeDetails"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"employeeDict"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selected_employees"];
            
        [app.conditionIDArray replaceObjectAtIndex:app.selectedRow withObject:[NSString stringWithFormat:@"%@",[Response objectForKey:@"id"]]];
            
            
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"paperworkAction"]isEqualToString:@"create"])
        {
            advanceDocumentTile *ob = (advanceDocumentTile *)self.superview.superview;
            [app.conditionIDArray addObject:@"0"];
            [ob addaccordianview];
        }
        else
        {
            advanceDocumentTile *ob = (advanceDocumentTile *)self.superview.superview;
            [ob closeTile];
        }
        
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
        [self.grouparray removeAllObjects];
        
        NSMutableArray *storesArray=[[NSMutableArray alloc]init];
        for(int i=0;i<[[responseData objectForKey:@"store"] count];i++)
        {
            NSMutableDictionary *storeDict=[[responseData objectForKey:@"store"]objectAtIndex:i];
            [storesArray addObject:[storeDict objectForKey:@"store_name"]];
        }
        
        NSMutableDictionary *protocolDict=[responseData objectForKey:@"protocol_details"];
        
        NSArray *allKeysArrays=[protocolDict allKeys];
        allKeysArrays = [allKeysArrays sortedArrayUsingComparator:^(id str1, id str2){
            
            return [(NSString *)str1 compare:(NSString *)str2 options:NSNumericSearch];
            
        }];
        NSMutableArray *allKeysArray=[allKeysArrays mutableCopy];
        [allKeysArray removeObject:@"employees"];
        
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
        

        NSMutableDictionary *employeeDict=[[NSMutableDictionary alloc]init];
        id empDictionary=[protocolDict objectForKey:@"employees"];
        if ([empDictionary isKindOfClass:[NSArray class]]) {
            
            [self.finalDict setObject:@"" forKey:@"employees"];
        }
        else
        {
            [employeeDict setObject:[empDictionary objectForKey:@"office"] forKey:@"office"];
            NSMutableArray *storesEmpArray=[[NSMutableArray alloc]init];
            for (int j=0; j<storesArray.count; j++) {
                [storesEmpArray addObject:[empDictionary objectForKey:[storesArray objectAtIndex:j]]];
            }
            [employeeDict setObject:storesEmpArray forKey:@"stores"];
            [self.finalDict setObject:employeeDict forKey:@"employees"];
            for (int of=0; of<[[responseData objectForKey:@"office_employee"]count]; of++) {
                
                NSMutableDictionary *localDict1=[[responseData objectForKey:@"office_employee"] objectAtIndex:of];
                
                NSString *myString=[NSString stringWithFormat:@"%@:%@",[localDict1 objectForKey:@"office_name"],[localDict1 objectForKey:@"emp_name"]];
                
                [self.grouparray addObject:myString];
                
            }
            
            for (int st=0; st<[[responseData objectForKey:@"store_employee"]count]; st++) {
                
                NSMutableDictionary *localDict1=[[responseData objectForKey:@"store_employee"] objectAtIndex:st];
                
                NSString *myString=[NSString stringWithFormat:@"%@:%@",[localDict1 objectForKey:@"store_name"],[localDict1 objectForKey:@"emp_name"]];
                
                [self.grouparray addObject:myString];
                
            }
        }
        
        
        
        [self.mycollectionview reloadData];
        self.descriptionText.text=[[[responseData objectForKey:@"description"]objectAtIndex:0]objectForKey:@"description"];
        
        
        
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
        
        [(settingsViewController *)[self.superview.superview.superview.superview.superview.superview.superview.superview nextResponder] presentViewController:alert animated:YES completion:nil];
    });
}

@end
