package
{
	import flash.geom.Rectangle;
	
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.URLResource;
	
	import samurai.display.Component;
	
	[SWF(frameRate="50", backgroundColor="#000000", width="1440", height="900")]
	public class SimplePlayerWithControls extends Component
	{
		public const PROGRESSIVE_PATH:String = "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";	
		
		public function SimplePlayerWithControls()
		{
			super();
		}
		
		protected override function addChildren():void
		{
			player = new MediaPlayerSprite();
			player.resource = new URLResource(PROGRESSIVE_PATH);
			player.mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			player.mediaContainer.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, onMediaSizeChange);
			addChild(player)
			
			controls = new Control(player.mediaPlayer);
			controls.visible = false;
			addChild(controls);
			
			addResizeHandler();
		}	
		
		protected override function render():void
		{
			size = new Rectangle(0, 10, player.mediaContainer.width, player.mediaContainer.height);
			
			x = stage.stageWidth - size.width >> 1;
			y = stage.stageHeight - (size.height + size.y) >> 1;
			
			controls.size = size;
			controls.invalidate();
		}	
		
		private function onStateChange(event:MediaPlayerStateChangeEvent):void	
		{
			trace("onStateChange, state: ", event.state);
		}
		
		private function onMediaSizeChange(event:DisplayObjectEvent):void
		{
			if (event.newWidth > 0 && event.newHeight > 0)
			{
				invalidate();
			}
		}	
		
		//
		// Internal
		
		private var controls:Control;
		private var player:MediaPlayerSprite;
	}
}