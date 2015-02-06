package it.sharpedge.navigator.debug
{
	public interface ILogger
	{
		/**
		 * Logs a message for debug purposes
		 * @param message Message to log
		 * @param params Message parameters
		 */
		function debug(message:*, params:Array = null):void;
		
		/**
		 * Logs a message for notification purposes
		 * @param message Message to log
		 * @param params Message parameters
		 */
		function info(message:*, params:Array = null):void;
		
		/**
		 * Logs a warning message
		 * @param message Message to log
		 * @param params Message parameters
		 */
		function warn(message:*, params:Array = null):void;
		
		/**
		 * Logs an error message
		 * @param message Message to log
		 * @param params Message parameters
		 */
		function error(message:*, params:Array = null):void;
		
		/**
		 * Logs a fatal error message
		 * @param message Message to log
		 * @param params Message parameters
		 */
		function fatal(message:*, params:Array = null):void;
	}
}