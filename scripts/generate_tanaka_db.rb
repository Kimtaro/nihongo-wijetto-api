require "csv"

class TanakaImporter
  JAPANESE_ID = 0
  ENGLISH_ID = 1
  JAPANESE = 2
  ENGLISH = 3
  INDICES = 4

  def initialize(file)
    @file = file
    @db = TanakaDb.new(sentences: {}, index: {})
  end

  def run
    csv = CSV.new(
      @file,
      col_sep: "\t",
      liberal_parsing: true,
      headers: false
    )

    csv.each_with_index do |row, index|
      import_row(row)

      puts index if index % 10_000 == 0
    end

    @db
  end

  private

  def import_row(row)
    japanese_id = row[JAPANESE_ID]
    sentence = TanakaSentence.new(
      japanese_id: japanese_id,
      english_id: row[ENGLISH_ID],
      japanese: row[JAPANESE],
      english: row[ENGLISH],
      indices: row[INDICES]
    )

    @db.sentences[japanese_id] = sentence

    tokens = tokenize_sentence(sentence)
    tokens.each do |token|
      @db.index[token] = [] unless @db.index.has_key?(token)
      @db.index[token] << japanese_id
    end
  end

  def tokenize_sentence(sentence)
    words = Ve.in(:ja).words(sentence.japanese)
    tokens = words.map(&:lemma) + words.map(&:word)
    tokens.uniq
  end
end

tanaka_file = Rails.root.join('data').join('wwwjdic.csv')
db = TanakaImporter.new(File.open(tanaka_file)).run

marshal_file = File.new(Rails.root.join('db').join('tanaka.db'), "w")
File.open(marshal_file, "wb") {|f| f.write(Marshal.dump(db))}
