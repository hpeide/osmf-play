package
{
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.URLResource;
	
	import samurai.display.Component;
	
	[SWF(frameRate="50", backgroundColor="#000000", width="1440", height="900")]	
	public class SimplePlayer extends Component
	{		
		public static const PROGRESSIVE_PATH:String = "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";	
		
		public var player:MediaPlayerSprite;
		
		public function SimplePlayer()
		{
			super();
		}
		
		protected override function addChildren():void
		{
			player = new MediaPlayerSprite();
			player.resource = new URLResource(PROGRESSIVE_PATH);
			player.mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			addChild(player)
			
			addResizeHandler();
		}	
		
		protected override function render():void
		{
			x = stage.stageWidth - player.mediaContainer.width >> 1;
			y = stage.stageHeight - player.mediaContainer.height >> 1;
		}	
		
		private function onStateChange(event:MediaPlayerStateChangeEvent):void	
		{
			invalidate();
		}
	}
}