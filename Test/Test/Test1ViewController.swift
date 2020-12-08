
import UIKit

class Test1ViewController: UIViewController {
        
    private var timer: Timer?
    
    private var redView: UIView?
        
    private var collisionFactor: CGFloat = 0.8

    private var moveingXSpeed: CGFloat = 800

    private var moveingYSpeed: CGFloat = 500

    private var lastUpdateTime: Double = CACurrentMediaTime()

    private var movingVector: CGPoint = CGPoint.init(x: 0, y: 0)
    
    private var dynamicAnimator: UIDynamicAnimator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultParams()
        
        self.initSubViews()
    }
    
    //MARK:Private Action
    private func setDefaultParams() {
        self.title = "测试"
    }
    
    private func initSubViews() {
        self.redView = UIView.init(frame: CGRect(x: 10, y: self.view.frame.size.height/2 - 50, width: 100, height: 100))
        self.redView?.backgroundColor = UIColor.red
        self.redView?.layer.cornerRadius = 50
        self.redView?.layer.masksToBounds = true
        self.view.addSubview(self.redView!)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tap)
    }
    
    //MARK:- 计时
    @objc private func creatTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    private func startTimer() {
        self.stopTimer()
        if self.timer == nil {
            self.creatTimer()
        }
        self.timer?.fireDate = Date.distantPast
    }

    private func stopTimer() {
        if self.timer != nil {
            self.timer?.fireDate = Date.distantFuture

            if self.timer?.isValid == true {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }

    ///
    @objc private func tapAction() {

        let redViewCenterX = self.redView!.bounds.origin.x + self.redView!.bounds.size.width / 2
        let redViewCenterY = self.redView!.bounds.origin.y + self.redView!.bounds.size.height / 2

        self.movingVector.x = self.view.bounds.size.width/2 - redViewCenterX
        self.movingVector.y = 100 - redViewCenterY

        let length = sqrt(self.movingVector.x*self.movingVector.x+self.movingVector.y*self.movingVector.y)
        self.movingVector.x = self.movingVector.x / length * self.moveingXSpeed
        self.movingVector.y = self.movingVector.y / length * self.moveingYSpeed

        self.creatTimer()
        
        self.dynamicAnimator = UIDynamicAnimator.init(referenceView: self.view)
        
        let gravityBehavior: UIGravityBehavior = UIGravityBehavior.init(items: [self.redView!])
        self.dynamicAnimator?.addBehavior(gravityBehavior)
    }

    private func durationSignceLastUpdate() -> Double {
        return CACurrentMediaTime() - self.lastUpdateTime
    }

    @objc private func updateTimer() {

        var deltTime = self.durationSignceLastUpdate()
        self.lastUpdateTime = CACurrentMediaTime()
        deltTime = min(1, deltTime)

        let redViewCenterX = self.redView!.frame.origin.x + self.redView!.frame.size.width / 2
        let redViewCenterY = self.redView!.frame.origin.y + self.redView!.frame.size.height / 2

        var newX: CGFloat = redViewCenterX + self.movingVector.x * CGFloat(deltTime)
        var newY: CGFloat = redViewCenterY + self.movingVector.y * CGFloat(deltTime)

        if (newX + self.redView!.bounds.size.width/2) >= self.view.frame.size.width {
            self.movingVector.x = -self.movingVector.x * self.collisionFactor
            self.movingVector.y = self.movingVector.y * self.collisionFactor

            newX = self.view.frame.size.width - self.redView!.frame.size.width / 2
        } else if (newX - self.redView!.frame.size.width / 2) <= 0 {
            self.movingVector.x = -self.movingVector.x * self.collisionFactor
            self.movingVector.y = self.movingVector.y * self.collisionFactor

            newX = self.redView!.frame.size.width / 2
        }

        if ((newY + self.redView!.frame.size.height / 2) >= self.view.frame.size.height) {
            self.movingVector.x = self.movingVector.x * self.collisionFactor
            self.movingVector.y = -self.movingVector.y * self.collisionFactor

            newY = self.view.frame.size.height - self.redView!.frame.size.height / 2;


        } else if ((newY - self.redView!.frame.size.height / 2) <= 0) {
            self.movingVector.x = self.movingVector.x * self.collisionFactor
            self.movingVector.y = -self.movingVector.y * self.collisionFactor

            newY = self.redView!.frame.size.height / 2;
        }

        self.redView?.center = CGPoint(x: newX, y: newY)
    }
}
