//
//  IntentHandler.m
//  IntentsExtension
//
//  Created by vivi wu on 2017/5/23.
//  Copyright © 2017 vivi wu. All rights reserved.
//

#import "IntentHandler.h"

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

@interface IntentHandler () <INStartVideoCallIntentHandling, INStartAudioCallIntentHandling /* INSendMessageIntentHandling , INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling */>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    return self;
}

#pragma mark - INStartAudioCallIntentHandling

- (void)handleStartAudioCall:(INStartAudioCallIntent *)intent
                  completion:(void (^)(INStartAudioCallIntentResponse *response))completion NS_SWIFT_NAME(handle(startAudioCall:completion:)){
    INStartAudioCallIntentResponse *response;
    
    if  ([intent.contacts firstObject].personHandle == nil){
        response = [[INStartAudioCallIntentResponse alloc] initWithCode:INStartAudioCallIntentResponseCodeFailure userActivity:nil];
        completion(response);
        return;
    }
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:INStartAudioCallIntent.self];
    
    response = [[INStartAudioCallIntentResponse alloc] initWithCode:INStartAudioCallIntentResponseCodeContinueInApp userActivity:userActivity];
    
    completion(response);
}

- (void)confirmStartAudioCall:(INStartAudioCallIntent *)intent
                   completion:(void (^)(INStartAudioCallIntentResponse *response))completion NS_SWIFT_NAME(confirm(startAudioCall:completion:)){
    
    INStartAudioCallIntentResponse *response;
    
    if  ([intent.contacts firstObject].personHandle == nil){
        response = [[INStartAudioCallIntentResponse alloc] initWithCode:INStartAudioCallIntentResponseCodeFailure userActivity:nil];
        completion(response);
        return;
    }
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:INStartAudioCallIntent.self];
    
    response = [[INStartAudioCallIntentResponse alloc] initWithCode:INStartAudioCallIntentResponseCodeContinueInApp userActivity:userActivity];
    
    completion(response);
}

- (void)resolveContactsForStartAudioCall:(INStartAudioCallIntent *)intent
                          withCompletion:(void (^)(NSArray<INPersonResolutionResult *> *resolutionResults))completion NS_SWIFT_NAME(resolveContacts(forStartAudioCall:with:)){
    NSArray *contacts = intent.contacts;
    NSMutableArray *resolutionResults = [[NSMutableArray alloc] init];
    for (INPerson *contact in contacts){
        [resolutionResults addObject:[INPersonResolutionResult successWithResolvedPerson:contact]];
    }
    completion(resolutionResults);
}

#pragma mark - INStartVideoCallIntentHandling
- (void)handleStartVideoCall:(INStartVideoCallIntent *)intent
                  completion:(void (^)(INStartVideoCallIntentResponse *response))completion NS_SWIFT_NAME(handle(startVideoCall:completion:)){
    
}

- (void)confirmStartVideoCall:(INStartVideoCallIntent *)intent
                   completion:(void (^)(INStartVideoCallIntentResponse *response))completion NS_SWIFT_NAME(confirm(startVideoCall:completion:)){
    INStartVideoCallIntentResponse *response;
    
    if  ([intent.contacts firstObject].personHandle == nil){
        response = [[INStartVideoCallIntentResponse alloc] initWithCode:INStartVideoCallIntentResponseCodeFailure userActivity:nil];
        completion(response);
        return;
    }
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:INStartAudioCallIntent.self];
    
    response = [[INStartVideoCallIntentResponse alloc] initWithCode:INStartVideoCallIntentResponseCodeContinueInApp userActivity:userActivity];
    
    completion(response);
}

#if  0

#pragma mark - INSendMessageIntentHandling

// Implement resolution methods to provide additional information about your intent (optional).
- (void)resolveRecipientsForSendMessage:(INSendMessageIntent *)intent with:(void (^)(NSArray<INSendMessageRecipientResolutionResult *> *resolutionResults))completion {
    NSArray<INPerson *> *recipients = intent.recipients;
    // If no recipients were provided we'll need to prompt for a value.
    if (recipients.count == 0) {
        completion(@[[INSendMessageRecipientResolutionResult needsValue]]);
        return;
    }
    NSMutableArray<INSendMessageRecipientResolutionResult *> *resolutionResults = [NSMutableArray array];
    
    for (INPerson *recipient in recipients) {
        NSArray<INPerson *> *matchingContacts = @[recipient]; // Implement your contact matching logic here to create an array of matching contacts
        if (matchingContacts.count > 1) {
            // We need Siri's help to ask user to pick one from the matches.
            [resolutionResults addObject:[INSendMessageRecipientResolutionResult disambiguationWithPeopleToDisambiguate:matchingContacts]];

        } else if (matchingContacts.count == 1) {
            // We have exactly one matching contact
            [resolutionResults addObject:[INSendMessageRecipientResolutionResult successWithResolvedPerson:recipient]];
        } else {
            // We have no contacts matching the description provided
            [resolutionResults addObject:[INSendMessageRecipientResolutionResult unsupported]];
        }
    }
    completion(resolutionResults);
}

- (void)resolveContentForSendMessage:(INSendMessageIntent *)intent withCompletion:(void (^)(INStringResolutionResult *resolutionResult))completion {
    NSString *text = intent.content;
    if (text && ![text isEqualToString:@""]) {
        completion([INStringResolutionResult successWithResolvedString:text]);
    } else {
        completion([INStringResolutionResult needsValue]);
    }
}

// Once resolution is completed, perform validation on the intent and provide confirmation (optional).

- (void)confirmSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse *response))completion {
    // Verify user is authenticated and your app is ready to send a message.
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSendMessageIntent class])];
    INSendMessageIntentResponse *response = [[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeReady userActivity:userActivity];
    completion(response);
}

// Handle the completed intent (required).

- (void)handleSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse *response))completion {
    // Implement your application logic to send a message here.
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSendMessageIntent class])];
    INSendMessageIntentResponse *response = [[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeSuccess userActivity:userActivity];
    completion(response);
}

// Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.

#pragma mark - INSearchForMessagesIntentHandling

- (void)handleSearchForMessages:(INSearchForMessagesIntent *)intent completion:(void (^)(INSearchForMessagesIntentResponse *response))completion {
    // Implement your application logic to find a message that matches the information in the intent.
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSearchForMessagesIntent class])];
    INSearchForMessagesIntentResponse *response = [[INSearchForMessagesIntentResponse alloc] initWithCode:INSearchForMessagesIntentResponseCodeSuccess userActivity:userActivity];
    // Initialize with found message's attributes
    response.messages = @[[[INMessage alloc]
        initWithIdentifier:@"identifier"
        content:@"I am so excited about SiriKit!"
        dateSent:[NSDate date]
        sender:[[INPerson alloc] initWithPersonHandle:[[INPersonHandle alloc] initWithValue:@"sarah@example.com" type:INPersonHandleTypeEmailAddress] nameComponents:nil displayName:@"Sarah" image:nil contactIdentifier:nil customIdentifier:nil]
        recipients:@[[[INPerson alloc] initWithPersonHandle:[[INPersonHandle alloc] initWithValue:@"+1-415-555-5555" type:INPersonHandleTypePhoneNumber] nameComponents:nil displayName:@"John" image:nil contactIdentifier:nil customIdentifier:nil]]
    ]];
    completion(response);
}

#pragma mark - INSetMessageAttributeIntentHandling

- (void)handleSetMessageAttribute:(INSetMessageAttributeIntent *)intent completion:(void (^)(INSetMessageAttributeIntentResponse *response))completion {
    // Implement your application logic to set the message attribute here.
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSetMessageAttributeIntent class])];
    INSetMessageAttributeIntentResponse *response = [[INSetMessageAttributeIntentResponse alloc] initWithCode:INSetMessageAttributeIntentResponseCodeSuccess userActivity:userActivity];
    completion(response);
}

#endif

@end
