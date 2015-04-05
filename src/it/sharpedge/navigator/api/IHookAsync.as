package it.sharpedge.navigator.api
{
	import it.sharpedge.navigator.core.NavigationState;

	public interface IHookAsync
	{
		function execute( from:NavigationState, to:NavigationState, callback:Function ):void;
	}
}