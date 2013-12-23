class AppDelegate
  
  COMMENTS_ATTRIBUTES = {
    NSFontAttributeName => NSFont.fontWithName("Menlo", size:14),
    NSParagraphStyleAttributeName  => NSMutableParagraphStyle.new.tap { |para| para.alignment = 2 },
    NSForegroundColorAttributeName => NSColor.colorWithCalibratedRed(0.062, green:0.286, blue:0.039, alpha:1.0)
  }
  
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
    setupSubviews
  end
  
  def scrollView
    @_scrollView ||= NSScrollView.alloc.init.tap do |sv|
      sv.translatesAutoresizingMaskIntoConstraints = false
      sv.borderType = NSNoBorder
      sv.hasVerticalScroller = true
      sv.hasHorizontalScroller = false
      sv.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable
    end
  end
    
  attr_reader :constraint

  def label
    @_label ||= NSLabelView.alloc.init.tap do |lb|
      lb.translatesAutoresizingMaskIntoConstraints = false
      lb.stringValue = "Hello World"
    end
  end
  
  def console
    @_console ||= NSTextView.alloc.initWithFrame(NSRect.new([0,0], scrollView.contentSize)).tap do |tv|
      tv.font = NSFont.fontWithName("Menlo", size:14)
      tv.delegate = self
      tv.automaticQuoteSubstitutionEnabled  = false
      tv.automaticDashSubstitutionEnabled   = false
      tv.automaticSpellingCorrectionEnabled = false
      tv.automaticTextReplacementEnabled = false
      contentSize = scrollView.contentSize
      tv.minSize = NSSize.new(1.0, contentSize.height)
      tv.maxSize = NSSize.new(Float::MAX, Float::MAX)
      tv.verticallyResizable = true
      tv.horizontallyResizable = true
      tv.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable
      tv.textContainer.containerSize = NSSize.new(contentSize.width, Float::MAX) # 
      tv.textContainerInset = NSSize.new(5.0, 10.0)
      tv.textContainer.widthTracksTextView = true
    end
  end
    
  def browser
    @_browser ||= NSBrowser.alloc.init.tap do |bw|
      bw.translatesAutoresizingMaskIntoConstraints = false
      @browser_delegate = BrowserDelegate.new
      bw.delegate = @browser_delegate
      bw.minColumnWidth = 100.0
      bw.maxVisibleColumns = 3
      bw.setTitle("Class Name", ofColumn:0)
      bw.setTitle("Class Methods", ofColumn:1)
      bw.setTitle("Class Instance Methods", ofColumn:2)
    end
  end
  
  def setupSubviews
    @mainWindow.contentView.addSubview browser
    @mainWindow.contentView.addSubview scrollView
        
    views_dict = { 'browser' => browser, 'console' => scrollView }  
    constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[console]|", options: 0, metrics: nil, views: views_dict)
    @mainWindow.contentView.addConstraints(constraints)
        
    constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[browser]|", options: 0, metrics: nil, views: views_dict)
    @mainWindow.contentView.addConstraints(constraints)
            
    constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[browser(==200)]-5-[console]|", options: 0, metrics: nil, views: views_dict)
    @mainWindow.contentView.addConstraints(constraints)
    
    @constraint = @mainWindow.contentView.constraints.find { |c| c.constant == 200.0 }
    
    scrollView.documentView = self.console
    @mainWindow.makeFirstResponder self.console
  end
  
  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless    
  end
  
  def clear
    self.console.string = ""
  end
  
  def textView(textView, doCommandBySelector:commandSelector)
    if 'insertNewline:' == NSStringFromSelector(commandSelector)
      last_line = textView.textStorage.string.split(/\r?\n/).last
      result = eval(last_line)
      @attributes ||= textView.typingAttributes
      newLine = "\t"
      attrString = NSAttributedString.alloc.initWithString("#{newLine * 8}# => #{result}", attributes:COMMENTS_ATTRIBUTES)
      textView.textStorage.appendAttributedString(attrString)
      attrString = NSAttributedString.alloc.initWithString("\n", attributes:@attributes)
      textView.textStorage.appendAttributedString(attrString)
    end
    false
  end
  
  def textDidChange(notification)
    if notification.object == self.console
      notification.object.textStorage.string
    end
  end
end
