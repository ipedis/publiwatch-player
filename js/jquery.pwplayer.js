// jQuery PubliWatch Player, accessible and responsive
// version 1.1, May 30th, 2013
// by Ipedis Entreprise
// License: Creative Common 3.0 BY-SA <https://creativecommons.org/licenses/by-sa/3.0/legalcode>
pwTranslate = false;

(function($, App) {
    $.pwplayer = function(movie, options) {
        var defaults = {
            callback : {
                onPlayVideo         : function(){},
                onStopVideo         : function(){},
                onEnterFullScreen   : function(){},
                onExitFullScreen    : function(){},
                onDisplaySubTitle   : function(){},
                onHideSubTitle      : function(){},
                onVolumeChange      : function(volume){},
                onSeekUpdate        : function(pos){},
                onDisplayHelp       : function(){},
                onHideHelp          : function(){},
                onTranscriptOpen    : function(){}
            },
            autoplay : false,
            uriTranslate: "translate/fr.json",
            uriTranscript: null,
            uriFlashFallbackFolder: "altFlash",
            uriAssetsFolder: "img",
            uriFlashFallbackVideoName: "video.mp4",
            uriFlashFallbackTranscriptName: "transcript.pdf",
            prefixCss : ""
        };
        
        // A pwplayer object attibute (global for all the method, but local for each instance of the player)
        var plugin = this;
        plugin.settings = {};
        
        var $movie = $(movie), // reference to the jQuery version of DOM movie
             movie = movie;    // reference to the actual DOM movie

        var $movieWrapper;
        var $movieControls;
        var $movieHelp;
        var $movieToolTip;
        var $movieContainer; 
        var $movieControlBar;
        var $moviePlayPauseBtn;
        var $movieTimebar;
        var $movieElapsedTime;
        var $movieTime;
        var $movieVideoDuration;
        var $movieMuteBtn;
        var $movieVolumeContainer;
        var $movieVolume;
        var $movieSubtitlesBtn;
        var $movieSubtitlesTextContainer;
        var $movieHelpBtn;
        var $movieTranscriptBtn;
        var $movieFullscreenBtn;

        var isTablet = false;
        var isSmartphone = false;
        var isDesktop = false;
        
        var is_touch_device = 'ontouchstart' in document.documentElement;

        var hasFs = false;
        var hasSt = false;
        var hasPdf = false;
        var hasHelp = true;

        var prx; // CSS selectors prefix

        var videoPositionTop;
        var videoPositionLeft;
        var videoPlayerHeight;
        var videoPlayerWidth;

        plugin.construct = function(){ 

            plugin.settings = $.extend({}, defaults, options);
            if(typeof options["callback"] != "undefined")
                plugin.settings["callback"] = $.extend({}, defaults["callback"], options["callback"]);

            if(typeof plugin.settings["uriTranslate"] == null){
                return false;
            }

            if(pwTranslate == false){
                $.get(plugin.settings["uriTranslate"], function(rep){

                    if(pwTranslate == false){
                        pwTranslate = rep;
                    }
                    plugin.init();
                }).fail(function() { });
            }
            else{
                plugin.init();
            }

        };

        plugin.init = function() {
            prx = plugin.settings["prefixCss"];
            checkDeviceType();
            createHtmlStructure();
            
            $movieTime.progressbar();
            $movieVolume.progressbar({value: 100});
            setControlBar($movieWrapper.outerWidth(),true);

            setBindingEvents();
            setImagePreview();//Poster HTML attribute
            autoPlayHandler();
            setFlashFallback();
            $movieSubtitlesBtn.children('img').attr("data-subtitle",1);

            //Positionning of the Player
            videoPositionTop = $movie.offset().top;
            videoPositionLeft = $movie.offset().left;
            videoPlayerHeight = $movie.height()/2;
            videoPlayerWidth = $movie.width()/2;

            createHelpWindow();
            $movieHelp.addClass("displayNone");

            $movie.bind('timeupdate', updateVideoCurrentTime);
            
        };//End init

        var videoTagIsSupported = function () {
          return !!document.createElement('video').canPlayType;
        };

        var setFlashFallback = function(){

            if(videoTagIsSupported() == false){
                hideVideoControlBar();
                $movieHelp.removeClass("displayBlock").addClass("displayNone");

                var uriFlashFallbackFolderParam = plugin.settings['uriFlashFallbackFolder'];

                var flashAlternativeIdAttribute;
                flashAlternativeIdAttribute = $movie.attr("id") + "Flash";

                var $videoTagAlternative = $("<div id="+flashAlternativeIdAttribute+">"+pwTranslate["interface"]["flashAlternative"]+"</div>");
                $movie.after($videoTagAlternative);   

                var flashvars = {
                    stSrtUrl : parseTrackBalise(),
                    pdfUrl : plugin.settings['uriTranscript'],
                    //pdfSize : '552 Ko',
                    xmlAccueilURL : uriFlashFallbackFolderParam + '/XML/accueil.xml',
                    xmlAccessibilityURL : uriFlashFallbackFolderParam + '/XML/accessibility.xml',
                    xmlAideURL : uriFlashFallbackFolderParam + '/XML/help.xml',
                    xmlBulle_infoURL : uriFlashFallbackFolderParam + '/XML/tooltip.xml',
                    xmlUrlsURL : uriFlashFallbackFolderParam +'/XML/urls.xml',
                    videoUrl : plugin.settings['uriFlashFallbackVideoName']
                };

                var params = { //Do not change these parameters
                    allowScriptAccess : 'always',
                    allowFullScreen : 'true',
                    scale : 'noscale',
                    bgcolor : '#000000',
                    wmode : 'window',
                    salign : 'lt'
                };

                var attributes = {
                    id : flashAlternativeIdAttribute,
                    name : flashAlternativeIdAttribute
                };

                var widthSWF = $movie.attr("width");
                var heightSWF = $movie.attr("height");


                swfobject.embedSWF(uriFlashFallbackFolderParam+"/player.swf", flashAlternativeIdAttribute, widthSWF, heightSWF, "9.0.0", uriFlashFallbackFolderParam + "expressInstall.swf", flashvars, params, attributes);

                }
        };

        var parseTrackBalise = function(){
            var el = $movie.find("track");
            var srcOfSrt = "";
            if(typeof el == "undefined"){
                // hack for IE 8, he doesn't support unknown tags
                var contentMovie = $movie.html();
                var pattern = /src=["']((.)+\.srt)["']/im;
                var array_matchs = pattern.exec(contentMovie);
                srcOfSrt = array_matchs[1];
            }
            else{
                srcOfSrt = el[0].getAttribute("src");
            }
            return srcOfSrt;
        };

        var setControlBar = function(ctrlbarWidth, setTooltip){
            var oneButtonWidth = $('.'+prx+'movieControlBar button').outerWidth();
            var muteButtonWidth;
            var volumeWidth;

            if(isDesktop){
                muteButtonWidth = $movieMuteBtn.outerWidth();
                volumeWidth = $movieVolumeContainer.outerWidth();
            }
            else{
                muteButtonWidth = 0;
                volumeWidth = 0;
            }

            var buttonCount = 2;
            if(hasPdf) buttonCount ++;
            if(hasSt) buttonCount ++;
            if(hasHelp) buttonCount ++;

            var allButtonsWidth = muteButtonWidth + buttonCount * oneButtonWidth;
            var timeBarWidth = (ctrlbarWidth - volumeWidth) - allButtonsWidth;
            var progressbarWidth = timeBarWidth - 100;

            $movieTimebar.outerWidth(timeBarWidth);
            $movieTime.outerWidth(progressbarWidth);

            $moviePlayPauseBtn.css('left',0);
            $movieTimebar.css('left', oneButtonWidth);
            
            if(isDesktop){
                $movieMuteBtn.css('left', oneButtonWidth + timeBarWidth);
            }else{
                $movieMuteBtn.addClass("displayNone");
            }

            if(isDesktop){
                $movieVolumeContainer.css('left', oneButtonWidth + timeBarWidth + muteButtonWidth);
            }else{
                $movieVolumeContainer.addClass("displayNone");
            }

            $movieFullscreenBtn.css('left', oneButtonWidth*(buttonCount-1) + timeBarWidth + muteButtonWidth + volumeWidth);

            if(hasSt){
                $movieSubtitlesBtn.css('left', oneButtonWidth + timeBarWidth + muteButtonWidth + volumeWidth);
                if(hasHelp){
                    $movieHelpBtn.css('left', oneButtonWidth*2 + timeBarWidth + muteButtonWidth + volumeWidth);
                    if(hasPdf) $movieTranscriptBtn.css('left', oneButtonWidth*3 + timeBarWidth + muteButtonWidth + volumeWidth);
                }
                else{
                    if(hasPdf) $movieTranscriptBtn.css('left', oneButtonWidth*2 + timeBarWidth + muteButtonWidth + volumeWidth);
                }
            }
            else{
                if(hasHelp){
                    $movieHelpBtn.css('left', oneButtonWidth + timeBarWidth + muteButtonWidth + volumeWidth);
                    if(hasPdf) $movieTranscriptBtn.css('left', oneButtonWidth*2 + timeBarWidth + muteButtonWidth + volumeWidth);
                }
                else{
                    if(hasPdf) $movieTranscriptBtn.css('left', oneButtonWidth + timeBarWidth + muteButtonWidth + volumeWidth);
                }
            }

            if(setTooltip) setTooltipPosition();
        }

        var setTooltipPosition = function()
        {
            //Position the toolTip above the control bar
            var toolTipTopPosition = $movieControls.offset().top - 29;
            $movieToolTip.css('top', toolTipTopPosition);

            $movieSubtitlesTextContainer.width($movie.width());
        }

        var autoPlayHandler = function(){
            //Hide the play button (except when autoplay)
            if (plugin.settings['autoplay'] == false || plugin.settings['autoplay'] == undefined) {
                $moviePlayPauseBtn.removeClass(prx+"btnPause").addClass(prx+"btnPlay").children("img").attr("src",plugin.settings["uriAssetsFolder"]+"/Play.png");
            } else{
                $moviePlayPauseBtn.removeClass(prx+"btnPlay").addClass(prx+"btnPause").children("img").attr("src",plugin.settings["uriAssetsFolder"]+"/Pause.png");
            }
            if (plugin.settings['autoplay'] == true){
               playVideo();
            }
        }

        var createHtmlStructure = function(){
            if($movie.find("track").length != 0) {
                hasSt = true;
            }

            if(plugin.settings['uriTranscript'] != null) {
                if(isTablet == false || isSmartphone == false){
                    hasPdf = true;
                }
            }

            if(isTablet == true || isSmartphone == true){
              hasPdf = false;
              hasHelp = false;
            }

            $movieControls = $("<div class='"+prx+"movieControlBar'><button class='"+prx+"btnPlayPause "+prx+"btnPlay' type='button'><img class='"+prx+"btnLinkTitle' alt='"+pwTranslate["interface"]["playMovie"]+"' src='"+plugin.settings["uriAssetsFolder"]+"/Play.png' /></button><div class='"+prx+"timeBar'><span class='"+prx+"movieTimeInfo "+prx+"movieElapsedTime'>00:00</span><div class='"+prx+"time'></div><span class='"+prx+"movieTimeInfo movieDuration'>--:--</span></div><button class='"+prx+"btnMute "+prx+"btnVolumeOff' type='button'><img class='"+prx+"btnLinkTitle' alt='"+pwTranslate["interface"]["cutSound"]+"' src='"+plugin.settings["uriAssetsFolder"]+"/MuteOff.png' /></button><span class='"+prx+"volumeWrapper'><span class='"+prx+"volume'></span></span><button class='"+prx+"btnSt "+prx+"btnStOn' type='button'><img class='"+prx+"btnLinkTitle' alt='"+pwTranslate["interface"]["disableSubtitle"]+"' src='"+plugin.settings["uriAssetsFolder"]+"/StOn.png' /></button><button class='"+prx+"btnHelp btnHelpOn' type='button'><img class='"+prx+"btnLinkTitle' alt='"+pwTranslate["interface"]["movieHelp"]+"' src='"+plugin.settings["uriAssetsFolder"]+"/Aide.png' /></button><button class='"+prx+"btnTranscript "+prx+"btnTranscriptOn' type='button'><img class='"+prx+"btnLinkTitle' alt='"+pwTranslate["interface"]["showTranscript"]+"' src='"+plugin.settings["uriAssetsFolder"]+"/Pdf.png' /></button><button class='"+prx+"btnFs "+prx+"btnFsOn' type='button'><img class='"+prx+"btnLinkTitle' alt='"+pwTranslate["interface"]["fullscreenMode"]+"' src='"+plugin.settings["uriAssetsFolder"]+"/FsOn.png' /></button></div>");

            // Ipad Hack //

            var $container = $("<div style='width : "+$movie.width()+"px;' class='"+prx+"movieWrapper'></div>");
            $movie.after($container);
            var plg = $movie.data("pwplayer");
            var tmpVideo = $movie[0].cloneNode(true);

            $movie.remove();
            $container[0].appendChild(tmpVideo);
            
            $movie = $container.find("video");
            movie = $movie[0];
            $movie.data("pwplayer",plg);
            $movieWrapper = $movie.parent('.movieWrapper');
            $movie.after($movieControls);

            // Fin hack Ipad //

            $movieToolTip = $("<span class='"+prx+"toolTip'></span>");
            $movie.after($movieToolTip);
            hideToolTips();

            $movieHelp = $("<div class='"+prx+"helpMovie'></div>");
            $movie.after($movieHelp);

            $movieContainer = $movie.parent('.'+prx+'movieWrapper');
            $movieControlBar = $('.'+prx+'movieControlBar', $movieContainer);

            $moviePlayPauseBtn = $('.'+prx+'btnPlayPause', $movieContainer);

            $movieTimebar = $('.'+prx+'timeBar', $movieContainer);
            $movieElapsedTime = $('.'+prx+'movieElapsedTime', $movieContainer);
            $movieTime = $('.'+prx+'time', $movieContainer);
            $movieVideoDuration = $('.'+prx+'movieDuration', $movieContainer);
            $movieMuteBtn = $('.'+prx+'btnMute', $movieContainer);
            $movieVolumeContainer = $('.'+prx+'volumeWrapper', $movieContainer);
            $movieVolume = $('.'+prx+'volume', $movieContainer);
            $movieSubtitlesBtn = $('.'+prx+'btnSt', $movieContainer);
            $movieHelpBtn = $('.'+prx+'btnHelp', $movieContainer);
            $movieTranscriptBtn = $('.'+prx+'btnTranscript', $movieContainer);
            $movieFullscreenBtn = $('.'+prx+'btnFs', $movieContainer);

            if($movie.find("track").length != 0){
                $movie.videoSub({
                    useBarDefaultStyle: false
                });
            }
            $movieSubtitlesTextContainer = $movie.parent().find("."+prx+"videosub-bar");

            //The unnecessary buttons have to be removed
            if (hasSt != true) {
               $movieSubtitlesBtn.removeClass("displayBlock").addClass("displayNone");
            }

            if(hasHelp != true){
               $movieHelpBtn.removeClass("displayBlock").addClass("displayNone");
            }
            
            if(hasPdf != true) {
               $movieTranscriptBtn.removeClass("displayBlock").addClass("displayNone");
            }

            //Hide the "Activate Subtitles" buttons
            $movieSubtitlesBtn.removeClass(prx+"btnStOn").addClass(prx+"btnStOff").children("img").attr("src",plugin.settings["uriAssetsFolder"]+"/StOff.png");
        };

        var setImagePreview = function(){
            if(plugin.settings['poster'] != null){
              $movie.attr('poster', plugin.settings['poster']);
            }
        };


        var createDeviceCssReferent = function(){
            var css = "#modernizr-typeSupport { font-size: 1px; display: none; }";
            css += "@media only screen and (min-width: 768px) and (max-width: 981px) {#modernizr-typeSupport {font-size: 2px;}}";
            var styleElement = "<style>#modernizr-typeSupport { font-size: 1px; display: none; }@media only screen and (min-width: 768px) and (max-width: 979px) {#modernizr-typeSupport {font-size: 2px;}}@media only screen and (max-width: 767px){#modernizr-typeSupport {font-size: 3px;}}@media only screen and (max-width: 480px){#modernizr-typeSupport {font-size: 4px;}}</style>";
            $('head').append(styleElement);
        };

        var checkDeviceType = function(){
            createDeviceCssReferent();
            if(document.getElementById("modernizr-typeSupport") === null){
                var elem = document.createElement("div");
                elem.id = "modernizr-typeSupport";
                document.body.appendChild(elem);
            } else{
                var elem = document.getElementById("modernizr-typeSupport");
            }

            isDesktop = false;
            isTablet = false;
            isSmartphone = false;

            switch($(elem).css("font-size")){
                case "1px":
                    isDesktop = true;
                break;
                case "2px":
                case "3px":
                    isTablet = true;
                break;
                case "4px":
                    isSmartphone = true;
                break;
            }

           if(is_touch_device == false)
            {
                isDesktop = true;
                isTablet = false;
                isSmartphone = false;
            }
        };

        var setBindingEvents = function(){
            $moviePlayPauseBtn.bind((is_touch_device) ? 'touchstart' : 'click',switchPlayPauseBtnState);
            $moviePlayPauseBtn.bind('mouseover focusin',overPlayPauseBtn);
            $moviePlayPauseBtn.bind('mouseout focusout',outPlayPauseBtn);

            $movieTime.bind((is_touch_device) ? 'touchstart' : 'click',setAndPlayCurrentTimeOnClick);
            $movieTime.bind('mouseover',displayToolTipVideoTimeOnOver);
            $movieTime.bind('mousemove',displayToolTipVideoTimeOnMove);
            $movieTime.bind('mouseout',hideToolTips);

            $movieMuteBtn.bind((is_touch_device) ? 'touchstart' : 'click', switchVolumeBtnState);
            $movieMuteBtn.bind('mouseover focusin', overVolumeBtn);
            $movieMuteBtn.bind('mouseout focusout', outVolumeBtn);

            $movieVolume.bind((is_touch_device) ? 'touchstart' : 'click',setVolumeOnClick);
            $movieVolume.bind('mouseover',displayToolTipVolumeOnOver);
            $movieVolume.bind('mousemove',displayToolTipVolumeOnOver);
            $movieVolume.bind('mouseout',hideToolTips);

            $movieSubtitlesBtn.bind((is_touch_device) ? 'touchstart' : 'click',switchSubtitlesBtnState);
            $movieSubtitlesBtn.bind('mouseover focusin',overSubtitlesBtn);
            $movieSubtitlesBtn.bind('mouseout focusout',outSubtitlesBtn);

            $movieHelpBtn.bind((is_touch_device) ? 'touchstart' : 'click',switchDisplayHelpWindow);
            $movieHelpBtn.bind('mouseover focusin', function(){
				$movieHelpBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/AideOver.png");
                displayToolTips(pwTranslate["toolTip"]["aide"], $(this).offset().left);
            });
            $movieHelpBtn.bind('mouseout focusout', function(){
				$movieHelpBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/Aide.png");
                hideToolTips();
            });

            $movieHelp.bind((is_touch_device) ? 'touchstart' : 'click',hideHelpWindow);

            $movieTranscriptBtn.bind((is_touch_device) ? 'touchstart' : 'click',displayVideoTranscript);
            $movieTranscriptBtn.bind('mouseover focusin', function(){
				$movieTranscriptBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/PdfOver.png");
                displayToolTips(pwTranslate["toolTip"]["pdf"], $(this).offset().left);
            });
            $movieTranscriptBtn.bind('mouseout focusout', function(){
				$movieTranscriptBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/Pdf.png");
				hideToolTips();
			});

            $movieFullscreenBtn.bind((is_touch_device) ? 'touchstart' : 'click', switchScreenMode);
            $movieFullscreenBtn.bind('mouseover focusin', function(){
				if($movie.attr('rel') != 'fullscreen')
					$movieFullscreenBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/FsOff.png");
                displayToolTips(pwTranslate["toolTip"]["fullscreenOn"], $(this).offset().left-30);
            });
            $movieFullscreenBtn.bind('mouseout focusout', function(){
				if($movie.attr('rel') != 'fullscreen')
					$movieFullscreenBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/FsOn.png");
                hideToolTips();
            });
            
            $(document).bind("fullscreenchange", function (){if(!document.fullScreen) exitFullScreen();});
            $(document).bind("webkitfullscreenchange", function (){if(!document.webkitIsFullScreen) exitFullScreen();});
            $(document).bind("mozfullscreenchange", function (){if(!document.mozFullScreen) exitFullScreen();});

            $(window).keydown(playerMappingHotkey);

            
        };

        var setVolumeOnClick = function(e){
            var ev = e || window.event;
            var pos = findPos(this);      
            var diffx = ev.clientX - pos.x;      
            $movieVolume.progressbar({ value: diffx*100/$(this).width() });
            var newVolume = diffx/$(this).width();
            setVideoVolume(newVolume);  
        };

        var displayToolTipVolumeOnOver = function(e){
            var ev = e || window.event;
            var pos = findPos(this);      
            var diffx = ev.clientX - pos.x;      
            var newVolume = diffx*100/$(this).width();
            displayToolTips(pwTranslate["toolTip"]["volumeBar"] + " : " + newVolume + "%", ev.clientX-20);
        };

        var displayToolTipVideoTimeOnMove = function(e){
            var ev = e || window.event;
            var pos = findPos(this);      
            var diffx = ev.clientX - pos.x;  
            var newVolume = diffx*100/$(this).width();    
            displayToolTips(pwTranslate["toolTip"]["volumeBar"] + " : " + newVolume + "%", ev.clientX-20);
        };

        var setAndPlayCurrentTimeOnClick = function(e){
            var ev = e || window.event;
            var pos = findPos(this);      
            var diffx = ev.clientX - pos.x;      
            $movieTime.progressbar({ value: diffx*100/$(this).width() });
            var duration = $movie[0].duration;
            $movie[0].currentTime = diffx*duration/$(this).width();

            plugin.settings["callback"]["onSeekUpdate"]();
        }

        var displayToolTipVideoTimeOnOver = function(e){
            var ev = e || window.event;
            var pos = findPos(this);      
            var diffx = ev.clientX - pos.x;    
            var currentPercentageVideoPlaying = diffx*100/$(this).width();
            var videoDuration = $movie[0].duration;
            var timeOverValue = (currentPercentageVideoPlaying*videoDuration)/100;

            displayToolTips(gTimeFormat(timeOverValue), e.pageX - $movieToolTip.width());
        };

        var displayToolTipVideoTimeOnMove = function(e){
            var ev = e || window.event;
            var pos = findPos(this);      
            var diffx = ev.clientX - pos.x;    
            var currentPercentageVideoPlaying = diffx*100/$(this).width();
            var videoDuration = $movie[0].duration;
            var timeOverValue = (currentPercentageVideoPlaying*videoDuration)/100;
            displayToolTips(gTimeFormat(timeOverValue), e.pageX - $movieToolTip.width()/2);
        };

        var moveForwardFiveSec = function (){
            $movie[0].currentTime += 5;
            $movieTime.progressbar({ value: $movie[0].currentTime*100/$movie[0].duration });
        };

        var moveBackwardFiveSec = function(){
            $movie[0].currentTime -= 5;
            $movieTime.progressbar({ value: $movie[0].currentTime*100/$movie[0].duration });
        };

        function findPos(el) {
            var x = y = 0;    
            if(el.offsetParent) {    
                x = el.offsetLeft;    
                y = el.offsetTop;    
                while(el = el.offsetParent) {    
                    x += el.offsetLeft;    
                    y += el.offsetTop;    
                }    
            }    
            return {'x':x, 'y':y};    
        }

        var hideVideoControlBar = function(){
            $movieControlBar.removeClass("displayBlock").addClass("displayNone");
        };

        var displayToolTips  = function(textToolTip, leftPosition){
            $movieToolTip.text(textToolTip);
            $movieToolTip.removeClass("displayNone").addClass("displayBlock");

            var toolTipTopPosition = $movieControls.offset().top - 29;
            $movieToolTip.css('top', toolTipTopPosition);

            $movieToolTip.css('left', leftPosition);

            $movieToolTip.removeClass("displayBlock").addClass("displayNone");
            $movieToolTip.removeClass("displayNone").addClass("displayBlock");

        };

        var hideToolTips = function(){
            $movieToolTip.removeClass("displayBlock").addClass("displayNone");
        };

        var buttonForNormalScreen = function(){
            $('.'+prx+'movieControlBar').removeClass("displayNone").addClass("displayBlock");
            $('.'+prx+'movieControlBar').css({position: 'relative', bottom: 'inherit'});

            setControlBar($movie.attr("width"),false);
            
            $("."+prx+"videosub-bar").show();
            $movie.next("."+prx+"videosub-bar").css({display:'block', fontSize:'12px', position :'absolute', bottom:'20px', top:'',width : $movie.attr("width")});

             $movieHelp.css('position', 'absolute');
             $movieHelp.css('top', videoPositionTop + videoPlayerHeight - 100);
             $movieHelp.css('left', videoPositionLeft + videoPlayerWidth - 150);
        };

        var buttonForFullScreen = function(){
            $('.'+prx+'movieControlBar').removeClass("displayBlock").addClass("displayNone");
            $movieControlBar.removeClass("displayNone").addClass("displayBlock");
            $movieControlBar.css({position: 'fixed', bottom: 0});
            $movieControlBar.css({position: 'fixed', left: 0});

            setControlBar($movie.outerWidth(),false);

            $("."+prx+"videosub-bar").hide();
            $movie.next("."+prx+"videosub-bar").css({display:'block', position :'fixed', width:'100%', bottom:'52px', left:'0', fontSize:'18px'});

            //Help is positioned
             $movieHelp.css('position', 'fixed');
             $movieHelp.css('top', '35%');
             $movieHelp.css('left', '35%');
        };

        var progressBarMappingHotkey = function(e){
            if (!$movie[0].paused){
                if (e.keyCode == 37){
                  $movie[0].currentTime -= 5;
                  $movieTime.progressbar({ value: $movie[0].currentTime*100/$movie[0].duration });
                }
                if (e.keyCode == 39){
                  $movie[0].currentTime += 5;
                  $movieTime.progressbar({ value: $movie[0].currentTime*100/$movie[0].duration });
                }

                if (e.shiftKey == true && e.keyCode == 226){
                  $movie[0].currentTime -= 5;
                  $movieTime.progressbar({ value: $movie[0].currentTime*100/$movie[0].duration });
                }

                if (e.shiftKey == false && e.keyCode == 226){
                  $movie[0].currentTime += 5;
                  $movieTime.progressbar({ value: $movie[0].currentTime*100/$movie[0].duration });
                }
            }
        };

        var updateVideoCurrentTime = function(){
            var currenttime = $movie[0].currentTime;
            $movieElapsedTime.text(gTimeFormat(currenttime));

            var videoDuration = $movie[0].duration;
            $movieVideoDuration.text(gTimeFormat(videoDuration));

          if(isNaN(videoDuration) == true){
            $("."+prx+"movieTimeInfo").css("margin-left", 0);
            $("."+prx+"movieTimeInfo").css("margin-right", 0);
          }else{
            $("."+prx+"movieTimeInfo").css("margin-left", "3px");
            $("."+prx+"movieTimeInfo").css("margin-right", "3px");
          }

          if($movie[0].ended){
            $movieTime.progressbar({ value: 0 });
            $movieElapsedTime.text(gTimeFormat(0));
            pauseVideo();
          }

        };

        var progressBarAutoUpdate = function(){
            $movieTime.progressbar({ value: $movie[0].currentTime*100/$movie[0].duration });
        };

        var findEventPositionXY = function(el){
            var x = y = 0;    
            if(el.offsetParent) {    
                x = el.offsetLeft;    
                y = el.offsetTop;    
                while(el = el.offsetParent) {    
                    x += el.offsetLeft;    
                    y += el.offsetTop;    
                }    
            }    
            return {'x':x, 'y':y};
        };

        var setVideoVolume = function(value){
           if(value == 0){
              $movieMuteBtn.removeClass(prx+"btnVolumeOff").addClass(prx+"btnVolumeOn").children("img").attr("src",plugin.settings["uriAssetsFolder"]+"/MuteOn.png");
              $movieMuteBtn.children('img').attr('alt',pwTranslate["interface"]["enableVolume"]);
            }
            else{
              $movieMuteBtn.removeClass(prx+"btnVolumeOn").addClass(prx+"btnVolumeOff").children("img").attr("src",plugin.settings["uriAssetsFolder"]+"/MuteOff.png");
              $movieMuteBtn.children('img').attr('alt',pwTranslate["interface"]["disableVolume"]);
            }

           $movieVolume.progressbar("option", "value", value*100);
           $movie[0].volume = value;
           plugin.settings["callback"]["onVolumeChange"](value);
        };

        var playVideo = function(){
            $movie[0].play();
            timer = setInterval(function(){
                $movieTime.progressbar({ value: $movie[0].currentTime*100/$movie[0].duration });
            }, 10);
            $movieHelp.removeClass("displayBlock").addClass("displayNone");

            $moviePlayPauseBtn.removeClass(prx+"btnPlay").addClass(prx+"btnPause").children("img").attr("src",plugin.settings["uriAssetsFolder"]+"/Pause.png");
            $moviePlayPauseBtn.children('img').attr('alt',pwTranslate["interface"]["stopMovie"]);

            hideToolTips();
            plugin.settings["callback"]["onPlayVideo"]();
        };

        var pauseVideo = function(){
              $movie[0].pause();
              if(typeof timer != "undefined"){
                 clearInterval(timer);
              }
              $moviePlayPauseBtn.removeClass(prx+"btnPause").addClass(prx+"btnPlay").children("img").attr("src",plugin.settings["uriAssetsFolder"]+"/Play.png");
              $moviePlayPauseBtn.children('img').attr('alt',pwTranslate["interface"]["playMovie"]);

              hideToolTips();
              plugin.settings["callback"]["onStopVideo"]();
        };

        var switchPlayPauseBtnState = function(e){
            if ($movie[0].paused) {
                playVideo();
            } else {
                pauseVideo();
            }
        };

        var overPlayPauseBtn = function(){
            if ($movie[0].paused){
			  $moviePlayPauseBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/PlayOver.png");
              displayToolTips(pwTranslate["toolTip"]["play"], $(this).offset().left);
            }else{
			  $moviePlayPauseBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/PauseOver.png");
              displayToolTips(pwTranslate["toolTip"]["pause"], $(this).offset().left);
            }
        };

        var outPlayPauseBtn = function(){
            if ($movie[0].paused){
			  $moviePlayPauseBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/Play.png");
            }else{
			  $moviePlayPauseBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/Pause.png");
            }
            hideToolTips();
        };

        var gTimeFormat = function(seconds) {
                var h = Math.floor(seconds / 3600);
                var m = Math.floor(seconds / 60) < 10 ? "0"+ Math.floor(seconds / 60) : Math.floor(seconds / 60);
                var s = Math.floor(seconds - (m * 60)) < 10 ? "0" + Math.floor(seconds - (m * 60)) : Math.floor(seconds - (m * 60));

                if(h>0){
                    m = m-60;
                    return h + ":" + m + ":" + s;
                }else{
                    return m + ":" + s;
                }
        };

        var switchVolumeBtnState = function(e){
            hideToolTips();
            //If the sound is greater than 0
            var volume = $movieVolume.progressbar("option", "value");
            if(volume > 0){
              setVideoVolume(0);
              $movieMuteBtn.removeClass(prx+"btnVolumeOff").addClass(prx+"btnVolumeOn").children("img").attr("src",plugin.settings["uriAssetsFolder"]+"/MuteOn.png");
              $movieMuteBtn.children('img').attr('alt',pwTranslate["interface"]["enableSound"]);
            }else{
              setVideoVolume(1);
              $movieMuteBtn.removeClass(prx+"btnVolumeOn").addClass(prx+"btnVolumeOff").children("img").attr("src",plugin.settings["uriAssetsFolder"]+"/MuteOff.png");
              $movieMuteBtn.children('img').attr('alt',pwTranslate["interface"]["disableSound"]);
            }   
        };

        var overVolumeBtn = function(){
            var volume = $movieVolume.progressbar("option", "value");
            if(volume > 0){
			  $movieMuteBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/MuteOn.png");
              displayToolTips(pwTranslate["toolTip"]["muteOff"], $(this).offset().left);
            }else{
              displayToolTips(pwTranslate["toolTip"]["muteOn"], $(this).offset().left);
            }
        };

        var outVolumeBtn = function(){
            var volume = $movieVolume.progressbar("option", "value");
            if(volume > 0)
			  $movieMuteBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/MuteOff.png");
            hideToolTips();
        };


        var volumeUpKeyCode = function(){
            hideToolTips();
            var volume = $movieVolume.progressbar("option", "value");
            var newVolume = volume/100 + 0.1;
            if (newVolume <= 1) {setVideoVolume(volume/100 + 0.1);}
        };

        var volumeDownKeyCode = function(){
            var volume = $movieVolume.progressbar("option", "value");
            var newVolume = volume/100 - 0.1;
            if (newVolume > 0) {setVideoVolume(volume/100 - 0.1);}
            if (newVolume <= 0) {setVideoVolume(0);}
        }

        var switchScreenMode = function()
        {
            if($movie.attr('rel') != 'fullscreen'){
				$movieFullscreenBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/FsOff.png");
                enterFullscreen();
            }
            else{
				$movieFullscreenBtn.children('img').attr('src',plugin.settings["uriAssetsFolder"]+"/FsOn.png");
                exitFullScreen();
            }
            hideToolTips();
        };

        var enterFullscreen = function(){
            $("video").hide();
            $movie.show();

            var el = $movie.parent().parent()[0];

            if(el.requestFullScreen){
                el.requestFullScreen();
            } 
            else if(el.webkitRequestFullScreen){
                el.webkitRequestFullScreen(el.ALLOW_KEYBOARD_INPUT);
            } 
            else if(el.mozRequestFullScreen){
                el.mozRequestFullScreen();
            }
            
            $movie.css({position: 'fixed', top: 0, left: 0, width: '100%', height: '100%'});
            buttonForFullScreen();
            $movie.attr('rel', 'fullscreen');

            plugin.settings["callback"]["onEnterFullScreen"]();
        };

        var exitFullScreen = function()
        {
            $("video").show();

            if(document.cancelFullScreen){
                document.cancelFullScreen();
            } 
            else if(document.webkitCancelFullScreen){
                document.webkitCancelFullScreen();
            } 
            else if(document.mozCancelFullScreen){
                document.mozCancelFullScreen();
            }

            buttonForNormalScreen();

            $movie.removeAttr('style').removeAttr('rel');
            plugin.settings["callback"]["onExitFullScreen"]();
        };

        var hideSubtitles = function(){
            $movieSubtitlesTextContainer.removeClass("displayBlock").addClass("displayNone");
            hideToolTips();
            plugin.settings["callback"]["onHideSubTitle"]();
        };

        var displaySubtitles = function(){
            $movieSubtitlesTextContainer.removeClass("displayNone").addClass("displayBlock");
            hideToolTips();
            plugin.settings["callback"]["onDisplaySubTitle"]();
        };

        var switchSubtitlesBtnState = function(e){
            $selectorSpan = $movieSubtitlesBtn.children('img');
            if($selectorSpan.attr("data-subtitle") == 1){
              hideSubtitles();
              $movieSubtitlesBtn.removeClass(prx+"btnStOff").addClass(prx+"btnStOn").children("img").attr("src",plugin.settings["uriAssetsFolder"]+"/StOn.png");
              $selectorSpan.attr('alt',pwTranslate["interface"]["enableSubtitle"]);
              $selectorSpan.attr("data-subtitle",0);
            }else{
              displaySubtitles();
              $movieSubtitlesBtn.removeClass("btnStOn").addClass(prx+"btnStOff").children("img").attr("src",plugin.settings["uriAssetsFolder"]+"/StOff.png");
              $selectorSpan.attr('alt',pwTranslate["interface"]["disableSubtitle"]); 
              $selectorSpan.attr("data-subtitle",1);
            }
        };

        var overSubtitlesBtn = function(){
            $selectorSpan = $movieSubtitlesBtn.children('img');
            if($selectorSpan.attr("data-subtitle") == 1){
              displayToolTips(pwTranslate["toolTip"]["stOff"], $(this).offset().left);
            }else{
			  $selectorSpan.attr('src',plugin.settings["uriAssetsFolder"]+"/StOff.png");
              displayToolTips(pwTranslate["toolTip"]["stOn"], $(this).offset().left);
            }
        };

        var outSubtitlesBtn = function(){
            $selectorSpan = $movieSubtitlesBtn.children('img');
            if($selectorSpan.attr("data-subtitle") != 1)
			  $selectorSpan.attr('src',plugin.settings["uriAssetsFolder"]+"/StOn.png");
            hideToolTips();
        };

        var displayVideoTranscript = function(){
            plugin.settings["callback"]["onTranscriptOpen"]();
            window.open(plugin.settings['uriTranscript']);

            pauseVideo();
            hideToolTips();
        };

        var switchDisplayHelpWindow = function(){
            if($movieHelp.is(":visible")){
              hideHelpWindow();
              if ($movie[0].currentTime > 1){
                playVideo();
              }
            }else{
              displayHelpWindow();
              pauseVideo();
            }
        }

        var displayHelpWindow = function(){
            $movieHelp.removeClass("displayNone").addClass("displayBlock");
            plugin.settings["callback"]["onDisplayHelp"]();
        };

        var hideHelpWindow = function(){
            $movieHelp.removeClass("displayBlock").addClass("displayNone");
            plugin.settings["callback"]["onHideHelp"]();
        };

        var createHelpWindow = function(){
            $movieHelp.append("<p class='"+prx+"helpMovieTitle'>"+pwTranslate["interface"]["help"]+"</p>");

            var fsHelp  = "<p><img src='"+plugin.settings["uriAssetsFolder"]+"/FsOn.png' alt='' /> "+pwTranslate["interface"]["showMovieInFullScreen"]+"</p>";
            var stHelp  = "<p><img src='"+plugin.settings["uriAssetsFolder"]+"/StOn.png' alt='' /> "+pwTranslate["interface"]["enableOrDisableSubTitle"]+"</p>";
            var pdfHelp = "<p><img src='"+plugin.settings["uriAssetsFolder"]+"/Pdf.png' alt='' /> "+pwTranslate["interface"]["showTranscriptOnMovie"]+"</p>";

            $movieHelp.append(fsHelp);

            if(hasSt){
                $movieHelp.append(stHelp);
            }

            if(hasPdf){
               $movieHelp.append(pdfHelp);
            }

            var bottomTextHelp1 = "<p>"+pwTranslate["interface"]["moviePlayerAccessible"]+"</p>";
            var bottomTextHelp2 = "<p>"+pwTranslate["interface"]["poweredBy"]+" <a href='http://www.ipedis.com' target='_blank'>Ipedis</a>, "+pwTranslate["interface"]["ForCompany"]+"</p>";
            $movieHelp.append("<br/>");
            $movieHelp.append(bottomTextHelp1);
            $movieHelp.append(bottomTextHelp2);


            $movieHelp.css('position', 'absolute');
            $movieHelp.css('top', videoPositionTop + videoPlayerHeight - 100);
            $movieHelp.css('left', videoPositionLeft + videoPlayerWidth - 150);
        };


        //Intercept the keyboard events
        var playerMappingHotkey = function(e){
            //Escape key : help + fullscreen
            if(e.keyCode == 27 ) {
                if($movieHelp.is(":visible")){
                    hideHelpWindow();
                }
                if($movieHelp.not(":visible") && $movie.attr('rel') == 'fullscreen'){
                    switchScreenMode();
                }
            }

            //Arrows or lower than : progress bar
            if (!$movie[0].paused){
                if (e.keyCode == 37){
                  moveBackwardFiveSec();
                }
                if (e.keyCode == 39){
                  moveForwardFiveSec();
                }

                if (e.shiftKey == true && e.keyCode == 226){
                  moveBackwardFiveSec();
                }

                if (e.shiftKey == false && e.keyCode == 226){
                  moveForwardFiveSec();
                }


                //Ctrl + shift + page Up/down : Volume control
                if (e.ctrlKey && e.shiftKey && e.keyCode == 33){
                   volumeUpKeyCode();
                  
                }
                if (e.ctrlKey && e.shiftKey && e.keyCode == 34) {
                  volumeDownKeyCode();
                };

            };

        };

        /*** EXTERNAL API ***/
        plugin.play = function(el,params) {
            playVideo();
        };

        plugin.pause = function(el,params){
            pauseVideo();
        };

        plugin.enterFullscreen = function(el,params){
            enterFullscreen();
        };

        plugin.exitFullScreen = function(el,params){
            exitFullScreen();
        };

        plugin.switchScreenMode = function(el,params){
            switchScreenMode();
        };

        plugin.hideSubtitles = function(el,params){
            hideSubtitles();
        };

        plugin.displaySubtitles = function(el,params){
            displaySubtitles();
        };

        plugin.setVolume =  function(el, params){
            if(typeof params["volume"] == "undefined"){
                return false;
            }
            if(params["volume"] > 100 || params["volume"] < 0){
                return false;
            }
            params["volume"] = params["volume"] / 100;
            setVideoVolume(params["volume"]);
        };

        plugin.displayHelp = function(el,params){
            displayHelpWindow();
        };

        plugin.hideHelp = function(el,params){
            hideHelpWindow();
        };
        
        plugin.openTranscript = function(el,params){
            displayVideoTranscript();
        };

        plugin.construct();
    }

    $.fn.pwplayer = function(options, customParams) {
         return $(this).each(function() {
            if (undefined == $(this).data('pwplayer')) {
                if(typeof options == "undefined")
                    options = {};
                var plugin = new $.pwplayer(this, options);
                $(this).data('pwplayer', plugin);
            }

            if (typeof options === 'string') { 
                $(this).data('pwplayer')[options].call($(this),$(this),customParams);
            }

        });
    }
})(jQuery, window.App);