namespace :elm do
  def compile_and_minify(args, main="Main")
    out = "elm.js"
    min = "elm.min.js"
    opt = args[:debug].present? ? "" : "--optimize"
    if system("elm make src/#{main}.elm #{opt} --output #{out}")
      File.open(min, "w") { |f| f.write(Terser.compile(esmify(File.read(out)))) }
      system("mv #{min} ../../javascript/")
      system("rm #{out}")
      puts "minified to #{min}"
    end
  end

  # based on https://github.com/ChristophP/elm-esm/blob/master/src/index.js
  def esmify(text)
    commented = ""
    elmExports = nil
    filter = false
    text.each_line do |line|
      unless filter
        case line
        when /\A\(function\(scope\)/
          filter = 1
        when /\A['"]use strict['"];/
          filter = 1
        when /\Afunction _Platform_export/
          filter = "}\n"
        when /\Afunction _Platform_mergeExports/
          filter = "}\n"
        when /\A_Platform_export\((.*)\);\}\(this\)/
          filter = 1
          elmExports = $1
        end
      end
      commented += (filter ? "// -- " : "") + line
      if filter
        case filter
        when 1
          filter = false
        else
          filter = false if line == filter
        end
      end
    end

    unless elmExports
      puts "couldn't find elmExports"
      return text
    end

    commented += "\nexport const Elm = #{elmExports};\n"
    commented
  end

  desc "make and minify the Elm JS file for playing SkyJo"
  task :sj, [:debug] do |task, args|
    Dir.chdir("app/views/elm") do
      compile_and_minify args
    end
  end
end
