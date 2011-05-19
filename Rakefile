#!/usr/bin/ruby
# -*- coding: UTF-8 -*-

require 'ftools'
require 'erb'

ABS_CSS_FILE        = File.expand_path('html/inc/tty.css')
ABS_JS_FILE         = File.expand_path('html/inc/showtty.js')
ABS_CSS_COMMON_FILE = File.expand_path('html/inc/common.css')
TTYPLAY_TMPL        = File.expand_path('html/templates/ttyplay.erb')
INDEX_TMPL          = File.expand_path('html/templates/index.erb')
INDEX_FILE          = File.expand_path('screencast.html')

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

task :html_chunks do
  FileList["html/**/*.json"].each do |t|
    title = File.basename(t).sub(/\.[^.]+$/, '')
    html_file = File.expand_path(t.sub(/\.[^.]+$/, '.html'))
    json_file = rel_path(html_file, File.expand_path(t))
    css_files = [ rel_path(html_file, ABS_CSS_FILE),
                  rel_path(html_file, ABS_CSS_COMMON_FILE) ]
    js_file = rel_path(html_file, ABS_JS_FILE)
    unless uptodate?(html_file, TTYPLAY_TMPL)
      File.open(html_file, "w") do |file|
        template = ERB.new(File.read(TTYPLAY_TMPL))
        file.puts template.result(binding)
      end
    end
  end
end

desc 'create index.html and other html files for ttyplay.'
task :html => [:html_chunks] do
  index_file = INDEX_FILE
  ttyrec_list = {}
  css_files = [rel_path(index_file, ABS_CSS_COMMON_FILE)]
  FileList["html/**/*.json"].each do |t|
    title = File.basename(t).sub(/\.[^.]+$/, '')
    part = t.sub(/.*\/part([0-9]+)\/.*$/, '\1')
    part = 'others' unless part =~ /^[0-9]+$/
    html_file = rel_path(index_file, File.expand_path(t.sub(/\.[^.]+$/, '.html')))
    ttyrec_list[part] = [] unless ttyrec_list.member?(part)
    ttyrec_list[part].push( { 'title' => title, 'html' => html_file } )
  end
  unless uptodate?(index_file, INDEX_TMPL)
    File.open(index_file, "w") do |file|
      template = ERB.new(File.read(INDEX_TMPL))
      file.puts template.result(binding)
    end
  end
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
  File.unlink INDEX_FILE if File.exists?(INDEX_FILE)
end

task :default => [:json, :html]
