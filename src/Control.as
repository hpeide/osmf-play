package
{
	import assets.BufferSy;
	import assets.PauseSy;
	import assets.PlaySy;
	import assets.VolumeSy;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaPlayer;
	
	import samurai.display.Component;
	
	public class Control extends Component
	{
		public function Control(player:MediaPlayer)
		{
			super();
			
			this.player = player;
		}
		
		protected override function addChildren():void
		{			
			visible = false;
			
			playSy = new PlaySy();
			playSy.addEventListener(MouseEvent.MOUSE_DOWN, onTogglePlayState);
			playSy.mouseChildren = false;
			playSy.buttonMode = true;
			addChild(playSy);
			
			pauseSy = new PauseSy();
			pauseSy.addEventListener(MouseEvent.MOUSE_DOWN, onTogglePlayState);
			pauseSy.mouseChildren = false;
			pauseSy.buttonMode = true;
			addChild(pauseSy);
			
			bufferSy = new BufferSy();
			bufferSy.x = pauseSy.x + pauseSy.width + 2;
			bufferSy.time.width = 0;
			bufferSy.buffer.width = 0;
			bufferSy.hit.width = 0;
			bufferSy.hit.alpha = 0;
			bufferSy.hit.addEventListener(MouseEvent.MOUSE_DOWN, onSeekDown);
			bufferSy.background.width = 0;
			addChild(bufferSy);
			
			volumeSy = new VolumeSy();
			volumeSy.addEventListener(MouseEvent.MOUSE_DOWN, onVolumeDown);
			volumeSy.mouseChildren = false;
			volumeSy.buttonMode = true;
			addChild(volumeSy);
			
			player.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onTimeChange);
			player.addEventListener(LoadEvent.BYTES_LOADED_CHANGE, onLoadChange);
		}
		
		protected override function render():void
		{
			y = size.height + size.y;
			
			volumeSy.x = size.width - 63;
			
			bufferSy.background.width = size.width - bufferSy.x - 65;
			bufferSy.hit.width = bufferSy.background.width - 26;
			
			switch (player.state)
			{
				case "playing":
					pauseSy.visible = true;
					playSy.visible = false;
					visible = true;
					break;
				case "ready":
				case "paused":
					pauseSy.visible = false;
					playSy.visible = true;
					visible = true;
					break;
				default:
			}
		}
		
		private function onTimeChange(event:TimeEvent):void
		{
			var percentPlayed:Number = player.currentTime / player.duration;
			bufferSy.time.width = bufferSy.hit.width * percentPlayed;
		}	
		
		private function onLoadChange(event:LoadEvent):void
		{
			var percentLoaded:Number = player.bytesLoaded / player.bytesTotal;
			bufferSy.buffer.width = bufferSy.hit.width * percentLoaded;
		}
		
		private function onTogglePlayState(event:MouseEvent):void
		{
			if (player.playing)
			{
				player.pause();
			}
			else
			{
				player.play();
			}
		}	
		
		private function onVolumeDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onVolumeUp, false, 0, true);
			volumeSy.bar.startDrag(false, new Rectangle(-24.55, 11.44, 37.25, 0));
		}
		
		private function onVolumeUp(event:MouseEvent):void
		{			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onVolumeUp);
			volumeSy.bar.stopDrag();
			
			var ratio:Number = (volumeSy.bar.x + 24) / 36;
			player.volume = ratio;
		}
		
		private function onSeekDown(event:MouseEvent):void
		{
			var ratio:Number = (bufferSy.mouseX + bufferSy.hit.x) / bufferSy.hit.width;
			
			if (ratio > 1)
			{
				ratio = 1;
			}
			
			player.seek(ratio * player.duration);
		}
		
		//
		// Internal
				
		private var player:MediaPlayer;
		private var playSy:PlaySy;
		private var pauseSy:PauseSy;
		private var bufferSy:BufferSy;
		private var volumeSy:VolumeSy;	
	}
}