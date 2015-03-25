package it.sharpedge.navigator.api
{
	import it.sharpedge.navigator.core.NavigationState;
	import it.sharpedge.navigator.dsl.IEnterSegmentMapper;
	import it.sharpedge.navigator.dsl.IExitSegmentMapper;

	public interface INavigator
	{
		
		function get currentState():NavigationState;
		function get running():Boolean;
		
		function clearMappings():void;
		function onEnterTo( stateOrPath:* ):IEnterSegmentMapper;
		function onExitFrom( stateOrPath:* ):IExitSegmentMapper;
		function request( stateOrPath:* ):void;
	}
}