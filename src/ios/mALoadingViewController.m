//
//  mALoadingViewController.m
//  miniAudicle
//
//  Created by Spencer Salazar on 7/26/16.
//
//

#import "mALoadingViewController.h"
#import "UIColor+iOS7BlueColor.h"


@interface mALoadingViewController ()
{
    IBOutlet UILabel *_statusLabel;
    IBOutlet UIActivityIndicatorView *_activityIndicator;
}

@end

@implementation mALoadingViewController

- (void)setLoadingViewStyle:(mALoadingViewStyle)loadingViewStyle
{
    _loadingViewStyle = loadingViewStyle;
    
    if(_loadingViewStyle == mALoadingViewStyleTransparent)
    {
        self.view.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.5];
        _activityIndicator.color = [UIColor whiteColor];
        _statusLabel.textColor = [UIColor whiteColor];
    }
    else if(_loadingViewStyle == mALoadingViewStyleOpaque)
    {
        self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        _activityIndicator.color = [UIColor iOS7BlueColor];
        _statusLabel.textColor = [UIColor blackColor];
    }
}

- (void)setLoading:(BOOL)loading
{
    _loading = loading;
    
    if(loading)
        [_activityIndicator startAnimating];
    else
        [_activityIndicator stopAnimating];
}

- (void)setStatus:(NSString *)status
{
    _status = status;
    _statusLabel.text = status;
}

- (id)init
{
    // convenience init method calls with default nib
    if(self = [self initWithNibName:@"mALoadingView" bundle:nil]) { }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.alpha = 0.0;
    self.loading = YES;
    self.status = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)show
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.view.alpha = 1.0;
                     }];
}

- (void)show:(void (^)())completion
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         completion();
                     }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.view.alpha = 0.0;
                     }];
}

- (void)hide:(void (^)())completion
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.view.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         completion();
                     }];
}

- (void)fit
{
    if(self.view.superview)
        self.view.frame = self.view.superview.bounds;
}

@end