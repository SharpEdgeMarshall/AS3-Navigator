package it.sharpedge.navigator.core.mappings
{
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.dsl.IExitStateMapping;
	import it.sharpedge.navigator.dsl.ISegmentMapping;
	

	public class ExitStateMapping extends SegmentMapping implements IExitStateMapping
	{
		private var _toMapping:SegmentMapping = null;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * Creates a Exit State Mapping
		 */
		public function ExitStateMapping( stateSegment:String )
		{
			super( stateSegment );
		}
		
		/**
		 * @inheritDoc
		 */
		public function to( stateOrPath:* ):ISegmentMapping {
			_toMapping ||= new SegmentMapping( "" );
			
			return _toMapping.getSegmentMappingFor( NavigationState.make( stateOrPath ).segments );
		}
	}
}