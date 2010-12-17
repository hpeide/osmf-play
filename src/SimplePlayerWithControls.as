package
{
	import assets.BufferSy;
	import assets.PauseSy;
	import assets.PlaySy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.URLResource;
	
	import samurai.display.Component;
	
	[SWF(frameRate="50", backgroundColor="#000000", width="1440", height="900")]
	public class SimplePlayerWithControls extends Component
	{
		public static const PROGRESSIVE_PATH:String = "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";	
		
		public var player:MediaPlayerSprite;
		
		public function SimplePlayerWithControls()
		{
			super();
		}
		
		protected override function addChildren():void
		{
			player = new MediaPlayerSprite();
			player.resource = new URLResource(PROGRESSIVE_PATH);
			player.mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			player.mediaPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onTimeChange);
			player.mediaPlayer.addEventListener(LoadEvent.BYTES_LOADED_CHANGE, onLoadChange);
			addChild(player)
			
			controller = new Sprite();
			addChild(controller);
			
			playSy = new PlaySy();
			playSy.addEventListener(MouseEvent.MOUSE_DOWN, onTogglePlayState);
			playSy.mouseChildren = false;
			playSy.buttonMode = true;
			playSy.visible = false;
			controller.addChild(playSy);
			
			pauseSy = new PauseSy();
			pauseSy.addEventListener(MouseEvent.MOUSE_DOWN, onTogglePlayState);
			pauseSy.mouseChildren = false;
			pauseSy.buttonMode = true;
			pauseSy.visible = false;
			controller.addChild(pauseSy);
			
			bufferSy = new BufferSy();
			bufferSy.visible = false;
			bufferSy.x = pauseSy.x + pauseSy.width + 2;
			bufferSy.time.width = 0;
			bufferSy.buffer.width = 0;
			bufferSy.hit.width = 0;
			bufferSy.hit.alpha = 0;
			bufferSy.background.width = 0;
			controller.addChild(bufferSy);			
			
			addResizeHandler();
		}	
		
		protected override function render():void
		{
			var yMargin:int = 10;
			x = stage.stageWidth - player.mediaContainer.width >> 1;
			y = stage.stageHeight - (player.mediaContainer.height + yMargin) >> 1;
			controller.y = player.mediaContainer.height + yMargin;
			bufferSy.hit.width = player.mediaContainer.width - (26 + bufferSy.x);
			bufferSy.background.width = player.mediaContainer.width - bufferSy.x;
		}	
		
		private function onStateChange(event:MediaPlayerStateChangeEvent):void	
		{
			invalidate();
			
			switch (event.state)
			{
				case "playing":
					pauseSy.visible = true;
					playSy.visible = false;
					bufferSy.visible = true;
					break;
				case "paused":
					pauseSy.visible = false;
					playSy.visible = true;
					break;
				default:
			}
			
			trace ("onStateChange", event.state);
		}
		
		private function onTimeChange(event:TimeEvent):void
		{
			var percentPlayed:Number = player.mediaPlayer.currentTime / player.mediaPlayer.duration;
			bufferSy.time.width = bufferSy.hit.width * percentPlayed;
		}	
		
		private function onLoadChange(event:LoadEvent):void
		{
			var percentLoaded:Number = player.mediaPlayer.bytesLoaded / player.mediaPlayer.bytesTotal;
			bufferSy.buffer.width = bufferSy.hit.width * percentLoaded;
		}
		
		private function onTogglePlayState(event:MouseEvent):void
		{
			if (player.mediaPlayer.playing)
			{
				player.mediaPlayer.pause();
			}
			else
			{
				player.mediaPlayer.play();
			}
		}	
		
		//
		// Internal
		
		private var controller:Sprite;
		private var playSy:PlaySy;
		private var pauseSy:PauseSy;
		private var bufferSy:BufferSy;
	}
}