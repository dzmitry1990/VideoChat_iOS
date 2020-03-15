import UIKit


 class MessagingCell: UITableViewCell {
    var msgView: UIView!
    var msgBalView: UIImageView!
    
    var profileImage: UIImageView!=UIImageView()
    var messageTime: UILabel!=UILabel()
    
    var messageText: UILabel!=UILabel()
    var sentBy: Bool!=Bool()
    
    var marginHorizontal: CGFloat = 12
    var marginVertical: CGFloat = 4
    
    var profileWidth: CGFloat = 34
    var textMarginHorizontal: CGFloat = 12
    var textMarginVertical: CGFloat = 5
    
    var marginBubble: CGFloat = 8
    
    var messageTextColor = UIColor.white
    var messageTextSize: CGFloat = 15.0
    var messageTextFontName = "SF Pro Display Regular"
    var messageTimeSize: CGFloat = 11.0
    var messageTimeFoneName = "SF Pro Display Semibold"
    var timeColor = UIColor.init(red: 168/255, green: 168/255, blue: 168/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func maxTextWidth() -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            return 220.0
        }
        else {
            return 400.0
        }
    }
    
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    class func balloonImage(_ sent: Bool) -> UIImage {
        if sent == true {
            return MessagingCell.imageWithColor(UIColor.init(white: 0.0, alpha: 0.5))
            
        }
        else {
            return MessagingCell.imageWithColor(UIColor.white);
        }
    }
   
    class func msgTextColor(_ sent: Bool) -> UIColor {
        if sent == true {
            return UIColor.white
            
        }
        else {
            return UIColor.black
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)  {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.msgView = UIView(frame: CGRect.zero)
        self.msgView.autoresizingMask = .flexibleHeight
        
        self.msgBalView = UIImageView(frame: CGRect.zero)
        self.msgBalView.clipsToBounds = true
        self.msgBalView.layer.cornerRadius = 12
        
        self.profileImage = UIImageView(image: nil)
        self.profileImage.layer.cornerRadius = profileWidth / 2
        self.profileImage.clipsToBounds = true
        
        self.messageText = UILabel(frame: CGRect.zero)
        self.messageTime = UILabel(frame: CGRect.zero)
        self.messageText.backgroundColor = UIColor.clear
        self.messageText.font = UIFont.sfProTextRegularFont(17)
        self.messageText.textColor = messageTextColor
        self.messageText.lineBreakMode = .byWordWrapping
        self.messageText.numberOfLines = 0
        
        self.messageTime.font = UIFont.sfProTextMediumFont(11)
        self.messageTime.textColor = timeColor
        self.messageTime.backgroundColor = UIColor.clear
        
        self.msgView.addSubview(self.msgBalView)
        self.msgView.addSubview(self.messageText)
        self.contentView.addSubview(self.messageTime)
        self.contentView.addSubview(self.msgView)
        self.contentView .addSubview(self.profileImage)
        self.backgroundColor = UIColor.clear
    }
    
    required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func floatVertical () -> CGFloat  {
        return 2 *  textMarginVertical + marginVertical + 16
    }
    func floatHorizontal () -> CGFloat  {
        return textMarginHorizontal
    }
    func messageSize1(_ message: NSString) -> CGSize {
        
        let a=message.boundingRect(with: CGSize(width: MessagingCell.maxTextWidth(), height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font :messageText.font], context: nil)

        return a.size
    }
    
    override func layoutSubviews() {
        let textSize: CGSize = self.messageSize1(messageText.text! as NSString)
        
        
        let b=messageTime.text!._bridgeToObjectiveC().boundingRect(with: messageTime.frame.size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font :messageTime.font], context: nil)
        let timeSize: CGSize = b.size
        
        var msgBalViewFrame: CGRect = CGRect.zero
        var messageTextFrame: CGRect = CGRect.zero
        var messageTimeFrame: CGRect = CGRect.zero
        var profileImageFrame: CGRect = CGRect.zero
        
        if sentBy == true {
            let profileX = profileWidth + marginHorizontal
            profileImageFrame = CGRect(x: self.frame.size.width - profileX, y: 0, width: profileWidth, height: profileWidth)

            msgBalViewFrame = CGRect(x: self.frame.size.width - (textSize.width + 2 * textMarginHorizontal) - marginBubble - profileX, y: 0, width: textSize.width+2*textMarginHorizontal, height: textSize.height + 2 * textMarginVertical)
            messageTextFrame = CGRect(x: self.frame.size.width - (textSize.width + textMarginHorizontal + marginBubble + profileX), y: msgBalViewFrame.origin.y + textMarginVertical,width: textSize.width, height: textSize.height)
            self.messageText.textColor = UIColor.white
            
            messageTimeFrame = CGRect(x: self.frame.width-timeSize.width-marginHorizontal ,y: msgBalViewFrame.size.height + 2, width: timeSize.width, height: timeSize.height);
        }
        else
        {
            let bubbleX = profileWidth + marginHorizontal + marginBubble
            profileImageFrame = CGRect(x: marginHorizontal, y: 0, width: profileWidth, height: profileWidth)
            
            msgBalViewFrame = CGRect(x: bubbleX, y: 0, width: textSize.width + 2 * self.textMarginHorizontal, height: textSize.height + 2 * self.textMarginVertical)
            messageTextFrame = CGRect(x: textMarginHorizontal + bubbleX, y: msgBalViewFrame.origin.y + self.textMarginVertical, width: textSize.width, height: textSize.height)
            self.messageText.textColor = UIColor.black
            
            messageTimeFrame = CGRect(x: marginHorizontal, y: msgBalViewFrame.size.height + 2, width: timeSize.width, height: timeSize.height)
        }
        
        self.msgBalView.image = MessagingCell.balloonImage(sentBy)
        self.msgBalView.frame = msgBalViewFrame
        self.messageText.frame = messageTextFrame
        self.messageText.textColor = MessagingCell.msgTextColor(sentBy)
        self.messageTime.textColor = UIColor.init(rgb: 0xF2F2F2)
        
        if self.profileImage.image != nil {
            self.profileImage.frame = profileImageFrame
            profileImage.layer.cornerRadius=profileImage.frame.size.width/2
            profileImage.layer.masksToBounds=true
        }
        
        if self.messageTime.text != nil {
            self.messageTime.frame = messageTimeFrame
        }
    }
    
}
