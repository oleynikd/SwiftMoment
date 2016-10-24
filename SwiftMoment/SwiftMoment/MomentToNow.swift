//
//  MomentFromNow.swift
//  SwiftMoment
//
//  Created by Madhava Jay on 07/06/2016.
//  Copyright © 2016 Adrian Kosmaczewski. All rights reserved.
//

import Foundation

extension Moment {

    /// Returns a localized string specifying the time duration between
    /// the current instance and the present moment.
    ///
    /// - returns: A localized string.
  public func toNow() -> String {
    let timeDiffDuration = moment().intervalSince(self)
    let deltaSeconds = -timeDiffDuration.seconds+1
    
    debugPrint("deltaSeconds", deltaSeconds)
    
    var value: Double!
    
    if deltaSeconds < 5 {
      // Just Now
      return NSDateTimeAgoLocalizedStrings("Just now")
      
    }
    else if deltaSeconds < Moment.minuteInSeconds {
      // Seconds Ago
      return stringFromFormat("In %%d %@seconds", withValue: Int(deltaSeconds))
      
    }
    else if deltaSeconds < (Moment.minuteInSeconds * 2) {
      // A Minute Ago
      return NSDateTimeAgoLocalizedStrings("In a minute")
      
    }
    else if deltaSeconds < Moment.hourInSeconds {
      // Minutes Ago
      return stringFromFormat("In %%d %@minutes", withValue: Int(deltaSeconds / Moment.minuteInSeconds))
      
    }
    else if deltaSeconds < (Moment.hourInSeconds * 1.5) {
      // An Hour Ago
      return NSDateTimeAgoLocalizedStrings("In an hour")
      
    }
    else if deltaSeconds < Moment.dayInSeconds {
      // Hours Ago
      value = round(deltaSeconds / Moment.hourInSeconds)
      debugPrint("value", deltaSeconds / Moment.hourInSeconds, value)
      return stringFromFormat("In %%d %@hours", withValue: Int(value))
      
    }
    else if deltaSeconds < (Moment.dayInSeconds * 2) {
      // Tomorrow
      return NSDateTimeAgoLocalizedStrings("Tomorrow")
      
    }
    else if deltaSeconds < Moment.weekInSeconds {
      // Days Ago
      value = floor(deltaSeconds / Moment.dayInSeconds)
      return stringFromFormat("In %%d %@days", withValue: Int(value))
      
    }
    else if deltaSeconds < (Moment.weekInSeconds * 2) {
      // Last Week
      return NSDateTimeAgoLocalizedStrings("Next week")
      
    }
    else if deltaSeconds < Moment.monthInSeconds {
      // Weeks Ago
      value = floor(deltaSeconds / Moment.weekInSeconds)
      return stringFromFormat("In %%d %@weeks", withValue: Int(value))
      
    }
    else if deltaSeconds < (Moment.dayInSeconds * 61) {
      // Last month
      return NSDateTimeAgoLocalizedStrings("Next month")
      
    }
    else if deltaSeconds < Moment.yearInSeconds {
      // Month Ago
      value = floor(deltaSeconds / Moment.monthInSeconds)
      return stringFromFormat("In %%d %@months", withValue: Int(value))
      
    }
    else if deltaSeconds < (Moment.yearInSeconds * 2) {
      // Last Year
      return NSDateTimeAgoLocalizedStrings("Next year")
    }
    
    // Years Ago
    value = floor(deltaSeconds / Moment.yearInSeconds)
    return stringFromFormat("In %%d %@years", withValue: Int(value))
  }

    private func stringFromFormat(_ format: String, withValue value: Int) -> String {
        let localeFormat = String(format: format,
                                  getLocaleFormatUnderscoresWithValue(Double(value)))
        return String(format: NSDateTimeAgoLocalizedStrings(localeFormat), value)
    }

    private func NSDateTimeAgoLocalizedStrings(_ key: String) -> String {
        // get framework bundle
        guard let bundleIdentifier = Bundle(for: MomentBundle.self).bundleIdentifier  else {
            return ""
        }

        guard let frameworkBundle = Bundle(identifier: bundleIdentifier) else {
            return ""
        }

        guard let resourcePath = frameworkBundle.resourcePath else {
            return ""
        }

        let bundleName = "MomentFromNow.bundle"
        let path = URL(fileURLWithPath: resourcePath).appendingPathComponent(bundleName)
        guard let bundle = Bundle(url: path) else {
            return ""
        }

        if let languageBundle = getLanguageBundle(bundle) {
            return languageBundle.localizedString(forKey: key, value: "", table: "NSDateTimeInFuture")
        }

        return ""
    }

    private func getLanguageBundle(_ bundle: Bundle) -> Bundle? {
        let localeIdentifer = self.locale.identifier
        if let languagePath = bundle.path(forResource: localeIdentifer, ofType: "lproj") {
            return Bundle(path: languagePath)
        }

        let langDict = Locale.components(fromIdentifier: localeIdentifer)
        let languageCode = langDict["kCFLocaleLanguageCodeKey"]
        if let languagePath = bundle.path(forResource: languageCode, ofType: "lproj") {
            return Bundle(path: languagePath)
        }

        return nil
    }

    private func getLocaleFormatUnderscoresWithValue(_ value: Double) -> String {
        guard let localeCode = Locale.preferredLanguages.first else {
            return ""
        }

        if localeCode == "ru" || localeCode == "uk" {
            let xy = Int(floor(value)) % 100
            let y = Int(floor(value)) % 10

            if y == 0 || y > 4 || (xy > 10 && xy < 15) {
                return ""
            }

            if y > 1 && y < 5 && (xy < 10 || xy > 20) {
                return "_"
            }

            if y == 1 && xy != 11 {
                return "__"
            }
        }

        return ""
    }

}
