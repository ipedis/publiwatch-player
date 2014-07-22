// by Ipedis Entreprise
// Licence: Creative Common 3.0 BY-SA <https://creativecommons.org/licenses/by-sa/3.0/legalcode>
package{
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.media.SoundTransform;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.accessibility.*;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;	
	import flash.media.SoundTransform;
	import flash.external.ExternalInterface;


	/**
	* Ceci est la classe correspondant à la barre qui permet de contrôler la vidéo.
	* Elle s'affiche sous la vidéo, elle est appellée à partir de la classe principale.
	* <p>Dans cette classe, on définit les différents boutons à utiliser, on les positionne et on créé les évènements.</p>
	*/
	public class CommandBar extends Sprite{
		/**
		* Hauteur de la barre de commande : (variable utilisée dans les fonctions de redimentionnement)
		*/
		
		public var commandBarHeight:Number = 35; // 28(Barre) + 15(InfoBulle) ---> POUR MACIF 21 + 51
		
		/**
		* Les différents boutons.
		*/
		public var myPlayBtn			:	PlayBtn			; // public pour que la fonction stopDragCursor de la classe TimerBar puisse y accéder
		public var myPauseBtn			:	PauseBtn		;
		private var myMuteOnBtn			:	MuteOnBtn		;
		private var myMuteOffBtn		:	MuteOffBtn		;
		private var myFullScreenOnBtn	:	FullScreenOnBtn	;
		private var myFullScreenOffBtn	:	FullScreenOffBtn;
		private var myStOnBtn			:	StOnBtn			;
		private var myStOffBtn			:	StOffBtn		;
		public var myAdOnBtn			:	AdOnBtn			;
		public var myAdOffBtn			:	AdOffBtn		;
		private var myPdfBtn			:	PdfBtn			;
		private var myAideBtn           :   AideBtn         ;
		private var myShareBtn          :   ShareBtn		;
		private var myHdOnBtn           :	HdOnBtn			;
		private var myHdOffBtn          :	HdOffBtn		;
		
		/**
		* Les différents textes bulles pour les boutons initialisées
		*/
		private var myPlayBtn_text:String='';
		private var myPauseBtn_text:String='';
		private var myMuteOnBtn_text:String='';
		private var myMuteOffBtn_text:String='';
		private var myFullScreenOnBtn_text:String='';
		private var myFullScreenOffBtn_text:String='';
		private var myAdOnBtn_text:String='';
		private var myAdOffBtn_text:String='';
		private var myStOnBtn_text:String='';
		private var myStOffBtn_text:String='';
		private var myPdfBtn_text:String='';
		private var myAideBtn_text:String='';
		private var myShareBtn_text:String='';
		private var myHdOnBtn_text:String='';
		private var myHdOffBtn_text:String='';
		
		/**
		* Les valeurs d'accessibilités
		*/
		public var acc_myPlayIco_name:String=''; //public car accessible à partir d'une autre classe
		public var acc_myPlayIco_description:String=''; //public car accessible à partir d'une autre classe
		public var acc_myCursor_name:String='';
		public var acc_myCursor_description:String='';
		private var acc_myPlayBtn_name:String='';
		private var acc_myPlayBtn_description:String='';
		private var acc_myPauseBtn_name:String='';
		private var acc_myPauseBtn_description:String='';
		private var acc_myMuteOnBtn_name:String='';
		private var acc_myMuteOnBtn_description:String='';
		private var acc_myMuteOffBtn_name:String='';
		private var acc_myMuteOffBtn_description:String='';
		private var acc_myFullScreenOnBtn_name:String='';
		private var acc_myFullScreenOnBtn_description:String='';
		private var acc_myFullScreenOffBtn_name:String='';
		private var acc_myFullScreenOffBtn_description:String='';
		private var acc_myStOnBtn_name:String='';
		private var acc_myStOnBtn_description:String='';
		private var acc_myStOffBtn_name:String='';
		private var acc_myStOffBtn_description:String='';
		private var acc_myAdOnBtn_name:String='';
		private var acc_myAdOnBtn_description:String='';
		private var acc_myAdOffBtn_name:String='';
		private var acc_myAdOffBtn_description:String='';
		private var acc_myPdfBtn_name:String='';
		private var acc_myPdfBtn_description:String='';
		private var acc_myAideBtn_name:String='';
		private var acc_myAideBtn_description:String='';
		public var acc_fermetureAide_name:String='';
		public var acc_fermetureAide_description:String='';
		public var acc_fermetureShare_name:String='';
		public var acc_fermetureShare_description:String='';
		private var acc_myShareBtn_name:String='';
		private var acc_myShareBtn_description:String='';
		private var acc_myHdOnBtn_name:String='';
		private var acc_myHdOnBtn_description:String='';
		private var acc_myHdOffBtn_name:String='';
		private var acc_myHdOffBtn_description:String='';
		
		
		
		/**
		* On déclare les variables qui permettront d'affecter les valeurs d'accessibilité
		* PlayIco, FullScreen, Aide, + Astuces clic plein écran deviennet silent, pour ne pas être non étiquetés
		*/
		public var acc_myPlayIco:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myPlayBtn:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myPauseBtn:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myMuteOnBtn:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myMuteOffBtn:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myFullScreenOnBtn:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myFullScreenOffBtn:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myStOnBtn:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myStOffBtn:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myAdOnBtn:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myAdOffBtn:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myPdfBtn:AccessibilityProperties = new AccessibilityProperties();
		public var acc_myCursor:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myAideBtn:AccessibilityProperties = new AccessibilityProperties();
		public var acc_fermetureAide:AccessibilityProperties = new AccessibilityProperties();
		public var acc_fermetureShare:AccessibilityProperties = new AccessibilityProperties();
		private var acc_myShareBtn:AccessibilityProperties = new AccessibilityProperties();
				
		/**
		* C'est la barre de progression de la vidéo, on va utiliser la classe TimeBar 
		*/
		public var myTimeBar:TimeBar; // Pour lier à la classe
		
		/**
		* C'est la barre de volume, on va utiliser la classe VolumeBar
		*/
		public var myVolumeBar:VolumeBar; //Pour lier à la classe
		
		/**
		* Les barres latérales entre la timebar
		*/
		private var mySmallSideBarLeft:BarreLateraleBlanche;
		private var mySmallSideBarRight:BarreLateraleBlanche;
		
		
		/**
		* Ce champ texte contenant le temps écoulé de la vidéo
		*/
		public var myCurrentTimeTextField:TextField;
		//public var myTextField1:TextField;
		
		/**
		* Ce champ texte contenant le temps total de la vidéo
		*/
		public var myTotalTimeTextField:TextField;
		
		// Champ Texte d'info bulle
		private var myInfoBulle:TextField;
		//Arrière-plan de l'info bulle
		private var myInfoBulleBackground:SymboleInfoBulleBackground;
		
		// Fond
		private var myBackground:CommandBarBackground;
		private var myBackground2:Sprite;
		private var myTimeBarBackground:Sprite;
		
		//Tableaux de boutons incertains
		private var tabBtnsTemp:Array;
		private var tabBtns:Array;
		
		//Bidouille fullscreen + image preview
		private var boolFS:String = "0"; //0 = en mode normal
		
		//Volume en cours
		public var myCurrentVolume:Number = 1;
		
		
		/**
		* La barre de commande, qui s'adapte suivant les paramètres.
		* 
		* @param autorunVal est nécessaire pour savoir quel bouton afficher (play ou pause).
		* @param pdfVal pour savoir si le bouton du transcript sera présent ou pas.
		* @param adVal pour savoir si le bouton de l'audio-description sera présent ou pas.
		* @param stVal pour savoir si le bouton pour le sous-titrage sera présent ou pas.
		* @param hdVal pour savoir si le bouton pour la vidéo en HD sera présent ou pas.
		* @param fsVal pour savoir si le bouton mode plein écran sera présent ou pas.
		* @param aideVal pour savoir si le bouton d'aide sera présent ou pas.
		*/
		public function CommandBar(autorunVal:Boolean, pdfVal, adVal, stVal, shareVal, hdVal, fsVal, aideVal, is_subVal, accessi_xml_param, bulle_xml_param){			
			
			if(is_subVal){
				this.commandBarHeight = 35; 
			} else {
				this.commandBarHeight = 35;
			}
		
			// Création et affichage de l'arrière plan
			this.myBackground2 = new Sprite(); // Le 2ème arrière plan est celui des infos bulles
			this.myBackground2.graphics.beginFill(0x333333);
			this.myBackground2.graphics.drawRect(0,0,640, this.commandBarHeight);
			this.addChild(this.myBackground2);
			
			// myBackground est l'arrière plan des bouttons
			this.myBackground = new CommandBarBackground();
			this.addChild(this.myBackground);
			
			//myTimaBarBackground, par dessus myBackground
			this.myTimeBarBackground = new Sprite();
			this.myTimeBarBackground.graphics.beginFill(0x656E82);
			this.myTimeBarBackground.graphics.drawRect(0,0,640, this.myBackground.height);
			//this.addChild(this.myTimeBarBackground);			
			
			// Barre de progression (TimeBar) ==> Nouvelle classe
			this.myTimeBar = new TimeBar();
			this.addChild(this.myTimeBar);
			
			this.mySmallSideBarLeft = new BarreLateraleBlanche();
			this.mySmallSideBarLeft.y = 9;
			this.mySmallSideBarRight = new BarreLateraleBlanche();
			this.mySmallSideBarRight.y = 9;

			// Barre de volume(VolumeBar) ==> Nouvelle classe
			this.myVolumeBar = new VolumeBar();
			this.addChild(this.myVolumeBar);
			
			
			/**
			* Formatage du texte du temps écoulé (police, couleur, taille...).
			*/
			var format:TextFormat = new TextFormat();
			format.font = "Quadranta";
			//format.font = "Tahoma";
			format.color = 0xFFFFFF;
			format.size = 13;//11
			format.kerning = true;
			//format.bold = true;
			
			/**
			* Champ texte contenant le temps écoulé.
			*/
			this.myCurrentTimeTextField = new TextField();
			this.myCurrentTimeTextField.selectable = false;
			this.myCurrentTimeTextField.multiline = false;
			this.myCurrentTimeTextField.wordWrap = false;
			this.myCurrentTimeTextField.antiAliasType = AntiAliasType.ADVANCED;
			this.myCurrentTimeTextField.defaultTextFormat = format;
			this.myCurrentTimeTextField.width = 50
			this.myCurrentTimeTextField.height = 30;
			this.myCurrentTimeTextField.y = 7;
			this.myCurrentTimeTextField.text = '00:00';
			this.addChild(this.myCurrentTimeTextField);
			
			/**
			* Champ texte contenant le temps total de la vidéo.
			*/
			this.myTotalTimeTextField = new TextField();
			this.myTotalTimeTextField.autoSize = TextFieldAutoSize.NONE;
			this.myTotalTimeTextField.selectable = false;
			this.myTotalTimeTextField.multiline = false;
			this.myTotalTimeTextField.wordWrap = false;
			this.myTotalTimeTextField.defaultTextFormat = format;
			this.myTotalTimeTextField.width = 40
			this.myTotalTimeTextField.height = 30;
			this.myTotalTimeTextField.y = this.myCurrentTimeTextField.y;
			this.myTotalTimeTextField.text = '00:00';
			this.addChild(this.myTotalTimeTextField);
			
			/**
			* Formatage du texte des infos bulle.
			*/
			var format2:TextFormat = new TextFormat();
			format2.font = "Tahoma";
			format2.color = 0xFFFFFF;
			format2.size = 11;
			format2.leftMargin = 7;
			format2.rightMargin = 7;
			format2.kerning = true;
			format2.align = "center";
			
			/**
			* Arrière-plan des infos-bulles
			*/
			this.myInfoBulleBackground = new SymboleInfoBulleBackground();
			this.myInfoBulleBackground.y = -20;
			this.addChild(this.myInfoBulleBackground);
			this.myInfoBulleBackground.visible = false;
			
			/**
			* Champ texte pour les infos bulle.
			*/
			this.myInfoBulle = new TextField();
			this.myInfoBulle.defaultTextFormat = format2;
			this.myInfoBulle.autoSize = TextFieldAutoSize.CENTER;
			this.myInfoBulle.selectable = false;
			this.myInfoBulle.y = -20;
			this.myInfoBulle.text = '';
			this.addChild(this.myInfoBulle);
			this.myInfoBulle.visible = false;
			
			
			
			
			/**
			* Application du filtre de rayonnement, contour des info-bulles
			*/
			var glowBulle:GlowFilter = new GlowFilter();
			glowBulle.color = 0x656E82;
			glowBulle.alpha = 1;
			glowBulle.blurX = 2;
			glowBulle.blurY = 2;
			glowBulle.strength = 5;
			glowBulle.quality = BitmapFilterQuality.MEDIUM;
			
			/**
			* On créé les boutons
			*/
			this.myPlayBtn = new PlayBtn();
			this.myPauseBtn = new PauseBtn();
			this.myMuteOnBtn = new MuteOnBtn();
			this.myMuteOffBtn = new MuteOffBtn();
			
			/**
			* On les attache à la barre de commande
			*/
			this.addChild(this.myPlayBtn);
			this.addChild(this.myPauseBtn);
			this.addChild(this.myMuteOnBtn);
			this.addChild(this.myMuteOffBtn);
	
			// Dès qu'on cliquera sur un boutton, on appellera la fonction btnClicked
			// Ici les boutons toujours présents
			this.myPlayBtn.addEventListener(MouseEvent.CLICK, btnClicked);
			this.myPauseBtn.addEventListener(MouseEvent.CLICK, btnClicked);
			this.myMuteOnBtn.addEventListener(MouseEvent.CLICK, btnClicked);
			this.myMuteOffBtn.addEventListener(MouseEvent.CLICK, btnClicked);
			
			//On déclare un fichier xml pour les bulles d'aide dont le nom est imposé.
			var myBulleXML:XML;
			var myBulleLoader:URLLoader = new URLLoader();
			myBulleLoader.load(new URLRequest(bulle_xml_param));
			myBulleLoader.addEventListener(Event.COMPLETE, myBulleXMLLoaded);	
			myBulleLoader.addEventListener(IOErrorEvent.IO_ERROR, iomyBulleXMLLoaded);
			
			//On déclare un fichier xml pour les valeurs d'accessibilité dont le nom est imposé.
			var myAccessibilityXML:XML;
			var myAccessibilityLoader:URLLoader = new URLLoader();
			myAccessibilityLoader.load(new URLRequest(accessi_xml_param));
			myAccessibilityLoader.addEventListener(Event.COMPLETE, myAccessibilityXMLLoaded);
			myAccessibilityLoader.addEventListener(IOErrorEvent.IO_ERROR, iomyAccessibilityXMLLoaded);
						
			if(autorunVal){
				this.myPlayBtn.visible = false;
			}else{
				this.myPauseBtn.visible = false;
			}
			
			this.myMuteOnBtn.visible = false;
			
			
			// Sur les éléments de la barre de commande, on ajoute aussi des écouteurs d'évènements pour déplacer l'info bulle :
			this.myPlayBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
			this.myPauseBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
			this.myPlayBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
			this.myPauseBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
			this.myTimeBar.addEventListener(MouseEvent.MOUSE_OVER, timeBarMove);
			
			this.myPlayBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
			this.myPauseBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
			this.myTimeBar.addEventListener(MouseEvent.MOUSE_MOVE, timeBarMove);
			
			this.myPlayBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
			this.myPauseBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
			this.myPlayBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
			this.myPauseBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
			this.myTimeBar.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
			
			
			this.myMuteOnBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
			this.myMuteOffBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
			this.myMuteOnBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
			this.myMuteOffBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
			
			this.myMuteOnBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
			this.myMuteOffBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
			this.myMuteOnBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
			this.myMuteOffBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
			
			// La hauteur des bouttons ne changeant jamais, on la défini dans le constructeur
			this.myPlayBtn.y = 0;
			this.myPauseBtn.y = 0;
			this.myMuteOnBtn.y = 0;
			this.myMuteOffBtn.y = 0;
			
			
			// Si on a passé en flashvars une url vers un transcript
			if(pdfVal){
				this.myPdfBtn = new PdfBtn();
				this.addChild(this.myPdfBtn);
				this.myPdfBtn.addEventListener(MouseEvent.CLICK, btnClicked);
				this.myPdfBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				this.myPdfBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
				this.myPdfBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				this.myPdfBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
				this.myPdfBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
				this.myPdfBtn.y = 0;

				this.acc_myPdfBtn.name = "Afficher le transcript sur une autre page";
				this.acc_myPdfBtn.description = "";
				this.myPdfBtn.accessibilityProperties = this.acc_myPdfBtn;				
			}
			if(adVal){
				this.myAdOnBtn = new AdOnBtn();
				this.addChild(this.myAdOnBtn);
				this.myAdOnBtn.addEventListener(MouseEvent.CLICK, btnClicked);
				this.myAdOnBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				this.myAdOnBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
				this.myAdOnBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				this.myAdOnBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
				this.myAdOnBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
				this.myAdOnBtn.y = 0;
				
				this.myAdOffBtn = new AdOffBtn();
				this.addChild(this.myAdOffBtn);
				this.myAdOffBtn.addEventListener(MouseEvent.CLICK, btnClicked);
				this.myAdOffBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				this.myAdOffBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
				this.myAdOffBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				this.myAdOffBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
				this.myAdOffBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
				this.myAdOffBtn.y = 0;
				this.myAdOffBtn.visible = false;
				
				this.acc_myAdOnBtn.name = "Activer l'audio-description";
				this.acc_myAdOnBtn.description = "";
				this.myAdOnBtn.accessibilityProperties = this.acc_myAdOnBtn;
				
				this.acc_myAdOffBtn.name = "Désactiver l'audio-description";
				this.acc_myAdOffBtn.description = "";
				this.myAdOffBtn.accessibilityProperties = this.acc_myAdOffBtn;
			}
			
			if(stVal){
				this.myStOnBtn = new StOnBtn();
				this.addChild(this.myStOnBtn);
				this.myStOnBtn.addEventListener(MouseEvent.CLICK, btnClicked);
				this.myStOnBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				this.myStOnBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
				this.myStOnBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				this.myStOnBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
				this.myStOnBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
				this.myStOnBtn.y = 0;
				this.myStOnBtn.visible = false;
				
				this.myStOffBtn = new StOffBtn();
				this.addChild(this.myStOffBtn);
				this.myStOffBtn.addEventListener(MouseEvent.CLICK, btnClicked);
				this.myStOffBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				this.myStOffBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
				this.myStOffBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				this.myStOffBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
				this.myStOffBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
				this.myStOffBtn.y = 0;
				
				this.acc_myStOnBtn.name = "Activer le sous-titrage";
				this.acc_myStOnBtn.description = "";
				this.myStOnBtn.accessibilityProperties = this.acc_myStOnBtn;
				
				this.acc_myStOffBtn.name = "Désactiver le sous-titrage";
				this.acc_myStOffBtn.description = "";
				this.myStOffBtn.accessibilityProperties = this.acc_myStOffBtn;
			}
			
			if(shareVal){
				this.myShareBtn = new ShareBtn();
				this.addChild(this.myShareBtn);
				this.myShareBtn.addEventListener(MouseEvent.CLICK, btnClicked);
				this.myShareBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				this.myShareBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
				this.myShareBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				this.myShareBtn.y = 0;
			}
			
			if(hdVal){
				this.myHdOnBtn = new HdOnBtn();
				this.addChild(this.myHdOnBtn);
				this.myHdOnBtn.addEventListener(MouseEvent.CLICK, btnClicked);
				this.myHdOnBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				this.myHdOnBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
				this.myHdOnBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				this.myHdOnBtn.visible = false;
				this.myHdOnBtn.y = 0;
				
				this.myHdOffBtn = new HdOffBtn();
				this.addChild(this.myHdOffBtn);
				this.myHdOffBtn.addEventListener(MouseEvent.CLICK, btnClicked);
				this.myHdOffBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				this.myHdOffBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
				this.myHdOffBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				this.myHdOffBtn.y = 0;
				
				this.myHdOnBtn.scaleX = this.myHdOffBtn.scaleX = 0.7;
			}
			
			if (fsVal){
				this.myFullScreenOnBtn = new FullScreenOnBtn();
				this.addChild(this.myFullScreenOnBtn);
				this.myFullScreenOnBtn.addEventListener(MouseEvent.CLICK, btnClicked);
				this.myFullScreenOnBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				this.myFullScreenOnBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
				this.myFullScreenOnBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				this.myFullScreenOnBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
				this.myFullScreenOnBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
				this.myFullScreenOnBtn.y = 0;
				
				this.myFullScreenOffBtn = new FullScreenOffBtn();
				this.addChild(this.myFullScreenOffBtn);
				this.myFullScreenOffBtn.addEventListener(MouseEvent.CLICK, btnClicked);
				this.myFullScreenOffBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				this.myFullScreenOffBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
				this.myFullScreenOffBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				this.myFullScreenOffBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
				this.myFullScreenOffBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
				this.myFullScreenOffBtn.y = 0;
				this.myFullScreenOffBtn.visible = false;
				
				this.acc_myFullScreenOnBtn.name = "Mode plein écran";
				this.acc_myFullScreenOnBtn.description = "";
				this.myFullScreenOnBtn.accessibilityProperties = this.acc_myFullScreenOnBtn;
				
				this.acc_myFullScreenOffBtn.name = "Quitter le mode plein écran";
				this.acc_myFullScreenOffBtn.description = "";
				this.myFullScreenOffBtn.accessibilityProperties = this.acc_myFullScreenOffBtn;
			}
			
			if(aideVal){
				this.myAideBtn = new AideBtn();
				this.addChild(this.myAideBtn);
				this.myAideBtn.addEventListener(MouseEvent.CLICK, btnClicked);
				this.myAideBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
				this.myAideBtn.addEventListener(MouseEvent.MOUSE_MOVE, btnOver);
				this.myAideBtn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
				this.myAideBtn.addEventListener(FocusEvent.FOCUS_IN, btnOver);
				this.myAideBtn.addEventListener(FocusEvent.FOCUS_OUT, btnOut);
				this.myAideBtn.y = 0;
			}
			
			/**************
			VOCALISATION DES BOUTONS EN DUR, MAIS LES TEXTES DU XML PRENNENT LE DESSUS...
			Français et Anglais?
			***************/
			
			this.acc_myPlayIco.name = "Play";
			this.acc_myPlayIco.description = "Lire la vidéo";
			
			this.acc_myPlayBtn.name = "Play";
			this.acc_myPlayBtn.description = "Lire ou interrompre la vidéo";
			
			this.acc_myPauseBtn.name = "Pause";
			this.acc_myPauseBtn.description = "Lire ou interrompre la vidéo";
			
			this.acc_myMuteOffBtn.name = "Couper le son";
			this.acc_myMuteOffBtn.description = "Appuyez sur les touches ctrl + shift + page suivante ou précédente pour ajuster le volume";
			
			this.acc_myMuteOnBtn.name = "Activer le son";
			this.acc_myMuteOnBtn.description = "Appuyez sur les touches ctrl + shift + page suivante ou précédente pour ajuster le volume";
			
			this.myPlayBtn.accessibilityProperties = this.acc_myPlayBtn;
			this.myPauseBtn.accessibilityProperties = this.acc_myPauseBtn;
			this.myMuteOffBtn.accessibilityProperties = this.acc_myMuteOffBtn;
			this.myMuteOnBtn.accessibilityProperties = this.acc_myMuteOnBtn;
			
				
			this.addEventListener(Event.ENTER_FRAME, actualizeTimeBar);
			this.addEventListener(Event.ENTER_FRAME, checkScreenReader);
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, keepFocus);
			
		}
		
		private function checkScreenReader(myEvent:Event=null){
			if (Accessibility.active){
				
				this.myTimeBar.myCursor.tabEnabled = false;
				MovieClip(root).myAS3Player.myPlayIco.tabEnabled = false;
				
				if(this.myAdOnBtn != null){
					this.adOnBtnClicked();
				}
				if(this.myAideBtn != null){
					//this.myAideBtn.visible = false;
					this.acc_myAideBtn.silent = true;
					this.myAideBtn.tabEnabled = false;
					this.myAideBtn.accessibilityProperties = acc_myAideBtn;
					
					this.acc_fermetureAide.silent = true;
					MovieClip(root).myAS3Player.myAide.fermetureAide.accessibilityProperties = this.acc_fermetureAide;
				}
				if(this.myFullScreenOnBtn != null){
					this.acc_myFullScreenOffBtn.silent = true;
					this.acc_myFullScreenOnBtn.silent = true;
					this.myFullScreenOffBtn.tabEnabled = false;
					this.myFullScreenOnBtn.tabEnabled = false;
					
				}
				
				this.removeEventListener(Event.ENTER_FRAME, checkScreenReader);
			}
		}
		
		private function btnClicked(myEvent:MouseEvent=null){
			
			switch(myEvent.currentTarget.toString()){
				/* pour les cas PlayBtn et PauseBtn, on fait une appelle une fonction intermédiaire
				pour que ces fonctions puissent être appelées depuis la classe TimeBar, cela permet d'enlever
				l'évènement : this.addEventListener(Event.ENTER_FRAME, actualizeTimeBar); (ça évite un syntillement visuel) */
				
				case '[object PlayBtn]':
					this.playBtnClicked();
					AS3Player.fvD = "play";
					ExternalInterface.call("xt_rm", AS3Player.fvA , AS3Player.fvB , AS3Player.fvC , AS3Player.fvD , AS3Player.fvE , AS3Player.fvF , AS3Player.fvG , AS3Player.fvH , AS3Player.fvI , AS3Player.fvJ , AS3Player.fvK , AS3Player.fvL , AS3Player.fvM , AS3Player.fvN);
				break;
				
				case '[object PauseBtn]':
					this.pauseBtnClicked();
					AS3Player.fvD = "pause";
					ExternalInterface.call("xt_rm", AS3Player.fvA , AS3Player.fvB , AS3Player.fvC , AS3Player.fvD , AS3Player.fvE , AS3Player.fvF , AS3Player.fvG , AS3Player.fvH , AS3Player.fvI , AS3Player.fvJ , AS3Player.fvK , AS3Player.fvL , AS3Player.fvM , AS3Player.fvN);
				break;
				
				case '[object MuteOnBtn]':
					this.setVolume(1);
					this.myCurrentVolume = 1;
					this.myVolumeBar.myReadBarVol.width = this.myVolumeBar.myTotalBarVol.width;
					if (MovieClip(root).myAS3Player.mp3Mode == true && this.myAdOffBtn.visible == true){
						MovieClip(root).myAS3Player.myTransform.volume = 1;
						MovieClip(root).myAS3Player.volumemp3();
					}
				break;
				
				case '[object MuteOffBtn]':					
					this.setVolume(0);
					this.myCurrentVolume = 0;
					this.myVolumeBar.myReadBarVol.width = 0;
					
					if (MovieClip(root).myAS3Player.mp3Mode == true && this.myAdOffBtn.visible == true){
						MovieClip(root).myAS3Player.myTransform.volume = 0;
						MovieClip(root).myAS3Player.volumemp3();
					}
				break;
				
				case '[object FullScreenOnBtn]':
					stage.displayState = "fullScreen";
					this.myFullScreenOnBtn.visible = false;
					this.myFullScreenOffBtn.visible = true;
					MovieClip(root).myAS3Player.conteneurImage.width = MovieClip(root).stage.stageWidth;
					MovieClip(root).myAS3Player.conteneurImage.height = MovieClip(root).stage.stageHeight;
					ExternalInterface.call("xt_rm", AS3Player.fvA , AS3Player.fvB , AS3Player.fvC , AS3Player.fvD , AS3Player.fvE , AS3Player.fvF , AS3Player.fvG , AS3Player.fvH , AS3Player.fvI , AS3Player.fvJ , AS3Player.fvK , AS3Player.fvL , AS3Player.fvM , AS3Player.fvN);
				break;
				
				case '[object FullScreenOffBtn]':
					stage.displayState = "normal";
					this.myFullScreenOnBtn.visible = true;
					this.myFullScreenOffBtn.visible = false;
					MovieClip(root).myAS3Player.conteneurImage.width = MovieClip(root).stage.stageWidth;
					MovieClip(root).myAS3Player.conteneurImage.height = MovieClip(root).stage.stageHeight;
				break;
				
				case '[object StOnBtn]':
					MovieClip(root).myAS3Player.mySubTitle.visible = true;
					this.myStOnBtn.visible = false;
					this.myStOffBtn.visible = true;
				break;
				
				case '[object StOffBtn]':
					MovieClip(root).myAS3Player.mySubTitle.visible = false;
					this.myStOnBtn.visible = true;
					this.myStOffBtn.visible = false;
				break;
				
				case '[object PdfBtn]':
					this.pauseBtnClicked();
					ExternalInterface.call("xt_rm", AS3Player.fvA , AS3Player.fvB , AS3Player.fvC , AS3Player.fvD , AS3Player.fvE , AS3Player.fvF , AS3Player.fvG , AS3Player.fvH , AS3Player.fvI , AS3Player.fvJ , AS3Player.fvK , AS3Player.fvL , AS3Player.fvM , AS3Player.fvN);
					navigateToUrl(MovieClip(root).myAS3Player.pdfUrl);
				break;
				
				case '[object AdOnBtn]':
					this.adOnBtnClicked();
				break;
								
				case '[object AdOffBtn]':
					this.adOffBtnClicked();
				break;
				
				case '[object HdOnBtn]':
					this.myHdOnBtn.visible = false;
					this.myHdOffBtn.visible = true;
					MovieClip(root).myAS3Player.hdVideoOff();
				break;
				
				case '[object HdOffBtn]':
					this.myHdOnBtnClicked();
				break;
				
				case '[object ShareBtn]':
					this.shareBtnClicked();
				break;
				
				case '[object AideBtn]':
					this.aideBtnClicked();
				break;
				
				default:
					trace('objet non géré : ' + myEvent.currentTarget.toString());
			}
		}
		
		/**
		* Une fois le fichier XML chargé, on affecte les valeurs du XML dans des variables pour les utiliser
		*/
		private function myBulleXMLLoaded(myEvent:Event){
				var myBulleXML = XML(myEvent.target.data);
				this.myPlayBtn_text = myBulleXML.play.(@lang==MovieClip(root).myAS3Player.player_lang);
				this.myPauseBtn_text = myBulleXML.pause.(@lang==MovieClip(root).myAS3Player.player_lang);
				this.myMuteOnBtn_text = myBulleXML.muteOn.(@lang==MovieClip(root).myAS3Player.player_lang);
				this.myMuteOffBtn_text = myBulleXML.muteOff.(@lang==MovieClip(root).myAS3Player.player_lang);
				this.myFullScreenOnBtn_text = myBulleXML.fullscreenOn.(@lang==MovieClip(root).myAS3Player.player_lang);
				this.myFullScreenOffBtn_text = myBulleXML.fullscreenOff.(@lang==MovieClip(root).myAS3Player.player_lang);
				this.myAdOnBtn_text = myBulleXML.adOn.(@lang==MovieClip(root).myAS3Player.player_lang);
				this.myAdOffBtn_text = myBulleXML.adOff.(@lang==MovieClip(root).myAS3Player.player_lang);
				this.myStOnBtn_text = myBulleXML.stOn.(@lang==MovieClip(root).myAS3Player.player_lang);
				this.myStOffBtn_text = myBulleXML.stOff.(@lang==MovieClip(root).myAS3Player.player_lang);
				this.myPdfBtn_text = myBulleXML.pdf.(@lang==MovieClip(root).myAS3Player.player_lang);
				this.myAideBtn_text = myBulleXML.aide.(@lang==MovieClip(root).myAS3Player.player_lang);
		}
			
		private function iomyBulleXMLLoaded(myError:IOErrorEvent){
			//Erreurs
		}
		
		/**
		* Une fois le fichier XML chargé, on affecte les valeurs du XML dans des variables pour les utiliser
		*/
		private function myAccessibilityXMLLoaded(myEvent:Event){
			var myAccessibilityXML = XML(myEvent.target.data);
			//On affecte les valeurs du XML
			this.acc_myPlayIco_name = myAccessibilityXML.playIco_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myPlayIco_description = myAccessibilityXML.playIco_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myPlayBtn_name = myAccessibilityXML.play_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myPlayBtn_description = myAccessibilityXML.play_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myPauseBtn_name = myAccessibilityXML.pause_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myPauseBtn_description = myAccessibilityXML.pause_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myMuteOnBtn_name = myAccessibilityXML.muteOn_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myMuteOnBtn_description = myAccessibilityXML.muteOn_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myMuteOffBtn_name = myAccessibilityXML.muteOff_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myMuteOffBtn_description = myAccessibilityXML.muteOff_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myFullScreenOnBtn_name = myAccessibilityXML.fullscreenOn_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myFullScreenOnBtn_description = myAccessibilityXML.fullscreenOn_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myFullScreenOffBtn_name = myAccessibilityXML.fullscreenOff_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myFullScreenOffBtn_description = myAccessibilityXML.fullscreenOff_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myStOnBtn_name = myAccessibilityXML.subtitleOn_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myStOnBtn_description = myAccessibilityXML.subtitleOn_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myStOffBtn_name = myAccessibilityXML.subtitleOff_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myStOffBtn_description = myAccessibilityXML.subtitleOff_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myAdOnBtn_name = myAccessibilityXML.audioDescriptionOn_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myAdOnBtn_description = myAccessibilityXML.audioDescriptionOn_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myAdOffBtn_name = myAccessibilityXML.audioDescriptionOff_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myAdOffBtn_description = myAccessibilityXML.audioDescriptionOff_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myPdfBtn_name = myAccessibilityXML.transcript_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myPdfBtn_description = myAccessibilityXML.transcript_description.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_myAideBtn_name = myAccessibilityXML.aide_name.(@lang==MovieClip(root).myAS3Player.player_lang); 				
			this.acc_myAideBtn_description = myAccessibilityXML.aide_description.(@lang==MovieClip(root).myAS3Player.player_lang); 
			this.acc_fermetureAide_name = myAccessibilityXML.closeAide_name.(@lang==MovieClip(root).myAS3Player.player_lang);
			this.acc_fermetureAide_description = myAccessibilityXML.closeAide_description.(@lang==MovieClip(root).myAS3Player.player_lang);

			/**
			* Affectation des valeurs d'accessibilité
			*/
			
			this.acc_myPlayIco.name = this.acc_myPlayIco_name;
			this.acc_myPlayIco.description = this.acc_myPlayIco_description;
			this.acc_myPlayIco.silent = true;
			MovieClip(root).myAS3Player.myPlayIco.accessibilityProperties = this.acc_myPlayIco;
			
			this.acc_myPlayBtn.name = this.acc_myPlayBtn_name;
			this.acc_myPlayBtn.description = this.acc_myPlayBtn_description;
			this.myPlayBtn.accessibilityProperties = this.acc_myPlayBtn;
			
			this.acc_myPauseBtn.name = this.acc_myPauseBtn_name;
			this.acc_myPauseBtn.description = this.acc_myPauseBtn_description;
			this.myPauseBtn.accessibilityProperties = this.acc_myPauseBtn;
			
			this.acc_myMuteOffBtn.name = this.acc_myMuteOffBtn_name;
			this.acc_myMuteOffBtn.description = this.acc_myMuteOffBtn_description;
			this.myMuteOffBtn.accessibilityProperties = this.acc_myMuteOffBtn;
			
			this.acc_myMuteOnBtn.name = this.acc_myMuteOnBtn_name;
			this.acc_myMuteOnBtn.description = this.acc_myMuteOnBtn_description;
			this.myMuteOnBtn.accessibilityProperties = this.acc_myMuteOnBtn;
			
			if(this.myStOnBtn){
				this.acc_myStOnBtn.name = this.acc_myStOnBtn_name;
				this.acc_myStOnBtn.description = this.acc_myStOnBtn_description;
				this.myStOnBtn.accessibilityProperties = this.acc_myStOnBtn;
				
				this.acc_myStOffBtn.name = this.acc_myStOffBtn_name;
				this.acc_myStOffBtn.description = this.acc_myStOffBtn_description;
				this.myStOffBtn.accessibilityProperties = this.acc_myStOffBtn;
			}
			
			if(this.myAdOnBtn){
				this.acc_myAdOnBtn.name = this.acc_myAdOnBtn_name;
				this.acc_myAdOnBtn.description = this.acc_myAdOnBtn_description;
				this.myAdOnBtn.accessibilityProperties = this.acc_myAdOnBtn;
				
				this.acc_myAdOffBtn.name = this.acc_myAdOffBtn_name;
				this.acc_myAdOffBtn.description = this.acc_myAdOffBtn_description;
				this.myAdOffBtn.accessibilityProperties = this.acc_myAdOffBtn;
			}
			
			if(this.myPdfBtn){
				this.acc_myPdfBtn.name = this.acc_myPdfBtn_name;
				this.acc_myPdfBtn.description = this.acc_myPdfBtn_description;
				this.myPdfBtn.accessibilityProperties = this.acc_myPdfBtn;
			}
							
			this.acc_myFullScreenOnBtn.name = this.acc_myFullScreenOnBtn_name;
			this.acc_myFullScreenOnBtn.description = this.acc_myFullScreenOnBtn_description;
			this.acc_myFullScreenOnBtn.silent = true;
			this.myFullScreenOnBtn.accessibilityProperties = this.acc_myFullScreenOnBtn;
			
			this.acc_myFullScreenOffBtn.name = this.acc_myFullScreenOffBtn_name;
			this.acc_myFullScreenOffBtn.description = this.acc_myFullScreenOffBtn_description;
			this.acc_myFullScreenOffBtn.silent = true;
			this.myFullScreenOffBtn.accessibilityProperties = this.acc_myFullScreenOffBtn;
			
			this.acc_myAideBtn.name = this.acc_myAideBtn_name;
			this.acc_myAideBtn.description = this.acc_myAideBtn_description;
			this.acc_myAideBtn.silent = true;
			this.myAideBtn.accessibilityProperties = this.acc_myAideBtn; 
			
			this.acc_fermetureAide.name = this.acc_fermetureAide_name;
			this.acc_fermetureAide.description = this.acc_fermetureAide_description;
			this.acc_fermetureAide.silent = true;
			MovieClip(root).myAS3Player.myAide.fermetureAide.accessibilityProperties = this.acc_fermetureAide;	
		}
		
		private function iomyAccessibilityXMLLoaded(myError:IOErrorEvent){
			//Erreurs
		}
				
		// Cette fonction met à jour la position et le texte dans le champ texte réservé à l'info bulle
		private function btnOver(myEvent=null){
			switch(myEvent.currentTarget.toString()){
				case '[object PlayBtn]':
					this.myInfoBulle.text = this.myPlayBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object PauseBtn]':
					this.myInfoBulle.text = this.myPauseBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				break;
				case '[object MuteOnBtn]':
					this.myInfoBulle.text = this.myMuteOnBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object MuteOffBtn]':
					this.myInfoBulle.text = this.myMuteOffBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object FullScreenOnBtn]':
					this.myInfoBulle.text = this.myFullScreenOnBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object FullScreenOffBtn]':
					this.myInfoBulle.text = this.myFullScreenOffBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object StOnBtn]':
					this.myInfoBulle.text = this.myStOnBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object StOffBtn]':
					this.myInfoBulle.text = this.myStOffBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object TimeBar]':
					// pour la barre de progression, voir la fonction timeBarMove
				break;
				case '[object PdfBtn]':
					this.myInfoBulle.text = this.myPdfBtn_text +" "+ MovieClip(root).myAS3Player.pdfSize;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object AdOnBtn]':
					this.myInfoBulle.text = this.myAdOnBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object AdOffBtn]':
					this.myInfoBulle.text = this.myAdOffBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object HdOnBtn]':
					this.myInfoBulle.text = this.myHdOnBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object HdOffBtn]':
					this.myInfoBulle.text = this.myHdOffBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;
				case '[object AideBtn]':
					this.myInfoBulle.text = this.myAideBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;	
				case '[object ShareBtn]':
					this.myInfoBulle.text = this.myShareBtn_text;
					this.myInfoBulleBackground.visible = true;
					this.myInfoBulleBackground.width = this.myInfoBulle.width;
				break;	
				default:
					trace('objet non géré : ' + myEvent.currentTarget.toString());
			}
			
			// Calcul de la nouvelle valeur de x : myEvent.stageX - this.myInfoBulle.width/2
			// On fait un petit min/max pour éviter que l'info bulle ne déborde de l'écran..
			if(myEvent.type == MouseEvent.MOUSE_OVER || myEvent.type == MouseEvent.MOUSE_MOVE){
				this.myInfoBulle.x = Math.min( Math.max( myEvent.stageX - this.myInfoBulle.width / 2, 0 ), MovieClip(root).stage.stageWidth - this.myInfoBulle.width );
				this.myInfoBulleBackground.x = Math.min( Math.max( myEvent.stageX - this.myInfoBulleBackground.width/2, 0 ), MovieClip(root).stage.stageWidth - this.myInfoBulleBackground.width );
			}
			if (myEvent.type == FocusEvent.FOCUS_IN) {
				this.myInfoBulle.x = Math.min( Math.max( myEvent.currentTarget.x + myEvent.currentTarget.width/2 - this.myInfoBulle.width / 2, 0 ), MovieClip(root).stage.stageWidth - this.myInfoBulle.width );
				this.myInfoBulleBackground.x = Math.min( Math.max( myEvent.currentTarget.x + myEvent.currentTarget.width/2 - this.myInfoBulleBackground.width/2, 0 ), MovieClip(root).stage.stageWidth - this.myInfoBulleBackground.width );
			}
			
			if(this.myInfoBulle.visible == false){
				this.myInfoBulle.visible = true;
			}
			
			if(this.myInfoBulleBackground.visible == false){
				this.myInfoBulleBackground.visible = true;
			}
			
		}
		
		private function btnOut(myEvent=null){
			this.myInfoBulle.visible = false;
			this.myInfoBulleBackground.visible = false;
		}
		
		private function timeBarMove(myEvent:MouseEvent=null){
			// on calcule le tps correspondant à la position de la souris sur la barre de progression, que l'on met au format 00:00 avec formatTime
			this.myInfoBulle.text = AS3Player.formatTime(
				Math.round(
					(myEvent.stageX - this.myTimeBar.x) / this.myTimeBar.width * MovieClip(root).myAS3Player.videoDuration
				)
			);
			if(this.myInfoBulle.visible == false){
				this.myInfoBulle.visible = true;
				this.myInfoBulleBackground.visible = true;
				this.myInfoBulleBackground.width = this.myInfoBulle.width;
			}
			this.myInfoBulle.x = Math.min( Math.max( myEvent.stageX - this.myInfoBulle.width/2, 0 ), MovieClip(root).stage.stageWidth - this.myInfoBulle.width );
			this.myInfoBulleBackground.x = Math.min( Math.max( myEvent.stageX - this.myInfoBulleBackground.width/2, 0 ), MovieClip(root).stage.stageWidth - this.myInfoBulleBackground.width );
		}
		
		private function actualizeTimeBar(myEvent:Event=null){
			this.myTimeBar.moveCursor(MovieClip(root).myAS3Player.myNetStream.time / MovieClip(root).myAS3Player.videoDuration);
			this.myTotalTimeTextField.text = AS3Player.formatTime( MovieClip(root).myAS3Player.videoDuration);
			this.myCurrentTimeTextField.text = AS3Player.formatTime( MovieClip(root).myAS3Player.myNetStream.time);
		}
		
		// setVolume est utilisée pour régler le volume de la vidéo
		// le volume se règle entre 0 et 1
		public function setVolume(newVolume:Number){
			
			if(newVolume >= 0 && newVolume <= 1){
				
				var mySoundTransform = new SoundTransform(newVolume);
				MovieClip(root).myAS3Player.myNetStream.soundTransform	= mySoundTransform;
				
				MovieClip(root).myAS3Player.myTransform.volume = newVolume;
				MovieClip(root).myAS3Player.volumemp3();
				
				if(newVolume > 0) {
					this.myMuteOnBtn.visible = false;
					this.myMuteOffBtn.visible = true;
				} else {
					this.myMuteOnBtn.visible = true;
					this.myMuteOffBtn.visible = false;
				}
			}
		}
		
		/**
		* On positionne les différents boutons.
		*/
		public function commandBarResize(largeur:uint, hauteur:uint){
			if(stage.displayState == "normal"){
				this.myFullScreenOnBtn.visible = true;
				this.myFullScreenOffBtn.visible = false;
				if(this.boolFS == "1"){
					MovieClip(root).myAS3Player.conteneurImage.width = MovieClip(root).stage.stageWidth;
					MovieClip(root).myAS3Player.conteneurImage.height = MovieClip(root).stage.stageHeight;
					this.boolFS == "0";
				}
			}
			
			if(stage.displayState == "fullScreen") {
				this.boolFS = "1";
				this.myFullScreenOnBtn.visible = false;
				this.myFullScreenOffBtn.visible = true;	
				//MovieClip(root).myAS3Player.myPlayIco_shade.graphics.clear();
			}
			
			// Positionnement de la barre même :
			this.x = 0;
			this.y = hauteur - this.commandBarHeight;
			
			
			// Positionnement des bouttons de la barre de commande :
			this.myPlayBtn.x = 0;
			this.myPauseBtn.x = this.myPlayBtn.x; //Pause et Play sont superposés
			this.myCurrentTimeTextField.x = this.myPlayBtn.x + 55;
			this.mySmallSideBarLeft.x = this.myCurrentTimeTextField.x + 34;
			
			
			this.tabBtnsTemp = new Array(this.myFullScreenOnBtn, this.myPdfBtn, this.myAideBtn, this.myStOnBtn);							
										
			//Ici le deuxième tableau qui contient les boutons présents
			this.tabBtns = new Array();
			//On récupère seulement les boutons présents
			for (var t=0; t<this.tabBtnsTemp.length; t++){
				if(this.tabBtnsTemp[t] != null){
					this.tabBtns.push(this.tabBtnsTemp[t]);
				}
			}
			//On positionne les boutons
			for (var tt=0; tt<this.tabBtns.length; tt++){
				//Le premier bouton tout à droite, les suivants sont cote a cote, (largeur des boutons)
				tabBtns[0].x = largeur - tabBtns[0].width;
				if(tt!=0){
					tabBtns[tt].x = tabBtns[tt-1].x - 47;
				}
								
				this.myVolumeBar.x = tabBtns[tabBtns.length-1].x - this.myVolumeBar.width - 2;
				this.myVolumeBar.y = 0;
				
				this.myMuteOnBtn.x = myVolumeBar.x - this.myMuteOffBtn.width - 5;
				this.myMuteOffBtn.x = this.myMuteOnBtn.x;
				
				this.myTotalTimeTextField.x = this.myMuteOnBtn.x - 45;
				this.mySmallSideBarRight.x = this.myTotalTimeTextField.x - 7;
			}
			
			//On superpose les boutons on/off
			if (this.myStOnBtn != null){
				this.myStOffBtn.x = this.myStOnBtn.x;
			}
			if (this.myAdOnBtn != null){
				this.myAdOffBtn.x = this.myAdOnBtn.x;
			}
			if(this.myHdOffBtn != null){
				this.myHdOnBtn.x = this.myHdOffBtn.x;
			}
			if(this.myFullScreenOnBtn != null){
				this.myFullScreenOffBtn.x = this.myFullScreenOnBtn.x;
			}
			
			
			// La formule précédente est explicite, mais on peut la simplifier en enlevant "largeur" :
			this.myTimeBar.timeBarResize(this.mySmallSideBarLeft.x + 5, ( - this.mySmallSideBarLeft.x + this.mySmallSideBarRight.x - 5) );
			
			// Redimentionnement de l'arrière plan
			this.myBackground.width = largeur;
			this.myBackground2.width = largeur;
			
			//On redimmensionne la largeur de la barre au dessus de timebar
			this.myTimeBarBackground.x = this.myCurrentTimeTextField.x - 2;
			this.myTimeBarBackground.width = this.myTimeBar.width + this.myCurrentTimeTextField.width + this.myTotalTimeTextField.width + 4 + 4 + 7;			
			
		}
		
		/**
		* La fonction s'exécutant lors du clic sur le bouton Play.
		*/
		public function playBtnClicked(){
			MovieClip(root).myAS3Player.bool_pause = false;
			if (MovieClip(root).myAS3Player.mp3Mode == true && this.myAdOffBtn.visible == true){
				MovieClip(root).myAS3Player.playmp3();
			}
			
			if (MovieClip(root).myAS3Player.customImagePreview != 0 && MovieClip(root).myAS3Player.bool_play_back == true){
				MovieClip(root).myAS3Player.myNetStream.pause();
				MovieClip(root).myAS3Player.myNetStream.seek(0);
				MovieClip(root).myAS3Player.mySubTitle.myTextField.text = '';
				MovieClip(root).myAS3Player.mySubTitle.myTextFieldError.text = '';
				MovieClip(root).myAS3Player.bool_play_back = false;
			}
			
			MovieClip(root).myAS3Player.myNetStream.resume();
			MovieClip(root).myAS3Player.myPlayIco.visible = false;
			
			MovieClip(root).myAS3Player.myPlayIco_shade.alpha = 0;
			MovieClip(root).myAS3Player.conteneurImage.visible = false;
			this.myPlayBtn.visible = false;
			this.myPauseBtn.visible = true;
			MovieClip(root).myAS3Player.myAide.visible = false;
			this.addEventListener(Event.ENTER_FRAME, actualizeTimeBar);
		}
		
		/**
		* La fonction s'exécutant lors du click sur le bouton Pause.
		*/
		public function pauseBtnClicked(buttonChange:Boolean=true){
			MovieClip(root).myAS3Player.bool_pause = true;
			if (MovieClip(root).myAS3Player.mp3Mode == true && this.myAdOffBtn.visible == true){
				MovieClip(root).myAS3Player.stopmp3();
			}
			MovieClip(root).myAS3Player.myNetStream.pause();
			this.myPlayBtn.visible = true;
			this.myPauseBtn.visible = false;
			
			MovieClip(root).myAS3Player.myPlayIco_shade.alpha = 0.5;
			if(buttonChange){
				this.myPlayBtn.visible = true;
				this.myPauseBtn.visible = false;
			}
			this.removeEventListener(Event.ENTER_FRAME, actualizeTimeBar);
		}
		
		/**
		* La fonction s'éxécutant lors du clic sur le bouton share
		**/
		public function shareBtnClicked(){
				MovieClip(root).myAS3Player.myAide.visible = false;
				if (MovieClip(root).myAS3Player.myShare.visible == false){
					this.pauseBtnClicked();
					MovieClip(root).myAS3Player.myShare.visible = true;
					stage.focus = MovieClip(root).myAS3Player.myShare;	
					MovieClip(root).myAS3Player.tabIndex = -1;
					MovieClip(root).myAS3Player.myShare.fermetureShare.tabIndex = 20;
					
				}else{
					MovieClip(root).myAS3Player.myShare.visible = false;
					//On met en pause la vidéo seulement si la vidéo n'a pas été lancée
					if (MovieClip(root).myAS3Player.myNetStream.time > 0.5){
						this.playBtnClicked();
					} else {
					}
				}
		}
				
		/**
		* La fonction s'éxécutant lors du clic sur le bouton aide
		**/
		public function aideBtnClicked(){
			//MovieClip(root).myAS3Player.myShare.visible = false;
				if (MovieClip(root).myAS3Player.myAide.visible == false){
					this.pauseBtnClicked();
					MovieClip(root).myAS3Player.myPlayIco.visible = false;
					MovieClip(root).myAS3Player.myAide.visible = true;
					
				}else{
					MovieClip(root).myAS3Player.myAide.visible = false;
					//On met en pause la vidéo seulement si la vidéo n'a pas été lancée
					if (MovieClip(root).myAS3Player.myNetStream.time > 0.5){
						this.playBtnClicked();
					} else {
					}
				}
		}
		
		/**
		* La fonction s'éxécutant lors du clic sur le bouton adOn
		**/
		public function adOnBtnClicked(){
			this.myAdOnBtn.visible = false;
			this.myAdOffBtn.visible = true;
			
			if(MovieClip(root).myAS3Player.mp3Mode){
				MovieClip(root).myAS3Player.adAudioOn();
			}else{
				MovieClip(root).myAS3Player.adVideoOn();
			}
		}
		
		public function adOffBtnClicked(){
			this.myAdOnBtn.visible = true;
			this.myAdOffBtn.visible = false;
			
			if(MovieClip(root).myAS3Player.mp3Mode){
				MovieClip(root).myAS3Player.adAudioOff();
			}else{
				MovieClip(root).myAS3Player.adVideoOff();
			}
		}
		
		/**
		* La fonction s'éxécutant lors du clic sur le bouton hdOn
		**/
		public function myHdOnBtnClicked(){
			this.myHdOnBtn.visible = true;
			this.myHdOffBtn.visible = false;
			
			MovieClip(root).myAS3Player.hdVideoOn();
		}
		
		/**
		* Cette fonction se lance lorsque le code de sécurité présent dans le fichier urls.xml n'est pas valide.
		* Elle retire les écouteurs d'évènemets sur les différents boutons.
		*/
		public function desactive(){
			this.myPlayBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myPauseBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myMuteOnBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myMuteOffBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myFullScreenOnBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myFullScreenOffBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myStOnBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myStOffBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myAdOnBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myAdOffBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myPdfBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myAideBtn.removeEventListener(MouseEvent.CLICK, btnClicked);
			this.myTimeBar.desactive();
		}
		
		public function desactiveTabIndex(){
			this.myPlayBtn.tabIndex = -1;
			this.myPauseBtn.tabIndex = -1;
			this.myMuteOnBtn.tabIndex = -1;
			this.myMuteOffBtn.tabIndex = -1;
			this.myFullScreenOnBtn.tabIndex = -1;
			this.myFullScreenOffBtn.tabIndex = -1;
			this.myStOnBtn.tabIndex = -1;
			this.myStOffBtn.tabIndex = -1;
			this.myAdOnBtn.tabIndex = -1;
			this.myAdOffBtn.tabIndex = -1;
			this.myPdfBtn.tabIndex = -1;
			this.myHdOnBtn.tabIndex = -1;
			this.myHdOffBtn.tabIndex = -1;
			this.myShareBtn.tabIndex = -1;
			this.myAideBtn.tabIndex = -1;
			this.myTimeBar.myCursor.tabIndex = -1;
			MovieClip(root).myAS3Player.tabIndex = -1;
		}
		
		
		public function activeTabIndex(){
			this.myPlayBtn.tabIndex = 20;
			this.myPauseBtn.tabIndex = 20;
			this.myMuteOnBtn.tabIndex = 40;
			this.myMuteOffBtn.tabIndex = 40;
			this.myFullScreenOnBtn.tabIndex = 130;
			this.myFullScreenOffBtn.tabIndex = 130;
			this.myStOnBtn.tabIndex = 100;
			this.myStOffBtn.tabIndex = 100;
			this.myAdOnBtn.tabIndex = 110;
			this.myAdOffBtn.tabIndex = 110;
			this.myPdfBtn.tabIndex = 120;
			/*this.myVolumeOn25Btn.tabIndex = 50;
			this.myVolumeOn50Btn.tabIndex = 60;
			this.myVolumeOn75Btn.tabIndex = 70;
			this.myVolumeOn100Btn.tabIndex = 80;
			this.myVolumeOff25Btn.tabIndex = 50;
			this.myVolumeOff50Btn.tabIndex = 60;
			this.myVolumeOff75Btn.tabIndex = 70;
			this.myVolumeOff100Btn.tabIndex = 80;*/
			this.myShareBtn.tabIndex = 140;
			//this.myAideBtn.tabIndex = 150;
			this.myTimeBar.myCursor.tabIndex = 90;
			MovieClip(root).myAS3Player.tabIndex = 1;
		}
		
		
		public function volumeClavier(myEvent:KeyboardEvent){
			if(myEvent.ctrlKey && myEvent.shiftKey && myEvent.keyCode == 33){//ctrl + fleche haut
				trace("ctrl + shift + pageUp");
				this.myVolumeBar.myReadBarVol.width += 0.1*this.myVolumeBar.myTotalBarVol.width;
				if(this.myVolumeBar.myReadBarVol.width > this.myVolumeBar.myTotalBarVol.width){
					this.myVolumeBar.myReadBarVol.width = this.myVolumeBar.myTotalBarVol.width;
				}
				this.myCurrentVolume += 0.1;
				this.setVolume(myCurrentVolume);

				if(this.myVolumeBar.myCursorVol.y < this.myVolumeBar.myCursorVol100){
					this.myVolumeBar.myCursorVol.y = this.myVolumeBar.myCursorVol100;
					this.setVolume(1);
					this.myCurrentVolume = 1;
				}
				
			}
			if(myEvent.ctrlKey && myEvent.shiftKey && myEvent.keyCode == 34){//ctrl + fleche bas
				trace("ctrl + shift + pageDown");
				this.myVolumeBar.myReadBarVol.width -= 0.1*this.myVolumeBar.myTotalBarVol.width;
				this.myCurrentVolume -= 0.1;
				this.setVolume(myCurrentVolume);
				
				if(this.myVolumeBar.myReadBarVol.width == 0){
					this.myMuteOffBtn.visible = false;
					this.myMuteOnBtn.visible = true;
					this.setVolume(0);
					this.myCurrentVolume = 0;
				}
			}
		}
		
		private function keepFocus(myEvent:KeyboardEvent){
			if(myEvent.keyCode == 13 || myEvent.keyCode == 32){
			}
		}
		

		
		
		/**
		* Fonction appellée lors de l'ouverture du transcript sur une nouvelle page.
		*/
		public function navigateToUrl(url:String) {
			var request:URLRequest = new URLRequest(url);
			try {            
				navigateToURL(request,'_blank');
			}
			catch (e:Error) {
				MovieClip(root).myAS3Player.mySubTitle.myTextField.text = 'La page : '+url+' ne peut être affichée\n'+e.toString();
			}
		}
	}
}