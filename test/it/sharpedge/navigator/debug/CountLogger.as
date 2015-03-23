package it.sharpedge.navigator.debug
{
	public class CountLogger extends TraceLogger implements ILogger
	{
		
		public var _debug:int = 0;
		public var _info:int = 0;
		public var _warn:int = 0;
		public var _error:int = 0;
		public var _fatal:int = 0;
		
		public function CountLogger()
		{
		}
		
		override public function debug(message:*, params:Array=null):void
		{
			super.debug(message,params);
			_debug++;
		}
		
		override public function info(message:*, params:Array=null):void
		{
			super.info(message,params);
			_info++;
		}
		
		override public function warn(message:*, params:Array=null):void
		{
			super.warn(message,params);
			_warn++;
		}
		
		override public function error(message:*, params:Array=null):void
		{
			super.error(message,params);
			_error++;
		}
		
		override public function fatal(message:*, params:Array=null):void
		{
			super.fatal(message,params);
			_fatal++;
		}
	}
}