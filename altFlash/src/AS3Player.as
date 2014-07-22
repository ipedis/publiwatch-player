// by Ipedis Entreprise
// License: Creative Common 3.0 BY-SA <https://creativecommons.org/licenses/by-sa/3.0/legalcode>
package{
	import flash.display.*;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.*;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.errors.IOError;
	import flash.accessibility.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
    import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	
	import nl.inlet42.data.subtitles.SubTitleData;
	import nl.inlet42.data.subtitles.SubTitleParser;
	
	/**
	* Ceci est la classe principale du player AS3. Elle est liée au MovieClip situé sur la scène du fichier .fla.
	* 
	* <p>C'est aussi dans cette classe qu'on appelle les autres classes à utiliser pour le player</p>
	*/
	public class AS3Player extends MovieClip{
				
		private var myNetConnection:NetConnection;
		public var myNetStream:NetStream;
		private var myVideo:Video;
		
		private var videoUrl:String='';
		private var currentVideo:String='';
		public var videoWidth:uint=320; // les 2 données sont public, pour que la fonction .onMetaData puisse les remplir
		public var videoHeight:uint=240; // on met tout de même des valeurs par défaut
		
		public var myCommandBar:CommandBar;  //Pour lier à la classe
		public var mySubTitle:SubTitle;      //Pour lier à la classe
		public var myAide:Aide;              //Pour lier à la classe
		private var videoBackground:Sprite;
		
		private var video_mask:Sprite = new Sprite();
		
		//Variables des données pour le sous-titrage externe
		protected var _subtitles:Array;
		protected var _curSub:SubTitleData;
		
		public var videoDuration:Number=0;
		public var videoAutorun=false;
		
		public var myPlayIco:PlayIco;
		public var myPlayIco_shade:Sprite = new Sprite();
		private var myWarningSign:WarningSign;
		
		public var bool_pause:Boolean = true; //true = en pause
		public var bool_play_back:Boolean = false; //si le bouton play se comporte comme le bouton back, si customImagePreview != 0 
		
		//Variables contenant les différents messages d'erreur utilisés
		private var wrongServer_msg:String='';
		
		//flashvar relatif au transcript pdf
		public var pdfUrl:String='';
		public var pdfSize:String='';
		
		//flashvar du chemin pour l'audio description
		public var adUrl:String='';
		public var mp3Mode:Boolean;
		
		//image de preview
		public var videoImgURL:String='';
		public var myVideoImgURL:URLRequest = new URLRequest(videoImgURL);
		//conteneur de l'image de preview
		public var conteneurImage:Loader = new Loader();
		
		//Tête de lecture, pour l'image de preview de la vidéo (en secondes)
		public var customImagePreview:Number = 0;
		
		//flashvar du chemin de la vidéo HD
		public var videoUrlHD:String ='';

		//flashvar qui demande si on affiche le sous-titre ou pas
		public var is_subtitle:Boolean = true;
		
		//flashvar du chemin pour le sous-titrage SRT 
		public var stSrtUrl:String ='';
		
		//flashvar qui permet d'ajouter le share button
		public var is_shareBtn:Boolean = false;
		
		//flashvar qui permet d'avoir la fenêtre de partage automatiquement à la fin de la vidéo
		public var is_autoshare:Boolean = false;
		
		//flashvar qui permet de savoir si la barre de commande se masque automatiquement ou pas
		public var is_autohide:Boolean = false;
		
		//flashvar qui permet de savoir le délai avant la disparition de la barre de commande (si la fonction est activée)
		public var autohide_timer_ms:Number = 3000;
		
		//flashvar qui permet de savoir si le player se redimensionne automatiquement ou pas
		// si true, on ajoute des bandes noires.
		public var is_autoscale:Boolean = true;
		
		//flashvar qui permet de savoir si le player est équipé d'un bouton Aide ou pas
		public var is_aide:Boolean = true;
		
		//flashvar qui permet de savoir si le player est équipé d'un bouton full screen ou pas
		public var is_fullScreen:Boolean = true;
		
		//flashvar qui demande la langue du player
		public var player_lang:String = 'FRA';
		
		//flashvars des chemins des fichiers XML
		public var xmlAccueilURL:String = 'XML/Accueil.xml';
		public var xmlAccessibilityURL:String = 'XML/Accessibility.xml';
		public var xmlAideURL:String = 'XML/Aide.xml';
		public var xmlBulle_infoURL:String = 'XML/Bulle-info.xml';
		public var xmlUrlsURL:String = 'XML/urls.xml';
		
		//----------------- Parametres XITI ----------------------
		public static var fvA:String;
		public static var fvB:String;
		public static var fvC:String;
		public static var fvD:String;
		public static var fvE:String;
		public static var fvF:String;
		public static var fvG;
		public static var fvH:String;
		public static var fvI:String;
		public static var fvJ:String;
		public static var fvK:String;
		public static var fvL:String;
		public static var fvM:String;
		public static var fvN:String;
		
		/* Ajout pour lecture urls.xml */
		private var myXmlLoader:URLLoader;
		//Pour le fichier XML de sous-titrage
		public var myXmlLoaderSub:URLLoader;
		
		private var myErrorLoader:URLLoader;
		
		private var myErrorXML:XML;
		
		
		private var ap:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myPlayIco_main:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myPlayIco_shade:AccessibilityProperties = new AccessibilityProperties();
		private var acc_video_mask:AccessibilityProperties = new AccessibilityProperties();
		
		/**
		* Constructeur, il regroupe les fonctions principales du lecteur
		*/
		public function AS3Player(){
			
			stage.focus = this;
			this.tabEnabled = true;
			
			// Création du rectangle noir derrière la vidéo
			this.videoBackground = new Sprite();
			this.videoBackground.graphics.beginFill(0x000000);
			this.videoBackground.graphics.drawRect(0,0,MovieClip(root).stage.stageWidth,MovieClip(root).stage.stageHeight);
			this.addChild(this.videoBackground);
			
			if(loaderInfo.parameters.videoUrl != undefined){
				this.videoUrl = loaderInfo.parameters.videoUrl;
				
				var tab_urls_absolues:Array = new Array("http://", "https://", "www.", "www-");
				for(var i:uint=0; i<5; i++){
					if(videoUrl.match(tab_urls_absolues[i])){
						this.videoUrl = "La vidéo n'est pas présente sur le bon serveur";
					}
				}
				
				
			}
			// Quand le player se lance, la vidéo à lire sera la vidéo sans audio-descriptions
			this.currentVideo = this.videoUrl;
			
			if(loaderInfo.parameters.videoAutorun != undefined){
				if(loaderInfo.parameters.videoAutorun == 'true'){
					this.videoAutorun = true;
				}
				if(loaderInfo.parameters.videoAutorun == 'false'){
					this.videoAutorun = false;
				}
			}
			
			if(loaderInfo.parameters.is_autohide != undefined){
				if(loaderInfo.parameters.is_autohide == 'true'){
					this.is_autohide = true;
				}
				if(loaderInfo.parameters.is_autohide == 'false'){
					this.is_autohide = false;
				}
			}
			
			if(loaderInfo.parameters.is_subtitle != undefined){
				if(loaderInfo.parameters.is_subtitle == 'true'){
					this.is_subtitle = true;
				}
				if(loaderInfo.parameters.is_subtitle == 'false'){
					this.is_subtitle = false;
				}
			}
			
			if(loaderInfo.parameters.stSrtUrl != undefined){
				this.stSrtUrl = loaderInfo.parameters.stSrtUrl;
			}
			
			if(loaderInfo.parameters.is_autoscale != undefined){
				if(loaderInfo.parameters.is_autoscale == 'true'){
					this.is_autoscale = true;
				}
				if(loaderInfo.parameters.is_autoscale == 'false'){
					this.is_autoscale = false;
				}
			}
			
			if(loaderInfo.parameters.is_aide != undefined){
				if(loaderInfo.parameters.is_aide == 'true'){
					this.is_aide = true;
				}
				if(loaderInfo.parameters.is_aide == 'false'){
					this.is_aide = false;
				}
			}
			
			if(loaderInfo.parameters.is_fullScreen != undefined){
				if(loaderInfo.parameters.is_fullScreen == 'true'){
					this.is_fullScreen = true;
				}
				if(loaderInfo.parameters.is_fullScreen == 'false'){
					this.is_fullScreen = false;
				}
			}
			
			if(loaderInfo.parameters.autohide_timer_ms != undefined) {
				this.autohide_timer_ms = loaderInfo.parameters.autohide_timer_ms;
			}
			
			if(loaderInfo.parameters.pdfUrl != undefined){
				this.pdfUrl = loaderInfo.parameters.pdfUrl;
			}
			if(loaderInfo.parameters.pdfSize != undefined){
				this.pdfSize = loaderInfo.parameters.pdfSize;
			}
			if(loaderInfo.parameters.adUrl != undefined){
				this.adUrl = loaderInfo.parameters.adUrl;
			}
			
			if(loaderInfo.parameters.videoImgURL != undefined){
				this.videoImgURL = loaderInfo.parameters.videoImgURL;
				this.myVideoImgURL = new URLRequest(videoImgURL);	
			}
			
			if(loaderInfo.parameters.customImagePreview != undefined){
				this.customImagePreview = loaderInfo.parameters.customImagePreview;
			}
			
			if(loaderInfo.parameters.player_lang != undefined){
				this.player_lang = loaderInfo.parameters.player_lang;
			}
			
			//Parametres XITI
			fvA = loaderInfo.parameters.fvA;
			fvB = loaderInfo.parameters.fvB;
			fvC = loaderInfo.parameters.fvC;
			fvD = loaderInfo.parameters.fvD;
			fvE = loaderInfo.parameters.fvE;
			fvF = loaderInfo.parameters.fvF;
			fvG = loaderInfo.parameters.fvG;
			fvH = loaderInfo.parameters.fvH;
			fvI = loaderInfo.parameters.fvI;
			fvJ = loaderInfo.parameters.fvJ;
			fvK = loaderInfo.parameters.fvK;
			fvL = loaderInfo.parameters.fvL;
			fvM = loaderInfo.parameters.fvM;
			fvN = loaderInfo.parameters.fvN;

			
			if(loaderInfo.parameters.xmlAccueilURL != undefined){
				this.xmlAccueilURL = loaderInfo.parameters.xmlAccueilURL;
			}
			if(loaderInfo.parameters.xmlAccessibilityURL != undefined){
				this.xmlAccessibilityURL = loaderInfo.parameters.xmlAccessibilityURL;
			}
			if(loaderInfo.parameters.xmlAideURL != undefined){
				this.xmlAideURL = loaderInfo.parameters.xmlAideURL;
			}
			if(loaderInfo.parameters.xmlBulle_infoURL != undefined){
				this.xmlBulle_infoURL = loaderInfo.parameters.xmlBulle_infoURL;
			}
			if(loaderInfo.parameters.xmlUrlsURL != undefined){
				this.xmlUrlsURL = loaderInfo.parameters.xmlUrlsURL;
			}
			
			var myAccueilXML:XML;
			var myAccueilLoader:URLLoader = new URLLoader();
			myAccueilLoader.load(new URLRequest(this.xmlAccueilURL));
			myAccueilLoader.addEventListener(Event.COMPLETE, processAccueilXML);
			myAccueilLoader.addEventListener(IOErrorEvent.IO_ERROR, errorAccueilXML);
			
			

			// création de l'icone "play"
			this.myPlayIco = new PlayIco();
			this.addChild(this.myPlayIco);
			//Accessibilité du bouton PlayIco
			this.acc_myPlayIco_main.silent = true;
			this.myPlayIco.accessibilityProperties = acc_myPlayIco_main;
			this.myPlayIco.addEventListener(MouseEvent.CLICK, playIcoClicked);	
			
			// connect(null) pour utiliser une vidéo locale
            this.myNetConnection = new NetConnection();
            this.myNetConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            this.myNetConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            this.myNetConnection.connect(null);
			
			
			// Création de la barre de commande ==> Dans une autre classe
			var pdf:Boolean=false;
			if(this.pdfUrl != ''){
				pdf = true;
			}
			
			var ad:Boolean=false;
			if(this.adUrl != ''){
				ad = true;
			}
			
			var hd:Boolean=false;
			if(this.videoUrlHD != ''){
				hd = true;
			}
			var st:Boolean=false;
			if(this.is_subtitle == true){
				st = true;
			}
			var sh:Boolean=false;
			if(this.is_shareBtn == true){
				sh = true;
			}
			
			var aide:Boolean=false;
			if(this.is_aide == true){
				aide = true;
			}
			
			var fs:Boolean=true;
			if(this.is_fullScreen == false){
				fs = false;
			}
			
			var is_sub:Boolean=true;
			if(this.is_subtitle == false){
				is_sub = false;
			}
			
			//Création de la barre de commande
			this.myCommandBar = new CommandBar(this.videoAutorun, pdf, ad, st, sh, hd, fs, aide, is_sub, this.xmlAccessibilityURL, this.xmlBulle_infoURL);
			this.addChild(this.myCommandBar);
			this.setChildIndex(this.myCommandBar, this.numChildren-1);
				
			//Création des sous-titres (on passe en paramètre la largeur disponible) ==> Dans une autre classe
			this.mySubTitle = new SubTitle(MovieClip(root).stage.stageWidth);
			this.addChild(this.mySubTitle);
			
			//Création de l'aide
			this.myAide = new Aide(fs, ad, st, pdf, hd, sh, this.xmlAideURL);
			this.addChild(this.myAide);
			this.myAide.visible = false;
			//Pour ne pas qu'elle vienne au-dessus de la barre de commande
			this.setChildIndex(this.myAide, this.numChildren-3);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.myCommandBar.volumeClavier);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, closeWindows);
			
			
			/**
			* Masque la barre de commande après inactivité.
			*/
			if (this.is_autohide == true) {
				/**
				* Mise en place du Timer de la détection de la souris active ou pas.
				*/
				var myInactivityTimer:Timer=new Timer(this.autohide_timer_ms);
				myInactivityTimer.addEventListener(TimerEvent.TIMER,isIdle);
				myInactivityTimer.start();
				stage.addEventListener(MouseEvent.MOUSE_MOVE,resetTimer);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,resetTimer2);			
				
				/**
				* Lorsqu'un mouvement de souris est détecté, on relance le Timer.
				* La barre de commande est visible et la zone de sous-titrage est adéquatement positionnée.
				*/
				function resetTimer(event:MouseEvent):void {
					 myInactivityTimer.reset();
					 myInactivityTimer.start();
					 MovieClip(root).myAS3Player.myCommandBar.visible = true;
					 //MovieClip(root).myAS3Player.mySubTitle.y = MovieClip(root).stage.stageHeight - 1.75*MovieClip(root).myAS3Player.myCommandBar.height;
				}
				
				/**
				* Lorsque la touche TAB est appuyée, on relance le Timer.
				* La barre de commande est visible et la zone de sous-titrage est adéquatement positionnée.
				*/
				function resetTimer2(event:KeyboardEvent):void {
					if (event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 38 || event.keyCode == 39 || event.keyCode == 40 || event.ctrlKey) {
						 myInactivityTimer.reset();
						 myInactivityTimer.start();
						 MovieClip(root).myAS3Player.myCommandBar.visible = true;
						 //MovieClip(root).myAS3Player.mySubTitle.y = MovieClip(root).stage.stageHeight - 1.75*MovieClip(root).myAS3Player.myCommandBar.height;
					}
				}
	
				/**
				* Cette fonction se lance lorsque le Timer est écoulé et qu'aucune activité (déplacement souris / touche TAB) n'a été détectée.
				* On chache alors la barre de commande et on peut abaisser la zone de sous-titrage?
				*/
				function isIdle(event:TimerEvent):void {
					 //trace("Souris inactive");
					 myInactivityTimer.start();
					 MovieClip(root).myAS3Player.myCommandBar.visible = false;
					 //MovieClip(root).myAS3Player.mySubTitle.y = MovieClip(root).stage.stageHeight - MovieClip(root).myAS3Player.mySubTitle.height;
				}
			}

			
			stage.addEventListener(Event.RESIZE, resizePlayer);
			this.resizePlayer();
		} //Fin constructeur
		
		/**
		* Cette fonction se lance si l'ouverture du fichier "urls.xml" a réussi.
		* Une fois 'urls.xml' chargé, le code suivant commence par extraire la base de l'url sur lequel il se trouve (par exemple www.ipedis.com)
		* A partir de cette url, on calcule 'myCode' qui est son code correspondant
		* On parcours ensuite urls.xml
		*/
		private function urlXmlLoaded(myEvent:Event)
		{
			var myXML = XML(this.myXmlLoader.data);
			this.wrongServer_msg = myXML.errorMessage.wrongServer.(@lang==this.player_lang);
			
			// Récupération de la base de l'url à partir de l'url complète
			var loaderURL:String = loaderInfo.loaderURL;
				loaderURL = loaderURL.replace('http://','');
				loaderURL = loaderURL.replace('https://','');
				
			var myIndex = loaderURL.search('/');
			var myURL = loaderURL.slice(0,myIndex);
				
			// Calcul du code correspondant à l'url récupéré juste avant
			var myCode:int = 1;
			for(var i=0 ; i<myURL.length ; i++) myCode *= myURL.charCodeAt(i)+i;
			myCode = Math.abs(myCode);
			
			//Recherche de l'URL dans le XML
			var urlValid:Boolean = false;
			var relatedCode:int;
			for each(var num:XML in myXML.url)
			{
				for each(var num2:XML in num)
				{
					if(myURL == num2.value) 
					{
						urlValid = true;
						relatedCode = num2.code;
						break;
					}
				}
			}
			
			//Si l'url est valide vérifier le code sinon désactivé le player
			if(urlValid)
			{validateCode(relatedCode,myCode);}
			else
			{deactivatePlayer();}
		}
		
		private function validateCode(xml_code:int,computed_code:int):void
		{
			var codeValid:Boolean = false;
			
			if(xml_code != computed_code)
			{
				var tab_supercodes:Array = new Array(885347808,1061853734,972264604,174768384,151955622,966115456,
													 247136256,307778848,130235568,140608160,597859456,900857856);
				for each(var cod:int in tab_supercodes)
				{
					if(cod == xml_code)
					{
						codeValid = true;
						break;
					}
				}
			}
			else
			{
				codeValid = true;
			}
			
			//Si le code est valide Ok sinon désactiver le player
			if(!codeValid) {deactivatePlayer();}
			
		}
			
		private function deactivatePlayer()
		{
			this.desactive(this.wrongServer_msg);
			this.myCommandBar.pauseBtnClicked();
		}
		
		/**
		* Cette fonction se lance lorsque l'ouverture du fichier "urls.xml" a échoué.
		*/
		private function ioError(myError:IOErrorEvent){
			//this.desactive('Erreur avec l\'ouverture du fichier urls.xml');
			this.desactive('The file urls.xml is not found');
		}
		
		
		/**
		* Cette fonction se lance lorsque le code de sécurité présent dans le fichier urls.xml n'est pas valide.
		* Elle désactive aussi les écouteurs d'évènements des boutons du player.
		* textValue est le texte affiché pour expliquer la désactivation du player
		*/
		public function desactive(textValue:String=''){
			// Le code n'est pas valide ? on appelle la fonction desactive() de myCommandBar
			this.mySubTitle.setText(textValue);
			this.myWarningSign = new WarningSign();
			this.myWarningSign.alpha = 0.75;
			this.addChild(this.myWarningSign);
			this.myWarningSign.x = MovieClip(root).stage.stageWidth / 2;
			this.myWarningSign.y = (MovieClip(root).stage.stageHeight - this.myCommandBar.commandBarHeight)/ 2;
			this.removeChild(myPlayIco);
			this.removeChild(conteneurImage);
			this.myCommandBar.desactive();
			
			this.myPlayIco_shade.buttonMode = false;
			this.video_mask.buttonMode = true;
			this.myPlayIco_shade.removeEventListener(MouseEvent.CLICK, simulate_play_pause);
			this.video_mask.removeEventListener(MouseEvent.CLICK, simulate_play_pause);			
			this.removeChild(this.video_mask);
			this.removeChild(this.myPlayIco_shade);
			
			stage.removeEventListener(Event.RESIZE, resizePlayer);
			this.desactive_masks();
		}
		
		/**
		* Cette fonction replace tout les éléments du player en fonction de la place disponible
		*/
		public function resizePlayer(myEvent:Event=null){
			var rapportEcran:Number;
			var rapportVideo:Number;
			var largeurDispo:uint;
			var hauteurDispo:uint;
			
			largeurDispo = MovieClip(root).stage.stageWidth;
			hauteurDispo = MovieClip(root).stage.stageHeight;
			
			// On dit à la commandBar de se retailler
			this.myCommandBar.commandBarResize(largeurDispo, hauteurDispo);
			
			if(this.is_subtitle == true){
				this.mySubTitle.y = hauteurDispo - 45 - 28;
			}
			this.mySubTitle.width = largeurDispo;
			//this.mySubTitle.setTextWidth(MovieClip(root).stage.stageWidth);
			// il faut mettre les soustitres au 1er plan : (l'index le + grand s'affiche au dessus de tout les autres
			this.setChildIndex(this.mySubTitle, this.numChildren-1);
			
			this.videoBackground.x = 0;
			this.videoBackground.y = 0;
			this.videoBackground.width = largeurDispo;
			if(this.is_subtitle == true){
				this.videoBackground.height = hauteurDispo + this.myCommandBar.height;
			} else {
				this.videoBackground.height = hauteurDispo;
			}
			
			/* Calcul du ratio Hauteur/Largeur pour l'Ecran et la Video, puis placement de la vidéo.*/
			if(this.is_subtitle == true){
				rapportEcran = largeurDispo / ( hauteurDispo - this.myCommandBar.height);
			}else{
				rapportEcran = largeurDispo / hauteurDispo;
			}
			rapportVideo = this.videoWidth / this.videoHeight;
			
			
			if (this.is_autoscale == true) {
				if( rapportVideo < rapportEcran){
					// Dans ce cas, des bandes noires apparaîssent de chaque côtés de la vidéo, car elle n'est pas assez large pour occuper toute la largeur dispo
					if(this.is_subtitle == true){
						this.myVideo.height = hauteurDispo - this.myCommandBar.height; //60 est la hauteur de la barre de volume
						this.myVideo.width = this.myVideo.height * rapportVideo;
						this.myVideo.x = (largeurDispo - this.myVideo.width) / 2;
						this.myVideo.y = 0;
					} else {
						this.myVideo.height = hauteurDispo;
						this.myVideo.width = this.myVideo.height * rapportVideo;
						this.myVideo.x = (largeurDispo - this.myVideo.width) / 2;
						this.myVideo.y = 0;
					}
				}else{
					// Ici, les bandes noires apparaîssent en haut et en bas de la vidéo, car elle n'est pas assez haute
					this.myVideo.width = largeurDispo;
					this.myVideo.height = this.myVideo.width / rapportVideo;
					
					this.myVideo.x = 0;
					
					this.myVideo.y = (hauteurDispo - 35 + 60 - this.myVideo.height) / 2;				
				}
			}else{
				if(this.is_subtitle == true){
					this.myVideo.height = hauteurDispo; //On divise par 2 à cause du volume
				}else{
					this.myVideo.height = hauteurDispo;
				}
				this.myVideo.width = largeurDispo;
			}
			
			this.mySubTitle.width = this.myVideo.width - 40;
			this.mySubTitle.x = (largeurDispo - this.mySubTitle.width) / 2;
			this.myCommandBar.debugField.text = '';
			
			
			// placement de l'icone play
			this.myPlayIco.x = largeurDispo / 2;
			this.myPlayIco.y = (hauteurDispo - this.myCommandBar.height/2)/2;
			this.myAide.x = (stage.stageWidth / 2) - (this.myAide.myAideBackground.width/2); 
			this.myAide.y = (stage.stageHeight / 2) - (this.myAide.myAideBackground.height/2);

			this.conteneurImage.contentLoaderInfo.addEventListener(Event.COMPLETE, resizeImage);
			this.conteneurImage.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOresizeImage);
			
			//Une fois qu'on connait le positionnement et les dimentions de la vidéo, on applique un masque cliquable
			//this.video_mask_click();
		}
		
		private function video_mask_click():void{
			
			if(this.videoAutorun == false && this.myCommandBar.myPlayBtn.visible == true){			
			}
				
			this.video_mask.graphics.beginFill(0xFFFFFFF, 0);
			this.video_mask.graphics.drawRect(this.myVideo.x,this.myVideo.y,this.myVideo.width,this.myVideo.height);
			this.video_mask.graphics.endFill();
			this.video_mask.buttonMode = true;
			this.video_mask.tabEnabled = false;
			
			this.acc_video_mask.silent = true;
			this.video_mask.accessibilityProperties = acc_video_mask;
			
			
			this.video_mask.addEventListener(MouseEvent.CLICK, simulate_play_pause);

			//On remet l'icone play au dessus, ainsi que la barre de commande (pour la volume bar)
			this.setChildIndex(this.myPlayIco, this.numChildren - 1);
			this.setChildIndex(this.mySubTitle, this.numChildren - 2);
			this.setChildIndex(this.myCommandBar, this.numChildren -3);
			this.setChildIndex(this.myAide, this.numChildren -4);
			this.setChildIndex(this.video_mask, this.numChildren -5);
			this.setChildIndex(this.conteneurImage, this.numChildren -6);
		}
		
		private function set_myPlayIco_shade():void{
			this.myPlayIco_shade.graphics.clear();
			this.myPlayIco_shade.graphics.beginFill(0x000000); //0.5
			this.myPlayIco_shade.graphics.drawRect(0,this.myVideo.y,stage.stageWidth,this.myVideo.height);
			this.myPlayIco_shade.graphics.endFill();
			this.myPlayIco_shade.buttonMode = true;
			this.myPlayIco_shade.tabEnabled = false;
			this.myPlayIco_shade.alpha = 0;
			
			this.acc_myPlayIco_shade.silent = true;
			this.myPlayIco_shade.accessibilityProperties = acc_myPlayIco_shade;
			
			setTimeout(set_myPlayIco_shade_alpha, 750);
			this.myPlayIco_shade.addEventListener(MouseEvent.CLICK, simulate_play_pause);
		}
		
		private function set_myPlayIco_shade_alpha():void{
			this.myPlayIco_shade.alpha = 0.5;
		}
		
		private function simulate_play_pause(myEvent:MouseEvent):void{
			if(this.bool_pause == true){
				this.myCommandBar.playBtnClicked();
				this.bool_pause = false;
			} else{
				this.myCommandBar.pauseBtnClicked();
				this.bool_pause = true;
			}
		}
		
		private function desactive_masks(){
			this.removeChild(this.myPlayIco_shade);
			this.removeChild(this.video_mask);
			
		}
		
		// connectStream effectue la connection avec le flux vidéo
        private function connectStream():void {
            this.myNetStream = new NetStream(this.myNetConnection);
			this.myNetStream.client = new Object();
            this.myNetStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            this.myNetStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			var adUrlExtension:String = this.adUrl.slice(this.adUrl.length-3,this.adUrl.length); // On récupère les 3 derniers caractères
			if(adUrlExtension == 'mp3'){
				this.mp3Mode = true;
			}
			if(adUrlExtension == 'flv'){
				this.mp3Mode == false;
			}
			if(this.myVideo != null){
				removeChild(myVideo);
			}
            this.myVideo = new Video(this.videoWidth,this.videoHeight);
            this.myVideo.attachNetStream(this.myNetStream);
	        this.myNetStream.play(this.currentVideo);
			
			this.conteneurImage.load(myVideoImgURL);
			//On attend que l'image du loader soit entièrement chargée
			this.addChild(conteneurImage);
			//L'image de prévisualisation ne s'affiche pas au départ dans le cas ou l'autorun est activé
			this.conteneurImage.visible = false;
			
			this.myPlayIco.visible = false;
			// si l'autorun vaut faux, on met en pause la vidéo
			if(this.videoAutorun == false){
				this.myNetStream.seek(0);
				this.myNetStream.pause();
				if(this.videoImgURL == ''){
					setTimeout(this.customPreview, 1500);
				}
				
				this.conteneurImage.visible = true;
			}
            addChild(this.myVideo);
			
			
			this.setChildIndex(this.conteneurImage, this.numChildren-2); // -2 si playico
			
			// Cette fonction va gérer le chargement de la barre de progression
			this.addEventListener(Event.ENTER_FRAME, actualizeLoadedBar);
			
			if (this.is_subtitle == true /*|| this.stSrtUrl == '' || this.stSrtUrl == null*/){
				this.myNetStream.client.onCaption = function(captions:Object,speaker:Number):void{
						MovieClip(root).myAS3Player.mySubTitle.myTextField.text = captions.toString();
				}
			}
			
			if (this.is_subtitle == true && this.stSrtUrl != '' && this.stSrtUrl != null){
				charger_fichier_srt();
			}
			
			this.myNetStream.client.onMetaData = function(info:Object):void {
				// On enregistre la durée de la vidéo en sec dans une propriété de la classe AS3Player
				MovieClip(root).myAS3Player.videoDuration = info.duration;
				MovieClip(root).myAS3Player.videoWidth = info.width;
				MovieClip(root).myAS3Player.videoHeight = info.height;
				MovieClip(root).myAS3Player.resizePlayer();
				// On a récupéré les dimensions de la vidéo à lire ? il faut donc "resizer" le player pour qu'il prenne en compte ces nouvelles données
			}
        }
		
		
		private function charger_fichier_srt():void{
			var srt_loader:URLLoader = new URLLoader();
			srt_loader.addEventListener(Event.COMPLETE, srt_correctement_charge);
			srt_loader.addEventListener(IOErrorEvent.IO_ERROR, ioError_SRT);
			srt_loader.load(new URLRequest(this.stSrtUrl));
		}
		
		private function ioError_SRT(myError:IOErrorEvent):void{
			trace("Erreur du fichier de sous-titrage");
		}
		
		private function srt_correctement_charge(myEvent:Event):void{
			var srt_loader:URLLoader = myEvent.currentTarget as URLLoader;
			var data:String = String(srt_loader.data); //On convertit en string le contenu du srt
			_subtitles = SubTitleParser.parseSRT(data);
			ecouteur_sous_titrage_srt();
		}
		
		//On récupère en permanance le temps actuel pour synchroniser le sous-titrage SRT
		private function ecouteur_sous_titrage_srt():void{
			
			var temps_srt:Number=0;
			
			//On met un timer qui met à jour le temps de la vidéo toutes les 100ms
			var timer_srt:Timer = new Timer(100,0);
			timer_srt.addEventListener(TimerEvent.TIMER,synchroniser_srt);
					function synchroniser_srt(myEvent:TimerEvent) {
						temps_srt = MovieClip(root).myAS3Player.myNetStream.time;
						setSubTitle(getSubtitleAt(temps_srt));
					}
			timer_srt.start();		
		}
		
		//Fonction permettant de récupérer le bon sous-titrage en fonction du temps de la vidéo (passé en paramètre)
		protected function getSubtitleAt(seconds:Number):SubTitleData{
			if (_subtitles == null)
				return null;
				
			var sub:SubTitleData;
			for (var i:Number = 0; i < _subtitles.length; i++)
			{
				sub = _subtitles[i] as SubTitleData;
				
				if (sub.end < seconds)
					continue;
					
				else if (sub.start > seconds)
					return null;
					
				else if (sub.start < seconds && sub.end > seconds)
					return sub;
			}
			return null;
		}
		
		//Fonction permettant d'afficher le contenu de SubtitleData
		private function setSubTitle(sub:SubTitleData):void{
			_curSub = sub;
			
			if (_curSub != null)
			{
				this.mySubTitle.myTextField.text = _curSub.text;
			}
			else
			{
				this.mySubTitle.myTextField.text = " ";
			}
		}
		
		// 'actualizeLoadedBar' va être régulièrement appelée au début pour actualiser longueur de la barre de vidéo chargée, jusqu'à ce que toute la vidéo soit chargée
		private function actualizeLoadedBar(myEvent:Event=null){
			this.myCommandBar.myTimeBar.setLoadedBar( this.myNetStream.bytesLoaded / this.myNetStream.bytesTotal );
			if(this.myNetStream.bytesLoaded == this.myNetStream.bytesTotal){
				this.removeEventListener(Event.ENTER_FRAME, actualizeLoadedBar);
			}
		}
        private function securityErrorHandler(event:SecurityErrorEvent):void {
            this.myCommandBar.debugField.text = 'securityErrorHandler: ' + event;
        }
        private function asyncErrorHandler(event:AsyncErrorEvent):void {
            // ignore AsyncErrorEvent events.
        }
		private function netStreamError(myEvent:AsyncErrorEvent){
			//trace("Désynchronisation lors du chargement de la vidéo !");
		}
        private function netStatusHandler(event:NetStatusEvent):void {
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
				break;
                case "NetStream.Play.StreamNotFound":
					if(this.videoUrl == ''){
						//Affiche dans myTextFieldError
						this.mySubTitle.setText('The flashvar "videoUrl" is not set');
					}else{
						//Affiche dans myTextFieldError
						this.mySubTitle.setText('Video not found : ' + this.videoUrl);
					}
				break;
				case "NetStream.Play.Stop":
					this.myNetStream.pause();
					this.myNetStream.seek(0);
					this.mySubTitle.myTextField.text = '';
					this.mySubTitle.myTextFieldError.text = '';
					this.conteneurImage.visible = true;
					this.myCommandBar.myPlayBtn.visible = true;
					this.myCommandBar.myPauseBtn.visible = false;
					this.myCommandBar.myTimeBar.moveCursor(0);
					this.customPreview();
					
				default:
            }
        }
		
		private function playIcoClicked(myEvent:MouseEvent=null){
			// on lance la fonction playBtnClicked() de la barre de commande
			this.myCommandBar.playBtnClicked();
		}
		
		var mySound:Sound;
		var myChannel:SoundChannel = new SoundChannel();
		var myTransform:SoundTransform = new SoundTransform();
		
		/**
		* Fonction qui gère la lecture du mp3
		*/
		public function playmp3():void{
			mySound = new Sound();
			mySound.load(new URLRequest(adUrl));
			//On récupère le temps écoulé en lui ajoutant 1ms et en multipliant par 1000 pour convertir en ms
			myChannel = mySound.play((this.myNetStream.time+0.001)*1000);
			myChannel.soundTransform = myTransform;
		}
		
		/**
		* Fonction qui gère le volume du mp3
		* Le volume du son est le même que celui de la vidéo au moment du clic sur le bouton AD, puis se met à jour "en direct" 
		*/
		public function volumemp3():void{
			myChannel.soundTransform = myTransform;
		}
		
		/**
		* Fonction qui arrête la lecture du mp3
		*/
		public function stopmp3():void{
			myChannel.stop();
		}
		
		/**
		* Pour activer l'audio-description en mode mp3
		* Le fichier mp3 ne se lance pas si la vidéo n'est pas lancée
		*/
		public function adAudioOn(){
			//Si on est pas en pause
			if(this.bool_pause == false){
				playmp3();
			}
		}
		
		/**
		* Pour désactiver l'audio-description en mode mp3
		*/
		public function adAudioOff(){
				stopmp3();
		}
		
		/**
		* Pour activer l'audio-description en mode flv
		*/
		public function adVideoOn(){
			// Les 2 premires et la dernière lignes réinitialise le player : Boutton sur pause, barre de progression à 0, sous-titres effacés
			if(this.videoAutorun){
				this.myCommandBar.playBtnClicked();
			}else{
				this.myCommandBar.pauseBtnClicked();
			}
			this.mySubTitle.setText1('');
			this.myCommandBar.myTimeBar.moveCursor(0);
			this.currentVideo = this.adUrl;
			this.connectStream();
			this.setChildIndex(this.myCommandBar, this.numChildren-1);
			this.setChildIndex(this.myAide, this.numChildren-3);
		}
		
		/**
		* Pour désactiver l'audio-description en mode flv
		*/
		public function adVideoOff(){
			if(this.videoAutorun){
				this.myCommandBar.playBtnClicked();
			}else{
				this.myCommandBar.pauseBtnClicked();
			}
			this.mySubTitle.setText1('');
			this.myCommandBar.myTimeBar.moveCursor(0);
			this.currentVideo = this.videoUrl;
			this.connectStream();
			this.setChildIndex(this.myCommandBar, this.numChildren-1);
		}
		
		/**
		* Pour lancer la vidéo en HD
		*/
		public function hdVideoOn(){
			if(this.videoAutorun){
				this.myCommandBar.playBtnClicked();
			}else{
				this.myCommandBar.pauseBtnClicked();
			}
			this.mySubTitle.setText1('');
			this.myCommandBar.myTimeBar.moveCursor(0);
			this.currentVideo = this.videoUrlHD;
			this.connectStream();			
			this.setChildIndex(this.myCommandBar, this.numChildren-1);
			this.setChildIndex(this.myAide, this.numChildren-3);
		}
		
		/**
		* Pour remettre la vidéo en mode normal
		*/
		public function hdVideoOff(){
			if(this.videoAutorun){
				this.myCommandBar.playBtnClicked();
			}else{
				this.myCommandBar.pauseBtnClicked();
			}
			this.mySubTitle.setText1('');
			this.myCommandBar.myTimeBar.moveCursor(0);
			this.currentVideo = this.videoUrl;
			this.connectStream();
			this.setChildIndex(this.myCommandBar, this.numChildren-1);
		}
		
		/**
		* Cette fonction retourne le nombre de minutes et de secondes et complète avec des zéros si besoin.
		* Par exemple : AS3Player.formatTime(70); renvoie 01:10
		*/
		public static function formatTime(t:int):String {
			var s:int = Math.round(t);
			var m:int = 0;
			if (s > 0) {
				while (s > 59) {
					m++;
					s -= 60;
				}
				return String((m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
			} else {
				return "00:00";
			}
		}
		
		/**
		* Cette fonction redimmensionne l'image de preview une fois qu'elle est complètement chargée
		*/
		private function resizeImage(event:Event):void{
			if(this.is_subtitle == true){
				conteneurImage.width = MovieClip(root).stage.stageWidth;
				conteneurImage.height = this.myVideo.height;
			} else {
				conteneurImage.width = MovieClip(root).stage.stageWidth;
				conteneurImage.height = MovieClip(root).stage.stageHeight;
			}
		}
		
		private function IOresizeImage(myError:IOErrorEvent):void{
			trace("");
		}
		private function customPreview():void{
			this.bool_play_back = true;
			this.myNetStream.seek(this.customImagePreview);
		}
		
		private function moveCursorToZero(){
			this.myCommandBar.myTimeBar.moveCursor(1);
		}
		
		
		private function closeWindows(myEvent:KeyboardEvent):void{
			if(myEvent.keyCode == 27 && this.myAide.visible){
				this.myAide.visible = false;
				//La vidéo ne se lancera pas si l'on est au tout début
				if (this.myNetStream.time > 0.5) {
					this.myCommandBar.playBtnClicked();
				}
			}
		}
		
		private function processAccueilXML(myEvent:Event){
				var myAccueilXML = XML(myEvent.target.data);
				this.ap.name = myAccueilXML.texte.(@lang==this.player_lang);
				this.accessibilityProperties  = this.ap;
		}
		
		private function errorAccueilXML(myError:IOErrorEvent){
			trace("Erreur accueil.xml");
		}
		
	}
}