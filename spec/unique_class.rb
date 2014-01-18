module UniqueClass
  @@_counter = 1

  def self.set(klass, name=nil)
    name ||= "Model_#{@@_counter}"
    @@_counter += 1
    klass.class_eval <<-RUBY
	def self.to_s
	  "#{name}"
	end
    RUBY
    Object.send(:remove_const, name) if Object.const_defined?(name)
    Object.const_set(name, klass) #unless Kernel.const_defined?(name)
    klass
  end

  def self.create(class_name=nil, &block)
    clazz = Class.new
    set(clazz, class_name)
    clazz.class_eval &block if block
    clazz
  end
end
