/*----------------------------------------------------------------------------
 miniAudicle
 Cocoa GUI to chuck audio programming environment
 
 Copyright (c) 2005-2013 Spencer Salazar.  All rights reserved.
 http://chuck.cs.princeton.edu/
 http://soundlab.cs.princeton.edu/
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 U.S.A.
 -----------------------------------------------------------------------------*/

//
//  mAExportProgressViewController.m
//  miniAudicle
//
//  Created by Spencer Salazar on 6/12/13.
//
//

#import "mAExportProgressViewController.h"

@interface mAExportProgressViewController ()

@end

@implementation mAExportProgressViewController

@synthesize delegate;

- (id)initWithWindowNibName:(NSString *)nibNameOrNil
{
    self = [super initWithWindowNibName:nibNameOrNil];
    if (self)
    {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    [progressIndicator startAnimation:self];
}

- (IBAction)cancel:(id)sender
{
    [delegate exportProgressDidCancel];
}

@end
