#!/usr/bin/ruby
# -*- coding: UTF-8 -*-

require 'fileutils'
require 'erb'
require 'rubygems'

ABS_CSS_FILE          = File.expand_path('html/inc/tty.css')
ABS_JS_PROTOTYPE_FILE = File.expand_path('html/inc/prototype.js')
ABS_JS_SHOWTTY_FILE   = File.expand_path('html/inc/showtty.js')
ABS_CSS_COMMON_FILE   = File.expand_path('html/inc/common.css')
TTYPLAY_TMPL          = File.expand_path('html/templates/ttyplay.erb')
SCAST_TMPL            = File.expand_path('html/templates/scast.erb')
INDEX_TMPL            = File.expand_path('html/templates/index.erb')
SCAST_HTML            = File.expand_path('screencast.html')
INDEX_HTML            = File.expand_path('index.html')
DEMO_INDEX_HTML       = File.expand_path('demo_index.html')
ERRATA_HTML           = File.expand_path('errata.html')

class ArgsBinding
  def initialize(args)
    args.keys.each do |key|
      eval("@%s=%s" % [key, args[key].inspect])
    end
  end
  def get_binding
    return binding()
  end
end

def strip_common_dir(path1, path2)
  if path1+"\t"+path2 =~ %r{^(.*/)(.*?)\t\1(.*)$}
    path1, path2 = $2, $3
  end
  return path1, path2
end

def rel_path(path1, path2)
  path1, path2 = strip_common_dir path1, path2
  return ('../' * path1.count('/')) + path2
end

def rel_path_dir(dir1, dir2)
  dir1 += '/' if dir1[-1,1] != '/'
  dir2 += '/' if dir2[-1,1] != '/'
  return rel_path dir1, dir2
end

rule( /\.json$/ => [
  proc {|tn| tn.sub(/\.[^.]+$/, '.ttyrec').sub(/^html\//, 'ttyrec/') }
]) do |t|
  abs_source = File.expand_path(t.source)
  abs_name   = File.expand_path(t.name)
  FileUtils.makedirs File.dirname abs_name
  puts "parse #{abs_source}"
  sh "(cd jsttyplay; rm -f #{abs_name}; perl preprocess.pl --size 80x25 #{abs_source} #{abs_name})"
end

FileList["ttyrec/**/*.ttyrec"].each do |t|
  json = 'html/' + t.sub(/^ttyrec\//, '').sub(/\.[^.]+$/, '.json')
  task :json => json
end

desc 'compile ttyrec files to json files'
task :json

desc 'create index.html and other html files for ttyplay.'
task :html => [:html_chunks, :html_screencast, INDEX_HTML, ERRATA_HTML]

task :html_chunks do
  FileList["html/**/*.json"].each do |t|
    title = File.basename(t).sub(/\.[^.]+$/, '')
    output_file = File.expand_path(t.sub(/\.[^.]+$/, '.html'))
    json_file = rel_path(output_file, File.expand_path(t))
    css_files = [ rel_path(output_file, ABS_CSS_FILE),
                  rel_path(output_file, ABS_CSS_COMMON_FILE) ]
    js_files  = [ rel_path(output_file, ABS_JS_PROTOTYPE_FILE),
                  rel_path(output_file, ABS_JS_SHOWTTY_FILE) ]
    unless uptodate?(output_file, TTYPLAY_TMPL)
      File.open(output_file, "w") do |file|
        template = ERB.new(File.read(TTYPLAY_TMPL))
        file.puts template.result(binding)
      end
    end
  end
end

task :html_screencast => [:html_chunks] do
  output_file = SCAST_HTML
  ttyrec_list = {}
  css_files = [rel_path(output_file, ABS_CSS_COMMON_FILE)]
  compile_time = Time.now.strftime("%Y/%m/%d %H:%M:%S")
  version = %x[git describe --tags --always].strip.gsub(/^v/, '')
  FileList["html/**/*.json"].each do |t|
    title = File.basename(t).sub(/\.[^.]+$/, '')
    part = t.sub(/.*\/part([0-9]+)\/.*$/, '\1')
    part = 'others' unless part =~ /^[0-9]+$/
    html_file = rel_path(output_file, File.expand_path(t.sub(/\.[^.]+$/, '.html')))
    ttyrec_list[part] = [] unless ttyrec_list.member?(part)
    ttyrec_list[part].push( { 'title' => title, 'html' => html_file } )
  end
  unless uptodate?(output_file, SCAST_TMPL)
    File.open(output_file, "w") do |file|
      template = ERB.new(File.read(SCAST_TMPL))
      file.puts template.result(binding)
    end
  end
end

def mkd2html args
  begin
    require 'redcarpet'
  rescue Exception
    $stderr.puts ""
    $stderr.puts "Error: redcarpet not found! Install redcarpet using:"
    $stderr.puts "    gem install redcarpet"
    $stderr.puts ""
    exit 1
  end
  if not args.key? :source or not args.key? :template or not args.key? :output or not args.key? :title
    raise "Incomplete arguments for mkd2html"
  end
  args[:subtitle] = '' if not args.key? :subtitle
  args[:compile_time] = Time.now.strftime("%Y/%m/%d %H:%M:%S") if not args.key? :compile_time
  args[:version] = %x[git describe --tags --always].strip.gsub(/^v/, '') if not args.key? :version
  args[:css_files] = [rel_path(args[:output], ABS_CSS_COMMON_FILE)]
  args[:js_files] = []
  if args.key? :extra_css
    args[:extra_css].each do |f|
      if f =~ /http:\/\//
        args[:css_files] << f
      else
        args[:css_files] << rel_path(args[:output], File.expand_path(f))
      end
    end
  end
  if args.key? :extra_js
    args[:extra_js].each do |f|
      if f =~ /http:\/\//
        args[:js_files] << f
      else
        args[:js_files] << rel_path(args[:output], File.expand_path(f))
      end
    end
  end
  args[:markdown] = Redcarpet.new(File.open(args[:source]).read, :tables).to_html
  File.open(args[:output], "w") do |file|
    template = ERB.new(File.read(args[:template]))
    file.puts template.result(ArgsBinding.new(args).get_binding)
  end
  puts "built %s from %s" % [args[:output], args[:source]]
end


file INDEX_HTML => ['README.mkd', INDEX_TMPL] do |t|
  mkd2html :title => "《Git权威指南》", :subtitle => "参考资料",
           :source => t.prerequisites[0], :template => t.prerequisites[1], :output => INDEX_HTML,
           :extra_js => ['html/inc/jquery-1.6.2.min.js', 'html/inc/click_more.js']

  mkd2html :title => "《Git权威指南》", :subtitle => "参考资料",
           :source => t.prerequisites[0], :template => t.prerequisites[1], :output => DEMO_INDEX_HTML
end

file ERRATA_HTML => ['errata.mkd', INDEX_TMPL] do |t|
  mkd2html :title => "《Git权威指南》", :subtitle => "勘误",
           :source => t.prerequisites[0], :template => t.prerequisites[1], :output => ERRATA_HTML,
           :extra_css => ['html/inc/errata.css'],
           :extra_js => ['html/inc/jquery-1.6.2.min.js', 'html/inc/click_more.js']
end

desc 'clean *.json and *.html files'
task :clean => [:clean_json, :clean_html]

task :clean_json do
  FileList["html/**/*.json"].each do |t|
    File.unlink t
  end
end

task :clean_html do
  FileList["html/**/*.html"].each do |t|
    File.unlink t
  end
  File.unlink SCAST_HTML if File.exists?(SCAST_HTML)
  File.unlink INDEX_HTML if File.exists?(INDEX_HTML)
  File.unlink ERRATA_HTML if File.exists?(ERRATA_HTML)
end

task :default => [:json, :html]
