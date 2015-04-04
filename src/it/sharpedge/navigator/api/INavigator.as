package it.sharpedge.navigator.api
{
	import flash.events.IEventDispatcher;
	
	import it.sharpedge.navigator.core.NavigationState;
	import it.sharpedge.navigator.dsl.IEnterSegmentMapper;
	import it.sharpedge.navigator.dsl.IExitSegmentMapper;

	public interface INavigator extends IEventDispatcher
	{
		
		function get currentState():NavigationState;
		function get isRunning():Boolean;
		
		function clearMappings():void;
		function onEnterTo( stateOrPath:* ):IEnterSegmentMapper;
		function onExitFrom( stateOrPath:* ):IExitSegmentMapper;
		function request( stateOrPath:* ):void;
	}
}