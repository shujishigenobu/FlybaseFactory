cdsfasta = "dmel-all-CDS-r6.05.fasta"

require 'pp'

File.open(cdsfasta).each do |l|
  if m = /^>(.+?)\s/.match(l.chomp)
     desc = m.post_match.strip
     entry_id = m[1]
    h = Hash.new
    h["entry_id"] = entry_id
    desc.split(/;/).each do |x|
      m2 = /(.+)\=(.*)/.match(x.strip)
      k = m2[1]
      v = m2[2]
      raise if h.has_key?(k)
      h[k] = v
    end
#    p h
    h2 = Hash.new
    h["dbxref"].split(/,/).each do |x|
      k, v = x.split(/:/)
#      p [k, v]
      if h2.has_key?(k)
        STDERR.puts "duplicated key: #{h['entry_id']} : #{k}"
      end
      h2[k] = v
      h["dbxref"] = h2
    end

    h["parent_transcript"], h["parent_gene"] = h["parent"].split(/,/)

    p h['entry_id']
  end
end
