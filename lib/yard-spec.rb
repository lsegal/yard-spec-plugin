require 'yard'
require 'ostruct'

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
    name = statement.parameters.first.source
    if statement.parameters[1]
      src = statement.parameters[1].jump(:string_content).source
      name += (src[0] == "#" ? "" : "::") + src
    end
    object = P(name)
    ensure_loaded! object
    object[:specifications] ||= []
    parse_block(statement.last.last, owner: object)
  rescue YARD::Handlers::NamespaceMissingError
  end
end

class RSpecItHandler < YARD::Handlers::Ruby::Base
  handles method_call(:it)
  
  def process
    owner[:specifications] << {}.tap do |o|
      source = statement.source.chomp
      indent = source.split(/\r?\n/).last[/^([ \t]*)/, 1].length
      o[:source] = source.gsub(/^[ \t]{#{indent}}/, '')
      o[:name] = statement.parameters.first.jump(:string_content).source
      o[:file] = statement.file
      o[:line] = statement.line
    end
  end
end

module YARD
  module Generators
    class MethodGenerator
      before_section :specs, :has_specs?
      
      def sections_for(object) 
        [:header, [:title, [G(MethodSignatureGenerator), :aliases],
         G(DeprecatedGenerator), :specs, G(DocstringGenerator), 
         G(TagsGenerator), G(SourceGenerator)]]
      end
      
      def has_specs?(object)
        object[:specifications] && object[:specifications].size > 0 ? true : false
      end
    end
  end
end

YARD::Generators::Base.register_template_path File.dirname(__FILE__) + '/../templates/'
