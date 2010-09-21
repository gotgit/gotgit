jQuery((function(){
  $=jQuery;
  var selected = $('img').filter(function() {
    if (this.parentNode.tagName=="A") return false;
    if (this.style && this.style['width']) {
      var w = this.style['width'];
      if (w.search(/px$/i)) {
        w = parseInt(w);
        if (w>32)
          return true;
        else
          return false;
      }
      else
        return true;
    }
    else
      return false;
  });
  if (selected)
  {
    selected.lightBox();
    selected.css({'cursor':'pointer'});
  }

  /* docinfo table align center for IE */
  if ($.browser.msie)
  {
    var table = $($('table.docinfo')[0]);
    if (table)
      table.attr({align:'center'});
  }
}));
