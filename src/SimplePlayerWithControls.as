package
{
	import flash.geom.Rectangle;
	
	import org.osmf.events.MediaPlayerStateChangeEvent;
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
			addChild(player)
			
			controller = new Controller(player.mediaPlayer);
			controller.visible = false;
			addChild(controller);
			
			addResizeHandler();
		}	
		
		protected override function render():void
		{
			size = new Rectangle(0, 10, player.mediaContainer.width, player.mediaContainer.height);
			controller.size = size;
			x = stage.stageWidth - size.width >> 1;
			y = stage.stageHeight - (size.height + size.y) >> 1;
			controller.invalidate();
		}	
		
		private function onStateChange(event:MediaPlayerStateChangeEvent):void	
		{
			invalidate();
		}
		
		//
		// Internal
		
		private var controller:Controller;
	}
}