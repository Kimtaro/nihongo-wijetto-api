require "set"

class Kanjidic2Importer
  ENTRY_NAME = "character"

  def initialize(kanjidic2)
    @doc = kanjidic2
    @db = Hash.new { |h, k| h[k] = Hash.new }
  end

  def create_db
    xml = @doc.read
    reader = Nokogiri::XML::Reader(xml)
    processed = 0

    reader.each do |node|
      is_opening_element = node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT

      if node.name == ENTRY_NAME && is_opening_element
        handle_entry node.outer_xml

        processed += 1
        puts processed if processed % 1000 == 0
      end
    end

    @db
  end

  private

  def handle_entry(entry)
    parsed_entry = Nokogiri::XML(entry, nil, "UTF-8")
    literal = parsed_entry.at_xpath("//literal").content
    entry = @db[literal]
  end
end
