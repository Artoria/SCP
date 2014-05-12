require 'json'
require 'sinatra'
require 'erb'
#encoding:UTF-8

class RCore
  def render(a, b = self)
    ERB.new(resolve(a)).result(b.instance_eval{binding})
  end

  def resolve(a)
    a
  end
end

class RQ < RCore
  def initialize(dir)
    @dir = dir
  end
  def resolve(f)
    R(File.join(@dir, f))
  end
  def value
    render 'main', self
  end
end


def R(a)
   entry = File.join("./R", a)
   case 
      when FileTest.file?(entry + ".txt")
	  File.read(entry + ".txt").force_encoding("UTF-8")
      when FileTest.file?(entry + ".lst")
	  File.read(entry + ".lst").force_encoding("UTF-8").split(/\n|\r/).compact.reject{|x| x == ""}.sample
      when FileTest.directory?(entry)
	  RQ.new(a).value

   end
end

RULES = Hash.new do |h, k| h[k] = {} end
class Rule
  def initialize(type = :register, &block)
    @bl = block
  end
  def run
    @text = ""
    instance_exec &@bl
    @text
  end

  class Selector
    def initialize(obj, text, klass = "window.jQuery")
      @obj = obj
      @text = text
      @klass = klass
    end
    def autotype(a)
      case a when Symbol then a.to_s else a.inspect end
    end
    def method_missing(sym, *args)
      if(!@first)
      	@obj.write "#{@klass}(#{autotype @text})"
      	@first = true
      end
      @obj.write ".#{autotype sym}(#{args.map{|x| autotype x}.join(",")} )\n"
      self
    end
  end
  def j(a)
    Selector.new(self, a)
  end
  def f(a)
    a = "/" + a.source + "/i"
    Selector.new(self, a.to_sym, "fuzzyId")
  end
  def write(s)
    @text << s
  end
  def s(a)
    a = "/" + a.source + "/i"
    Selector.new(self, a.to_sym, "selectText")
  end
  def st(a)
    a = "/" + a.source + "/i"
    Selector.new(self, a.to_sym, "selectByText")
  end
  def chain(rule, type = :register)
    if v = findrule(rule, type)
      write v.run
    end
  end
  alias include chain
end

def rule(url, type = :register, &block)
   RULES[type][url] = block
end

def rule_register(url, &block)
  rule url, :register, &block
end

def rule_new(url, &block)
  rule url, :new, &block
end 






def findrule(url, type = :register)
  RULES[type].each{|k, v|
     if k === url
	 puts "#{url} -> #{type} #{k}"
	return Rule.new(type, &v)
     end
  }
  nil
end

get '/startup' do
  load './rule.rb'
  response.headers['content-type'] = "application/javascript; charset=UTF-8"
  k = params['url']
  ERB.new(File.read 'app/app.js.erb').result(findrule(k).instance_eval{binding})
end

get '/new' do
  load './rule.rb'
  response.headers['content-type'] = "application/javascript; charset=UTF-8"
  k = params['url']
  ERB.new(File.read 'app/new.js.erb').result(findrule(k, :new).instance_eval{binding})
end

