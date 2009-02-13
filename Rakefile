require "rubygems"
require "rake"

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

  file pkg_file => [pkg_dir] + s.files do
    puts "Creating Gem #{gem_file}"
    Gem::Builder.new(s).build
    mkdir_p pkg_dir
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
  s.requirements = ["allegro 4.2.2 (http://alleg.sourceforge.net/)"]

  s.extensions = ["ext/extconf.rb"]
  s.files = FileList["ext/*.{c,i,rb}", "examples/**/*", "Manifest.txt"].to_a
  s.require_paths = ["ext"]

  s.has_rdoc = true
  s.extra_rdoc_files = ["README.txt", "History.txt"]
  s.rdoc_options = ["--main", "README.txt", "--extension", "i=c"]
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
spec_win.extra_rdoc_files = ["README.txt", "History.txt"]

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
task :docs_win do
  sh "rdoc --force-update --main README.txt --extension i=c README.txt History.txt ext/*.i ext/*.c"
end

desc "Remove the documentation"
task :clean_docs do
  rm_rf "doc"
end

# General build tasks
desc "Remove all package products"
task :clean_all => [:clean, :clean_win] do
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