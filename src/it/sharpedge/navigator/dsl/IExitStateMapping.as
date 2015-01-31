package it.sharpedge.navigator.dsl
{
	public interface IExitStateMapping extends IStateMapping
	{
		function to( state:String ):IStateMapping;
	}
}