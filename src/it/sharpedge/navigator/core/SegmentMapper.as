package it.sharpedge.navigator.core
{
	import flash.utils.Dictionary;
	
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.dsl.IEnterSegmentMapper;
	import it.sharpedge.navigator.dsl.IExitSegmentMapper;
	import it.sharpedge.navigator.dsl.ISegmentMapper;
	

	public class SegmentMapper implements ISegmentMapper, IEnterSegmentMapper, IExitSegmentMapper	{
		// The state segment this SegmentMapping belongs to
		internal var _stateSegment:String = "";
		
		// Parent SegmentMapping
		internal var _parentSegmentMapping:SegmentMapper = null;
		
		// SubSegmentMappings
		internal var _subSegmentMappings:Dictionary = null;
		
		// ComplementaryMapping
		internal var _complementaryMapping:SegmentMapper = null;
		
		private var _stateMapping : StateMapping = new StateMapping();

		
		public function get path():String {
			if( _parentSegmentMapping )
				return _parentSegmentMapping.path + _stateSegment + NavigationState.DELIMITER;
			else
				return _stateSegment + NavigationState.DELIMITER;				
		}
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * Creates a State Mapping
		 */
		public function SegmentMapper( stateSegment:String )
		{
			_stateSegment = stateSegment;
		}
		
		/*============================================================================*/
		/* Private/Internal                                                           */
		/*============================================================================*/
		
		
		/*
		* Return the SegmentMapping matching the segments passed if not exist it'll generate it
		* @param segments The segments that will generate the mapping
		* @return The SegmentMapping matching the segments
		*/
		internal function getSegmentMappingFor( segments:Array ):SegmentMapper {
			var segment:String = segments.shift();
			
			if(!_subSegmentMappings[ segment ])
				addSubSegmentMapping(new SegmentMapper( segment ));
			
			// if there are other segments go deeper
			if( segments.length )
				return SegmentMapper( _subSegmentMappings[ segment ] ).getSegmentMappingFor( segments );
			else
				return SegmentMapper( _subSegmentMappings[ segment ] );
		}
		
		internal function getMatchingElements( segments:Array, result:Array ) : Array {
			// TODO populate result of StateMapping objects going recursive looking for matching path
			
			return null;
		}
		
		/*============================================================================*/
		/* Public                                                                     */
		/*============================================================================*/
		
		/*
		 * Add a SubSegmentMapping
		 */
		public function addSubSegmentMapping( segmentMapping:SegmentMapper ):void {
			
			// TODO: dispatch error or log
			if( segmentMapping._parentSegmentMapping ) return;
			
			segmentMapping._parentSegmentMapping = this;
			_subSegmentMappings[ segmentMapping._stateSegment ] = segmentMapping;
		}
		
		/*
		* Remove a SubSegmentMapping
		*/
		public function removeSubSegmentMapping( segmentMapping:SegmentMapper ):void {
			// TODO: dispatch error or log
			if( segmentMapping._parentSegmentMapping != this ) return;
			
			segmentMapping._parentSegmentMapping = null;
			delete _subSegmentMappings[ segmentMapping._stateSegment ];
		}
		
		/**
		 * @inheritDoc
		 */
		public function from( stateOrPath:* ):ISegmentMapper{
			_complementaryMapping ||= new SegmentMapper( "" );
			
			return  _complementaryMapping.getSegmentMappingFor( NavigationState.make( stateOrPath ).segments );
		}
		
		/**
		 * @inheritDoc
		 */
		public function to( stateOrPath:* ):ISegmentMapper {
			_complementaryMapping ||= new SegmentMapper( "" );
			
			return _complementaryMapping.getSegmentMappingFor( NavigationState.make( stateOrPath ).segments );
		}
		
		/**
		 * @inheritDoc
		 */
		public function addGuards( ... guards ):ISegmentMapper
		{
			_stateMapping.addGuards( guards );			
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addHooks( ... hooks ):ISegmentMapper
		{
			_stateMapping.addHooks( hooks );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeGuard( guard : * ):ISegmentMapper
		{
			_stateMapping.removeGuard( guard );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeHook( hook : * ):ISegmentMapper
		{
			_stateMapping.removeHook( hook );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function redirectTo( stateOrPath:String = null ):void {
			
			_stateMapping.redirectTo( stateOrPath );
		}
		
	}
}