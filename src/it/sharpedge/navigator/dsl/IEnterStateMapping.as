package it.sharpedge.navigator.dsl
{
	public interface IEnterStateMapping extends ISegmentMapping
	{	
		/**
		 * Get a IEnterStateFromMapping rappresenting when arriving from that state
		 * @param state The from state.
		 * @return IEnterStateFromMapping to continue mapping.
		 */
		function from( stateOrPath:* ):ISegmentMapping;
		
		
	}
}