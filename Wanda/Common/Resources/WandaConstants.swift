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
    static let wandaProdURL = "http://wanda-dev.us-east-2.elasticbeanstalk.com/wanda-app"
    static let wandaDevURL = "http://wanda-dev.us-east-2.elasticbeanstalk.com/wanda-app"
}



struct WandaAnalytics {
    // General
    static let clicked = "_clicked_"
    static let error = "_error"
    static let simpleError = "error"
    static let success = "_success"
    static let button = "_button"
    static let div = "_"
    
    static let contactWanda = "contact_wanda"
    
    // Profile
    static let profile = "profile"
    static let load = "_load"
    static let overflowMenu = "_overflow_menu"
    static let logout = "_logout"
    static let profileLoadError = profile + load + error
    static let profileCohortListLoadError = profile + "_cohort_list" + load + error
    static let profileEditProfileClickedError = profile + "_edit_profile" + clicked + simpleError
    static let profileCohortMotherClickedError = profile + "_cohort_mother" + clicked + simpleError
    static let profileEmailClickedError = profile + "_email" + clicked + simpleError
    static let profilePhoneClickedError = profile + "_phone" + clicked + simpleError
    static let profileOverflowMenuLogoutError = profile + overflowMenu + logout + error
    static let profileOverflowMenuContactError = profile + overflowMenu + "_" + contactWanda + error
    
    // Cohort Mother
    static let cohortMother = "cohort_mother"
    static let cohortMotherProfileLoadError = cohortMother + "_" + profile + load + error
//    UH OH
    static let cohortMotherEmailClickedError = cohortMother + "_" + profile + "_email" + clicked + simpleError
    static let cohortMotherPhoneClickedError = cohortMother + "_" + profile + "_phone" + clicked + simpleError
    static let cohortMotherOverflowMneuContactError = cohortMother + overflowMenu + error
    static let cohortMotherOverflowMenuLogoutError = cohortMother + overflowMenu + logout + error
        
    // Edit Profile
    static let editProfile = "edit_profile"
    static let editProfileLoadError = editProfile + load + error
    static let editProfileUpdateMotherError = editProfile + "_update_mother" + error
    static let editProfileUpdatePhotoError = editProfile + "_update_photo" + error
    static let editProfileOverflowMenuContactWandaError = editProfile + overflowMenu + "_" + contactWanda + error
    static let editProfileOverflowMenuLogoutError = editProfile + overflowMenu + logout + error

    // Login
    static let login = "login"
    static let loginButtonTapped = login + clicked + login + button
    static let loginSuccess = login + div + login + success
    static let loginError = login + div + login + error
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
    static let classDetailChangeRSVPButtonTapped = classDetail + clicked + "change_rsvp" + button
    static let classDetailUpdateRSVPButtonTapped = classDetail + clicked + "change_rsvp" + button
    static let classDetailCancelRSVPButtonTapped = classDetail + clicked + "change_rsvp" + button
}
