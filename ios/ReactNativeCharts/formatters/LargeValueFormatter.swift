//
//  LargeValueFormatter.swift
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//
import Foundation
import Charts

open class LargeValueFormatter: NSObject, IValueFormatter, IAxisValueFormatter
{
    fileprivate static let MAX_LENGTH = 5

    open var DEFAULT_PRECISION = "1"

    /// Suffix to be appended after the values.
    ///
    /// **default**: suffix: ["", "k", "m", "b", "t"]
    open var suffix = ["", "k", "m", "b", "t"]

    /// An appendix text to be added at the end of the formatted value.
    open var appendix: String?

    open var precision: String?

    public override init()
    {

    }

    public init(appendix: String?)
    {
        self.appendix = appendix
        self.precision = DEFAULT_PRECISION
    }

    fileprivate func format(_ value: Double) -> String
    {
        var sig = value
        var length = 0
        let maxLength = suffix.count - 1

        while sig >= 1000.0 && length < maxLength
        {
            sig /= 1000.0
            length += 1
        }
        var toBeFormatted = "%2."+self.precision!+"f"
      if(!shouldHaveDecimal(value: value)) {
        toBeFormatted = "%2.0f"
      }
        var r = String(format: toBeFormatted, sig) + suffix[length]

      if appendix != nil
        {
            r += appendix!
        }

        return r
    }

  open func shouldHaveDecimal(
    value:Double ) -> Bool{
    if(value.truncatingRemainder(dividingBy: 1000) == 0 ||
      value.truncatingRemainder(dividingBy: 100000) == 0 ||
      value.truncatingRemainder(dividingBy: 10000000) == 0 ||
      value.truncatingRemainder(dividingBy: 1000000000000) == 0 ||
      value <= 1000) {
      return false
    }
    return true
  }
    open func stringForValue(
        _ value: Double, axis: AxisBase?) -> String
    {
        return format(value)
    }

    open func setPrecisionForFormatter(
        _ precision: String) -> Void
    {
      self.precision = !precision.isEmpty ? precision : DEFAULT_PRECISION
    }

    open func stringForValue(
        _ value: Double,
        entry: ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: ViewPortHandler?) -> String
    {
        return format(value)
    }
}
