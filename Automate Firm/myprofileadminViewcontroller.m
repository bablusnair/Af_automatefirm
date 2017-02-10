//
//  myprofileadminViewcontroller.m
//  Automate Firm
//
//  Created by Ambu Vamadevan on 19/01/2017.
//  Copyright © 2017 leonine. All rights reserved.
//

#import "myprofileadminViewcontroller.h"
#import "paymentHistoryTableViewCell.h"
#import "paymethodTablecell.h"
#import "paymentBrowseCollectionCell.h"

@interface myprofileadminViewcontroller ()

@end

@implementation myprofileadminViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.addnewPaymentmethodview.hidden=true;
   // self.estDatePicker.backgroundColor=[UIColor lightGrayColor];
    self.dobPicker.backgroundColor=[UIColor lightGrayColor];
    self.datebackgroundView.hidden=true;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.imagearray=[[NSMutableArray alloc] init];
    
    
    
    
    self.myconnection=[[connectionclass alloc]init];
    self.myconnection.mydelegate=self;
    
    [self.myconnection displayAllCountries];
    [self.myconnection signupAgentlistingservice];
    [self.myconnection signupsectorlistingservice];
    
    self.countrydict=[[NSMutableDictionary alloc] init];
    self.statedict=[[NSMutableDictionary alloc] init];
    self.citydict=[[NSMutableDictionary alloc] init];
    self.sectordict=[[NSMutableDictionary alloc] init];
    self.agentdict=[[NSMutableDictionary alloc] init];
    
    
    self.sectorTableview.hidden=true;
    self.agentTableview.hidden=true;
    self.livinginTableview.hidden=true;
    self.stateTableview.hidden=true;
    self.cityTableview.hidden=true;
    self.estdateTableview.hidden=true;
    
    self.sectorArray=[[NSMutableArray alloc] init];
    
    self.agentArray=[[NSMutableArray alloc] init];
    
    self.livingInArray=[[NSMutableArray alloc] init];
    
    self.stateArray=[[NSMutableArray alloc] init];
    
    self.cityArray=[[NSMutableArray alloc] init];
    
    self.estyearArray=[[NSMutableArray alloc] init];

    for (int i=2000; i<3000; i++) {
        
        [self.estyearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.estmatedDatetext) {
        self.estdateTableview.hidden=false;
        return NO;
    }
   else if (textField==self.dobtext) {
        self.dobPicker.hidden=FALSE;
        return  NO;
    }
    
    else if (textField==self.sectorTextfield) {
        
        self.sectorTableview.hidden=false;
        return NO;
        
    }
    
    else if (textField==self.livinginTextfield) {
        
        self.livinginTableview.hidden=false;
        return NO;
        
    }
    else if (textField==self.stateTextfield) {
        
        self.stateTableview.hidden=false;
        return NO;
        
    }
    else if (textField==self.cityTextfield) {
        
        self.cityTableview.hidden=false;
        return NO;
        
    }
    else if (textField==self.dateofbirthTextfield) {
        
        self.datebackgroundView.hidden=false;
        return NO;
        
    }
    else
    {
        self.activeField=textField;
        return  YES;
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)donebutton:(id)sender
{
    self.addnewPaymentmethodview.hidden=true;
}
-(IBAction)cancelbutton:(id)sender
{
    self.addnewPaymentmethodview.hidden=true;
}

-(IBAction)addnewpaymentMethod:(id)sender
{
     self.addnewPaymentmethodview.hidden=false;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==self.paymentHistroytable) {
        
        return 10;
    }
    
    else if (tableView==self.cartHistroytable)
    {
        
    return 12;
    
    }
    else if (tableView==self.paymentMethodtableview)
    {
        
        return 5;
        
    }
    
    else if (tableView==self.sectorTableview) {
        
        return [self.sectorArray count];
    }
    
    else if (tableView==self.agentTableview) {
        
        return [self.agentArray count];
    }
    
    else if (tableView==self.livinginTableview) {
        
        // if (self.filterflag==1)
        //{
        // return [self.filtercountryArray count];
        // }
        // else
        // {
        return [self.livingInArray count];
        // }
        
    }
    
    else if (tableView==self.stateTableview) {
        
        //if (self.filterflag1==1)
        // {
        //    return [self.filterstateArray count];
        // }
        //  else
        // {
        return [self.stateArray count];
        // }
        
    }
    
    else if(tableView==self.cityTableview)
    {
        
        // if (self.filterflag2==1)
        // {
        //return [self.filtercityArray count];
        // }
        // else
        // {
        return [self.cityArray count];
        //}
        
    }
    else if (tableView==self.estdateTableview) {
        
        return [self.estyearArray count];
    }

    else
    {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.paymentHistroytable) {
        
        paymentHistoryTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"myprofile"];
        if (cell==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"paymentHistoryTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        return cell;
        
    }
    
    
    else if (tableView==self.cartHistroytable)
    {
        paymentHistoryTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"myprofile"];
        if (cell==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"paymentHistoryTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        return cell;
    }
    
    
    else if (tableView==self.paymentMethodtableview)
    {
        paymethodTablecell *cell=[tableView dequeueReusableCellWithIdentifier:@"payment"];
        
        if (cell==nil) {
            
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"paymethodTablecell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        return cell;
    }
    
    else if (tableView==self.sectorTableview) {
        
        UITableViewCell *cell =[[UITableViewCell alloc] init];
        cell.textLabel.text=[self.sectorArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    else  if (tableView==self.agentTableview) {
        
        UITableViewCell *cell =[[UITableViewCell alloc] init];
        cell.textLabel.text=[self.agentArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    else  if (tableView==self.livinginTableview) {
        
        UITableViewCell *cell =[[UITableViewCell alloc] init];
        
        //   if (self.filterflag==1)
        //{
        // cell.textLabel.text = [self.filtercountryArray objectAtIndex:indexPath.row];
        //}
        //  else
        //{
        cell.textLabel.text=[self.livingInArray objectAtIndex:indexPath.row];
        // }
        
        return cell;
    }
    
    
    else  if (tableView==self.stateTableview) {
        
        UITableViewCell *cell =[[UITableViewCell alloc] init];
        
        //        if (self.filterflag1==1)
        //        {
        //            cell.textLabel.text = [self.filterstateArray objectAtIndex:indexPath.row];
        //        }
        //        else
        //        {
        cell.textLabel.text=[self.stateArray objectAtIndex:indexPath.row];
        //        }
        
        return cell;
    }
    
    
    else if(tableView==self.cityTableview) {
        
        UITableViewCell *cell =[[UITableViewCell alloc] init];
        
        //        if (self.filterflag2==1)
        //        {
        //            cell.textLabel.text = [self.filtercityArray objectAtIndex:indexPath.row];
        //        }
        //        else
        //        {
        cell.textLabel.text=[self.cityArray objectAtIndex:indexPath.row];
        
        //        }
        
        return cell;
    }
    
    else if(tableView==self.estdateTableview) {
        
        UITableViewCell *cell =[[UITableViewCell alloc] init];
        
        //        if (self.filterflag2==1)
        //        {
        //            cell.textLabel.text = [self.filtercityArray objectAtIndex:indexPath.row];
        //        }
        //        else
        //        {
        cell.textLabel.text=[self.estyearArray objectAtIndex:indexPath.row];
        
        //        }
        
        return cell;
    }
    else
    {
        return  nil;
    }
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.sectorTableview) {
        
        self.sectorTextfield.text=[self.sectorArray objectAtIndex:indexPath.row];
        self.sectorTableview.hidden=true;
        
        if (self.sectorTextfield.text.length>0) {
            
            self.sectorString=[self.sectordict objectForKey:self.sectorTextfield.text];
        }
        
    }
    else  if (tableView==self.livinginTableview) {
        
        self.livinginTextfield.text=[self.livingInArray objectAtIndex:indexPath.row];
        
        if(self.livinginTextfield.text.length>0)
        {
            [self.myconnection displaySelectedStates:[self.countrydict objectForKey:self.livinginTextfield.text]];
            self.countryString=[self.countrydict objectForKey:self.livinginTextfield.text];
        }
        
        self.livinginTableview.hidden=true;
    }
    else  if (tableView==self.stateTableview) {
        
        self.stateTextfield.text=[self.stateArray objectAtIndex:indexPath.row];
        
        if(self.stateTextfield.text.length>0)
        {
            [self.myconnection displayAllCities:[self.statedict objectForKey:self.stateTextfield.text]];
            self.stateString=[self.statedict objectForKey:self.stateTextfield.text];
        }
        self.stateTableview.hidden=true;
    }
    else  if (tableView==self.cityTableview) {
        
        self.cityTextfield.text=[self.cityArray objectAtIndex:indexPath.row];
        self.cityTableview.hidden=true;
        self.cityString=[self.citydict objectForKey:self.cityTextfield.text];
    }
    else  if (tableView==self.estdateTableview) {
        
        self.estmatedDatetext.text=[self.estyearArray objectAtIndex:indexPath.row];
        self.estdateTableview.hidden=true;
    }
    
}

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.scrollView.contentOffset = CGPointMake(0,0);
    return YES;
}

- (IBAction)datePickAction:(id)sender {
    
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    if ( [sender tag]==0) {

    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:self.estDatePicker.date]];
    self.estmatedDatetext.text=str;
        self.estDatePicker.hidden=true;
    }
    else{
        NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:self.dobPicker.date]];
        self.dobtext.text=str;
        self.dobPicker.hidden=true;
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.imagearray count];
    
   }


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"mycell";

    paymentBrowseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.myimgview.image=[self.imagearray objectAtIndex:indexPath.row];
     cell.closebutton.hidden=true;
    UILongPressGestureRecognizer *press=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpress:)];
    [cell addGestureRecognizer:press];
    return cell;

}


-(void)longpress:(UILongPressGestureRecognizer *)guster
{
    
    paymentBrowseCollectionCell *cell0 = (paymentBrowseCollectionCell *)[self.broswecollectionview cellForItemAtIndexPath:self.preindexpath];
     cell0.closebutton.hidden=true;
    
    paymentBrowseCollectionCell *cell = (paymentBrowseCollectionCell *)guster.view;
    cell.closebutton.hidden=false;
    self.myindexpath = [self.broswecollectionview indexPathForCell:cell];
    
    self.preindexpath=self.myindexpath;
    
}

-(IBAction)browseaction:(id)sender
{
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = 10; //Set the maximum number of images to select, defaults to 4
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
    elcPicker.imagePickerDelegate = self;
    
    //Present modally
    [self presentViewController:elcPicker animated:YES completion:nil];
    
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
      [self.imagearray removeAllObjects];
    
    for (NSDictionary *dict in info) {
        
        if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
            UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
            [self.imagearray addObject:image];
        }
    }
  
    [self.broswecollectionview reloadData];
    
      [picker dismissViewControllerAnimated:YES completion:Nil];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    
  [picker dismissViewControllerAnimated:YES completion:Nil];
    
}

-(IBAction)browseimagecloseaction:(id)sender
{
    
    [self.imagearray removeObjectAtIndex:self.myindexpath.row];
    
    [self.broswecollectionview reloadData];
}


-(void)allcountryresponse:(id)countrylist;
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.livingInArray removeAllObjects];
        for (int i=0; i<[countrylist count]; i++) {
            
            
            NSMutableDictionary *dict = [countrylist objectAtIndex:i];
            [self.countrydict setObject:[dict objectForKey:@"country_id"] forKey:[dict objectForKey:@"country_name"]];
            [self.livingInArray addObject:[dict objectForKey:@"country_name"]];
            
        }
        
        [self.livinginTableview reloadData];
        
    });
    
}

-(void)allstateresponse:(id )statelist
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.stateArray removeAllObjects];
        for (int i=0; i<[statelist count]; i++) {
            
            
            NSMutableDictionary *dict = [statelist objectAtIndex:i];
            [self.statedict setObject:[dict objectForKey:@"state_id"] forKey:[dict objectForKey:@"name"]];
            [self.stateArray addObject:[dict objectForKey:@"name"]];
            
        }
        
        [self.stateTableview reloadData];
        
    });
    
    
}

-(void)allcityresponse:(id)Citylist
{
    
    [self.cityArray removeAllObjects];
    NSLog(@"%@",Citylist);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.cityArray removeAllObjects];
        
        for (int i=0; i<[Citylist count]; i++) {
            
            NSMutableDictionary *dict = [Citylist objectAtIndex:i];
            
            [self.citydict setObject:[dict objectForKey:@"city_id"] forKey:[dict objectForKey:@"name"]];
            [self.cityArray addObject:[dict objectForKey:@"name"]];
        }
        
        [self.cityTableview reloadData];
        
    });
    
}

-(void)signupmodulesectorResponse:(id)details
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.sectorArray removeAllObjects];
        
        for (int i=0; i<[details count]; i++) {
            
            NSMutableDictionary *dict = [details objectAtIndex:i];
            
            [self.sectordict setObject:[dict objectForKey:@"s_id"] forKey:[dict objectForKey:@"title"]];
            
            [self.sectorArray addObject:[dict objectForKey:@"title"]];
        }
        
        [self.sectorTableview reloadData];
        
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
                                                   
                                               }];
    [alert addAction:ok];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}


-(IBAction)backbutton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)datepickerDoneaction:(id)sender
{
    
   NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
   dateFormat.dateStyle=NSDateFormatterMediumStyle;
   [dateFormat setDateFormat:@"dd/MMM/yyyy"];

   NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:self.dobPicker.date]];
   self.dateofbirthTextfield.text=str;
   self.datebackgroundView.hidden=true;
 
}

@end
