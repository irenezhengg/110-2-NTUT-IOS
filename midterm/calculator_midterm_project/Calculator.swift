import Foundation

class Calculator {
    private var process: Array<String>
    private var num: String
    private var negative: Bool
    private var formula: String {
        get {
            var result: String = ""
            for step in process {
                result += step;
                result += " "
            }

            return result
        }
    }
    private var result: Double {
        get {
            let steps: Array<String> = self.process

            while let index = self.process.firstIndex(of: "%") {
                let left = Double(self.process[index-1])!
                let right = Double(self.process[index+1])!
                self.process.insert(
                    String(
                        left.truncatingRemainder(dividingBy: right)),
                    at: index-1);
                self.process.removeSubrange(index...index+2);
            }
            
            var formula = self.formula
                .replacingOccurrences(of: "÷", with: "/")
                .replacingOccurrences(of: "x", with: "*")
            
            /* convert all integers to double */
            var tmp = formula.split(separator: " ")

            for i in tmp.indices {
                tmp[i] = Double(tmp[i]) != nil ? String.SubSequence(String(Double(tmp[i])!)) : tmp[i]
            }

            formula = tmp.joined(separator: " ")
            /* end */

            let result = NSExpression(format: formula)
                .expressionValue(with: nil, context: nil) as? Double

            self.process = steps
            return result != nil && result!.isFinite ? result! : 0.0
        }
    }
    
    private func isNumberValid() -> Bool {
        return Double(self.num) != nil ? true : false
    }

    private func checkLastStepIsNumber() -> Bool {
        return Double(self.process.last!) != nil ? true : false
    }
    
    private func addLastNumber() {
        // store the number that is in tmp first
        let number: Double = Double(self.num)!
        if number == Double(Int(number)) {
            self.process.append(String(Int(number)))
        }
        else {
            self.process.append(String(number))
        }
    }

    public func operate(input: String) {
        if self.process.last != nil && (self.process.last! == "=" || self.process.last! == "0") {
            self.process.removeAll()
        }
        
        if self.num.isEmpty {
            self.num = "0"
        }

        if self.isNumberValid() {
            if self.process.count > 0 && !self.checkLastStepIsNumber() {
                self.process.removeLast()
                self.process.append(input)
                return;
            }
            
            self.addLastNumber()
            
            self.num = ""

            if self.checkLastStepIsNumber() {
                self.process.append(input)
            }
        }
    }

    public func chooseNumber(input: String) {
        if (input == "." && self.num.last != nil && self.num.contains(".")) {
            return
        }
        
        if input == "." && self.num.isEmpty {
            self.num = "0"
        }

        self.num += input
    }

    public func inverseNumber() {
        if self.process.last != nil && (self.process.last! == "=" || self.process.last! == "0") {
            self.process.removeAll()
        }
        if self.num.isEmpty {
            self.num = "0";
        }
        
        self.process.append("±(\(self.num))");

        if self.negative {
            self.num.removeFirst();
        }
        else {
            self.num.insert("-", at: self.num.startIndex);
        }

        self.negative = !self.negative;
        self.process.append("=");
    }

    public func calculate() -> Double {
        if self.process.last != nil && (self.process.last! == "=" || self.process.last! == "0") {
            self.process.removeAll();
        }
        
        if self.num.isEmpty {
            self.num = "0";
        }

        if self.isNumberValid() {
            self.addLastNumber()
        }

        var result = self.result
        
        if result == Double(Int(result)) {
            self.num = String(Int(result))
        }
        else {
            self.num = String(result)
        }
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 8

        result = Double(formatter.string(from: NSNumber(value: result))!)!;

        self.process.append("=")
        print("Formula: \(self.formula)")
        print("Result: \(result)")
        return result
    }

    public func getFormula() -> String {
        return self.formula
    }
    
    public func getLastNumber() -> String {
        return self.num.isEmpty ? "0" : self.num
    }
    
    public func reset() {
        self.process.removeAll()
        self.process.append("0")
        self.num = ""
    }

    init() {
        self.process = Array()
        self.num = ""
        self.negative = false
    }
}
