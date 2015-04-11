package it.sharpedge.navigator
{
	import it.sharpedge.navigator.debug.CountLogger;
	import it.sharpedge.navigator.debug.ILogger;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class TraceLoggerTest
	{
		
		private var ilogger:ILogger;
		private var logger:CountLogger = new CountLogger();
		
		[Before]
		public function initNavigator() : void {
			logger = new CountLogger();
		}
		
		[Test]
		public function debug() : void {
			logger.debug("debug");
			assertThat("Logger Debug works", logger._debug, equalTo(1));
		}
		
		[Test]
		public function info() : void {
			logger.info("info");
			assertThat("Logger Info works", logger._info, equalTo(1));
		}
		
		[Test]
		public function error() : void {
			logger.error("error");
			assertThat("Logger Error works", logger._error, equalTo(1));
		}
		
		[Test]
		public function warn() : void {
			logger.warn("warn");
			assertThat("Logger Warn works", logger._warn, equalTo(1));
		}
		
		[Test]
		public function fatal() : void {
			logger.fatal("fatal");
			assertThat("Logger Fatal works", logger._fatal, equalTo(1));
		}
	}
}