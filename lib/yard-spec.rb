require 'yard'

$RSpecCount = 0

class SpecificationGroupObject < YARD::CodeObjects::NamespaceObject
  attr_accessor :test_class, :specifications
  def type; :specification_group end
  def path; "__RSpecTest::" + super end
  
  def initialize(*args)
    super
    @specifications = []
  end
end

class RSpecDescribeHandler < YARD::Handlers::Ruby::Base
  handles method_call(:describe)
  
  def process
    obj = register SpecificationGroupObject.new(namespace, "Test#{$RSpecCount += 1}") do |o|
      o.test_class = P(statement.parameters.first.source)
    end
    parse_block(statement.last.last, namespace: obj)
  end
end

class RSpecItHandler < YARD::Handlers::Ruby::Base
  handles method_call(:it)
  
  def process
    namespace.specifications << statement.parameters.first.jump(:string_content).source
  end
end

YARD.parse Dir.glob(ARGV[0])

YARD::Registry.all(:specification_group).each do |spec|
  puts "Specifications for: #{spec.test_class.path}"
  puts spec.specifications.join("\n").gsub(/^/, '  - ')
end