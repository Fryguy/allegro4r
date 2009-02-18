require 'rubygems'
require 'rake'

# Overrides some of the rdoc methods to handle class documentation in files
#   other than where Init_xxx is located.
require 'rdoc/rdoc'
require 'rdoc/parsers/parse_c'
module RDoc
  class C_Parser
    def handle_class_module(var_name, class_mod, class_name, parent, in_module, source_file = nil)
      progress(class_mod[0, 1])

      parent_name = @known_classes[parent] || parent

      if in_module
        enclosure = @classes[in_module]
        unless enclosure
          if enclosure = @known_classes[in_module]
            handle_class_module(in_module, (/^rb_m/ =~ in_module ? "module" : "class"),
              enclosure, nil, nil)
            enclosure = @classes[in_module]
          end
        end
        unless enclosure
          warn("Enclosing class/module '#{in_module}' for " +
              "#{class_mod} #{class_name} not known")
          return
        end
      else
        enclosure = @top_level
      end

      if class_mod == "class"
        cm = enclosure.add_class(NormalClass, class_name, parent_name)
        @stats.num_classes += 1
      else
        cm = enclosure.add_module(NormalModule, class_name)
        @stats.num_modules += 1
      end
      cm.record_location(enclosure.toplevel)

      if source_file
        file_name = File.join(@file_dir, source_file)
        body = (@@known_bodies[source_file] ||= File.read(file_name))
      else
        body = @body
      end

      find_class_comment(cm.full_name, cm, body)
      @classes[var_name] = cm
      @known_classes[var_name] = cm.full_name
    end

    def find_class_comment(class_name, class_meth, body)
      comment = nil
      if body =~ %r{((?>/\*.*?\*/\s+))
                     (static\s+)?void\s+Init_#{class_name}\s*(?:_\(\s*)?\(\s*(?:void\s*)?\)}xmi
        comment = $1
      elsif body =~ %r{Document-(class|module):\s#{class_name}\s*?\n((?>.*?\*/))}m
        comment = $2
      else
        if body =~ /rb_define_(class|module)/m then
          class_name = class_name.split("::").last
          comments = []
          body.split(/(\/\*.*?\*\/)\s*?\n/m).each_with_index do |chunk, index|
            comments[index] = chunk
            if chunk =~ /rb_define_(class|module).*?"(#{class_name})"/m then
              comment = comments[index-1]
              break
            end
          end
        end
      end
      class_meth.comment = mangle_comment(comment) if comment
    end

    def do_classes
      @body.scan(%r{(\w+)\s* = \s*rb_define_module\s*\(\s*"(\w+)"\s*\)(?:;\s*/[*/]\s+in\s+(\w+?\.[cy]))?}mx) do
        |var_name, class_name, source_file|
        handle_class_module(var_name, "module", class_name, nil, nil, source_file)
      end

      # The '.' lets us handle SWIG-generated files
      @body.scan(/([\w\.]+)\s* = \s*rb_define_class\s*
                \(
                   \s*"(\w+)",
                   \s*(\w+)\s*
                \)/mx) do

        |var_name, class_name, parent|
        handle_class_module(var_name, "class", class_name, parent, nil)
      end

      @body.scan(/(\w+)\s*=\s*boot_defclass\s*\(\s*"(\w+?)",\s*(\w+?)\s*\)/) do
        |var_name, class_name, parent|
        parent = nil if parent == "0"
        handle_class_module(var_name, "class", class_name, parent, nil)
      end

      @body.scan(%r{(\w+)\s* = \s*rb_define_module_under\s*
                \(
                   \s*(\w+),
                   \s*"(\w+)"
                \s*\)(?:;\s*/[*/]\s+in\s+(\w+?\.[cy]))?}mx) do

        |var_name, in_module, class_name, source_file|
        handle_class_module(var_name, "module", class_name, nil, in_module, source_file)
      end

      @body.scan(%r{([\w\.]+)\s* = \s*rb_define_class_under\s*
                \(
                   \s*(\w+),
                   \s*"(\w+)",
                   \s*(\w+)\s*
                \s*\)(?:;\s*/[*/]\s+in\s+(\w+?\.[cy]))?}mx) do

        |var_name, in_module, class_name, parent, source_file|
        handle_class_module(var_name, "class", class_name, parent, in_module, source_file)
      end
    end
  end
end

task :create_pkg_dir do
  mkdir_p "pkg"
end

def gem_package_tasks(s, *options)
  options = options.first || {}
  desc_title  = options.has_key?(:desc_title) ? "#{options[:desc_title]} " : ""
  task_suffix = options.has_key?(:task_suffix) ? "_#{options[:task_suffix]}" : ""
  
  task_build    = "build#{task_suffix}".to_sym
  task_gem      = "gem#{task_suffix}".to_sym
  task_manifest = "manifest#{task_suffix}".to_sym
  task_clobber  = "clobber_pkg#{task_suffix}".to_sym

  build_depends = [task_manifest, task_gem]
  build_depends = options[:build_depends] + build_depends if options.has_key?(:build_depends)

  gem_file = "#{s.name}-#{s.version}#{s.platform == Gem::Platform::RUBY ? "" : "-#{s.platform}"}.gem"
  pkg_dir = "pkg"
  pkg_file = "#{pkg_dir}/#{gem_file}"

  desc "Build the gem file #{gem_file}"
  task task_build => build_depends

  desc "Build the gem file #{gem_file}"
  task task_gem => pkg_file

  file pkg_file => [:create_pkg_dir, pkg_dir] + s.files do
    puts "Creating Gem #{gem_file}"
    Gem::Builder.new(s).build
    mv gem_file, pkg_file, :verbose => true
    puts "Creating Gem #{gem_file}...completed"
  end

  desc "Remove the gem file #{gem_file}"
  task task_clobber do
    rm_rf pkg_file
  end

  desc "Create the #{desc_title}Manifest.txt file"
  task task_manifest do
    puts "Creating #{desc_title}Manifest.txt"
    File.open("Manifest.txt", "w") { |f| f.write(s.files.join("\n")) }
  end
end

# Ruby specification
spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY

  s.name = "allegro4r"
  s.version = "0.0.1"
  s.authors = ["Jason Frey"]
  s.email = "fryguy9 @nospam@ yahoo.com"
  s.homepage = "http://allegro4r.rubyforge.org"
  s.rubyforge_project = s.name

  s.summary = "Ruby binding for the Allegro game programming library"
  s.description = "Ruby binding for the Allegro game programming library as well as more stuff"
  s.requirements = ["Allegro 4.2.2 (http://alleg.sourceforge.net/)"]

  s.extensions = ["ext/extconf.rb"]
  s.files = FileList["ext/*.{c,i,rb}", "examples/**/*", "Manifest.txt"].to_a
  s.require_paths = ["ext"]

  s.has_rdoc = true
  s.extra_rdoc_files = FileList["README.txt", "History.txt"].to_a
  s.rdoc_options = ["--main", "README.txt"]
end

# Ruby build tasks
gem_package_tasks(spec)

desc "Remove package products"
task :clean => :clobber_pkg

# Windows specification
spec_win = spec.clone
spec_win.platform = Gem::Platform.new("i386-mswin32_60")
spec_win.extensions = []
spec_win.files = FileList["ext/allegro4r.so", "examples/**/*", "Manifest.txt"]
spec_win.extra_rdoc_files = FileList["README.txt", "History.txt"].to_a

# Windows build tasks
gem_package_tasks(spec_win, :desc_title => "Windows", :task_suffix => "win", :build_depends => [:create_win])

desc "Remove Windows package products"
task :clean_win => :clobber_pkg_win do
  rm_rf Dir.glob("ext/*.o")
  #rm_rf Dir.glob("ext/*.so")
  #rm_rf Dir.glob("ext/Makefile")
end

desc "Build the binary for Windows"
task :create_win do
  so_file = "ext/allegro4r.so"
  if File.exists?(so_file)
    puts "Not rebuilding #{so_file}, as it is already built."
  else
    raise "Unable to build #{so_file}.  Must be in a MinGW environment." unless RUBY_PLATFORM == "i386-mingw32"
    cd("ext") do
      #sh "ruby -I ../rbconfig-mingw.rb extconf.rb"
      sh "/mingw/ruby/bin/ruby extconf.rb --with-allegro-dir=/mingw/allegro-mingw-4.2.2"
      sh "make clean"
      sh "make"
    end
  end
end

desc "Build the documentation"
task :docs do
  RDoc::RDoc.new.document(["--force-update"] + spec_win.rdoc_options + spec_win.extra_rdoc_files + ["ext/allegro4r.c"])
end

desc "Remove the documentation"
task :clean_docs do
  rm_rf "doc"
end

# General build tasks
desc "Remove all package products"
task :clean_all => [:clean, :clean_win] do
  rm_rf "pkg"
  rm_f "Manifest.txt"
end

desc "Build all package products"
task :build_all => [:build, :build_win]

desc "Install gem"
task :install do
  cd("pkg") do
    sh "gem install allegro4r"
  end
end

desc "Uninstall gem"
task :uninstall do
  sh "gem uninstall allegro4r"
end

task :default => :build_all