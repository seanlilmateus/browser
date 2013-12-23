class BrowserDelegate2
  TITLES = ["Class Methods",  "Instance Methods"]
  NUMBER_OF_COLUMNS = 3
  
  def rootItemForBrowser(browser)
    @collection ||= begin
      klasses = Module.constants.reject { |c| c.to_s =~ /^[A-Z]+$/ || c.to_s[0..3] =~ /^[A-Z]+$/ }
                        .select {|c| Module.const_get(c).is_a?(Class) rescue nil }
                        .map(&Module.method(:const_get))
      # @collection = klasses.map { |klass| Node.new(klass) } #.sort_by(&:kind)
      klasses.map do |klass|
        Hash[
          'Ancestors' => klass.ancestors[1..-1],
          'Class'    => klass,
          'Kind'     => klass.class,
          TITLES.first  => klass.methods(false, true),
          TITLES.last => klass.instance_methods(false, true),
        ]
      end   
    end     
  end
=begin    
  def browser(browser, numberOfChildrenOfItem:item)
    if item.is_a?(Hash)
      @collection.count
    elsif item.is_a?(Array)
      item.count
    # elsif TITLES.include?(item)
    #   c1 = browser.selectedRowInColumn(0)
    #   @collection[c1][item].count
    else
      0
    end
    
  end
  
  def browser(browser, child:index, ofItem:item)
    NSLog("browser(%@, child:%@, ofItem:%@)", browser, index, item.class)    
    if item.is_a?(Array)
      item[index]
    elsif item.is_a?(Hash)
      TITLES
    else
      puts "item: #{item}"
      item
    end
  end
  
  def browser(browser, isLeafItem:item)
    # not item.is_a?(Array)
    false
  end
  
  def browser(browser, objectValueForItem:item)
    item.to_s rescue nil
  end
  
  def browser(browser, numberOfRowsInColumn:column)
    if column.zero?
      NSLog("numberOfRowsInColumn: [%@] 0", column)    
      @collection.count
    elsif column == 1
      NSLog("numberOfRowsInColumn: [%@] 1", column)    
      TITLES.count
    elsif column == 2
      NSLog("numberOfRowsInColumn: [%@] 2", column)    
      @collection[@row][@key].count
    else
      @collection[@row][@key].count
    end
  end
  
  def browser(sender, selectRow:row, inColumn:column)
    @row = row
    puts "selectRow:#{row} - inColumn:#{column}"
    true
  end
    
  def browser(browser, willDisplayCell:cell, atRow:row, column:column)
    cell.title = if column == 0
                    @row = row
                    @collection[row]['Class'].to_s
                 elsif column == 1
                    @key = TITLES[row].to_s
                  elsif column == 2
                    # puts "atRow:#{row} - column:#{browser.selectionIndexPath.description}"
                    "XXXX"
                  else
                    @collection[row]['Class'].to_s
                  end
  end
  
  
  def browser(browser, createRowsForColumn:column, inMatrix:matrix)
    if column == 0
      puts "column == 0 #{matrix}"
    elsif column == 1
      puts "column == 1 #{matrix}"
    elsif column == 2
      puts "column == 2 #{matrix}"
    end
  end
  
  def browser(browser, titleOfColumn:column)
    TITLES[column]
  end
  
  def browser(browser, isColumnValid:column)
    NUMBER_OF_COLUMNS >= column
  end
=end
end

class BrowserDelegate
  TITLES = ['Ancestors', 'Constants', 'Methods', 'Instance Methods']
  KEYS = [:ancestors, :konstants, :selectors, :instances_selectors]
  
  def collection
    @collection ||= begin
      # klasses = Module.constants.reject { |c| c.to_s =~ /^[A-Z]+$/ || c.to_s[0..3] =~ /^[A-Z]+$/ || c.to_s[0] == '_'}
      #                 .select {|c| Module.const_get(c).is_a?(Class) rescue nil }
      #                 .map(&Module.method(:const_get))
      klasses = CBKlasses.klasses   
      klasses.map { |klass| Node.new(klass)}.sort_by(&:klass)
    end     
  end
  
  def browser(sender, isColumnValid:column)
    return true if column == 0 or column == 1
    false
  end
  
  def browser(sender, createRowsForColumn:column, inMatrix:matrix)
    if column == 0
      collection.each_with_index do |node, index|
        matrix.addRow
        cell = matrix.cellAtRow(index, column:column)
        cell.stringValue = node.klass
        cell.leaf = false
        cell.loaded = true
      end
    elsif column == 1
      KEYS.each_with_index do |title, index|
        matrix.addRow
        cell = matrix.cellAtRow(index, column:0)
        cell.stringValue = TITLES[index]
        cell.leaf = false
        cell.loaded = false
      end
      
    elsif column == 2
      idx = sender.selectedRowInColumn(0)
      row = sender.selectedRowInColumn(1)
      key = KEYS[row]
      collection[idx].send(key).each_with_index do |title, index|
        matrix.addRow
        cell = matrix.cellAtRow(index, column:0)
        cell.stringValue = title.to_s
        cell.leaf = true
        cell.loaded = true
      end
    end
  end
end