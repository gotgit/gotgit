/*
 * click_more.js
 * Copyright 2011, Jiang Xin
 */

$(function(){

  $('.click-more').each(function(i) {
    contentNode = this.parentNode.nextSibling;
    if (contentNode instanceof Text) {
      contentNode = contentNode.nextSibling;
    }
    contentNode.parentNode.removeChild(contentNode);
    divNode = $('<div class="click-more-contents">').hide();
    divNode.append(contentNode);
    button = $('<div class="click-more-button-closed">更多...</div>');
    button.addClass('click-more-button');
    $(this.parentNode).append(button);
    $(this.parentNode).append(divNode);
  })

  $('.click-more').parent().each(function(i) {
    $('.click-more-button', this).bind('click', function() {
      divNode = $('div.click-more-contents', this.parentNode);
      divNode.toggle();
      button = $('.click-more-button', this.parentNode)
      if (divNode.is(':visible')) {
        button.removeClass('click-more-button-closed');
        button.addClass('click-more-button-opened');
        button[0].textContent = '收起...';
      } else {
        button.removeClass('click-more-button-opened');
        button.addClass('click-more-button-closed');
        button[0].textContent = '更多...';
      }
    })
  });

})
