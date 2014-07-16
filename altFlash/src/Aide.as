package {
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;

	public class Aide extends MovieClip {

		public var myAideBackground:Sprite;
		private var myAideTitleField:TextField;
		private var aideText1:TextField;
		private var aideText2:TextField;
		private var aideText3:TextField;
		private var aideText4:TextField;
		private var aideText5:TextField;
		private var player_info1:TextField;
		private var player_info2:TextField;

		public var fermetureAide:SymboleFermetureAide;

		private var aideTabTemp:Array;
		private var aideTab:Array;
		

		private var aideTabTemp2:Array;
		private var aideTab2:Array;

		private var aideTextArray:Array = new Array();
		private var aideIconArray:Array = new Array();

		private var aideIconLoaderArray:Array = new Array();
		private var aideIconURLRequestArray:Array = new Array();

		public function Aide(fsVal, adVal, stVal, pdfVal, hdVal, shVal, aide_xml_param) {

			//Création et affichage de l'arrière-plan
			this.myAideBackground = new Sprite();
			this.myAideBackground.graphics.beginFill(0x666666);
			this.myAideBackground.graphics.drawRect(0,0,300,180);//x,y,largeur,hauteur
			this.myAideBackground.alpha = 0.85;
			this.addChild(this.myAideBackground);

			this.fermetureAide = new SymboleFermetureAide();
			this.fermetureAide.x = this.width - this.fermetureAide.width - 5;
			this.fermetureAide.y = 5;
			this.fermetureAide.buttonMode = true;
			this.fermetureAide.tabIndex = 10;
			this.myAideBackground.addChild(this.fermetureAide);
			this.fermetureAide.addEventListener(MouseEvent.CLICK, hideMyAideBackground);

			var format:TextFormat = new TextFormat();
			format.font = "Tahoma";
			format.color = 0xFFFFFF;
			format.size = 16;
			format.bold = true;
			format.align = "center";

			var format2:TextFormat = new TextFormat();
			format2.font = "Tahoma";
			format2.color = 0xFFFFFF;
			format2.size = 11;
			format2.align = "left";

			this.myAideTitleField = new TextField();
			this.myAideTitleField.autoSize = TextFieldAutoSize.NONE;
			this.myAideTitleField.selectable = false;
			this.myAideTitleField.multiline = true;
			this.myAideTitleField.wordWrap = true;
			this.myAideTitleField.text='';
			this.myAideTitleField.defaultTextFormat = format;
			this.myAideTitleField.height = 20;
			this.myAideTitleField.width = this.myAideBackground.width - this.fermetureAide.width - 5;
			this.addChild(this.myAideTitleField);


			//Player infos 1 et 2
			this.player_info1 = new TextField();
			this.player_info1.autoSize = TextFieldAutoSize.NONE;
			this.player_info1.selectable = false;
			this.player_info1.multiline = true;
			this.player_info1.wordWrap = true;
			this.player_info1.x = 10;
			this.player_info1.y = this.myAideBackground.height - 40;//125
			this.player_info1.height = 18;
			this.player_info1.width = this.myAideBackground.width - 10;
			this.player_info1.defaultTextFormat = format2;
			this.addChild(this.player_info1);

			this.player_info2 = new TextField();
			this.player_info2.autoSize = TextFieldAutoSize.NONE;
			this.player_info2.selectable = false;
			this.player_info2.multiline = true;
			this.player_info2.wordWrap = true;
			this.player_info2.x = 10;
			this.player_info2.y = this.myAideBackground.height - 25;//140
			this.player_info2.height = 18;
			this.player_info2.width = this.width;
			this.player_info2.defaultTextFormat = format2;
			this.addChild(this.player_info2);

			var myAideXML:XML;
			var myAideLoader:URLLoader = new URLLoader();
			myAideLoader.load(new URLRequest(aide_xml_param));
			myAideLoader.addEventListener(Event.COMPLETE, processAideXML);

			function processAideXML(myEvent:Event) {
				var myAideXML = XML(myEvent.target.data);
				myAideTitleField.text = myAideXML.title.(@lang==MovieClip(root).myAS3Player.player_lang);

				//Ici nous avons toutes les valeur succeptibles d'apparaître dans la fenêtre d'aide, de haut en bas
				this.aideTabTemp = new Array(fsVal, adVal, stVal, pdfVal, hdVal, shVal);
				this.aideTab = new Array();

				this.aideTabTemp2 = new Array(fsVal, adVal, stVal, pdfVal, hdVal, shVal);
				this.aideTab2 = new Array();

				//On récupère les textes du fichier XML, ainsi que le chemin des icones
				for (var i=0; i<myAideXML.list.btn.btn_name.length(); i++) {
					aideTextArray[i] = myAideXML.list.btn.btn_name.(@lang==MovieClip(root).myAS3Player.player_lang)[i];
					aideIconArray[i] = myAideXML.list.btn.btn_icon[i];
				}
				//On garde que les textes dont les boutons sont présents
				for (var t=0; t<this.aideTabTemp.length; t++) {
					if (this.aideTabTemp[t] == true) {
						this.aideTabTemp[t] = aideTextArray[t];
						this.aideTab.push(this.aideTabTemp[t]);
					}
					if (this.aideTabTemp2[t] == true) {
						this.aideTabTemp2[t] = aideIconArray[t];
						this.aideTab2.push(this.aideTabTemp2[t]);
					}
				}
				//On affiche les informations
				for (var j=0; j<this.aideTab.length; j++) {

					aideIconURLRequestArray[j] = new URLRequest(this.aideTab2[j]);
					aideIconLoaderArray[j] = new Loader();
					aideIconLoaderArray[j].load(aideIconURLRequestArray[j]);

					addChild(aideIconLoaderArray[j]);
					aideIconLoaderArray[j].x = 10;
					aideIconLoaderArray[j].y = 26*j + 30;

					var txtField:TextField = new TextField();
					txtField.defaultTextFormat = format2;
					txtField.selectable = false;
					txtField.text = this.aideTab[j];
					txtField.width = 75;
					txtField.autoSize = TextFieldAutoSize.LEFT;
					txtField.height = 18;
					txtField.x = 40;
					txtField.y = aideIconLoaderArray[j].y + 3;
					addChild(txtField);
				}
				player_info1.text = myAideXML.accessi_text.(@lang==MovieClip(root).myAS3Player.player_lang);
				player_info2.text = myAideXML.ipedis.(@lang==MovieClip(root).myAS3Player.player_lang);
			}

		}

		/**
		* Fonction lancée pour fermer la fenêtre d'aide
		*/
		private function hideMyAideBackground(myEvent:MouseEvent) {
			this.visible = false;
			//La vidéo ne se lancera pas si l'on est au tout début
			if (MovieClip(root).myAS3Player.myNetStream.time > 0.5) {
				MovieClip(root).myAS3Player.myCommandBar.playBtnClicked();
			}
		}
		

	}//Class
}//Package