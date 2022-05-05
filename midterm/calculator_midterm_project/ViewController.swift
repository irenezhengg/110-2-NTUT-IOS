import UIKit

class ViewController: UIViewController {
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var outcomeLabel: UILabel!
    
    private var calc: Calculator = Calculator();
    private var method: String = ""
    private var outcome: String = ""

    func buttonStyleSetup(button: UIButton) -> Void {
        button.layer.borderWidth = CGFloat(1.0)
        button.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttons.forEach(buttonStyleSetup)
        
        method = "0"
        updateView()
    }
    
//    @IBAction func btnPressed(_ sender: UIButton) {
//        calc.chooseNumber(input: sender.currentTitle!)
//        
//        outcome = calc.getLastNumber()
//        sender.backgroundColor = UIColor.orange
//        sender.setTitleColor(UIColor.white, for: .normal)
//        updateView();
//    }
    
    @IBAction func clickNumber(_ sender: UIButton) {
        calc.chooseNumber(input: sender.currentTitle!)
        
        outcome = calc.getLastNumber()
        updateView();
        
//        sender.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
    }

    @IBAction func clickOperaton(_ sender: UIButton) {
        calc.operate(input: sender.currentTitle!)
        
        outcome = calc.getLastNumber()
        method = calc.getFormula()
        updateView()
    }

    @IBAction func inverseNumber(_ sender: UIButton) {
        calc.inverseNumber()
        
        method = calc.getFormula()
        outcome = calc.getLastNumber()
        updateView()
    }

    @IBAction func calculate(_ sender: UIButton) {
        let tmp = calc.calculate();

        if (tmp == Double(Int(tmp))) {
            outcome = String(Int(tmp))
        }
        else {
            outcome = String(tmp)
        }

        method = calc.getFormula()
        updateView()
    }

    @IBAction func reset(_ sender: UIButton) {
        calc.reset();
        method = calc.getFormula();
        outcome = calc.getLastNumber();
        updateView();
    }

    func updateView() {
        outcomeLabel.text = outcome;
        methodLabel.text = method;
    }
}
