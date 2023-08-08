TanakaDb = Struct.new(:sentences, :index) do
  def marshal_dump
    {}.tap do |result|
      result[:sentences] = sentences
      result[:index] = index
    end
  end

  def marshal_load(serialized)
    self.sentences = serialized[:sentences]
    self.index = serialized[:index]
  end

  def lookup(word)
    ids = index[word]
    sentences.fetch_values(*ids)
  end
end

TanakaSentence = Struct.new(:japanese_id, :english_id, :japanese, :english, :indices) do
  def marshal_dump
    {}.tap do |result|
      result[:japanese_id] = japanese_id
      result[:english_id] = english_id
      result[:japanese] = japanese
      result[:english] = english
      result[:indices] = indices
    end
  end

  def marshal_load(serialized)
    self.japanese_id = serialized[:japanese_id]
    self.english_id = serialized[:english_id]
    self.japanese = serialized[:japanese]
    self.english = serialized[:english]
    self.indices = serialized[:indices]
  end

  def as_json(options)
    {
      japanese: japanese,
      english: english
    }
  end
end

tanaka_db_file = Rails.root.join('db').join('tanaka.db')

if File.exist?(tanaka_db_file)
  TANAKA_DB = Marshal.load(File.binread(tanaka_db_file))
else
  TANAKA_DB = {}
end
