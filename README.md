# ABCPinTextFieldInput
一个简单的PIN码输入控件。  

![image](https://github.com/AKACoder/ABCPinTextFieldInput/blob/master/Example/example.gif)   


### 关于'ABC'
- '**ABC**' 是 '**available but chaos**' 的缩写，用以说明我的水平不是很好。  


### 依赖  
**[duemunk/Async](https://github.com/duemunk/Async)**  
如果你在使用
Grand Central Dispatch 
([GCD](https://developer.apple.com/library/prerelease/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/index.html))
强烈建议你尝试一下Async！  

**[mamaral/Neon](https://github.com/mamaral/Neon)**  
因为我太过笨拙，用不明白AutoLayout，所以使用了这个异常优秀的布局库。

### 安装  
cocoapods:    
> pod 'ABCPinTextFieldInput'
  
或者直接吧SourceCode下的源码拖到工程里 

### 使用说明  
**ABCPinTextFieldInput 的 config**:
```swift

//用户绘制输入框的界面的callback类型，第一个参数是input，第二个参数是给出的input的位置，第一个input是0，以此类推。
public typealias ABCPinTextFieldInputCustomDraw = (UITextField, Int) -> Void

//输入框的模式
public enum ABCPinMode {
    //明文文本，未输入时，使用小横线显示占位。参数为：横线颜色、横线宽度、横线高度
    case PlainTextWithDash(dashColor: UIColor, dashWidth: CGFloat, dashHeight: CGFloat)
    
    //密文文本（输后显示小圆点），未输入时，使用小横线显示占位。参数为：横线颜色、横线宽度、横线高度
    case PasswordTextWithDash(dashColor: UIColor, dashWidth: CGFloat, dashHeight: CGFloat)
    
    //明文文本，未输入时，使用底部边框显示占位。参数为：底边颜色、底边宽度、底边高度
    case PlainTextWithBottomBorder(borderColor: UIColor, borderWidth: CGFloat, borderHeight: CGFloat)
    
    //密文文本（输后显示小圆点），未输入时，使用底部边框显示占位。参数为：底边颜色、底边宽度、底边高度
    case PasswordTextWithBottomBorder(borderColor: UIColor, borderWidth: CGFloat, borderHeight: CGFloat)
    
    //自定义模式，需要提供 ABCPinTextFieldInputCustomDraw 类型的毁掉函数
    case CustomMode(customDraw: ABCPinTextFieldInputCustomDraw?)
}

//配置类
public class ABCPinTextFieldConfig {
    //输入框配置项
    public let InputConfig = ABCPinTextFieldInputConfig()
    
    //输入框的个数，默认是4个
    public var PinCount: Int = 4
    
    //每个输入框之间的间隔，模式是10
    public var InputPadding: CGFloat = 10
    
    //输入框模式，请参考上面的枚举
    public var Mode: ABCPinMode = .PlainTextWithDash(dashColor: UIColor.black, dashWidth: 40, dashHeight: 2)
}

//input的配置类 ABCPinTextFieldInputConfig
public class ABCPinTextFieldInputConfig {
    //是否显示由控件提供的AccessoryBar
    public var ShowAccessoryBar = true

    //AccessoryBar的背景色
    public var AccessoryBarColor = UIColor(red: 0xe5/255, green: 0xe5/255, blue: 0xe5/255, alpha: 1)
    
    //AccessoryBar的高度
    public var AccessoryBarHeight:CGFloat = 120 / UIScreen.main.scale
    
    //AccessoryBar的按钮文本
    public var AccessoryBarButtonText = "完成"
    
    //AccessoryBar的按钮文本颜色
    public var AccessoryBarButtonTextColor = UIColor.black
    
    //AccessoryBar的按钮文本字体
    public var AccessoryBarButtonFont = UIFont.systemFont(ofSize: 30 / UIScreen.main.scale)

    //用户提供的AccessoryBar
    public var CustomAccessoryView: UIView? = nil
    
    //默认键盘
    public var KeyboardType: UIKeyboardType = .numberPad
}

```

**ABCPinTextFieldInput 的 接口**:
```swift
    //初始化，直接给出frame参数
    public init(with config: ABCPinTextFieldConfig, frame: CGRect)
    
    //初始化，未指定frame参数，需要手动调用Layout方法以进行布局操作
    public init(with config: ABCPinTextFieldConfig)
    
    //进行布局操作，如果布局失败，返回false（仅在当前控件的frame是empty的时候，会返回false）
    public func Layout() -> Bool
    
    //输入框的代理
    public weak var Delegate: ABCPinTextFieldDelegate?
    
    //输入框的使能/禁用
    public var IsEnable: Bool {get set}
    
    //输入框的当前字符串
    public var Text: String {get}

```


**几个简单的代理**  
```swift
@objc public protocol ABCPinTextFieldDelegate: class {
    //禁用和使能之后被调用
    @objc optional func Enabled()
    @objc optional func Disabled()
    
    //所有位置都输入完毕，Resign的时候，该代理方法会被调用
    @objc optional func FinishedResign()
    
    //位置没有被填满的时候Resign，该代理方法会被调用
    @objc optional func UnfinishedResign()
}
```


### 例子
**ABCPinTextFieldInput** 非常简单。我提供了一个粗糙的Example。
你可以把SourceCode和Example都拖到工程里，然后在ViewController.swift里添加如下代码：
```swift
    override func viewDidLoad() {
        .... other code
        let _ = ABCPinTextFieldExample(view: view)
    }
```



### License
MIT
