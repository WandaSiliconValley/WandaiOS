//
//  WandaConstants.swift
//  Wanda
//
//  Created by Bell, Courtney on 8/23/18.
//  Copyright © 2018 Bell, Courtney. All rights reserved.
//

import UIKit

struct WandaConstants {
    static let jenniferEmail = "jennifer@wandasiliconvalley.org"
    static let wandaSupportEmail = "wandaapphelp@gmail.com"
    static let wandaURL = "http://wanda.us-east-2.elasticbeanstalk.com/wanda-app"
}

struct WandaAnalytics {
    
    // General
    static let clicked = "_clicked_"
    static let error = "_error"
    static let success = "_success"
    static let button = "_button"
    static let div = "_"
    
    static let contactWanda = "contact_wanda"
    
    // Login
    static let login = "login"
    static let loginButtonTapped = login + clicked + login + button
    static let loginSuccess = login + div + login + success
    static let loginError = login + div + login + error
    static let loginSignUpButtonTapped = login + clicked + signUp + button
    static let loginForgotPasswordTapped = login + clicked + "forgot_password" + button
    
    // Forgot Password
    static let resetPassword = "reset_password"
    static let resetPasswordTapped = resetPassword + clicked + resetPassword + button
    static let resetPassowordError = resetPassword + error
    static let resetPasswordSuccess = resetPassword + success
    static let resetPasswordContactUsTapped = resetPassword + clicked + contactWanda + button
    
    // Sign Up
    static let signUp = "sign_up"
    static let signUpButtonTapped = signUp + clicked + signUp + button
    static let signUpSuccess = signUp + success
    static let signUpError = signUp + error
    static let signUpContactUsTapped = signUp + clicked + contactWanda + button
    
    // Class Schedule
    static let classSchedule = "class_schedule"
    static let classReserveSpotButtonTapped = classSchedule + clicked + "reserve_my_spot" + button
    static let  classUpcomingClassTapped = classSchedule + clicked + "class_tile"
    static let classLogoutButtonTapped = classSchedule +  clicked + "logout"
    
    // Event Detail
    static let classDetail = "class_detail"
    static let menu = "menu"
    static let classDetailMenuButtonTapped = classDetail + clicked + menu
    static let classDetailMenuContatctWandaTapped = classDetail + div + menu + clicked + contactWanda
    static let classDetailMenuAddEventTapped = classDetail + div + menu + clicked + "add_to_calendar"
    static let classDetailAddressTapped = classDetail + clicked + "address"
    static let classDetailReserveSpotTapped = classDetail + clicked + "reserve_my_spot" + button
}
