// by Ipedis Entreprise
// License: Creative Common 3.0 BY-SA <https://creativecommons.org/licenses/by-sa/3.0/legalcode>
package{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.accessibility.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;	
	import flash.media.SoundTransform;
	
	/**
	* Classe qui permet de gérer le contrôle du volume grâce à un slider vertical
	*/
	public class VolumeBar extends MovieClip{
		public var myCursorVol:CursorVol;
		public var myReadBarVol:ReadBarVol;		// Volume actuel
		public var myTotalBarVol:TotalBarVol;		//Barre totale
		
		public var myCursorVol100:Number;
		public var myCursorVol0:Number;
		
		public var myVolumeBackground:VolumeBackground;
		
		public var pourcent:Number;
		
		
		/**
		* Constructeur
		*/
		public function VolumeBar(){
			this.myVolumeBackground = new VolumeBackground();
			addChild(this.myVolumeBackground);
			
			this.myCursorVol = new CursorVol();
			this.myReadBarVol = new ReadBarVol();
			this.myTotalBarVol = new TotalBarVol();
			
			this.myCursorVol.x = this.myVolumeBackground.width/2 - this.myCursorVol.width/2;
			this.myCursorVol.y = this.myVolumeBackground.height - ((this.myVolumeBackground.height - this.myTotalBarVol.height)/2) -  this.myTotalBarVol.height;
			this.myCursorVol100 = this.myCursorVol.y;
			this.myCursorVol0 = this.myVolumeBackground.height - ((this.myVolumeBackground.height - this.myTotalBarVol.height)/2) - this.myCursorVol.height;
			
			this.myReadBarVol.x = 0;
			this.myReadBarVol.y = this.myVolumeBackground.height/2 - (this.myReadBarVol.height/2); 
			this.myTotalBarVol.x = 0;
			this.myTotalBarVol.y = this.myVolumeBackground.height/2 - (this.myTotalBarVol.height/2); 
			
			this.myReadBarVol.alpha = 1.25; //Il faut rajouter 0.25 à cause de l'alpha de volumeBackground
			this.myTotalBarVol.alpha = 1.25;
			this.myCursorVol.alpha = 1.25;
			
			this.myVolumeBackground.addChild(this.myTotalBarVol);
			this.myVolumeBackground.addChild(this.myReadBarVol);
			
			this.myVolumeBackground.addEventListener(MouseEvent.MOUSE_DOWN, startDragCursorVol);
			this.myVolumeBackground.addEventListener(MouseEvent.MOUSE_UP, stopDragCursorVol);
			this.myVolumeBackground.addEventListener(MouseEvent.CLICK, dragCursorVol);
		}
			
			
			
			
		private function startDragCursorVol(myEvent:MouseEvent=null){
				MovieClip(root).myAS3Player.addEventListener(MouseEvent.MOUSE_UP, stopDragCursorVol);
				MovieClip(root).myAS3Player.addEventListener(MouseEvent.MOUSE_MOVE, dragCursorVol);
				this.addEventListener(MouseEvent.MOUSE_MOVE, dragCursorVol);
			}
		
		private function dragCursorVol(myEvent:MouseEvent=null){
			// on déplace le cursor soit parce que le clic est enfoncé (myEvent.buttonDown)
			// soit parce qu'on a cliqué (== MouseEvent.CLICK)
			if(myEvent.buttonDown || myEvent.type == MouseEvent.CLICK){
				
				pourcent = this.myTotalBarVol.mouseX;
				pourcent = pourcent/this.myTotalBarVol.width;
				trace("Pourcentage de la barre : " + pourcent);
				MovieClip(root).myAS3Player.myCommandBar.myCurrentVolume = pourcent;
				MovieClip(root).myAS3Player.myCommandBar.setVolume(MovieClip(root).myAS3Player.myCommandBar.myCurrentVolume);

				this.moveCursorVol(pourcent);
			}else{
				// si le clic est relaché, il faut arrêter de déplacer le curseur
				stopDragCursorVol(myEvent);
			}
		}
		
		
		private function stopDragCursorVol(myEvent:MouseEvent=null){
			MovieClip(root).myAS3Player.removeEventListener(MouseEvent.MOUSE_UP, stopDragCursorVol);
			MovieClip(root).myAS3Player.removeEventListener(MouseEvent.MOUSE_MOVE, dragCursorVol);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, dragCursorVol);
		}
		
		public function moveCursorVol(Val:Number){
			this.myReadBarVol.width = pourcent*this.myTotalBarVol.width;
			
			//La taille de la barre de volume actuel ne dépasse pas celle de la barre totale
			if(this.myReadBarVol.width > this.myTotalBarVol.width){
				this.myReadBarVol.width = this.myTotalBarVol.width;
			}

		}
			
			
			
			
			
			
			
			
		
	}
}