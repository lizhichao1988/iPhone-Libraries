//
//  RFoundationAppDelegate.h
//  RFoundation
//
//  Created by Ryan Wang on 11-4-15.
//  Copyright 2011 DDMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFoundationAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

