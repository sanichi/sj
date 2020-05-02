namespace :elm do
  def compile_and_minify(name, args, main="Main")
    out = "_elm_#{name}.js"
    min = "_elm_#{name}.min.js"
    opt = args[:debug].present? ? "" : "--optimize"
    if system("elm make src/#{main}.elm #{opt} --output #{out}")
      File.open(min, "w") do |file|
        file.write(Uglifier.compile(File.read(out)))
      end
      system("rm #{out}")
      puts "uglified ───> #{min}"
    end
  end

  desc "make and minify the Elm JS file for a card table"
  task :table, [:debug] do |task, args|
    Dir.chdir("app/views/pages") do
      compile_and_minify "table", args
    end
  end
end
