#=== conf
$id_table_file = "fbgn_fbtr_fbpp_fb_2015_02.tsv"
$annotation_file = "fbgn_annotation_ID_fb_2015_02.tsv"
#===

class Fbgn
  def initialize(id)
    @id = id
    @fbtrs = []
    @fbpps = []
    @gsym = nil
  end

  attr_reader :id
  attr_accessor :fbtrs, :fbpps, :gsym

  def add_fbtr(fbtr)
    if fbtr && fbtr != ""
      @fbtrs << fbtr unless @fbtrs.include?(fbtr)
    end
  end
end


class FbgnSet

  def initialize
    @db = {}

    File.open($id_table_file).each do |l|
      next unless /^\FBgn/.match(l)
      a = l.chomp.split(/\t/)
      if v = @db[a[0]]
      else      
        fbgn = Fbgn.new(a[0])
        @db[a[0]] = fbgn
      end
      @db[a[0]].add_fbtr( a[1])
    end

    File.open($annotation_file).each do |l|
      next if /^\#/.match(l)
      next if /^\s/.match(l)
      a = l.chomp.split(/\t/)
      next if /\\/.match(a[0]) # skip non-Dmel genes
      next unless @db[a[1]]
      @db[a[1]].gsym = a[0]
    end
  end

  attr_accessor :db

end

if __FILE__ == $0
  fbgn_set.keys.each do |k|
    fbgn = fbgn_set[k]
    p [k,fbgn.gsym,  fbgn.fbtrs.join(",")]
  end
end
