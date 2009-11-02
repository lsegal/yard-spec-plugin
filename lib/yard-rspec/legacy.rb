class LegacyRSpecDescribeHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /\Adescribe\s+(.+?)\s+(do|\{)/
  handles MATCH
  
  def process
    objname = statement.tokens.to_s[MATCH, 1].gsub(/["']/, '')
    obj = {:spec => owner ? (owner[:spec] || "") : ""}
    obj[:spec] += objname
    parse_block :owner => obj
  rescue YARD::Handlers::NamespaceMissingError
  end
end

class LegacyRSpecItHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /\Ait\s+['"](.+?)['"]\s+(do|\{)/
  handles MATCH
  
  def process
    return if owner.nil?
    obj = P(owner[:spec])
    return if obj.is_a?(Proxy)
    
    (obj[:specifications] ||= []) << {
      :name => statement.tokens.to_s[MATCH, 1],
      :file => parser.file,
      :line => statement.line,
      :source => statement.block.to_s
    }
  end
end

