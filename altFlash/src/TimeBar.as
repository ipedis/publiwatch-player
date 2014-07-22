// by Ipedis Entreprise
// License: Creative Common 3.0 BY-SA <https://creativecommons.org/licenses/by-sa/3.0/legalcode>
package{
	import flash.display.*;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.accessibility.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;	
	import flash.media.SoundTransform;
	import flash.external.ExternalInterface;
	
	/**
	* Classe de la barre de progression. Elle ne s'appelle pas "ProgressBar" car c'est un mot clé d'ActionScript.
	*/
	public class TimeBar extends Sprite{
		private var myLoadedBar:LoadedBar;	// lu
		private var myReadBar:ReadBar;		// chargée
		private var myTotalBar:TotalBar;	// longueur totale même si non chargée
		public var myCursor:Cursor;
		public var acc_myCursor:AccessibilityProperties = new AccessibilityProperties();
		
		/**
		* Constructeur 
		*/
		public function TimeBar(){
			this.y = 9;
			
			this.myLoadedBar = new LoadedBar();
			this.myReadBar = new ReadBar();
			this.myTotalBar = new TotalBar();
			this.myCursor = new Cursor();
			
			acc_myCursor.silent = true;
			this.myCursor.accessibilityProperties = acc_myCursor;
			
			this.addChild(this.myTotalBar);
			this.addChild(this.myLoadedBar);
			this.addChild(this.myReadBar);
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, moveKeyCursor);
			this.addEventListener(KeyboardEvent.KEY_DOWN, containerKeyDown);
			this.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, focusChange);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, startDragCursor);
			this.addEventListener(MouseEvent.MOUSE_UP, stopDragCursor);
			this.addEventListener(MouseEvent.CLICK, dragCursor2);
		}
		
		
		var tabDown:Boolean = false;
		/**
		* On intercepte l'appui sur touche "Tab".
		*/
		private function containerKeyDown(myEvent:KeyboardEvent):void {
			if (myEvent.keyCode == 9) {
				tabDown = true;
			}else {
				tabDown = false;
			}
		}
		
		/**
		* Cette fonction permet aux touches flèches de ne pas modifier le focus lorsqu'il est sur le curseur.
		*/
		private function focusChange(myEvent:FocusEvent):void {
			if (tabDown) { return;}
			myEvent.preventDefault(); //preventDefault permet d'annuler un évènement.
		}
		
		/**
		* Lorsque le focus est sur le curseur, on peut le déplacer avec les flèches sans déplacer le focus
		* (Ne fonctionne pas avec JAWS...). (Haut, bas, gauche, droite)
		*/
		private function moveKeyCursor(myEvent:KeyboardEvent){
			if (myEvent.keyCode == 38) {
				MovieClip(root).myAS3Player.myNetStream.seek(MovieClip(root).myAS3Player.myNetStream.time + 3);
					if (MovieClip(root).myAS3Player.mp3Mode == true && MovieClip(root).myAS3Player.myCommandBar.myAdOffBtn.visible == true){
						MovieClip(root).myAS3Player.stopmp3();
						MovieClip(root).myAS3Player.playmp3();
					}
			}
			else if (myEvent.keyCode == 40) {
				MovieClip(root).myAS3Player.myNetStream.seek(MovieClip(root).myAS3Player.myNetStream.time - 3);
					if (MovieClip(root).myAS3Player.mp3Mode == true && MovieClip(root).myAS3Player.myCommandBar.myAdOffBtn.visible == true){
						MovieClip(root).myAS3Player.stopmp3();
						MovieClip(root).myAS3Player.playmp3();
					}
			}
			else if (myEvent.keyCode == 37) {
				MovieClip(root).myAS3Player.myNetStream.seek(MovieClip(root).myAS3Player.myNetStream.time - 5);
					if (MovieClip(root).myAS3Player.mp3Mode == true && MovieClip(root).myAS3Player.myCommandBar.myAdOffBtn.visible == true){
						MovieClip(root).myAS3Player.stopmp3();
						MovieClip(root).myAS3Player.playmp3();
					}
			}
			else if (myEvent.keyCode == 39) {
				MovieClip(root).myAS3Player.myNetStream.seek(MovieClip(root).myAS3Player.myNetStream.time + 5);
					if (MovieClip(root).myAS3Player.mp3Mode == true && MovieClip(root).myAS3Player.myCommandBar.myAdOffBtn.visible == true){
						MovieClip(root).myAS3Player.stopmp3();
						MovieClip(root).myAS3Player.playmp3();
					}
			}
		}
		
		private function startDragCursor(myEvent:MouseEvent=null){
			// c'est plus agréable si on met la vidéo en pause pendant le le clic est enfoncé
			MovieClip(root).myAS3Player.myCommandBar.pauseBtnClicked(false); 
			MovieClip(root).myAS3Player.myPlayIco.visible = false;
			MovieClip(root).myAS3Player.addEventListener(MouseEvent.MOUSE_UP, stopDragCursor);
			MovieClip(root).myAS3Player.addEventListener(MouseEvent.MOUSE_MOVE, dragCursor);
			this.addEventListener(MouseEvent.MOUSE_MOVE, dragCursor);
		}
		
		private function dragCursor(myEvent:MouseEvent=null){
			// on déplace le cursor soit parce que le clic est enfoncé (myEvent.buttonDown)
			// soit parce qu'on a cliqué (== MouseEvent.CLICK)
			if(myEvent.buttonDown || myEvent.type == MouseEvent.CLICK){
				var percent:Number = (myEvent.stageX - this.x) / this.width;
				percent = Math.max( Math.min( percent, 1 ), 0);
				this.moveCursor( percent );
				
				MovieClip(root).myAS3Player.myNetStream.seek( percent * MovieClip(root).myAS3Player.videoDuration );
				MovieClip(root).myAS3Player.myCommandBar.myCurrentTimeTextField.text = AS3Player.formatTime( percent * MovieClip(root).myAS3Player.videoDuration );
				
			}else{
				// si le clic est relaché, il faut arrêter de déplacer le curseur
				stopDragCursor(myEvent);
			}
		}
		
		private function dragCursor2(myEvent:MouseEvent=null){ 
			MovieClip(root).myAS3Player.myPlayIco.visible = false;
			MovieClip(root).myAS3Player.bool_pause = true;
			MovieClip(root).myAS3Player.stopmp3();
			
			var percent:Number = (myEvent.stageX - this.x) / this.width;
				percent = Math.max( Math.min( percent, 1 ), 0);
			this.moveCursor( percent );
			MovieClip(root).myAS3Player.myNetStream.seek( percent * MovieClip(root).myAS3Player.videoDuration );
			MovieClip(root).myAS3Player.myCommandBar.myCurrentTimeTextField.text = AS3Player.formatTime( percent * MovieClip(root).myAS3Player.videoDuration );
			
			MovieClip(root).myAS3Player.removeEventListener(MouseEvent.MOUSE_UP, stopDragCursor);
			MovieClip(root).myAS3Player.removeEventListener(MouseEvent.MOUSE_MOVE, dragCursor);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, dragCursor);
			
			if(MovieClip(root).myAS3Player.myCommandBar.myPlayBtn.visible == false){
				MovieClip(root).myAS3Player.myCommandBar.playBtnClicked();
			}
		}
		
		private function stopDragCursor(myEvent:MouseEvent=null){
			MovieClip(root).myAS3Player.removeEventListener(MouseEvent.MOUSE_UP, stopDragCursor);
			MovieClip(root).myAS3Player.removeEventListener(MouseEvent.MOUSE_MOVE, dragCursor);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, dragCursor);
			
			ExternalInterface.call("xt_rm", AS3Player.fvA , AS3Player.fvB , AS3Player.fvC , AS3Player.fvD , AS3Player.fvE , AS3Player.fvF , AS3Player.fvG , AS3Player.fvH , AS3Player.fvI , AS3Player.fvJ , AS3Player.fvK , AS3Player.fvL , AS3Player.fvM , AS3Player.fvN);
						
			if (MovieClip(root).myAS3Player.mp3Mode == true && MovieClip(root).myAS3Player.myCommandBar.myAdOffBtn.visible == true){
				var percent:Number = (myEvent.stageX - this.x) / this.width;
					percent = Math.max( Math.min( percent, 1 ), 0); //ratio de la position du curseur de la vidéo entre 0 et 1
				var dureeMP3:Number = MovieClip(root).myAS3Player.mySound.length;
					trace (AS3Player.formatTime(dureeMP3/1000)+" est la durée totale du MP3");
					trace (AS3Player.formatTime(percent*dureeMP3/1000) + " = Position du MP3 à lire");
			}
			
			//dragCursor(myEvent);
			
			if(MovieClip(root).myAS3Player.myCommandBar.myPlayBtn.visible == false){
				MovieClip(root).myAS3Player.myCommandBar.playBtnClicked();
			}
		}
		
		/**
		* Cette fonction évite que le curseur puisse être placé en dehors de la barre de progression
		* <p>Il faut prendre le max entre la valeur trouvé et 0 et le min entre la valeur trouvé et la largeur de la barre de progression.
		* <br />(Cela dit on fait déjà un min/max sur le percent dans dragCursor)</p>
		*/
		public function moveCursor(Val:Number){
			this.myCursor.x = Math.min( Math.max( Val * (this.myTotalBar.width - this.myCursor.width), 0 ), this.myTotalBar.width - this.myCursor.width );
			this.myReadBar.width = this.myCursor.x + this.myCursor.width/2;
		}
		
		public function setLoadedBar(Val:Number){
			this.myLoadedBar.width = Val * this.myTotalBar.width;
		}
		
		/**
		* Cette fonction sert à redimmensionner la barre de progression
		*/
		public function timeBarResize(xVal:uint, largeurVal:uint){
			/**
			* tmp sert à sauvegarder le rapport de longueur entre la barre de vidéo chargée et la barre totale,
			* et conserver ce rapport après redimentionnement du player
			*/
			var tmp:Number;
			/**
			* tmp2 sert à la même chose mais pour garder le ratio entre le curseur et la barre de vidéo lue.
			*/
			var tmp2:Number;
			this.x = xVal;
			
			/* Exemple:
			- Avant de redimentionner, le curseur se trouve à la moitié de la barre de progression
			- On calcule alors le ratio, tmp2 vaut alors 0.5, soit 50%
			- On donne la nouvelle dimension à myTotalBar (qui vaut largeurVal reçu en paramètre)
			- et le curseur se positionne à 50% de la nouvelle longueur de myTotalBar
			*/
			
			// on calcule d'abord les ratios
			tmp = this.myLoadedBar.width / this.myTotalBar.width;
			tmp2 = this.myCursor.x / this.myTotalBar.width;
			
			// on peut ensuite redimentionner
			this.myTotalBar.width = largeurVal;
			this.myLoadedBar.width = tmp * this.myTotalBar.width;
			this.myCursor.x = tmp2 * this.myTotalBar.width;
			this.myReadBar.width = this.myCursor.x + this.myCursor.width/2;
		}
		
		/**
		* Cette fonction se lance lorsque le code de sécurité présent dans le fichier urls.xml n'est pas valide.
		*/
		public function desactive(){
			this.removeEventListener(MouseEvent.MOUSE_DOWN, startDragCursor);
			this.removeEventListener(MouseEvent.MOUSE_UP, stopDragCursor);
			this.removeEventListener(MouseEvent.CLICK, dragCursor);
		}
	}
}