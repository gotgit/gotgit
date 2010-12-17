## Set change log file for your documents
#CHANGELOG="../debian/changelog"
#
#doc_rev=`head -1 #{CHANGELOG} | sed -e "s/^\\S*\\s\\+(\\([0-9]*:\\)\\?\\(\\S\\+\\)).*/\\2/"`
#doc_datestring=`grep "^ -- .* <.*>  .\\+$" #{CHANGELOG} | head -1 | sed -e "s/^.\\+>  \\(.\\+\\)$/\\1/g"`
#doc_date=`date -d "#{doc_datestring}" +"%Y-%m-%d %H:%M:%S"`
#ENV["DOC_REV"]=ENV["DOC_REV"]? ENV["DOC_REV"] : doc_rev.strip
#ENV["DOC_DATE"]=ENV["DOC_DATE"]? ENV["DOC_DATE"] : doc_date.strip

ENV["DOC_REV"]= "0.1"


require 'docbones'
source_suffix = '.rst'
::Docbones.setup source_suffix

ENV["DOC_INDEX"]=ENV["DOC_INDEX"]? ENV["DOC_INDEX"] : "index"

PROJ.root= "."
PROJ.name = "gitbook"
PROJ.index = ENV["DOC_INDEX"]
PROJ.output = "../../output"
PROJ.images = "images"
PROJ.css_path = "common/nf.lightbox.css,common/doc.css"
PROJ.js_path = "common/jquery.js,common/nf.lightbox.js,common/load-nf.lightbox.js"
# PROJ.pdf_style = "/opt/ossxp/conf/pdf/ossxp.style"
PROJ.pdf_style = "common/pdf.style"
PROJ.default_dpi = 120

task:default do
  sh 'rake -T'
end

task:part1 do
  ENV["DOC_INDEX"] = "part1"
  sh 'rake html'
end

task:part2 do
  ENV["DOC_INDEX"] = "part2"
  sh 'rake html'
end

task:part3 do
  ENV["DOC_INDEX"] = "part3"
  sh 'rake html'
end

task:part4 do
  ENV["DOC_INDEX"] = "part4"
  sh 'rake html'
end

task:part5 do
  ENV["DOC_INDEX"] = "part5"
  sh 'rake html'
end

task:part6 do
  ENV["DOC_INDEX"] = "part6"
  sh 'rake html'
end

task:part7 do
  ENV["DOC_INDEX"] = "part7"
  sh 'rake html'
end

task:part8 do
  ENV["DOC_INDEX"] = "part8"
  sh 'rake html'
end

task:part9 do
  ENV["DOC_INDEX"] = "part9"
  sh 'rake html'
end


