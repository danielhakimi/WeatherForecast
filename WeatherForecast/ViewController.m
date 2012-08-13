//
//  ViewController.m
//  EuroTalkApp
//
//  Created by Daniel Hakimi-Nayeri on 09/08/2012.
//  Copyright (c) 2012 Daniel Hakimi-Nayeri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize displayWeatherLabel;
@synthesize imageView;
@synthesize displayWeatherButton;
@synthesize countryTextField;
@synthesize cityTextField;
@synthesize showWeatherTextField;
@synthesize cityRegionPicker;

- (void)viewDidLoad
{
    internationalCityURL = @"http://api.wunderground.com/api/6e6371e8b47b980b/geolookup/conditions/forecast/q/";
    USCityURL = @"http://api.wunderground.com/api/6e6371e8b47b980b/forecast/geolookup/conditions/q/CA/";
    iconURL = @"http://icons.wxug.com/i/c/a/";
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setCityTextField:nil];
    [self setShowWeatherTextField:nil];
    [self setCityRegionPicker:nil];
    [self setCountryTextField:nil];
    [self setDisplayWeatherButton:nil];
    [self setImageView:nil];
    [self setDisplayWeatherLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)removeKeyboard:(id)sender
{
    [cityTextField resignFirstResponder];
}

- (IBAction)worldCityPicker:(id)sender
{
    if (cityRegionPicker.selectedSegmentIndex == 1)
    {        
        countryTextField.hidden = NO;
        cityTextField.text = nil;
    }
    else
    {        
        countryTextField.hidden = YES;
        countryTextField.text = nil;
        cityTextField.text = nil;
        
    }
}

- (IBAction)DisplayWeatherForecast:(id)sender
{
    cityString = cityTextField.text;
    
    if (cityRegionPicker.selectedSegmentIndex == 1)
    {
        [self textFieldShouldReturn:countryTextField];
    }
    else
    {
        [self textFieldShouldReturn:cityTextField];
    }
}


// formatText takes a string and changes the first letter of each word to an capital letter
-(NSString *) formatText:(NSString *) string
{
    NSArray *storedText = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *sortedText = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [storedText count]; i++)
    {
        NSString *capitalizedString = [storedText objectAtIndex:i];
        
        if (i != [storedText count] -1)
            capitalizedString = [capitalizedString stringByAppendingString:@"_"];
        
        capitalizedString = [capitalizedString capitalizedString];
        [sortedText addObject:capitalizedString];
    }
    
    return [sortedText componentsJoinedByString:@""];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    USCityURL = @"http://api.wunderground.com/api/6e6371e8b47b980b/forecast/geolookup/conditions/q/CA/";
    internationalCityURL = @"http://api.wunderground.com/api/6e6371e8b47b980b/geolookup/conditions/forecast/q/";
    iconURL = @"http://icons.wxug.com/i/c/a/";
    displayWeatherLabel.text = nil;
    
    if (cityRegionPicker.selectedSegmentIndex == 1)
    {
        // get country string
        countryString = countryTextField.text;
        countryString = [self formatText:countryString];
        countryString = [countryString stringByAppendingString:@"/"];
        internationalCityURL = [internationalCityURL stringByAppendingString:countryString];
        
        // get city string                
        city = cityString = cityTextField.text;
        cityString = [self formatText:cityString];
        cityString = [cityString stringByAppendingString:@".json"];
        internationalCityURL = [internationalCityURL stringByAppendingString:cityString];
        
        countryTextField.text = nil;
        cityTextField.text = nil;
        
        // Process 
        [self requestWeatherForecast:internationalCityURL];
        NSLog(@"country string = %@", internationalCityURL);
        internationalCityURL = nil;
    }
    else
    {
        city = cityString = cityTextField.text;
        cityString = [self formatText:cityString];
        cityString = [cityString stringByAppendingString:@".json"];
        USCityURL = [USCityURL stringByAppendingString:cityString];
        
        countryTextField.text = nil;
        cityTextField.text = nil;
        
        [self requestWeatherForecast:USCityURL];
         NSLog(@"city string = %@", USCityURL);
        USCityURL = nil;
    }
   
    [countryTextField resignFirstResponder];
    [textField resignFirstResponder];
    [displayWeatherButton resignFirstResponder];
    [cityTextField resignFirstResponder];
    return YES;
    
}

-(void) requestWeatherForecast: (NSString *) URLString
{
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    id forecast = [json objectForKey:@"forecast"];    
    
    if (forecast)
    {          
        forecast = [forecast objectForKey:@"simpleforecast"];
        forecast = [forecast objectForKey:@"forecastday"];
        forecast = [forecast objectAtIndex:0];
        forecast = [forecast objectForKey:@"conditions"];
                
        cityString = nil;
        cityTextField.text = nil;
        
        iconURL = [iconURL stringByAppendingString:[self formatText:forecast]];
        iconURL = [iconURL stringByAppendingString:@".gif"];
        iconURL = [iconURL lowercaseString];
        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconURL]]];
        
        labelPrefix = @"Today's weather forecast for ";       
        labelPrefix = [labelPrefix stringByAppendingString:[city stringByAppendingString:@": "]];      
        labelPrefix = [labelPrefix stringByAppendingString:[forecast lowercaseString]];
        displayWeatherLabel.text = labelPrefix;
        
        city = nil;
        NSLog(@"%@", iconURL);
        NSLog(@"%@", forecast);
        NSLog(@"%@", USCityURL);
        NSLog(@"%@", internationalCityURL);
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter a valid location"
                                                       delegate:nil cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        imageView.image = nil;
    }
    
}

@end
