#!/usr/bin/ruby
# -*- coding: UTF-8 -*-

require 'ftools'
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
ERRATA_HTML           = File.expand_path('errata.html')

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
  proc {|tn| tn.sub(/\.[^.]+$/, '.ttyrec').sub(/^html\//, '') }
]) do |t|
  abs_source = File.expand_path(t.source)
  abs_name   = File.expand_path(t.name)
  File.makedirs File.dirname abs_name
  puts "parse #{abs_source}"
  sh "(cd jsttyplay; perl preprocess.pl --size 80x25 #{abs_source} #{abs_name})"
end

FileList["**/*.ttyrec"].exclude(/^html\//).each do |t|
  json = 'html/' + t.sub(/\.[^.]+$/, '.json')
  task :json => json
end

desc 'compile ttyrec files to json files'
task :json

desc 'create index.html and other html files for ttyplay.'
task :html => [:html_chunks, :html_screencast, :html_index, :html_errata]

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

def mkd2html title, subtitle, mkd_file, tmpl_file, output_file
  begin
    require 'redcarpet'
  rescue Exception
    $stderr.puts ""
    $stderr.puts "Error: redcarpet not found! Install redcarpet using:"
    $stderr.puts "    gem install redcarpet"
    $stderr.puts ""
    exit 1
  end
  compile_time = Time.now.strftime("%Y/%m/%d %H:%M:%S")
  css_files = [rel_path(output_file, ABS_CSS_COMMON_FILE)]
  markdown = Redcarpet.new(File.open(mkd_file).read).to_html
  File.open(output_file, "w") do |file|
    template = ERB.new(File.read(tmpl_file))
    file.puts template.result(binding)
  end
end

file :html_index => ['README.mkd', INDEX_TMPL] do |t|
  title = "《Git权威指南》"
  subtitle = "参考资料"
  mkd2html title, subtitle, t.prerequisites[0], t.prerequisites[1], INDEX_HTML
end

file :html_errata => ['errata.mkd', INDEX_TMPL] do |t|
  title = "《Git权威指南》"
  subtitle = "勘误"
  mkd2html title, subtitle, t.prerequisites[0], t.prerequisites[1], ERRATA_HTML
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
