namespace :elm do
  def compile_and_minify(args, main="Main")
    out = "elm.js"
    min = "elm.min.js"
    opt = args[:debug].present? ? "" : "--optimize"
    if system("elm make src/#{main}.elm #{opt} --output #{out}")
      File.open(min, "w") { |f| f.write(Uglifier.compile(File.read(out))) }
      system("mv #{min} ../../assets/javascripts/")
      system("rm #{out}")
      puts "uglified ───> #{min}"
    end
  end

  desc "make and minify the Elm JS file for playing SkyJo"
  task :sj, [:debug] do |task, args|
    Dir.chdir("app/views/elm") do
      compile_and_minify args
    end
  end
end
