//
//  AnalyticsManager.swift
//  Marcana
//
//  Created by Deniz Ozagac on 28/02/2023.
//  See https://docs.google.com/spreadsheets/d/1yZiFqzP2XB_t7aFzhInEM8IMqcz58D3HhCeRBUgL9j8/edit#gid=0

import Foundation
import Amplitude

struct AnalyticsKeys {
    static let appLaunch = "app_launch"

    static let onboardingWelcomePageview = "onboarding_welcome_pageview"
    static let onboardingGoalsPageview = "onboarding_goals_pageview"
    static let onboardingExperiencePageview = "onboarding_experience_pageview"
    static let onboardingRemindersPageview = "onboarding_reminders_pageview"
    static let onboardingTestimonialsPageview = "onboarding_testimonials_pageview"
    static let onboardingTransitionPageview = "onboarding_transition_pageview"

    static let paywallPageview = "paywall_pageview" // AnalyticsAmplitudeEventPropertyKeys.paywallSource
    static let paywallXTapped = "paywall_x_tapped"
    static let paywallPricingTapped = "paywall_pricing_tapped"
    static let paywallPurchaseTapped = "paywall_purchase_tapped"
    static let paywallPurchaseCompleted = "paywall_purchase_completed"
    
    static let userInfoFlowNamePageview = "userinfoflow_name_pageview"
    static let userInfoFlowGenderPageview = "userinfoflow_gender_pageview"
    static let userInfoFlowBirthdayPageview = "userinfoflow_birthday_pageview"
    static let userInfoFlowOccupationPageview = "userinfoflow_occupation_pageview"
    static let userInfoFlowRelationshipPageview = "userinfoflow_relationship_pageview"
    
    static let homepageMusicTapped = "homepage_music_tapped"
    static let homepageReaderTapped = "homepage_reader_tapped"
    static let homepageWhyIsNotFreeTapped = "homepage_why_is_not_free_tapped"
    
    static let deckPageview = "deck_pageview"
    static let cardDetailPageview = "card_detail_pageview" // AnalyticsAmplitudeEventPropertyKeys.cardDetailSource
    static let settingsPageview = "settings_pageview"
    static let historyPageview = "history_pageview"
    static let profilePageview = "profile_pageview"

    static let fortuneflowQuestionPageview = "fortuneflow_question_pageview"
    static let fortuneflowQuestionHelperTapped = "fortuneflow_question_helper_tapped"
    static let fortuneflowQuestionPassed = "fortuneflow_question_passed"

    static let fortuneflowRequestSuccess = "fortuneflow_request_success"
    static let fortuneflowReadingPageview = "fortuneflow_reading_pageview"
    static let fortuneflowReadingLiked = "fortuneflow_reading_liked"
    static let fortuneflowReadingShared = "fortuneflow_reading_shared"
}

struct AnalyticsAmplitudeEventPropertyKeys {
    static let subscriptionType = "subscription_type"
    static let musicPlaying = "music_playing" // bool
    static let fortuneType = "fortune_type" // enum FortuneType
    
    static let paywallSource = "paywall_source" // PaywallSource enum
    static let cardDetailSource = "card_detail_source" // CardDetailSource enum
    
    static let fortuneQuestion = "fortune_question" // string
    static let apiResultSuccess = "api_result_success"  // bool
    
    static let buttonPosition = "button_position" // top or bottom
}

enum PaywallSource: String {
    case onboardingView = "onboarding_view"
    case homepageView = "homepage_view"
}

enum CardDetailSource: String {
    case deckView = "deck_view"
    case cardSelectView = "card_select_view"
    case readingView = "reading_view"
}

struct AnalyticsAmplitudeUserPropertyKeys {
    static let reminderTimeHour = "reminder_time_hour" // int
    static let reminderTimeMinute = "reminder_time_minute" // int
    static let consentedNotifications = "consent_notifications" // true, false
    
    static let userName = "user_name" // string
    static let userGender = "user_gender" // string
    static let userBirthday = "user_birthday" // ?
    static let userAge = "user_age" // int
    static let userOccupation = "user_occupation" // string
    static let userRelationship = "user_relationship" // string
}

class AnalyticsManager {

    static let shared = AnalyticsManager()
    let apiKey = "b1f138e2bea8c35aed408656af792985"

    private init() {
        Amplitude.instance().initializeApiKey(apiKey)
    }

    func logEvent(eventName: String, properties: [AnyHashable: Any]? = nil) {
        Amplitude.instance().logEvent(eventName, withEventProperties: properties)
    }

    func setUserId(userId: String) {
        Amplitude.instance().setUserId(userId)
    }

    func setUserProperties(properties: [AnyHashable: Any]) {
        Amplitude.instance().setUserProperties(properties)
    }

    func clearUserProperties() {
        Amplitude.instance().clearUserProperties()
    }
}
