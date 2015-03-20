package it.sharpedge.navigator.debug
{
	public class TraceLogger implements ILogger
	{
		public function TraceLogger()
		{
		}
		
		public function debug(message:*, params:Array=null):void
		{
			trace("[DEBUG] " + message + params?params:"");
		}
		
		public function info(message:*, params:Array=null):void
		{
			trace("[INFO] " + message + params?params:"");
		}
		
		public function warn(message:*, params:Array=null):void
		{			
			trace("[WARN] " + message + params?params:"");
		}
		
		public function error(message:*, params:Array=null):void
		{
			trace("[ERROR] " + message + params?params:"");
		}
		
		public function fatal(message:*, params:Array=null):void
		{
			trace("[FATAL] " + message + params?params:"");
		}
	}
}