/*
 * ACCP-SEEK iPhone application.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import <UIKit/UIKit.h>

//
// TODO: was not tested on firmwares older than 3.0
//

#define NIFMailSenderErrorDomain @"NIFMailSenderErrorDomain"

enum  {	
	kNIFMailSenderError_Unknown = 0,
	kNIFMailSenderError_Cancelled
};

@class NIFMailSender;

@protocol NIFMailSenderDelegate <NSObject>
- (void)mailSender:(NIFMailSender*)sender didFinishWithError:(NSError*)error;
@end

@interface NIFMailSender : NSObject {
	NSString* toAddress;
	NSString* subject;
	NSString* body;
	
	id<NIFMailSenderDelegate> delegate;
}

@property (nonatomic, copy) NSString* toAddress;
@property (nonatomic, copy) NSString* subject;
@property (nonatomic, copy) NSString* body;

@property (nonatomic, assign) id<NIFMailSenderDelegate> delegate;

+ (BOOL)canSendWithoutLeavingApp;

- (void)sendWithController:(UIViewController*)controller;

@end
