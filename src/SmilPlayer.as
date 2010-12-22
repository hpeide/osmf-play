package
{
	import flash.geom.Rectangle;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.PluginInfoResource;
	import org.osmf.media.URLResource;
	import org.osmf.smil.SMILPluginInfo;
	
	import samurai.display.Component;
	
	[SWF(frameRate="50", backgroundColor="#000000", width="1440", height="900")]
	public class SmilPlayer extends Component
	{
		private const SMIL_PATH:String = "http://mediapm.edgesuite.net/osmf/content/test/smil/elephants_dream.smil";
		
		public function SmilPlayer()
		{
			super();
		}
		
		protected override function addChildren():void
		{			
			player = new MediaPlayer();
			player.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			
			container = new MediaContainer();
			container.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, onMediaSizeChange);
			addChild(container);
			
			var factory:DefaultMediaFactory = new DefaultMediaFactory();
			factory.addEventListener(MediaFactoryEvent.MEDIA_ELEMENT_CREATE, onMediaElementLoaded);
			factory.loadPlugin(new PluginInfoResource(new SMILPluginInfo()));
			factory.createMediaElement(new URLResource(SMIL_PATH));
			
			controls = new Control(player);
			controls.visible = false;
			addChild(controls);			
				
			addResizeHandler();
		}	
		
		protected override function render():void
		{
			size = new Rectangle(0, 10, container.width, container.height);
			
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
		
		private function onMediaElementLoaded(event:MediaFactoryEvent):void
		{
			var factory:DefaultMediaFactory = event.target as DefaultMediaFactory;
			factory.removeEventListener(MediaFactoryEvent.MEDIA_ELEMENT_CREATE, onMediaElementLoaded);
			factory = null;
			
			element = event.mediaElement;
			player.media = element;
			container.addMediaElement(element);
		}		
		
		//
		// Internal
		
		private var controls:Control;
		private var player:MediaPlayer;
		private var container:MediaContainer;
		private var element:MediaElement;
	}
}