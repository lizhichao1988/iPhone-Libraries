/*
 * ACCP-SEEK iPhone application.
 * Copyright (C) 2009 Neusis Ltd. All Rights Reserved.
 */

#import "NIFMailSender.h"

#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30000

#import <MessageUI/MessageUI.h>

@interface NIFMailSender () <MFMailComposeViewControllerDelegate>
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;
@end

#endif

@implementation NIFMailSender

@synthesize toAddress;
@synthesize subject;
@synthesize body;

@synthesize delegate;

- (NSString*)encode:(NSString*)s {
	return (NSString*)CFURLCreateStringByAddingPercentEscapes(
		NULL,
		(CFStringRef)s,
		NULL,
		(CFStringRef)@"!*'();:@&=+$,/?%#[]",
		kCFStringEncodingUTF8
	);
}

+ (BOOL)canSendWithoutLeavingApp {

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30000
	Class mailClass = NSClassFromString(@"MFMailComposeViewController");
	if (mailClass != nil && [MFMailComposeViewController canSendMail]) {	
		return YES;
	}
#endif

	return NO;	
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30000
- (void)mailComposeController:(MFMailComposeViewController*)controller 
	didFinishWithResult:(MFMailComposeResult)result 
	error:(NSError *)error
{
	if (result == MFMailComposeResultCancelled) {
		if (delegate && [delegate respondsToSelector:@selector(mailSender:didFinishWithError:)]) {
			NSError* e = [NSError 
				errorWithDomain:NIFMailSenderErrorDomain 
				code:kNIFMailSenderError_Cancelled 
				userInfo:nil
			];
			[delegate mailSender:self didFinishWithError:e];
		}		
	} else if (result == MFMailComposeResultFailed) {
		if (delegate && [delegate respondsToSelector:@selector(mailSender:didFinishWithError:)]) {
			if (error) {
				[delegate mailSender:self didFinishWithError:error];
			} else {
				NSError* e = [NSError 
					errorWithDomain:NIFMailSenderErrorDomain 
					code:kNIFMailSenderError_Unknown 
					userInfo:nil
				];
				[delegate mailSender:self didFinishWithError:e];
			}
		}		
	} else {
		if (delegate && [delegate respondsToSelector:@selector(mailSender:didFinishWithError:)]) {
			[delegate mailSender:self didFinishWithError:nil];
		}			
	}
	[controller dismissModalViewControllerAnimated:YES];
}
#endif

- (void)sendWithController:(UIViewController*)controller {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30000
	Class mailClass = NSClassFromString(@"MFMailComposeViewController");
	if (mailClass != nil && [MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController* c = [[[MFMailComposeViewController alloc] init] autorelease];
		
		[c setMailComposeDelegate:self];
		
		if (subject) {
			[c setSubject:subject];
		}
		if (toAddress) {
			[c setToRecipients:[NSArray arrayWithObject:toAddress]];
		}
		if (body) {
			[c setMessageBody:body isHTML:NO];
		}
						
		[controller presentModalViewController:c animated:YES];
		
		return;
	}
#endif

	NSMutableString* urlString = [NSMutableString string];
	[urlString appendString:@"mailto:"];
	if (toAddress) {
		[urlString appendString:toAddress];
	}
	if (subject) {
		[urlString appendString:@"?subject="];
		[urlString appendString:[self encode:subject]];
	}
	if (body) {
		if (!subject) {
			[urlString appendString:@"?"];
		}
		[urlString appendString:@"&body="];
		[urlString appendString:[self encode:body]];
	}
	
	BOOL succeeded = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
	
	if (delegate && [delegate respondsToSelector:@selector(mailSender:didFinishWithError:)]) {
		if (!succeeded)	{
			NSError* e = [NSError 
				errorWithDomain:NIFMailSenderErrorDomain 
				code:kNIFMailSenderError_Unknown 
				userInfo:nil
			];
			[delegate mailSender:self didFinishWithError:e];
		} else {
			[delegate mailSender:self didFinishWithError:nil];
		}
	}
}

@end
