namespace :book do
  desc 'build basic book formats'
  task :build do

    begin

      book_dir = 'book'
      output_dir = 'output'

      version_string = ENV['TRAVIS_TAG'] || `git describe --tags`.chomp
      if version_string.empty?
        version_string = '1.0'
      end
      date_string = Time.now.strftime("%Y-%m-%d")
      compile_time = Time.now.strftime("%Y-%m-%d %k-%M-%S")

      # general parameters
      paramsAttr = {
          'revnumber'=> version_string,
          'revdate' => date_string,
          'compile_time' => compile_time
      }
      paramsHash = {
        'destination-dir' => "#{output_dir}"
      }

      # HTML specific parameters

      htmlParams = paramsHash.merge({
        'attribute' => paramsAttr.merge({
          # 'stylesdir'=>'theme',
          # 'stylesheet'=>'bartificer.css'
        }),
        'out-file' => 'ttt.html'
      })

      # ePub specific parameters
      epubParams = paramsHash.merge({
        'attribute' => paramsAttr.merge({
          # 'ebook-validate' => '',
          'epub3-stylesdir' => "'theme/epub'",
          'pygments-style' => 'manni',
          'pygments-linenums-mode' => 'inline'
        }),
        'out-file' => 'ttt.epub'
      })

      # PDF specific parameters
      pdfParams = paramsHash.merge({
        'attribute' => paramsAttr.merge({
          'pdf-themesdir' => "'#{book_dir}/theme/pdf'",
          'pdf-fontsdir' => "'#{book_dir}/theme/fonts,GEM_FONTS_DIR'",
          'pdf-theme' => 'bartificer'
        }),
        'out-file' => 'ttt.pdf',
      })

      def buildParams(params)
        result = ''
        params.each do |key, value|
          if key == 'attribute'
            value.each do | k, val |
              result = result + " -a #{k}='#{val}'"
            end
          else
            result = result +" --#{key}='#{value}'"
          end
        end
        return result
      end

      puts "Generating contributors list"
      `git shortlog -es  | cut -f 2-  > #{book_dir}/contributors.txt`

      puts "\nConverting to HTML..."
      `bundle exec asciidoctor #{buildParams(htmlParams)} #{book_dir}/ttt-spine.adoc`
      puts " -- HTML output at #{htmlParams['destination-dir']}/#{htmlParams['out-file']}"

      puts "Sync the assets"
      `rsync -r --delete book/assets/* output/assets/`

      puts "\nConverting to EPub..."
      `bundle exec asciidoctor-epub3 #{buildParams(epubParams)} #{book_dir}/ttt-spine.adoc`
      puts " -- Epub output at #{epubParams['destination-dir']}/#{epubParams['out-file']}"

      # puts "Validating ePub"
      # `java -jar epubcheck/epubcheck.jar #{epubParams['destination-dir']}/#{epubParams['out-file']}`

    #   puts "Converting to Mobi (kf8)..."
    #   `bundle exec asciidoctor-epub3 #{params} -a ebook-format=kf8 #{book_dir}/ttt-spine.adoc`
    #   puts " -- Mobi output at ttt.mobi"

      puts "\nConverting to PDF A4... (this one takes a while)"
      `bundle exec asciidoctor-pdf #{buildParams(pdfParams)} #{book_dir}/ttt-spine.adoc`
      # 2>/dev/null`
      puts " -- PDF output at #{pdfParams['destination-dir']}/#{pdfParams['out-file']}"

      params = pdfParams
      params['out-file'] = 'ttt-us.pdf'
      params['attribute']['pdf-theme'] = 'bartificer-us'

      puts "\nConverting to PDF US... (this one takes a while)"
      `bundle exec asciidoctor-pdf #{buildParams(params)} --trace #{book_dir}/ttt-spine.adoc`
      # 2>/dev/null`
      puts " -- PDF output at #{params['destination-dir']}/#{params['out-file']}"

      puts "\nZip everything"
      `zip -r output/ttt_all.zip output/ttt* output/assets`
    end
  end
end

task :default => "book:build"
