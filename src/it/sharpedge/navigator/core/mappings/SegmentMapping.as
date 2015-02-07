package it.sharpedge.navigator.core.mappings
{
	import flash.utils.Dictionary;
	
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.dsl.ISegmentMapping;
	

	public class SegmentMapping implements ISegmentMapping
	{
		// The state segment this SegmentMapping belongs to
		internal var _stateSegment:String = "";
		
		// Parent SegmentMapping
		internal var _parentSegmentMapping:SegmentMapping = null;
		
		// SubSegmentMappings
		internal var _subSegmentMappings:Dictionary = null;

		// The redirect state
		private var _redirectTo : NavigationState = null;
		
		private var _guards:Array = null;
		
		/**
		 * @inheritDoc
		 */
		public function get guards():Array
		{
			return _guards;
		}
		
		private var _hooks:Array = null;
		
		/**
		 * @inheritDoc
		 */
		public function get hooks():Array
		{
			return _hooks;
		}
		
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
		public function SegmentMapping( stateSegment:String )
		{
			_stateSegment = stateSegment;
		}		
		
		/*
		 * Add a SubSegmentMapping
		 */
		public function addSubSegmentMapping( segmentMapping:SegmentMapping ):void {
			
			// TODO: dispatch error or log
			if( segmentMapping._parentSegmentMapping ) return;
			
			segmentMapping._parentSegmentMapping = this;
			_subSegmentMappings[ segmentMapping._stateSegment ] = segmentMapping;
		}
		
		/*
		* Remove a SubSegmentMapping
		*/
		public function removeSubStateMapping( segmentMapping:SegmentMapping ):void {
			// TODO: dispatch error or log
			if( segmentMapping._parentSegmentMapping != this ) return;
			
			segmentMapping._parentSegmentMapping = null;
			delete _subSegmentMappings[ segmentMapping._stateSegment ];
		}
		
		/*
		 * Return the SegmentMapping matching the segments passed if not exist it'll generate it
		 * @param segments The segments that will generate the mapping
		 * @return The SegmentMapping matching the segments
		 */
		public function getSegmentMappingFor( segments:Array ):SegmentMapping {
			var segment:String = segments.shift();
			_subSegmentMappings[ segment ] ||= new SegmentMapping( segment );
			
			if( segments.length )
				return SegmentMapping( _subSegmentMappings[ segment ] ).getSegmentMappingFor( segments );
			else
				return SegmentMapping( _subSegmentMappings[ segment ] );
		}
		
		/**
		 * @inheritDoc
		 */
		public function addGuards( ... guards ):ISegmentMapping
		{
			_guards = _guards ? _guards.concat.apply( null, guards ) : new Array( guards ) ;
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addHooks( ... hooks ):ISegmentMapping
		{
			_hooks = _hooks ? _hooks.concat.apply( null, hooks ) : new Array( hooks );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeGuard( guard : * ):ISegmentMapping
		{
			if( !_guards ) return this;
			
			var index : int = _guards.indexOf( guard );			
			if( index == -1 ) return this;
			
			_guards.splice( index, 1 );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeHook( hook : * ):ISegmentMapping
		{
			if( !_hooks ) return this;
			
			var index : int = _hooks.indexOf( hook );			
			if( index == -1 ) return this;
			
			_hooks.splice( index, 1 );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function redirectTo( stateOrPath:String = null ):void {
			
			// Dispose
			if( _redirectTo ) _redirectTo.dispose();
			
			_redirectTo = NavigationState.make( stateOrPath ).clone();
		}
		
	}
}