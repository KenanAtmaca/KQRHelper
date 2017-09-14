# KQRHelper
İOS QR Code Generator and Reader

#### Use

```Swift
        var qr = KQRHelper()
```

##### Generate QR image

```Swift
        imgView = UIImageView()
        imgView.frame = CGRect(x: 100, y: 100, width: 30, height: 30)
        view.addSubview(imgView)
        
        qr.QRView = imgView // #1
        
        qr.generate(text: "kenanatmaca.com") // #2
```

##### Scan QR

```Swift
      override func viewDidLoad() {
        super.viewDidLoad()
        
        qr.reader(to: self.view)
    }
```

##### Show Result

```Swift
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
       qrLabel.text = qr.result ?? "NONE"
    }
```
