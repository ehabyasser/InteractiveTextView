# InteractiveTextView

How to use it 

 let textView = InteractiveTextView(text: "You can register using eCorp Web, and to be activated through KFH corporate branches To register click here. for your click more", actions: ["click here" , "more"] , tags: ["action" , "more"]) { action in
        print("click here clicked \(action)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 16).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -16).isActive = true
        textView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }
