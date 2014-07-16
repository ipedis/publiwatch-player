package nl.inlet42.data.subtitles
{
	public class SubTitleData
	{
		protected var _text:String;
		protected var _start:Number;
		protected var _duration:Number;
		protected var _end:Number;
		
		protected static const pcLB:RegExp = /\r\n/g;
		protected static const macLB:RegExp = /\r/g;
		
		public function get end():Number { return _end; }
		public function set end(value:Number):void { _end = value; }
		
		public function get duration():Number { return _duration; }
		public function set duration(value:Number):void { _duration = value; }
		
		public function get start():Number { return _start; }
		public function set start(value:Number):void { _start = value; }
		
		public function get text():String { return _text; }
		public function set text(value:String):void
		{
			_text = value.replace(pcLB, "\n").replace(macLB, "\n").replace("\n\n", "\n");
		}
		
		public function SubTitleData(text:String = "", start:Number = 0, duration:Number = 0, end:Number = 0)
		{
			this.text = text;
			this.start = start;
			this.duration = duration;
			this.end = end;
		}
 
		public static function toString():void
		{
			trace("nl.inlet42.data.subtitles.SubTitleData");
		}
		
		
	}
}