/*
[===========================================================================]
[   Copyright (c) 2009, Helori LAMBERTY                                     ]
[   All rights reserved.                                                    ]
[                                                                           ]
[   Redistribution and use in source and binary forms, with or without      ] 
[   modification, are permitted provided that the following conditions      ]
[   are met:                                                                ]
[                                                                           ]  
[   * Redistributions of source code must retain the above copyright        ]
[   notice, this list of conditions and the following disclaimer.           ]
[                                                                           ]
[   * Redistributions in binary form must reproduce the above copyright     ]
[   notice, this list of conditions and the following disclaimer in         ]
[   the documentation and/or other materials provided with the              ]
[   distribution.                                                           ]
[                                                                           ]
[   * Neither the name of NotesFor.net nor the names of its                 ]
[   contributors may be used to endorse or promote products derived         ]
[   from this software without specific prior written permission.           ]   
[                                                                           ]
[   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS     ]
[   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT       ]
[   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR   ]
[   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT    ]
[   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,   ]
[   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT        ]
[   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   ]
[   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY   ]
[   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT     ]
[   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE       ] 
[   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH        ] 
[   DAMAGE.                                                                 ]
[===========================================================================]
*/

(function($) {
    $.fn.lightBox = function(settings) {
        ///	<summary>
        ///		Init the JQuery ligntbox settings. 
        ///	</summary>
        ///	<param name="settings" type="Options">
        ///		1: overlayBgColor - (string) Background color to overlay; inform a hexadecimal value like: #RRGGBB. Where RR, GG, and BB are the hexadecimal values for the red, green, and blue values of the color.
        ///		2: overlayOpacity - (integer) Opacity value to overlay; inform: 0.X. Where X are number from 0 to 9.
        ///		3: fixedNavigation - (boolean) Boolean that informs if the navigation (next and prev button) will be fixed or not in the interface.
        ///		4: imageLoading - (string) Path and the name of the loading icon image
        ///		5: imageBtnPrev - (string) Path and the name of the prev button image
        ///		6: imageBtnNext - (string) Path and the name of the next button image
        ///		7: imageBtnClose - (string) Path and the name of the close button image
        ///		8: imageBlank - (string) Path and the name of a blank image (one pixel)
        ///		9: imageBtnBottomPrev - (string) Path and the name of the bottom prev button image
        ///		10: imageBtnBottomNext - (string) (string) Path and the name of the bottom next button image
        ///		11: imageBtnPlay - (string) Path and the name of the close button image
        ///		12: imageBtnStop - (string) Path and the name of the play button image
        ///		13: containerBorderSize - (integer) If you adjust the padding in the CSS for the container, #lightbox-container-image-box, you will need to update this value
        ///		14: containerResizeSpeed - (integer) Specify the resize duration of container image. These number are miliseconds. 500 is default.
        ///		15: txtImage - (string) Specify text "Image"
        ///		16: txtOf - (string) Specify text "of"
        ///		17: txtPrev - (string) Specify text "previous"
        ///		18: keyToNext - (string) Specify text "next"    
        ///		19: keyToClose - (string) (c = close) Letter to close the jQuery lightBox interface. Beyond this letter, the letter X and the SCAPE key is used to.
        ///		20: keyToPrev - (string) (p = previous) Letter to show the previous image.
        ///		21: keyToNext - (string) (n = next) Letter to show the next image.
        ///		22: slideShowTimer - (integer) number of milliseconds to change image by default 5000.
        ///	</param>
        ///	<returns type="jQuery" />
        settings = jQuery.extend({
            // Configuration related to overlay
            overlayBgColor: '#000',
            overlayOpacity: 0.8,
            // Configuration related to navigation
            fixedNavigation: false,
            // Configuration related to images
            imageLoading: '/javascript/lightbox/images/loading.gif',
            imageBtnPrev: '/javascript/lightbox/images/prev.png',
            imageBtnNext: '/javascript/lightbox/images/next.png',
            imageBtnClose: '/javascript/lightbox/images/close.png',
            imageBlank: '/javascript/lightbox/images/lightbox-blank.gif',
            imageBtnBottomPrev: '/javascript/lightbox/images/btm_prev.gif',
            imageBtnBottomNext: '/javascript/lightbox/images/btm_next.gif',
            imageBtnPlay: '/javascript/lightbox/images/start.png',
            imageBtnStop: '/javascript/lightbox/images/pause.png',
            // Configuration related to container image box
            containerBorderSize: 10,
            containerResizeSpeed: 500,
            // Configuration related to texts in caption. For example: Image 2 of 8. You can alter either "Image" and "of" texts.
            txtImage: 'Image',
            txtOf: 'of',
            txtPrev: '&nbsp;Previous',
            txtNext: '&nbsp;Next',
            // Configuration related to keyboard navigation
            keyToClose: 'c',
            keyToPrev: 'p',
            keyToNext: 'n',
            //Configuration related to slide show
            slideShowTimer: 5000,
            // Don´t alter these variables in any way
            step: 0,
            imageArray: [],
            slideShow: 'start',
            activeImage: 0
        }, settings);

        // Caching the jQuery object with all elements matched
        var jQueryMatchedObj = this; // This, in this context, refer to jQuery object

        function _initialize() {
            _start(this, jQueryMatchedObj); // This, in this context, refer to object (link) which the user have clicked
            return false; // Avoid the browser following the link
        }

        function _start(objClicked, jQueryMatchedObj) {
            ///	<summary>
            ///		Start the jQuery lightBox plugin.  
            ///	</summary>
            ///	<param name="objClicked" type="object">objClicked The object (link) whick the user have clicked</param>
            ///	<param name="jQueryMatchedObj" type="object">jQueryMatchedObj The jQuery object with all elements matched</param>

            // Hime some elements to avoid conflict with overlay in IE. These elements appear above the overlay.
            $('embed, object, select').css({ 'visibility': 'hidden' });
            // Call the function to create the markup structure; style some elements; assign events in some elements.
            _set_interface();
            // Unset total images in imageArray
            settings.imageArray.length = 0;
            // Unset image active information
            settings.activeImage = 0;
            // We have an image set? Or just an image? Let´s see it.
            if (jQueryMatchedObj.length == 1) {
                settings.imageArray.push(new Array(objClicked.getAttribute('href') ? objClicked.getAttribute('href') : objClicked.getAttribute('src'), objClicked.getAttribute('title')));
            } else {
                // Add an Array (as many as we have), with href and title atributes, inside the Array that storage the images references		
                for (var i = 0; i < jQueryMatchedObj.length; i++) {
                    settings.imageArray.push(new Array(jQueryMatchedObj[i].getAttribute('href') ? jQueryMatchedObj[i].getAttribute('href'): jQueryMatchedObj[i].getAttribute('src'), jQueryMatchedObj[i].getAttribute('title')));
                }
            }
            while (settings.imageArray[settings.activeImage][0] != ( objClicked.getAttribute('href') ? objClicked.getAttribute('href') : objClicked.getAttribute('src'))) {
                settings.activeImage++;
            }
            // Call the function that prepares image exibition
            _set_image_to_view();
        }

        function _set_interface() {
            // Apply the HTML markup into body tag
            //$('body').append('<div id="jquery-overlay" /><div id="jquery-box"><div id="jquery-lightbox"><div id="lightbox-container-image-box"><div id="lightbox-container-image-box-top"><div id="lightbox-container-image-box-top-left"><img src="' + settings.imageBtnPlay + '"></div><div id="lightbox-container-image-box-top-middle"></div><div id="lightbox-container-image-box-top-right"><img src="' + settings.imageBtnClose + '"></div></div><div id="lightbox-container-image"><img id="lightbox-image"/></div><div id="lightbox-nav" style="display: block;"><a id="lightbox-nav-btnPrev" href="#" /><a id="lightbox-nav-btnNext" href="#" /></div><div id="lightbox-loading" style="display: none;"><a id="lightbox-loading-link" href="#"><img src="' + settings.imageLoading + '"></a></div></div><div id="lightbox-container-image-data-box"><div id="lightbox-container-image-data"><span id="lightbox-image-details-caption">Image name</span> <span id="lightbox-image-details-currentNumber"></span>&nbsp;|&nbsp;<div id="lightbox-image-details-previous-image"><img src="' + settings.imageBtnBottomPrev + '"><span id="lightbox-image-details-previous-text">' + settings.txtPrev + '</span>&nbsp;</div><div id="lightbox-image-details-next-image"><img src="' + settings.imageBtnBottomNext + '"><span id="lightbox-image-details-next-text">' + settings.txtNext + '</span></div></div></div></div>');
            $('body').append('<div id="jquery-overlay" /><div id="jquery-box"><div id="jquery-lightbox"><div id="lightbox-container-image-box"><div id="lightbox-container-image-box-top"><div id="lightbox-container-image-box-top-left"><img src="' + settings.imageBtnPlay + '"></div><div id="lightbox-container-image-box-top-middle"></div><div id="lightbox-container-image-box-top-right"><img src="' + settings.imageBtnClose + '"></div></div><div id="lightbox-container-image"><img id="lightbox-image"/></div><div id="lightbox-nav" style="display: block;"><a id="lightbox-nav-btnPrev" href="#" title="' + settings.txtPrev + '" /><a id="lightbox-nav-btnNext" href="#" title="' + settings.txtNext + '" /></div><div id="lightbox-loading" style="display: none;"><a id="lightbox-loading-link" href="#"><img src="' + settings.imageLoading + '"></a></div></div><div id="lightbox-container-image-data-box"><div id="lightbox-container-image-data"><span id="lightbox-image-details-caption">Image name</span> <span id="lightbox-image-details-currentNumber"></span>&nbsp;|&nbsp;<div id="lightbox-image-details-previous-image"><img src="' + settings.imageBtnBottomPrev + '" alt="' + settings.txtPrev + '">&nbsp;</div><div id="lightbox-image-details-next-image"><img src="' + settings.imageBtnBottomNext + '" alt="' + settings.txtNext + '"></div></div></div></div>');

            $('#lightbox-container-image-box').corner();
            $('#lightbox-container-image-data-box').corner();

            // Get page sizes
            var arrPageSizes = ___getPageSize();
            // Style overlay and show it
            $('#jquery-overlay').css({
                backgroundColor: settings.overlayBgColor,
                opacity: settings.overlayOpacity,
                width: arrPageSizes[0],
                height: arrPageSizes[1]
            }).fadeIn();
            // Get page scroll
            var arrPageScroll = ___getPageScroll();
            // Calculate top and left offset for the jquery-lightbox div object and show it
            $('#jquery-lightbox').css({
                top: arrPageScroll[1] + (arrPageSizes[3] / 10),
                left: arrPageScroll[0]
            }).show();

            // Assigning click events in elements to close overlay
            //            $('#jquery-overlay,#jquery-lightbox').click(function() {
            //                _finish();
            //            });
            // Assign the _finish function to lightbox-loading-link and lightbox-secNav-btnClose objects
            $('#lightbox-container-image-box-top-right img').click(function() {
                _finish();
                return false;
            });

            // Assigning click events to background box to close lightbox
            $('#jquery-box,#jquery-overlay,#lightbox-container-image-box').click(function() {
                _finish();
                return false;
            });

            //Start/Stop the slide show
            $('#lightbox-container-image-box-top-left img').click(function() {
                if (settings.slideShow == 'start') {
                    $('#lightbox-container-image-box-top-left img')[0].src = settings.imageBtnStop;
                    settings.step = 0;
                    $('#lightbox-container-image-box-top-left img').everyTime(settings.slideShowTimer / Math.round(settings.slideShowTimer / 125), "timer", function(i) {
                        _set_timer();
                    }, Math.round(settings.slideShowTimer / 125));
                    settings.slideShow = 'stop';
                }
                else {
                    $('#lightbox-container-image-box-top-left img')[0].src = settings.imageBtnPlay;
                    $('#lightbox-container-image-box-top-left img').stopTime("timer");
                    settings.step = 0;
                    $("#lightbox-container-image-box-top-middle").reportprogress(settings.step, Math.round(settings.slideShowTimer / 125));
                    settings.slideShow = 'start';
                }
                return false;
            });

            // If window was resized, calculate the new overlay dimensions
            $(window).resize(function() {
                // Get page sizes
                var arrPageSizes = ___getPageSize();
                // Style overlay and show it
                $('#jquery-overlay').css({
                    width: arrPageSizes[0],
                    height: arrPageSizes[1]
                });
                // Get page scroll
                var arrPageScroll = ___getPageScroll();
                // Calculate top and left offset for the jquery-lightbox div object and show it
                $('#jquery-lightbox').css({
                    top: arrPageScroll[1] + (arrPageSizes[3] / 10),
                    left: arrPageScroll[0]
                });
            });
        }

        function _set_timer() {
            settings.step = settings.step + 1
            $("#lightbox-container-image-box-top-middle").reportprogress(settings.step, Math.round(settings.slideShowTimer / 125)); if (settings.step == Math.round(settings.slideShowTimer / 125)) {
                settings.step = 0;
                settings.activeImage = settings.activeImage + 1;
                if (settings.imageArray.length <= settings.activeImage) {
                    settings.activeImage = 0;
                }
                $('#lightbox-container-image-box-top-left img').stopTime("timer");
                _set_image_to_view(true);
            }
        }
        /**
        * Prepares image exibition; doing a image´s preloader to calculate it´s size
        *
        */
        function _set_image_to_view(timer) {
            // Show the loading
            $('#lightbox-loading').show();
            if (settings.fixedNavigation) {
                $('#lightbox-image,#lightbox-container-image-data-box,#lightbox-image-details-currentNumber').hide();
            } else {
                // Hide some elements
                $('#lightbox-image,#lightbox-nav,#lightbox-nav-btnPrev,#lightbox-nav-btnNext,#lightbox-container-image-data-box,#lightbox-image-details-currentNumber,#lightbox-container-image-box-top').hide();
            }
            // Image preload process
            var objImagePreloader = new Image();
            objImagePreloader.onload = function() {
                $('#lightbox-image').attr('src', settings.imageArray[settings.activeImage][0]);
                // Perfomance an effect in the image container resizing it
                _resize_container_image_box(objImagePreloader.width, objImagePreloader.height);
                //	clear onLoad, IE behaves irratically with animated gifs otherwise
                objImagePreloader.onload = function() { };
            };
            objImagePreloader.src = settings.imageArray[settings.activeImage][0];
            if (timer) {
                $('#lightbox-container-image-box-top-left img').everyTime(settings.slideShowTimer / Math.round(settings.slideShowTimer / 125), "timer", function(i) {
                    _set_timer();
                }, Math.round(settings.slideShowTimer / 125));
            }
        };
        /**
        * Perfomance an effect in the image container resizing it
        *
        * @param integer intImageWidth The image´s width that will be showed
        * @param integer intImageHeight The image´s height that will be showed
        */
        function _resize_container_image_box(intImageWidth, intImageHeight) {
            // Get current width and height
            var intCurrentWidth = $('#lightbox-container-image-box').width();
            var intCurrentHeight = $('#lightbox-container-image-box').height();
            // Get the width and height of the selected image plus the padding
            var intWidth = (intImageWidth + (settings.containerBorderSize * 2)); // Plus the image´s width and the left and right padding value
            var intHeight = (intImageHeight + (settings.containerBorderSize * 2)); // Plus the image´s height and the left and right padding value
            // Diferences
            var intDiffW = intCurrentWidth - intWidth;
            var intDiffH = intCurrentHeight - intHeight;
            // Perfomance the effect
            $('#lightbox-container-image-box').animate({ width: intWidth, height: intHeight }, settings.containerResizeSpeed, function() { _show_image(); });
            if ((intDiffW == 0) && (intDiffH == 0)) {
                if ($.browser.msie) {
                    ___pause(250);
                } else {
                    ___pause(100);
                }
            }
            $('#lightbox-container-image-data-box').css({ width: intWidth });
            $('#lightbox-nav-btnPrev,#lightbox-nav-btnNext').css({ height: intImageHeight + (settings.containerBorderSize * 2) - 32 });
        };
        /**
        * Show the prepared image
        *
        */
        function _show_image() {
            $('#lightbox-loading').hide();
            $('#lightbox-image').fadeIn(function() {
                _show_image_data();
                _set_navigation();
            });
            _preload_neighbor_images();
        };
        /**
        * Show the image information
        *
        */
        function _show_image_data() {
            $('#lightbox-container-image-data-box').slideDown('fast');
            $('#lightbox-image-details-caption').hide();
            if (settings.imageArray[settings.activeImage][1]) {
                $('#lightbox-image-details-caption').html(settings.imageArray[settings.activeImage][1]).show();
            }
            // If we have a image set, display 'Image X of X'
            if (settings.imageArray.length > 1) {
                $('#lightbox-image-details-currentNumber').html(settings.txtImage + ' ' + (settings.activeImage + 1) + ' ' + settings.txtOf + ' ' + settings.imageArray.length).show();
            }
            $('#lightbox-container-image-box-top').show();
        }
        /**
        * Display the button navigations
        *
        */
        function _set_navigation() {
            $('#lightbox-nav').show();

            // Instead to define this configuration in CSS file, we define here. And it´s need to IE. Just.
            $('#lightbox-nav-btnPrev,#lightbox-nav-btnNext').css({ 'background': 'transparent url(' + settings.imageBlank + ') no-repeat' });

            // Show the prev button, if not the first image in set
            if (settings.activeImage != 0) {
                if (settings.fixedNavigation) {
                    $('#lightbox-image-details-previous-image, #lightbox-image-details-previous-text').unbind()
						.bind('click', function() {
						    settings.activeImage = settings.activeImage - 1;
						    _set_image_to_view();
						    return false;
						});
                } else {
                    // Show the images button for Next buttons
                    $('#lightbox-image-details-previous-image, #lightbox-image-details-previous-text').unbind().show().bind('click', function() {
                        settings.activeImage = settings.activeImage - 1;
                        _set_image_to_view();
                        return false;
                    });
                }
            }
            else
                $('#lightbox-image-details-previous-image, #lightbox-image-details-previous-text').hide();

            // Show the prev button, if not the first image in set
            if (settings.activeImage != 0) {
                if (settings.fixedNavigation) {
                    $('#lightbox-nav-btnPrev').css({ 'background': 'url(' + settings.imageBtnPrev + ') left 50% no-repeat' })
						.unbind()
						.bind('click', function() {
						    settings.activeImage = settings.activeImage - 1;
						    _set_image_to_view();
						    return false;
						});
                } else {
                    // Show the images button for Next buttons
                    $('#lightbox-nav-btnPrev').unbind().hover(function() {
                        $(this).css({ 'background': 'url(' + settings.imageBtnPrev + ') left 50% no-repeat' });
                    }, function() {
                        $(this).css({ 'background': 'transparent url(' + settings.imageBlank + ') no-repeat' });
                    }).show().bind('click', function() {
                        settings.activeImage = settings.activeImage - 1;
                        _set_image_to_view();
                        return false;
                    });
                }
            }

            // Show the next button, if not the last image in set
            if (settings.activeImage != (settings.imageArray.length - 1)) {
                if (settings.fixedNavigation) {
                    $('#lightbox-image-details-next-image, #lightbox-image-details-next-text').unbind()
						.bind('click', function() {
						    settings.activeImage = settings.activeImage + 1;
						    _set_image_to_view();
						    return false;
						});
                } else {
                    // Show the images button for Next buttons
                    $('#lightbox-image-details-next-image, #lightbox-image-details-next-text').unbind().show().bind('click', function() {
                        settings.activeImage = settings.activeImage + 1;
                        _set_image_to_view();
                        return false;
                    });
                }
            }
            else
                $('#lightbox-image-details-next-image, #lightbox-image-details-next-text').hide();

            if (settings.activeImage != (settings.imageArray.length - 1)) {
                if (settings.fixedNavigation) {
                    $('#lightbox-nav-btnNext').css({ 'background': 'url(' + settings.imageBtnNext + ') right 50% no-repeat' })
						.unbind()
						.bind('click', function() {
						    settings.activeImage = settings.activeImage + 1;
						    _set_image_to_view();
						    return false;
						});
                } else {
                    // Show the images button for Next buttons
                    $('#lightbox-nav-btnNext').unbind().hover(function() {
                        $(this).css({ 'background': 'url(' + settings.imageBtnNext + ') right 50% no-repeat' });
                    }, function() {
                        $(this).css({ 'background': 'transparent url(' + settings.imageBlank + ') no-repeat' });
                    }).show().bind('click', function() {
                        settings.activeImage = settings.activeImage + 1;
                        _set_image_to_view();
                        return false;
                    });
                }
            }
            // Enable keyboard navigation
            _enable_keyboard_navigation();
        }

        /**
        * Enable a support to keyboard navigation
        *
        */
        function _enable_keyboard_navigation() {
            $(document).keydown(function(objEvent) {
                _keyboard_action(objEvent);
            });
        }
        /**
        * Disable the support to keyboard navigation
        *
        */
        function _disable_keyboard_navigation() {
            $(document).unbind();
        }
        /**
        * Perform the keyboard actions
        *
        */
        function _keyboard_action(objEvent) {
            // To ie
            if (objEvent == null) {
                keycode = event.keyCode;
                escapeKey = 27;
                // To Mozilla
            } else {
                keycode = objEvent.keyCode;
                escapeKey = objEvent.DOM_VK_ESCAPE ? objEvent.DOM_VK_ESCAPE : 27;
            }
            // Get the key in lower case form
            key = String.fromCharCode(keycode).toLowerCase();
            // Verify the keys to close the ligthBox
            if ((key == settings.keyToClose) || (key == 'x') || (keycode == escapeKey)) {
                _finish();
            }
            // Verify the key to show the previous image
            if ((key == settings.keyToPrev) || (keycode == 37)) {
                // If we´re not showing the first image, call the previous
                if (settings.activeImage != 0) {
                    settings.activeImage = settings.activeImage - 1;
                    _set_image_to_view();
                    _disable_keyboard_navigation();
                }
            }
            // Verify the key to show the next image
            if ((key == settings.keyToNext) || (keycode == 39)) {
                // If we´re not showing the last image, call the next
                if (settings.activeImage != (settings.imageArray.length - 1)) {
                    settings.activeImage = settings.activeImage + 1;
                    _set_image_to_view();
                    _disable_keyboard_navigation();
                }
            }
        }
        /**
        * Preload prev and next images being showed
        *
        */
        function _preload_neighbor_images() {
            if ((settings.imageArray.length - 1) > settings.activeImage) {
                objNext = new Image();
                objNext.src = settings.imageArray[settings.activeImage + 1][0];
            }
            if (settings.activeImage > 0) {
                objPrev = new Image();
                objPrev.src = settings.imageArray[settings.activeImage - 1][0];
            }
        }
        /**
        * Remove jQuery lightBox plugin HTML markup
        *
        */
        function _finish() {
            $('#jquery-lightbox').remove();
            $('#jquery-overlay').fadeOut(function() { $('#jquery-overlay').remove(); });
            // Show some elements to avoid conflict with overlay in IE. These elements appear above the overlay.
            $('embed, object, select').css({ 'visibility': 'visible' });
        }
        /**
        / THIRD FUNCTION
        * getPageSize() by quirksmode.com
        *
        * @return Array Return an array with page width, height and window width, height
        */
        function ___getPageSize() {
            var xScroll, yScroll;
            if (window.innerHeight && window.scrollMaxY) {
                xScroll = window.innerWidth + window.scrollMaxX;
                yScroll = window.innerHeight + window.scrollMaxY;
            } else if (document.body.scrollHeight > document.body.offsetHeight) { // all but Explorer Mac
                xScroll = document.body.scrollWidth;
                yScroll = document.body.scrollHeight;
            } else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
                xScroll = document.body.offsetWidth;
                yScroll = document.body.offsetHeight;
            }
            var windowWidth, windowHeight;
            if (self.innerHeight) {	// all except Explorer
                if (document.documentElement.clientWidth) {
                    windowWidth = document.documentElement.clientWidth;
                } else {
                    windowWidth = self.innerWidth;
                }
                windowHeight = self.innerHeight;
            } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
                windowWidth = document.documentElement.clientWidth;
                windowHeight = document.documentElement.clientHeight;
            } else if (document.body) { // other Explorers
                windowWidth = document.body.clientWidth;
                windowHeight = document.body.clientHeight;
            }
            // for small pages with total height less then height of the viewport
            if (yScroll < windowHeight) {
                pageHeight = windowHeight;
            } else {
                pageHeight = yScroll;
            }
            // for small pages with total width less then width of the viewport
            if (xScroll < windowWidth) {
                pageWidth = xScroll;
            } else {
                pageWidth = windowWidth;
            }
            arrayPageSize = new Array(pageWidth, pageHeight, windowWidth, windowHeight);
            return arrayPageSize;
        };
        /**
        / THIRD FUNCTION
        * getPageScroll() by quirksmode.com
        *
        * @return Array Return an array with x,y page scroll values.
        */
        function ___getPageScroll() {
            var xScroll, yScroll;
            if (self.pageYOffset) {
                yScroll = self.pageYOffset;
                xScroll = self.pageXOffset;
            } else if (document.documentElement && document.documentElement.scrollTop) {	 // Explorer 6 Strict
                yScroll = document.documentElement.scrollTop;
                xScroll = document.documentElement.scrollLeft;
            } else if (document.body) {// all other Explorers
                yScroll = document.body.scrollTop;
                xScroll = document.body.scrollLeft;
            }
            arrayPageScroll = new Array(xScroll, yScroll);
            return arrayPageScroll;
        };
        /**
        * Stop the code execution from a escified time in milisecond
        *
        */
        function ___pause(ms) {
            var date = new Date();
            curDate = null;
            do { var curDate = new Date(); }
            while (curDate - date < ms);
        };
        // Return the jQuery object for chaining. The unbind method is used to avoid click conflict when the plugin is called more than once
        return this.unbind('click').click(_initialize);
    };
})(jQuery);                        // Call and execute the function immediately passing the jQuery object


/*
[===========================================================================]
[   JQUERY PROGRESS BAR                                                     ]
[===========================================================================]
*/
(function($) {
    //Main Method
    $.fn.reportprogress = function(val, maxVal) {
        var max = 100;
        if (maxVal)
            max = maxVal;
        return this.each(
			function() {
			    var div = $(this);
			    var innerdiv = div.find(".progress");

			    if (innerdiv.length != 1) {
			        innerdiv = $("<div class='progress'></div>");
			        //			        div.append("<div class='text'>&nbsp;</div>");
			        //			        $("<span class='text'>&nbsp;</span>").css("width", div.width()).appendTo(innerdiv);
			        div.append(innerdiv);
			    }
			    var width = Math.round(val / max * 100);
			    innerdiv.css("width", width + "%");
			    //			    div.find(".text").html(width + " %");
			}
		);
    };
})(jQuery);

/*
[===========================================================================]
[   JQUERY CURVY CORNERS                                                    ]
[===========================================================================]
*/

(function($) {
    $.fn.corner = function(options) {

        function BlendColour(Col1, Col2, Col1Fraction) {
            var red1 = parseInt(Col1.substr(1, 2), 16);
            var green1 = parseInt(Col1.substr(3, 2), 16);
            var blue1 = parseInt(Col1.substr(5, 2), 16);
            var red2 = parseInt(Col2.substr(1, 2), 16);
            var green2 = parseInt(Col2.substr(3, 2), 16);
            var blue2 = parseInt(Col2.substr(5, 2), 16);
            if (Col1Fraction > 1 || Col1Fraction < 0) Col1Fraction = 1;
            var endRed = Math.round((red1 * Col1Fraction) + (red2 * (1 - Col1Fraction)));
            if (endRed > 255) endRed = 255;
            if (endRed < 0) endRed = 0;
            var endGreen = Math.round((green1 * Col1Fraction) + (green2 * (1 - Col1Fraction)));
            if (endGreen > 255) endGreen = 255;
            if (endGreen < 0) endGreen = 0;
            var endBlue = Math.round((blue1 * Col1Fraction) + (blue2 * (1 - Col1Fraction)));
            if (endBlue > 255) endBlue = 255;
            if (endBlue < 0) endBlue = 0;
            return "#" + IntToHex(endRed) + IntToHex(endGreen) + IntToHex(endBlue);
        }

        function IntToHex(strNum) {
            base = strNum / 16;
            rem = strNum % 16;
            base = base - (rem / 16);
            baseS = MakeHex(base);
            remS = MakeHex(rem);
            return baseS + '' + remS;
        }

        function MakeHex(x) {
            if ((x >= 0) && (x <= 9)) {
                return x;
            } else {
                switch (x) {
                    case 10: return "A";
                    case 11: return "B";
                    case 12: return "C";
                    case 13: return "D";
                    case 14: return "E";
                    case 15: return "F";
                };
                return "F";
            };
        }

        function pixelFraction(x, y, r) {
            var pixelfraction = 0;
            var xvalues = new Array(1);
            var yvalues = new Array(1);
            var point = 0;
            var whatsides = "";
            var intersect = Math.sqrt((Math.pow(r, 2) - Math.pow(x, 2)));
            if ((intersect >= y) && (intersect < (y + 1))) {
                whatsides = "Left";
                xvalues[point] = 0;
                yvalues[point] = intersect - y;
                point = point + 1;
            };
            var intersect = Math.sqrt((Math.pow(r, 2) - Math.pow(y + 1, 2)));
            if ((intersect >= x) && (intersect < (x + 1))) {
                whatsides = whatsides + "Top";
                xvalues[point] = intersect - x;
                yvalues[point] = 1;
                point = point + 1;
            };
            var intersect = Math.sqrt((Math.pow(r, 2) - Math.pow(x + 1, 2)));
            if ((intersect >= y) && (intersect < (y + 1))) {
                whatsides = whatsides + "Right";
                xvalues[point] = 1;
                yvalues[point] = intersect - y;
                point = point + 1;
            };
            var intersect = Math.sqrt((Math.pow(r, 2) - Math.pow(y, 2)));
            if ((intersect >= x) && (intersect < (x + 1))) {
                whatsides = whatsides + "Bottom";
                xvalues[point] = intersect - x;
                yvalues[point] = 0;
            };
            switch (whatsides) {
                case "LeftRight":
                    pixelfraction = Math.min(yvalues[0], yvalues[1]) + ((Math.max(yvalues[0], yvalues[1]) - Math.min(yvalues[0], yvalues[1])) / 2);
                    break;
                case "TopRight":
                    pixelfraction = 1 - (((1 - xvalues[0]) * (1 - yvalues[1])) / 2);
                    break;
                case "TopBottom":
                    pixelfraction = Math.min(xvalues[0], xvalues[1]) + ((Math.max(xvalues[0], xvalues[1]) - Math.min(xvalues[0], xvalues[1])) / 2);
                    break;
                case "LeftBottom":
                    pixelfraction = (yvalues[0] * xvalues[1]) / 2;
                    break;
                default:
                    pixelfraction = 1;
            };
            return pixelfraction;
        }

        function rgb2Hex(rgbColour) {
            try {
                var rgbArray = rgb2Array(rgbColour);
                var red = parseInt(rgbArray[0]);
                var green = parseInt(rgbArray[1]);
                var blue = parseInt(rgbArray[2]);
                var hexColour = "#" + IntToHex(red) + IntToHex(green) + IntToHex(blue);
            } catch (e) {
                alert("There was an error converting the RGB value to Hexadecimal in function rgb2Hex");
            };
            return hexColour;
        }

        function rgb2Array(rgbColour) {
            var rgbValues = rgbColour.substring(4, rgbColour.indexOf(")"));
            var rgbArray = rgbValues.split(", ");
            return rgbArray;
        }

        function format_colour(colour) {
            var returnColour = "transparent";
            if (colour != "" && colour != "transparent") {
                if (colour.substr(0, 3) == "rgb" && colour.substr(0, 4) != "rgba") {
                    returnColour = rgb2Hex(colour);
                }
                else if (colour.length == 4) {
                    returnColour = "#" + colour.substring(1, 2) + colour.substring(1, 2) + colour.substring(2, 3) + colour.substring(2, 3) + colour.substring(3, 4) + colour.substring(3, 4);
                }
                else {
                    returnColour = colour;
                };
            };
            return returnColour;
        };
        function strip_px(value) {
            return parseInt(((value != "auto" && value.indexOf("%") == -1 && value != "" && value.indexOf("px") !== -1) ? value.slice(0, value.indexOf("px")) : 0))
        }

        function drawPixel(box, intx, inty, colour, transAmount, height, newCorner, image, bgImage, cornerRadius, isBorder, borderWidth, boxWidth, settings) {
            var $$ = $(box);
            var pixel = document.createElement("div");
            $(pixel).css({ height: height, width: "1px", position: "absolute", "font-size": "1px", overflow: "hidden" });
            //var topMaxRadius = Math.max(settings["tr"].radius, settings["tl"].radius);
            var topMaxRadius = Math.max(settings.tl ? settings.tl.radius : 0, settings.tr ? settings.tr.radius : 0);
            // Dont apply background image to border pixels
            if (image == -1 && bgImage != "") {
                if (topMaxRadius > 0)
                    $(pixel).css("background-position", "-" + ((boxWidth - cornerRadius - borderWidth) + intx) + "px -" + (($$.height() + topMaxRadius - borderWidth) - inty) + "px");
                else
                    $(pixel).css("background-position", "-" + ((boxWidth - cornerRadius - borderWidth) + intx) + "px -" + (($$.height()) - inty) + "px");
                $(pixel).css({
                    "background-image": bgImage,
                    "background-repeat": $$.css("background-repeat"),
                    "background-color": colour
                });
            }
            else {
                if (!isBorder) $(pixel).css("background-color", colour).addClass('hasBackgroundColor');
                else $(pixel).css("background-color", colour);
            };

            if (transAmount != 100)
                setOpacity(pixel, transAmount);
            //$(pixel).css('opacity',transAmount/100);
            $(pixel).css({ top: inty + "px", left: intx + "px" });
            return pixel;
        };

        function setOpacity(obj, opacity) {
            opacity = (opacity == 100) ? 99.999 : opacity;

            if ($.browser.safari && obj.tagName != "IFRAME") {
                // Get array of RGB values
                var rgbArray = rgb2Array(obj.style.backgroundColor);

                // Get RGB values
                var red = parseInt(rgbArray[0]);
                var green = parseInt(rgbArray[1]);
                var blue = parseInt(rgbArray[2]);

                // Safari using RGBA support
                obj.style.backgroundColor = "rgba(" + red + ", " + green + ", " + blue + ", " + opacity / 100 + ")";
            }
            else if (typeof (obj.style.opacity) != "undefined") {
                // W3C
                obj.style.opacity = opacity / 100;
            }
            else if (typeof (obj.style.MozOpacity) != "undefined") {
                // Older Mozilla
                obj.style.MozOpacity = opacity / 100;
            }
            else if (typeof (obj.style.filter) != "undefined") {
                // IE
                obj.style.filter = "alpha(opacity:" + opacity + ")";
            }
            else if (typeof (obj.style.KHTMLOpacity) != "undefined") {
                // Older KHTML Based Browsers
                obj.style.KHTMLOpacity = opacity / 100;
            }
        }

        // Apply the corners
        function applyCorners(box, settings) {

            var $$ = $(box);

            // Get CSS of box and define vars
            var thebgImage = $$.css("backgroundImage");
            var topContainer = null;
            var bottomContainer = null;
            var masterCorners = new Array();
            var contentDIV = null;
            var boxHeight = strip_px($$.css("height")) ? strip_px($$.css("height")) : box.scrollHeight;
            var boxWidth = strip_px($$.css("width")) ? strip_px($$.css("width")) : box.scrollWidth;
            var borderWidth = strip_px($$.css("borderTopWidth")) ? strip_px($$.css("borderTopWidth")) : 0;
            var boxPaddingTop = strip_px($$.css("paddingTop"));
            var boxPaddingBottom = strip_px($$.css("paddingBottom"));
            var boxPaddingLeft = strip_px($$.css("paddingLeft"));

            var boxPaddingRight = strip_px($$.css("paddingRight"));
            var boxColour = format_colour($$.css("backgroundColor"));
            var bgImage = (thebgImage != "none" && thebgImage != "initial") ? thebgImage : "";
            //var boxContent 		= $$.html();
            var borderColour = format_colour($$.css("borderTopColor"));
            var borderString = borderWidth + "px" + " solid " + borderColour;

            var topMaxRadius = Math.max(settings.tl ? settings.tl.radius : 0, settings.tr ? settings.tr.radius : 0);
            var botMaxRadius = Math.max(settings.bl ? settings.bl.radius : 0, settings.br ? settings.br.radius : 0);

            $$.addClass('hasCorners').css({ "padding": "0", "borderColor": box.style.borderColour, 'overflow': 'visible' });
            if (box.style.position != "absolute") $$.css("position", "relative");
            if (($.browser.msie)) {
                if ($.browser.version == 6 && box.style.width == "auto" && box.style.height == "auto") $$.css("width", "100%");
                $$.css("zoom", "1");
                $("*", $$).css("zoom", "normal");
            }

            for (var t = 0; t < 2; t++) {
                switch (t) {
                    case 0:
                        if (settings.tl || settings.tr) {
                            var newMainContainer = document.createElement("div");
                            topContainer = box.appendChild(newMainContainer);
                            $(topContainer).css({ width: "100%", "font-size": "1px", overflow: "hidden", position: "absolute", "padding-left": borderWidth, "padding-right": borderWidth, height: topMaxRadius + "px", top: 0 - topMaxRadius + "px", left: 0 - borderWidth + "px" }).addClass('topContainer');
                        };
                        break;
                    case 1:
                        if (settings.bl || settings.br) {
                            var newMainContainer = document.createElement("div");
                            bottomContainer = box.appendChild(newMainContainer);
                            $(bottomContainer).css({ width: "100%", "font-size": "1px", overflow: "hidden", position: "absolute", "padding-left": borderWidth, "padding-right": borderWidth, height: botMaxRadius, bottom: 0 - botMaxRadius + "px", left: 0 - borderWidth + "px" }).addClass('bottomContainer');
                        };
                        break;
                };
            };

            if (settings.autoPad == true) {
                //$$.html("");
                var contentContainer = document.createElement("div");
                var contentContainer2 = document.createElement("div");
                var clearDiv = document.createElement("div");

                $(contentContainer2).css({ margin: "0", "padding-bottom": boxPaddingBottom, "padding-top": boxPaddingTop, "padding-left": boxPaddingLeft, "padding-right": boxPaddingRight, 'overflow': 'visible', height: "100%" }).addClass('hasBackgroundColor content_container');

                $(contentContainer).css({ position: "relative", 'float': "left", width: "100%", "margin-top": "-" + Math.abs(topMaxRadius - borderWidth) + "px", "margin-bottom": "-" + Math.abs(botMaxRadius - borderWidth) + "px", height: "100%" }).addClass = "autoPadDiv";

                $(clearDiv).css("clear", "both");

                contentContainer2.appendChild(contentContainer);
                contentContainer2.appendChild(clearDiv);
                $$.wrapInner(contentContainer2);
            };

            if (topContainer) $$.css("border-top", 0);
            if (bottomContainer) $$.css("border-bottom", 0);
            var corners = ["tr", "tl", "br", "bl"];
            for (var i in corners) {
                if (i > -1 < 4) {
                    var cc = corners[i];
                    if (!settings[cc]) {

                        if (((cc == "tr" || cc == "tl") && topContainer != null) || ((cc == "br" || cc == "bl") && bottomContainer != null)) {
                            var newCorner = document.createElement("div");
                            $(newCorner).css({ position: "relative", "font-size": "1px", overflow: "hidden" });

                            if (bgImage == "")
                                $(newCorner).css("background-color", boxColour);
                            else
                                $(newCorner).css("background-image", bgImage).css("background-color", boxColour); ;

                            switch (cc) {
                                case "tl":
                                    $(newCorner).css({ height: topMaxRadius - borderWidth, "margin-right": settings.tr.radius - (borderWidth * 2), "border-left": borderString, "border-top": borderString, left: -borderWidth + "px", "background-repeat": $$.css("background-repeat"), "background-position": borderWidth + "px 0px" });
                                    break;
                                case "tr":
                                    $(newCorner).css({ height: topMaxRadius - borderWidth, "margin-left": settings.tl.radius - (borderWidth * 2), "border-right": borderString, "border-top": borderString, left: borderWidth + "px", "background-repeat": $$.css("background-repeat"), "background-position": "-" + (topMaxRadius + borderWidth) + "px 0px" });
                                    break;
                                case "bl":
                                    if (topMaxRadius > 0)
                                        $(newCorner).css({ height: botMaxRadius - borderWidth, "margin-right": settings.br.radius - (borderWidth * 2), "border-left": borderString, "border-bottom": borderString, left: -borderWidth + "px", "background-repeat": $$.css("background-repeat"), "background-position": "0px -" + ($$.height() + topMaxRadius - borderWidth + 1) + "px" });
                                    else
                                        $(newCorner).css({ height: botMaxRadius - borderWidth, "margin-right": settings.br.radius - (borderWidth * 2), "border-left": borderString, "border-bottom": borderString, left: -borderWidth + "px", "background-repeat": $$.css("background-repeat"), "background-position": "0px -" + ($$.height()) + "px" });
                                    break;
                                case "br":
                                    if (topMaxRadius > 0)
                                        $(newCorner).css({ height: botMaxRadius - borderWidth, "margin-left": settings.bl.radius - (borderWidth * 2), "border-right": borderString, "border-bottom": borderString, left: borderWidth + "px", "background-repeat": $$.css("background-repeat"), "background-position": "-" + settings.bl.radius + borderWidth + "px -" + ($$.height() + topMaxRadius - borderWidth + 1) + "px" });
                                    else
                                        $(newCorner).css({ height: botMaxRadius - borderWidth, "margin-left": settings.bl.radius - (borderWidth * 2), "border-right": borderString, "border-bottom": borderString, left: borderWidth + "px", "background-repeat": $$.css("background-repeat"), "background-position": "-" + settings.bl.radius + borderWidth + "px -" + ($$.height()) + "px" });
                                    break;
                            };
                        };
                    } else {
                        if (masterCorners[settings[cc].radius]) {
                            var newCorner = masterCorners[settings[cc].radius].cloneNode(true);
                        } else {
                            var newCorner = document.createElement("DIV");
                            $(newCorner).css({ height: settings[cc].radius, width: settings[cc].radius, position: "absolute", "font-size": "1px", overflow: "hidden" });
                            var borderRadius = parseInt(settings[cc].radius - borderWidth);
                            for (var intx = 0, j = settings[cc].radius; intx < j; intx++) {
                                if ((intx + 1) >= borderRadius)
                                    var y1 = -1;
                                else
                                    var y1 = (Math.floor(Math.sqrt(Math.pow(borderRadius, 2) - Math.pow((intx + 1), 2))) - 1);
                                if (borderRadius != j) {
                                    if ((intx) >= borderRadius)
                                        var y2 = -1;
                                    else
                                        var y2 = Math.ceil(Math.sqrt(Math.pow(borderRadius, 2) - Math.pow(intx, 2)));
                                    if ((intx + 1) >= j)
                                        var y3 = -1;
                                    else
                                        var y3 = (Math.floor(Math.sqrt(Math.pow(j, 2) - Math.pow((intx + 1), 2))) - 1);
                                };
                                if ((intx) >= j)
                                    var y4 = -1;
                                else
                                    var y4 = Math.ceil(Math.sqrt(Math.pow(j, 2) - Math.pow(intx, 2)));
                                if (y1 > -1) newCorner.appendChild(drawPixel(box, intx, 0, boxColour, 100, (y1 + 1), newCorner, -1, bgImage, settings[cc].radius, 0, borderWidth, boxWidth, settings));
                                if (borderRadius != j) {
                                    for (var inty = (y1 + 1); inty < y2; inty++) {
                                        if (settings.antiAlias) {
                                            if (bgImage != "") {
                                                var borderFract = (pixelFraction(intx, inty, borderRadius) * 100);
                                                if (borderFract < 30) {
                                                    newCorner.appendChild(drawPixel(box, intx, inty, borderColour, 100, 1, newCorner, 0, bgImage, settings[cc].radius, 1, borderWidth, boxWidth, settings));
                                                } else {
                                                    newCorner.appendChild(drawPixel(box, intx, inty, borderColour, 100, 1, newCorner, -1, bgImage, settings[cc].radius, 1, borderWidth, boxWidth, settings));
                                                };
                                            } else {
                                                var pixelcolour = BlendColour(boxColour, borderColour, pixelFraction(intx, inty, borderRadius));
                                                newCorner.appendChild(drawPixel(box, intx, inty, pixelcolour, 100, 1, newCorner, 0, bgImage, settings[cc].radius, cc, 1, borderWidth, boxWidth, settings));
                                            };
                                        };
                                    };
                                    if (settings.antiAlias) {
                                        if (y3 >= y2) {
                                            if (y2 == -1) y2 = 0;
                                            newCorner.appendChild(drawPixel(box, intx, y2, borderColour, 100, (y3 - y2 + 1), newCorner, 0, bgImage, 0, 1, borderWidth, boxWidth, settings));
                                        }
                                    } else {
                                        if (y3 >= y1) {
                                            newCorner.appendChild(drawPixel(box, intx, (y1 + 1), borderColour, 100, (y3 - y1), newCorner, 0, bgImage, 0, 1, borderWidth, boxWidth, settings));
                                        }
                                    };
                                    var outsideColour = borderColour;
                                } else {
                                    var outsideColour = boxColour;
                                    var y3 = y1;
                                };
                                if (settings.antiAlias) {
                                    for (var inty = (y3 + 1); inty < y4; inty++) {
                                        newCorner.appendChild(drawPixel(box, intx, inty, outsideColour, (pixelFraction(intx, inty, j) * 100), 1, newCorner, ((borderWidth > 0) ? 0 : -1), bgImage, settings[cc].radius, 1, borderWidth, boxWidth, settings));
                                    };
                                };
                            };
                            masterCorners[settings[cc].radius] = newCorner.cloneNode(true);
                        };
                        if (cc != "br") {
                            for (var t = 0, k = newCorner.childNodes.length; t < k; t++) {
                                var pixelBar = newCorner.childNodes[t];
                                var pixelBarTop = strip_px($(pixelBar).css("top"));
                                var pixelBarLeft = strip_px($(pixelBar).css("left"));
                                var pixelBarHeight = strip_px($(pixelBar).css("height"));

                                if (cc == "tl" || cc == "bl") {
                                    $(pixelBar).css("left", settings[cc].radius - pixelBarLeft - 1 + "px");
                                };

                                if (cc == "tr" || cc == "tl") {
                                    $(pixelBar).css("top", settings[cc].radius - pixelBarHeight - pixelBarTop + "px");
                                };

                                switch (cc) {
                                    case "tr":
                                        $(pixelBar).css("background-position", "-" + Math.abs((boxWidth - settings[cc].radius + borderWidth) + pixelBarLeft) + "px -" + Math.abs(settings[cc].radius - pixelBarHeight - pixelBarTop - borderWidth) + "px");
                                        break;
                                    case "tl":
                                        $(pixelBar).css("background-position", "-" + Math.abs((settings[cc].radius - pixelBarLeft - 1) - borderWidth) + "px -" + Math.abs(settings[cc].radius - pixelBarHeight - pixelBarTop - borderWidth) + "px");
                                        break;
                                    case "bl":
                                        if (topMaxRadius > 0)
                                            $(pixelBar).css("background-position", "-" + Math.abs((settings[cc].radius - pixelBarLeft - 1) - borderWidth) + "px -" + Math.abs(($$.height() + topMaxRadius - borderWidth + 1)) + "px");
                                        else
                                            $(pixelBar).css("background-position", "-" + Math.abs((settings[cc].radius - pixelBarLeft - 1) - borderWidth) + "px -" + Math.abs(($$.height())) + "px");
                                        break;
                                };
                            };
                        };
                    };

                    if (newCorner) {
                        switch (cc) {
                            case "tl":
                                if ($(newCorner).css("position") == "absolute") $(newCorner).css("top", "0");
                                if ($(newCorner).css("position") == "absolute") $(newCorner).css("left", "0");
                                if (topContainer) topContainer.appendChild(newCorner);
                                break;
                            case "tr":
                                if ($(newCorner).css("position") == "absolute") $(newCorner).css("top", "0");
                                if ($(newCorner).css("position") == "absolute") $(newCorner).css("right", "0");
                                if (topContainer) topContainer.appendChild(newCorner);
                                break;
                            case "bl":
                                if ($(newCorner).css("position") == "absolute") $(newCorner).css("bottom", "0");
                                if (newCorner.style.position == "absolute") $(newCorner).css("left", "0");
                                if (bottomContainer) bottomContainer.appendChild(newCorner);
                                break;
                            case "br":
                                if ($(newCorner).css("position") == "absolute") $(newCorner).css("bottom", "0");
                                if ($(newCorner).css("position") == "absolute") $(newCorner).css("right", "0");
                                if (bottomContainer) bottomContainer.appendChild(newCorner);
                                break;
                        };
                    };
                };
            };

            var radiusDiff = new Array();
            radiusDiff["t"] = Math.abs(settings.tl.radius - settings.tr.radius);
            radiusDiff["b"] = Math.abs(settings.bl.radius - settings.br.radius);
            for (z in radiusDiff) {
                if (z == "t" || z == "b") {
                    if (radiusDiff[z]) {
                        var smallerCornerType = ((settings[z + "l"].radius < settings[z + "r"].radius) ? z + "l" : z + "r");
                        var newFiller = document.createElement("div");
                        $(newFiller).css({ height: radiusDiff[z], width: settings[smallerCornerType].radius + "px", position: "absolute", "font-size": "1px", overflow: "hidden", "background-color": boxColour, "background-image": bgImage });
                        switch (smallerCornerType) {
                            case "tl":
                                $(newFiller).css({ "bottom": "0", "left": "0", "border-left": borderString, "background-position": "0px -" + (settings[smallerCornerType].radius - borderWidth) });
                                topContainer.appendChild(newFiller);
                                break;

                            case "tr":
                                $(newFiller).css({ "bottom": "0", "right": "0", "border-right": borderString, "background-position": "0px -" + (settings[smallerCornerType].radius - borderWidth) + "px" });
                                topContainer.appendChild(newFiller);
                                break;

                            case "bl":
                                $(newFiller).css({ "top": "0", "left": "0", "border-left": borderString, "background-position": "0px -" + ($$.height() + settings[smallerCornerType].radius - borderWidth) });
                                bottomContainer.appendChild(newFiller);
                                break;

                            case "br":
                                $(newFiller).css({ "top": "0", "right": "0", "border-right": borderString, "background-position": "0px -" + ($$.height() + settings[smallerCornerType].radius - borderWidth) });
                                bottomContainer.appendChild(newFiller);

                                break;
                        }
                    };

                    var newFillerBar = document.createElement("div");
                    $(newFillerBar).css({ position: "relative", "font-size": "1px", overflow: "hidden", "background-color": boxColour, "background-image": bgImage, "background-repeat": $$.css("background-repeat") });
                    switch (z) {
                        case "t":
                            if (topContainer) {
                                if (settings.tl.radius && settings.tr.radius) {
                                    $(newFillerBar).css({
                                        height: topMaxRadius - borderWidth + "px",
                                        "margin-left": settings.tl.radius - borderWidth + "px",
                                        "margin-right": settings.tr.radius - borderWidth + "px",
                                        "border-top": borderString
                                    }).addClass('hasBackgroundColor');

                                    if (bgImage != "")
                                        $(newFillerBar).css("background-position", "-" + (topMaxRadius + borderWidth) + "px 0px");

                                    topContainer.appendChild(newFillerBar);

                                };
                                $$.css("background-position", "0px -" + (topMaxRadius - borderWidth + 1) + "px");
                            };
                            break;
                        case "b":
                            if (bottomContainer) {
                                if (settings.bl.radius && settings.br.radius) {
                                    $(newFillerBar).css({
                                        height: botMaxRadius - borderWidth + "px",
                                        "margin-left": settings.bl.radius - borderWidth + "px",
                                        "margin-right": settings.br.radius - borderWidth + "px",
                                        "border-bottom": borderString
                                    });

                                    if (bgImage != "" && topMaxRadius > 0)
                                        $(newFillerBar).css("background-position", "-" + (settings.bl.radius - borderWidth) + "px -" + ($$.height() + topMaxRadius - borderWidth + 1) + "px");
                                    else
                                        $(newFillerBar).css("background-position", "-" + (settings.bl.radius - borderWidth) + "px -" + ($$.height()) + "px").addClass('hasBackgroundColor');

                                    bottomContainer.appendChild(newFillerBar);
                                };
                            };
                            break;
                    };
                };
            };
            $$.prepend(topContainer);
            $$.prepend(bottomContainer);
        }

        var settings = {
            tl: { radius: 8 },
            tr: { radius: 8 },
            bl: { radius: 8 },
            br: { radius: 8 },
            antiAlias: true,
            autoPad: true,
            validTags: ["div"]
        };
        if (options && typeof (options) != 'string')
            $.extend(settings, options);

        return this.each(function() {
            if (!$(this).is('.hasCorners')) {
                applyCorners(this, settings);
            }

        });

    };
})(jQuery);

/*
[===========================================================================]
[   JQUERY TIMER                                                            ]
[===========================================================================]
*/

jQuery.fn.extend({
    everyTime: function(interval, label, fn, times, belay) {
        return this.each(function() {
            jQuery.timer.add(this, interval, label, fn, times, belay);
        });
    },
    oneTime: function(interval, label, fn) {
        return this.each(function() {
            jQuery.timer.add(this, interval, label, fn, 1);
        });
    },
    stopTime: function(label, fn) {
        return this.each(function() {
            jQuery.timer.remove(this, label, fn);
        });
    }
});

jQuery.event.special

jQuery.extend({
    timer: {
        global: [],
        guid: 1,
        dataKey: "jQuery.timer",
        regex: /^([0-9]+(?:\.[0-9]*)?)\s*(.*s)?$/,
        powers: {
            // Yeah this is major overkill...
            'ms': 1,
            'cs': 10,
            'ds': 100,
            's': 1000,
            'das': 10000,
            'hs': 100000,
            'ks': 1000000
        },
        timeParse: function(value) {
            if (value == undefined || value == null)
                return null;
            var result = this.regex.exec(jQuery.trim(value.toString()));
            if (result[2]) {
                var num = parseFloat(result[1]);
                var mult = this.powers[result[2]] || 1;
                return num * mult;
            } else {
                return value;
            }
        },
        add: function(element, interval, label, fn, times, belay) {
            var counter = 0;

            if (jQuery.isFunction(label)) {
                if (!times)
                    times = fn;
                fn = label;
                label = interval;
            }

            interval = jQuery.timer.timeParse(interval);

            if (typeof interval != 'number' || isNaN(interval) || interval <= 0)
                return;

            if (times && times.constructor != Number) {
                belay = !!times;
                times = 0;
            }

            times = times || 0;
            belay = belay || false;

            var timers = jQuery.data(element, this.dataKey) || jQuery.data(element, this.dataKey, {});

            if (!timers[label])
                timers[label] = {};

            fn.timerID = fn.timerID || this.guid++;

            var handler = function() {
                if (belay && this.inProgress)
                    return;
                this.inProgress = true;
                if ((++counter > times && times !== 0) || fn.call(element, counter) === false)
                    jQuery.timer.remove(element, label, fn);
                this.inProgress = false;
            };

            handler.timerID = fn.timerID;

            if (!timers[label][fn.timerID])
                timers[label][fn.timerID] = window.setInterval(handler, interval);

            this.global.push(element);

        },
        remove: function(element, label, fn) {
            var timers = jQuery.data(element, this.dataKey), ret;

            if (timers) {

                if (!label) {
                    for (label in timers)
                        this.remove(element, label, fn);
                } else if (timers[label]) {
                    if (fn) {
                        if (fn.timerID) {
                            window.clearInterval(timers[label][fn.timerID]);
                            delete timers[label][fn.timerID];
                        }
                    } else {
                        for (var fn in timers[label]) {
                            window.clearInterval(timers[label][fn]);
                            delete timers[label][fn];
                        }
                    }

                    for (ret in timers[label]) break;
                    if (!ret) {
                        ret = null;
                        delete timers[label];
                    }
                }

                for (ret in timers) break;
                if (!ret)
                    jQuery.removeData(element, this.dataKey);
            }
        }
    }
});

jQuery(window).bind("unload", function() {
    jQuery.each(jQuery.timer.global, function(index, item) {
        jQuery.timer.remove(item);
    });
});
