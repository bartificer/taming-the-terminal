namespace :book do
  desc 'build basic book formats'
  task :build do

    begin
      book_dir = 'book'

      version_string = ENV['TRAVIS_TAG'] || `git describe --tags`.chomp
      if version_string.empty?
        version_string = '1.0'
      end
      date_string = Time.now.strftime("%Y-%m-%d")
      compile_time = Time.now.strftime("%Y-%m-%d %k-%M-%S")

      # general parameters
      params =
        "--attribute revnumber='#{version_string}' \
        --attribute revdate='#{date_string}'       \
        --attribute compile_time='#{compile_time}' \
        --destination-dir='output'                 \
        "

      # HTML specific parameters
      htmlparams =
      "                                            \
      --out-file='ttt.html'                        \
      "

      # ePub specific parameters
      epubparams =
      "                                            \
      --attribute pygments-style='manni'           \
      --attribute pygments-linenums-mode='inline'  \
      --out-file='ttt.epub'                        \
      "

      # PDF specific parameters
      pdfparams =
        "                                          \
        --out-file='ttt.pdf'                       \
        "

      puts "Generating contributors list"
      `git shortlog -es  | cut -f 2-  > #{book_dir}/contributors.txt`

      puts "Converting to HTML..."
      `bundle exec asciidoctor #{params} #{htmlparams} #{book_dir}/ttt-spine.adoc`
      puts " -- HTML output at ttt.html"

      puts "Sync the assets"
      `rsync -r --delete book/assets/* output/assets/`

      puts "Converting to EPub..."
      `bundle exec asciidoctor-epub3 #{params} #{epubparams} #{book_dir}/ttt-epub-spine.adoc`
      puts " -- Epub output at ttt.epub"

    #   puts "Converting to Mobi (kf8)..."
    #   `bundle exec asciidoctor-epub3 #{params} -a ebook-format=kf8 #{book_dir}/ttt-spine.adoc`
    #   puts " -- Mobi output at ttt.mobi"

      puts "Converting to PDF... (this one takes a while)"
      `bundle exec asciidoctor-pdf #{params} #{pdfparams} #{book_dir}/ttt-spine.adoc`
      # 2>/dev/null`
      puts " -- PDF output at ttt.pdf"

    end
  end
end

task :default => "book:build"
