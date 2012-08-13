//
//  ViewController.h
//  EuroTalkApp
//
//  Created by Daniel Hakimi-Nayeri on 09/08/2012.
//  Copyright (c) 2012 Daniel Hakimi-Nayeri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    NSString *cityString;
    NSString *internationalCityURL;
    NSString *USCityURL;
    NSString *iconURL;
    NSString *countryString;
    NSString *city;
    NSString *labelPrefix;
}

@property (weak, nonatomic) IBOutlet UILabel *displayWeatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *displayWeatherButton;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (retain, nonatomic) IBOutlet UITextField *cityTextField;
@property (retain, nonatomic) IBOutlet UILabel *showWeatherTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cityRegionPicker;

- (IBAction)removeKeyboard:(id)sender;
- (IBAction)worldCityPicker:(id)sender;
- (IBAction)DisplayWeatherForecast:(id)sender;

-(void) requestWeatherForecast: (NSString *) URLString;
-(NSString *) formatText:(NSString *) string;

@end
