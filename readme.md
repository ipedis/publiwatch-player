# PubliWatch Player
#### Player vidéo accessible

## Exemple d'intégration

Intégrer la balise `<video>` de manière habituelle, en lui définissant un ID et une largeur ainsi qu'une hauteur.
Définir les chemins des vidéos avec la balise <source>. Définir le fichier de sous-titrage avec la balise track. 

Initialiser le plugin en appelant la méthode pwplayer() à partir de l'ID de la balise `<video>`.

#### Code HTML :
```
<video id="player1" width="950" height="450">
    <source type="video/mp4" src="video.mp4"></source>
	<source type="video/webm" src="video.webm"></source>
	<track kind="subtitle" src="video.srt"></track>
</video>
```

#### Code javascript :
```
<script type="text/javascript">
	$(function() {
		//Instancier le player sur la balise vidéo "player1"
		$("#player1").pwplayer();

		//Instancier le player sur la balise vidéo "player2" avec paramètres
		$("#player2").pwplayer({
			"uriTranslate" : "translate/fr.json",
			"uriTranscript" : "transcript.pdf",
			"uriFlashFallbackFolder" : "altFlash",
			"uriFlashFallbackVideoName" : "video.mp4",

		//Pour appeller toutes les balises vidéos en un seul appel
		$('video').pwplayer();
	});
</script>
```

#### Paramètres disponibles :
* `uriTranslate` fichier json regroupant les éléments textuels du Player (valeur par défaut : `"translate/fr.json"`) 
* `uriTranscript` chemin du fichier de transcription de la vidéo (valeur par défaut : `null`)
* `autoplay` lecture automatique de la vidéo (valeur par défaut : `false`)
* `prefixCss` permet de définir un préfixe s'ajoutant aux classes CSS (valeur par défaut : `""`)
* `poster` permet de spécifier une image de prévisualisation de la vidéo, en ajoutant l'attribut poster à la balise vidéo (valeur par défaut : `""`)


#### Démo :
Une démonstration du player est disponible à cette url :
 http://demo.ipedis.com/video-player/

## API Externe

Liste exhaustive des appels de fonctions internes depuis l'extérieur du Player :

* `play()` lire la vidéo
* `pause()` interrompre la vidéo
* `enterFullscreen()` ouvrir la vidéo en mode plein écran
* `exitFullScreen()` quitter le mode plein écran
* `switchScreenMode()` intervertir le mode plein/mode normal
* `hideSubtitles()` masquer les sous-titres
* `displaySubtitles()` afficher les sous-titres
* `setVolume(volume)` modifier le volume, le paramètre doit être passé sous la forme : `{ volume : n }`, n étant compris entre 0 et 100
* `displayHelp()` afficher l'aide
* `hideHelp()` masquer l'aide
* `openTranscript()` ouvrir le transcript
* `getVolume()` récupérer le volume actuel

#### Exemple :
```
<script type="text/javascript">
    $("#externalApiPlay").bind("click",function(){
			$("video#player2").pwplayer("play");
	});

	$("#externalApiPause").bind("click",function(){
			$("video#player2").pwplayer("pause");
	});
</script>
```

## Callbacks

Liste exhaustive des fonctions de callback :

* `onPlayVideo` est appelé à la lecture de la vidéo
* `onStopVideo` est appelé à l'intérruption de la vidéo
* `onEnterFullScreen` est appelé à l'entrée dans le mode plein écran
* `onExitFullScreen` est appelé à la sortie du mode plein écran
* `onDisplaySubTitle` est appelé lorsque les sous-titres sont activés
* `onHideSubTitle` est appelé lorsque les sous-titres sont désactivés
* `onVolumeChange` est appelé lorsque le volume est modifié
* `onSeekUpdate` est appelé lorsque l'on navigue dans la barre de progression de la vidéo
* `onDisplayHelp` est appelé lorsque l'aide s'affiche
* `onHideHelp` est appelé lorsque l'aide se masque
* `onTranscriptOpen` est appelé lorsque le transcript est ouvert

#### Exemple :
```
<script type="text/javascript">
$("video#player2").pwplayer({
    callback : { 
		onPlayVideo : function(el){console.log("Callback : La vidéo a été lancée");}
	}
});
</script>
```

## Fallback Flash

Pour les navigateurs ne prennant pas en charge la balise `video`, le Player Flash est utilisé. Le Player Flash doit être placé dans un dosser, suivant l'arborescence suivante.

#### Arborescence du dossier (noms par défaut) :
```
video.mp4 (paramétrable)
XML (dossier)
accessibility.xml
accueil.xml
help.xml
tooltip.xml
urls.xml
```

#### Paramètres supplémentaires lors de l'initialisation du plugin :
* `uriFlashFallbackFolder` chemin du dossier contenent l'alternative Flash du Player (valeur par défaut : `"altFlash"`)
* `uriFlashFallbackVideoName` nom du fichier vidéo contenu dans le dossier de l'alternative Flash (valeur par défaut : `"video.mp4"`)

## Licence

PubliWatch Player est mis à disposition sous licence Attribution - Partage dans les Mêmes Conditions 3.0 France (CC-BY-SA). Pour voir une copie de cette licence, visitez https://creativecommons.org/licenses/by-sa/3.0/fr/legalcode ou écrivez à Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.