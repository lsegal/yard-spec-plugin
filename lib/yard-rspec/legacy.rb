class LegacyRSpecDescribeHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /\Adescribe\s+(.+)\s+(?:do|\{)/
  handles MATCH
  
  def process
    describes = statement.tokens.to_s[MATCH, 1].gsub(/["']/, "")

    # Remove the argument list from describe "#method(a, b, &c)"
    if arguments = describes[/[#.](?:.+?)(\([^)]*\))$/, 1]
      describes = describes[0, describes.length - arguments.length]
    end

    unless owner.is_a?(Hash)
      pwner = Hash[:describes => describes, :context => ""]
      parse_block(:owner => pwner)
    else
      describes = owner[:describes] + describes
      pwner = owner.merge(:describes => describes)
      parse_block(:owner => pwner)
    end
  rescue YARD::Handlers::NamespaceMissingError
  end
end

class LegacySpecContextHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /\Acontext\s+(['"])(.+)\1(?:.*?)\s+(?:do|\{)/
  handles MATCH

  def process
    if owner.is_a?(Hash)
      context = statement.tokens.to_s[MATCH, 2]
      context = owner[:context] + context + " "

      parse_block(:owner => owner.merge(:context => context))
    end
  end
end

class LegacyRSpecItHandler < YARD::Handlers::Ruby::Legacy::Base
  MATCH = /\A(?:it|specify)\s+(['"])(.+?)\1.*?(?:(\s+(?:do|\{))|$)/

  handles MATCH
  handles /\A(?:it|specify)\s+.*?(?:do|\{)/
  
  def process
    return unless owner.is_a?(Hash)
    return unless owner[:describes]

    node = YARD::Registry.resolve(nil, owner[:describes], true)
    spec = statement.tokens.to_s[MATCH, 2] || "untitled spec"

    unless node
      log.warn "Unknown node #{owner[:describes]} for spec defined in #{parser.file} near line #{statement.line}"
      return
    end

    source = statement.block.to_s.strip

    (node[:specifications] ||= []) << \
      Hash[ :name => owner[:context] + spec,
            :file => parser.file,
            :line => statement.line,
            :source => source ]
  end
end

class LegacyRSpecItsHandler < YARD::Handlers::Ruby::Legacy::Base
# MATCH = /\Aits\s*(\(?)\s*[:]?(['"]?)(.+)\2\1(?:(\s+(?:do|\{))|$)/
# handles MATCH

  MATCH = /\Aits\s*([(]?)\s*:?(['"]?)([^'")]+)\2/
  handles MATCH

  def process
    return unless owner.is_a?(Hash)
    return unless owner[:describes]

    node = YARD::Registry.resolve(nil, owner[:describes], true)

    property = statement.tokens.to_s[MATCH, 3]
    should   = statement.block.to_s[/should(?:_not)?\s+(.+)/, 1]

    spec = if property and should
             "#{property} #{should}"
           else
             "untitled spec"
           end

    unless node
      log.warn "Unknown node #{owner[:describes]} for spec defined in #{parser.file} near line #{statement.line}"
      return
    end

    source = statement.block.to_s.strip

    (node[:specifications] ||= []) << \
      Hash[ :name => owner[:context] + spec,
            :file => parser.file,
            :line => statement.line,
            :source => source ]
  end
end
