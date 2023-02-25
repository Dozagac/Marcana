//
//  Extensions.swift
//  Marcana
//
//  Created by Deniz Ozagac on 29/11/2022.
//

import Foundation
import SwiftUI


extension View {
    // Allows separate corner rounding
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func onFirstAppear(_ action: @escaping () -> ()) -> some View {
        modifier(FirstAppear(action: action))
    }

    //MARK: Conditional modifier, used in paywall
    // https://www.avanderlee.com/swiftui/conditional-view-modifier/
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    
//    // https://stackoverflow.com/questions/69712759/swiftui-fullscreencover-with-no-animation
//    func withoutAnimation(action: @escaping () -> Void) {
//        var transaction = Transaction()
//        transaction.disablesAnimations = true
//        withTransaction(transaction) {
//            action()
//        }
//    }
}

// needed for the mailSubject to be passable to the .sheet in the settingsView
extension String: Identifiable {
  public var id: Self { self }
}

// for onFirstAppear View extension
private struct FirstAppear: ViewModifier {
    let action: () -> ()
    
    // Use this to only fire your block one time
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        // And then, track it here
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}

// custom perfix operator for being ablt to add not (!) operator to Bool Binding
prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}

// Protocol Extension for notEmpty
extension Collection {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

extension Color {
    static let marcanaLicorice = Color("MarcanaLicorice")
    static let marcanaBackground = Color("MarcanaBackground")
    static let marcanaPink = Color("MarcanaPink")
    static let marcanaBlue = Color("MarcanaBlue")
    static let marcanaLightGreen = Color("MarcanaLightGreen")
    static let icon = Color("Icon")
    static let iconUnselected = Color("IconUnselected")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

    func startOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year, .month], from: self)
        components.day = 1
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }

    func nextDate() -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return nextDate ?? Date()
    }

    func previousDate() -> Date {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return previousDate ?? Date()
    }

    func addMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
        return endDate ?? Date()
    }

    func removeMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: -numberOfMonths, to: self)
        return endDate ?? Date()
    }

    func removeYears(numberOfYears: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .year, value: -numberOfYears, to: self)
        return endDate ?? Date()
    }

    func getHumanReadableDayString() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]

        let calendar = Calendar.current.component(.weekday, from: self)
        return weekdays[calendar - 1]
    }


    func timeSinceDate(fromDate: Date) -> String {
        let earliest = self < fromDate ? self : fromDate
        let latest = (earliest == self) ? fromDate : self

        let components: DateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: earliest, to: latest)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let week = components.weekOfYear ?? 0
        let day = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0


        if year >= 2 {
            return "\(year) years ago"
        } else if (year >= 1) {
            return "1 year ago"
        } else if (month >= 2) {
            return "\(month) months ago"
        } else if (month >= 1) {
            return "1 month ago"
        } else if (week >= 2) {
            return "\(week) weeks ago"
        } else if (week >= 1) {
            return "1 week ago"
        } else if (day >= 2) {
            return "\(day) days ago"
        } else if (day >= 1) {
            return "1 day ago"
        } else if (hours >= 2) {
            return "\(hours) hours ago"
        } else if (hours >= 1) {
            return "1 hour ago"
        } else if (minutes >= 2) {
            return "\(minutes) minutes ago"
        } else if (minutes >= 1) {
            return "1 minute ago"
        } else if (seconds >= 3) {
            return "\(seconds) seconds ago"
        } else {
            return "Just now"
        }

    }
}
