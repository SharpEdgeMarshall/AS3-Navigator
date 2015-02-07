package it.sharpedge.navigator.core.mappings
{
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.dsl.IEnterStateMapping;
	import it.sharpedge.navigator.dsl.ISegmentMapping;

	public class EnterStateMapping extends SegmentMapping implements IEnterStateMapping
	{
		
		private var _fromMapping:SegmentMapping = null;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * Creates a Enter State Mapping
		 */
		public function EnterStateMapping( stateSegment:String )
		{
			super( stateSegment );
		}
		
		/**
		 * @inheritDoc
		 */
		public function from( stateOrPath:* ):ISegmentMapping{
			_fromMapping ||= new EnterStateMapping( "" );
			
			return  _fromMapping.getSegmentMappingFor( NavigationState.make( stateOrPath ).segments );
		}
		
		
		
	}
}