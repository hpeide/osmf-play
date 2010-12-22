package
{
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.LightweightVideoElement;
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	
	import samurai.display.Component;
	
	[SWF(frameRate="50", backgroundColor="#000000", width="1440", height="900")]	
	public class SeperatedPlayer extends Component
	{
		
		public static const PROGRESSIVE_PATH:String = "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
		
		public function SeperatedPlayer()
		{
			super();
		}
		
		protected override function addChildren():void
		{
			element = new LightweightVideoElement(new URLResource(PROGRESSIVE_PATH), new NetLoader())
			
			player = new MediaPlayer(element);
			player.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			
			container = new MediaContainer();
			container.addMediaElement(element);
			container.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, onMediaSizeChange);
			addChild(container)
			
			addResizeHandler();
		}	
		
		protected override function render():void
		{
			x = stage.stageWidth - container.width >> 1;
			y = stage.stageHeight - container.height >> 1;
		}	
		
		private function onStateChange(event:MediaPlayerStateChangeEvent):void	
		{
			trace ("onStateChange", event.state);
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
		
		private var player:MediaPlayer;
		private var container:MediaContainer;
		private var element:MediaElement;	
	}
}