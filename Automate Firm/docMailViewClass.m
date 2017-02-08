//
//  docMailViewClass.m
//  Automate Firm
//
//  Created by Ambu Vamadevan on 24/11/2016.
//  Copyright © 2016 leonine. All rights reserved.
//

#import "docMailViewClass.h"
#import "mailCell.h"
#import "recieverCell.h"
#import "homeViewController.h"



@implementation docMailViewClass

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.myconnection=[[connectionclass alloc]init];
    self.myconnection.mydelegate=self;

    
    [self.attachDocCollection registerNib:[UINib nibWithNibName:@"mailCell" bundle:nil] forCellWithReuseIdentifier:@"simplecell"];
    [self.reciverCollection registerNib:[UINib nibWithNibName:@"recieverCell" bundle:nil] forCellWithReuseIdentifier:@"simplecell"];
   // self.attachmentArary=[[NSMutableArray alloc]initWithObjects:@"document-thumbnail.jpg",@"document-thumbnail.jpg",@"document-thumbnail.jpg",@"document-thumbnail.jpg",@"document-thumbnail.jpg",@"document-thumbnail.jpg", nil];
    self.receiverAray=[[NSMutableArray alloc]initWithObjects:@"abc", nil];
     self.app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.attachmentArary=[[NSMutableArray alloc]init];
    [self.attachmentArary addObjectsFromArray:self.app.selectedDoc_array];

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==self.reciverCollection) {
        return self.receiverAray.count;
    }
    else{
        return  self.attachmentArary.count;
 
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag==1) {
        recieverCell *cell=(recieverCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"simplecell" forIndexPath:indexPath];
        cell.reciverLabel.text=self.receiverAray[indexPath.row];
        return  cell;

    }
    else{
    mailCell *cell=(mailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"simplecell" forIndexPath:indexPath];
   // cell.docImage.image=[UIImage imageNamed:self.attachmentArary[indexPath.row]];
    return  cell;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.mailidText) {
    
        [self.receiverAray addObject:self.mailidText.text];
        [self.reciverCollection reloadData];
        
    }
    
    
}


-(IBAction)deleteReceverAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    CGPoint rootPoint = [button convertPoint:CGPointZero toView:self.reciverCollection];
    
    NSIndexPath *indexPath = [self.reciverCollection indexPathForItemAtPoint:rootPoint];
    [self.receiverAray removeObjectAtIndex:indexPath.row];
    [self.reciverCollection reloadData];

}

- (IBAction)closeView:(id)sender {
    [self removeFromSuperview];
}

-(IBAction)sendmail:(id)sender
{
    
    [self.myconnection EmailDocumentationprocess:self.frommailtext.text toaddress:self.mailidText.text subject:self.subjecttextField.text composematter:self.composeletterttextField.text attachedimages:self.app.selectedDoc_array];
}

-(void)mailidDSendingImagesresponse:(id)mailresponse
{
    if ([mailresponse isEqualToString:@"200"]) {
        
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"Success"
                                   message:@"Mail Send Successfully"
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       //Do Some action here
                                                   }];
        [alert addAction:ok];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [(homeViewController *)[self.superview.superview.superview.superview nextResponder] presentViewController:alert animated:YES completion:nil];
        });

        
        [self removeFromSuperview];
    }
    else
    {
        
        
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"Error"
                                   message:@"Mail Cannot Send "
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       //Do Some action here
                                                   }];
        [alert addAction:ok];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [(homeViewController *)[self.superview.superview.superview.superview nextResponder] presentViewController:alert animated:YES completion:nil];
        });

        
    }
}

-(void)showalerviewcontroller:(NSString *)errorMessage
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@""
                               message:errorMessage
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   //Do Some action here
                                               }];
    [alert addAction:ok];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [(homeViewController *)[self.superview.superview.superview.superview nextResponder] presentViewController:alert animated:YES completion:nil];
    });
    
}

@end
