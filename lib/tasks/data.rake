include Rails

DATA_DIR = Rails.root.join('data')

namespace :data do
  task :ensure_data_directory do
    Dir.mkdir(DATA_DIR) unless File.exist?(DATA_DIR)
  end

  namespace :dl do
    desc "Download all files"
    task :all => [:kanjidic2, :tanaka] do
    end

    desc "Download Kanjidic2"
    task :kanjidic2 => [:ensure_data_directory] do
      dl_and_gunzip('http://www.edrdg.org/kanjidic/kanjidic2.xml.gz')
    end

    desc "Download Tanaka Corpus"
    task :tanaka => [:ensure_data_directory] do
      dl('https://downloads.tatoeba.org/exports/wwwjdic.csv')
    end

    def dl(url)
      filename = url.split('/')[-1]
      target_path = DATA_DIR + filename
      sh "rm #{target_path}" if File.exist?(target_path)
      sh "wget -O #{target_path} #{url}"
      target_path
    end

    def gunzip(path)
      sh "gunzip -f #{path}"
    end

    def dl_and_gunzip(url)
      path = dl(url)
      gunzip(path)
    end

    def bunzip2(path)
      sh "bunzip2 -f #{path}"
    end

    def dl_and_bunzip2(url)
      path = dl(url)
      bunzip2(path)
    end
  end
end
