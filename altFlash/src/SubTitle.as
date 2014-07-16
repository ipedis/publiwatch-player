package{
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	/**
	* Cette classe gère l'affichage du sous-titrage lorsqu'il est injecté dans la vidéo.
	*/
	public class SubTitle extends MovieClip{
		public var myTextField:TextField;
		public var myTextFieldError:TextField; //Pour les messages d'erreurs
				
		/**
		* Constructeur.
		* 
		* @param widthValue définit la largeur de la zone de sous-titrage.
		*/
		public function SubTitle(widthValue:uint){
			
			/**
			* Pour formater la zone de sous-titrage
			*/
			var format:TextFormat = new TextFormat();
			format.font = "Tahoma";
			format.color = 0xFFFFFF;
			format.size = 13.5;
			format.align = "center";
			
			//Errors
			var format2:TextFormat = new TextFormat();
			format2.font = "Courier New";
			format2.color = 0xFF0000;
			format2.size = 16;
			format2.bold = true;
			format2.align = "center";
			
			this.myTextField = new TextField();
			this.myTextField.autoSize = TextFieldAutoSize.NONE;
			this.myTextField.selectable = false;
			this.myTextField.multiline = true;
			this.myTextField.wordWrap = true;
			this.myTextField.defaultTextFormat = format;
			this.myTextField.width = 650;
			this.myTextField.height = 40;
			this.myTextField.text = '';
			this.addChild(this.myTextField);
			myTextField.backgroundColor = 0xFF0000;
			

			/**
			* Application du filtre de rayonnement (noir), pour améliorer la visibilité en cas de fond clair.
			*/
			var glow:GlowFilter = new GlowFilter();
			glow.color = 0x000000;
			glow.alpha = 1;
			glow.blurX = 5;
			glow.blurY = 5;
			glow.strength = 5;
			glow.quality = BitmapFilterQuality.MEDIUM;
			this.myTextField.filters = [glow];
			
			/**
			* Deuxième ligne de texte pour les messages d'erreur (on ne peut pas utiliser myTextField car dans le cas où les sous-titres 
			* sont désactivés, il faut tout de même afficher les message d'erreurs).
			*/
			this.myTextFieldError = new TextField();
			this.myTextFieldError.autoSize = TextFieldAutoSize.NONE;
			this.myTextFieldError.selectable = false;
			this.myTextFieldError.multiline = true;
			this.myTextFieldError.wordWrap = true;
			this.myTextFieldError.defaultTextFormat = format2;
			this.myTextFieldError.width = 640;
			this.myTextFieldError.height = 40;
			this.myTextFieldError.filters = [glow];
			this.myTextFieldError.text = '';
			this.addChild(this.myTextFieldError);
			
		}
		
		/**
		* 
		*/
		public function getText(){
			return this.myTextField.text;
		}
		
		/**
		* On remplit la zone de texte grâce au paramètre.
		* 
		* @param textValue On écrit ici le texte qui sera affiché dans la zone d'erreur.
		*/
		public function setText(textValue:String){
			this.myTextFieldError.text = textValue; //pour avoir le message d'erreur en cas de non-présence du sous-titrage
		}
		
		
		public function setText1(textValue:String){
			this.myTextField.text = textValue; 
		}
		
		/**
		* On donne une largeur à la zone de sous-titrage.
		* 
		* @param widthValue On donne la largeur de la zone de sous-titrage.
		*/
		public function setTextWidth(widthValue:uint){
			this.myTextField.width = widthValue;
			this.myTextFieldError.width = widthValue;
		}
	}
}