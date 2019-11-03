//
//  WandaLocalizableStrings.swift
//  Wanda
//
//  Created by Bell, Courtney on 8/23/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import UIKit

struct AlertStrings {
    static var discard: String {
        return NSLocalizedString("Wanda_Alerts_Discard",
            value: "DISCARD",
            comment: "Alert button title indicating that on tap the action will be discarded.")
    }
    static var doYouWantToKeepWorking: String {
        return NSLocalizedString("Wanda_Alerts_DoYouWantToKeepWorking",
            value: "Do you want to keep working?",
            comment: "Alert message asking the user if they would like to remain on the current page.")
    }
    static var keepWorking: String {
        return NSLocalizedString("Wanda_Alerts_KeepWorking",
            value: "KEEP WORKING",
            comment: "Alert button title indicating that on tap the user will remain on the current page.")
    }
    static var oopsMessage: String {
        return NSLocalizedString("Wanda_Alerts_Oops",
            value: "Oops, your edits didn't get saved. Do you want to keep working?",
            comment: "Alert title indicating that any edits won't be saved if the user navigates away from the current page.")
    }
}

struct ClassStrings {
    static var changeRSVP: String {
        return NSLocalizedString("Wanda_Class_ICantMakeIt",
            value: "CHANGE RSVP",
            comment: "Button title indicating tap to the user will enter edit mode for their rsvp.")
    }
    static var iCantMakeIt: String {
        return NSLocalizedString("Wanda_Class_ICantMakeIt",
            value: "I CAN'T MAKE IT",
            comment: "Button title indicating tap to let the WANDA admins know you will no longer be able to attend a class.")
    }
    static var nextClass: String {
        return NSLocalizedString("Wanda_Class_NextClass",
            value: "NEXT CLASS",
            comment: "Table section header for the next class a user has coming up.")
    }
    static var requiredClassMessage: String {
        return NSLocalizedString("Wanda_Class_RequiredClassMessage",
            value: "This is a required class, but if you are sure you can't make it, continue with your cancellation.",
            comment: "Message indicating that the class the user wants to cancel is required.")
    }
    static var reserveMySpot: String {
        return NSLocalizedString("Wanda_Class_ReserveMySpot",
            value: "RESERVE MY SPOT",
            comment: "Button title indicating tap to send rsvp.")
    }
    static var sendRSVP: String {
        return NSLocalizedString("Wanda_Class_SendRSVP",
            value: "SEND RSVP",
            comment: "Button title indicating tap to let the user will send their rsvp.")
    }
    static var sorryYouCantMakeIt: String {
        return NSLocalizedString("Wanda_Class_SorryYouCantMakeIt",
            value: "Sorry you can't make it",
            comment: "Title acknowledging the user cannot attend the class.")
    }
    static var upcomingClasses: String {
        return NSLocalizedString("Wanda_Class_UpcomingClasses",
            value: "UPCOMING CLASSES",
            comment: "Table section header for the list of upcoming classes a user has.")
    }
    static var updateRSVP: String {
        return NSLocalizedString("Wanda_Class_UpdateRSVP",
            value: "UPDATE RSVP",
            comment: "Button title indicating tap to let the user will update their rsvp.")
    }
}

struct ErrorStrings {
    static var errorMessage: String {
        return NSLocalizedString("Wanda_Error_ErrorMessage",
            value: "Looks like something isn't working properly. Try again or contact support for help.",
            comment: "Alert message informing the user that something went wrong.")
    }
    static var emailNotFound: String {
        return NSLocalizedString("Wanda_Error_EmailNotFound",
            value: "Email not on file with WANDA",
            comment: "Alert message informing the user that the email entered is not on file.")
    }
    static var emailRequired: String {
        return NSLocalizedString("Wanda_Error_EmailRequired",
            value: "Email Required",
            comment: "Alert message informing the user that the email field is required.")
    }
    static var invalidCredentials: String {
        return NSLocalizedString("Wanda_Error_InvalidCredentials",
            value: "Email or password is incorrect",
            comment: "Error message indicating the email or password is incorrect.")
    }
    static var networkError: String {
        return NSLocalizedString("Wanda_Error_NetworkError",
            value: "No Internet Connection",
            comment: "Error message indicating that there was a network error.")
    }
    static var networkErrorMessage: String {
        return NSLocalizedString("Wanda_Error_NetworkErrorMessage",
            value: "Unable to connect to WANDA. Please check your internet connection and try again.",
            comment: "Error message indicating that the user is not connected to a network.")
    }
    static var passwordError: String {
        return NSLocalizedString("Wanda_Error_PasswordError",
            value: "Password must be at least 6 characters.",
            comment: "Error message indicating the password must be at least 6 characters long.")
    }
    static var passwordRequired: String {
        return NSLocalizedString("Wanda_Error_PasswordRequired",
            value: "Password Required",
            comment: "Alert message informing the user that the password field is required.")
    }
    static var support: String {
        return NSLocalizedString("Wanda_Error_Support",
            value: "SUPPORT",
            comment: "Button title indicating that on tap the user can contact WANDA Support.")
    }
    static var systemError: String {
        return NSLocalizedString("Wanda_Error_SystemError",
            value: "System Error",
            comment: "Alert title indicating that the system experienced an error.")
    }
}

struct GeneralStrings {
    static var cancelAction: String {
        return NSLocalizedString("Wanda_General_Cancel",
            value: "CANCEL",
            comment: "Button title indicating that on tap the action will be canceled.")
    }
    static var confirmed: String {
        return NSLocalizedString("Wanda_General_Confirmed",
            value: "Confirmed",
            comment: "Button title indicating that the action is confirmed.")
    }
    static var continueAction: String {
        return NSLocalizedString("Wanda_Class_Continue",
            value: "CONTINUE",
            comment: "Button title indicating that on tap the user will continue with the current action.")
    }
    static var dismissAction: String {
        return NSLocalizedString("Wanda_General_Dismiss",
            value: "DISMISS",
            comment: "Button title indicating that on tap the alert will be dismissed.")
    }
    static var nextAction: String {
        return NSLocalizedString("Wanda_General_Next",
            value: "NEXT",
            comment: "Button title indicating that on tap the user will be taken to the next step or screen.")
    }
    static var submitAction: String {
        return NSLocalizedString("Wanda_Class_Submit",
            value: "SUBMIT",
            comment: "Button title indicating that on tap the user will submit the form.")
    }
    static var success: String {
        return NSLocalizedString("Wanda_General_Success",
            value: "Success",
            comment: "Message indicating that the action was a success.")
    }
    static var tryAgainAction: String {
        return NSLocalizedString("Wanda_Class_TryAgain",
            value: "TRY AGAIN",
            comment: "Button title indicating that on tap the action will be tried again.")
    }
}

struct LoginSignUpStrings {
    static var emailInUse: String {
        return NSLocalizedString("Wanda_LoginSignUp_EmailInUse",
            value: "Email already in use",
            comment: "Message indicating that the email entered already has a WANDA account.")
    }
    static var invalidEmail: String {
        return NSLocalizedString("Wanda_LoginSignUp_InvalidEmail",
            value: "Not a valid email",
            comment: "Message indicating that the email entered is invalid.")
    }
    static var login: String {
        return NSLocalizedString("Wanda_LoginSignUp_Login",
            value: "LOGIN",
            comment: "Button title indicating that on tap the user will attempt to login.")
    }
    static var loginHelp: String {
        return NSLocalizedString("Wanda_LoginSignUp_LoginHelp",
            value: "Login Help",
            comment: "Email subject indicating a user needs help logging in.")
    }
    static var passwordsDoNotMatch: String {
        return NSLocalizedString("Wanda_LoginSignUp_passwordsDoNotMatch",
            value: "Passwords do not match",
            comment: "Message indicating that the passwords do not match.")
    }
    static var resetPassword: String {
        return NSLocalizedString("Wanda_LoginSignUp_ResetPassword",
            value: "RESET PASSWORD",
            comment: "Button title indicating that on tap the user will reset their password.")
    }
    static var resetPasswordMessage: String {
        return NSLocalizedString("Wanda_LoginSignUp_ResetPasswordMessage",
            value: "An email was sent your way.",
            comment: "Message indicating that an email was sent to the user to reset their password.")
    }
    static var signUpHelp: String {
        return NSLocalizedString("Wanda_LoginSignUp_SignUpHelp",
            value: "Sign Up Help",
            comment: "Email subject indicating a user needs help signing up.")
    }
    static var useEmailOnFile: String {
        return NSLocalizedString("Wanda_LoginSignUp_UpcomingClasses",
            value: "Use email on file with WANDA",
            comment: "Message informing the user that they must use the email on file with WANDA.")
    }
}

struct SuccessStrings {
    static var accountCreated: String {
        return NSLocalizedString("Wanda_Success_AccountCreated",
            value: "Your account has been created!",
            comment: "Message confirming the user's has successfully signed up for the app.")
    }
    static var reservationSuccessMessage: String {
        return NSLocalizedString("Wanda_Success_ReservationSuccess",
            value: "Your RSVP has been sent to WANDA. We’re so excited to see you at the next class.",
            comment: "Message confirming the user has successfully reserved the class.")
    }
    static var signUpSuccessMessage: String {
        return NSLocalizedString("Wanda_Success_SignUpSuccess",
            value: "Get started to see the class schedule and make your monthly contributions.",
            comment: "Message informing the user that they have successfully signed up for the app and can now login anytime.")
    }
    static var thanksForSigningUp: String {
        return NSLocalizedString("Wanda_Success_ThanksForSigningUp",
            value: "Thanks for signing up!",
            comment: "Message thanking the user for signing up for a WANDA class.")
    }
}
