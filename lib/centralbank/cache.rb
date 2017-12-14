

class Cache
  def initialize( name )
    @name = name
  end

  def write( data )
    File.open( @name, 'w' ) do |f|        ## use utf8 - why? why not??
      f.write JSON.pretty_generate( data )
    end
  end

  def read
    if File.exists?( @name )
      data = File.read( @name )   ## use utf8 - why? why not??
      JSON.parse( data )
    else
      nil
    end
  end
end   ## class Cache
