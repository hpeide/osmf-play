package
{
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.LightweightVideoElement;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	
	import samurai.display.Component;
	
	[SWF(frameRate="50", backgroundColor="#000000", width="1440", height="900")]	
	public class SeperatedPlayer extends Component
	{
		
		public static const PROGRESSIVE_PATH:String = "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";	
		
		public var player:MediaPlayer;
		public var container:MediaContainer;
		public var resource:URLResource;
		public var netLoader:NetLoader;
		public var element:LightweightVideoElement;
		
		public function SeperatedPlayer()
		{
			super();
		}
		
		protected override function addChildren():void
		{			
			resource = new URLResource(PROGRESSIVE_PATH);
			netLoader = new NetLoader();
			element = new LightweightVideoElement(resource, netLoader);
			player = new MediaPlayer(element);
			player.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			container = new MediaContainer();
			container.addMediaElement(element);
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
			invalidate();
			
			trace ("onStateChange", event.state);
		}
		
		
	}
}