class Node
  attr_reader :ancestors, :klass, :selectors, :instances_selectors, :kind, :konstants
  
  def initialize(klass)
    @klass = klass.to_s
    @kind = klass.class
    @konstants = klass.constants(false)
    @ancestors = klass.ancestors[1..-1].reverse
    @selectors = klass.methods(false, true)
    @instances_selectors = klass.instance_methods(false, true)
  end
  
  def to_s
    "Kind:#@kind\nClass:#@klass\n\t- ancestors:#@ancestors\n\t- methods:#@selectors\n\t- instance_methods:#@instances_selectors\n#{'_'*150}"
  end
end

class CBKlasses
  def self.klasses
    CBKlasses.all
             .reject { |c| c =~ /(^[A-Z]+$|^RBAnonymous)/ || c[0] == '_' || c.include?("Proxy") || c == 'Object' }
             .sort
             .flat_map {|c| NSClassFromString(c) }
             .select { |klass| klass.instancesRespondToSelector('inspect') }
  end
end