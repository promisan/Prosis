<cfparam name="attributes.map"      default="gmap">
<cfparam name="attributes.width"      default="400">
<cfparam name="attributes.height"     default="390">
<cfparam name="attributes.mode"       default="edit">
<cfparam name="attributes.scope"      default="embed">
<cfparam name="attributes.field"      default="">

<cfset width  =  attributes.width>
<cfset height =  attributes.height>
<cfset mode   =  attributes.mode>
<cfset scope  =  attributes.scope>
<cfset field  =  attributes.field>

<cfparam name="url.field"       default="">

<cfif url.field eq "">
	<cfset url.field = field>
</cfif>	

<cfoutput>

	<script language="JavaScript">
		
	var aRelated = new Array();
	var bounceTimer = 0;
	var _MAP_ 	 = 	'#attributes.map#';
	var _point_ ;
	
	var mapObj;
	var sobj;

	
	function doResetMap() {
		aRelated = new Array();
	}
			
	function mapaddress(scope) {	
			   
	    add   = document.getElementById('address').value	    								
		cit   = document.getElementById('addresscity').value		
		cou   = document.getElementById('country').value		
				
		_cf_loadingtexthtml='';
		if (scope != 'dialog') {
		// _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>";	
   		ColdFusion.navigate('#SESSION.root#/Tools/Maps/MapContent.cfm?scope=#scope#&mode=#mode#&width=#width#&height=#height#&country='+cou+'&city='+cit+'&address='+add,'mapcontent')	 
		} else {
		ColdFusion.navigate('#SESSION.root#/Tools/Maps/MapContent.cfm?scope=dialog&mode=#mode#&width=#width#&height=#height#&country='+cou+'&city='+cit+'&address='+add,'mapcontent')	 		
		}
		
	}
	 
	function mapzip() {
	
	 	cou = document.getElementById('country').value		
		zip = document.getElementById('addresspostalcode').value
   		ColdFusion.navigate('#SESSION.root#/Tools/Maps/MapContent.cfm?scope=#scope#&mode=#mode#&width=#width#&height=#height#&country='+cou+'&postalcode='+zip,'mapcontent')	 
		
	}
	 
	function mapcoord(scope) {
	 	lat = document.getElementById('cLatitude').value
		lng = document.getElementById('cLongitude').value
		if (scope != 'dialog') {
   		ColdFusion.navigate('#SESSION.root#/Tools/Maps/MapContent.cfm?scope=#scope#&mode=#mode#&width=#width#&height=#height#&latitude='+lat+'&longitude='+lng,'mapcontent')	 
		} else {
		ColdFusion.navigate('#SESSION.root#/Tools/Maps/MapContent.cfm?scope=dialog&mode=#mode#&width=#width#&height=#height#&latitude='+lat+'&longitude='+lng,'mapcontent')	 
		}
	}
	 
	function getcoordinates() {
	 	    
		ret = document.getElementById('cLatitude').value+":"+document.getElementById('cLongitude').value
		parent.refreshmap('#url.field#',ret)		
		parent.ColdFusion.Window.hide('mymap',true)
	    	
	} 
	 
	function getmap() {	 
	  
       var mapObj = ColdFusion.Map.getMapObject('#attributes.map#');		      
	   var coord  = mapObj.getCenter()
	   
       lat = coord.lat()	
	   lng = coord.lng()	
	   	   
	   // update field values in form 
	 	  
	   document.getElementById('cLatitude').value  = lat	 
	   document.getElementById('cLongitude').value = lng	
	   _cf_loadingtexthtml='';
	   
	   ColdFusion.navigate('#SESSION.root#/Tools/Maps/getAddress.cfm?latitude='+lat+'&longitude='+lng,'maploc')
	   	 
	   var centerLongLat={
			latitude: lat,
			longitude: lng
			};
							
	   ColdFusion.Map.addMarker('#attributes.map#', centerLongLat)						   
	   ColdFusion.Map.setCenter('#attributes.map#', centerLongLat);
	   
	   }
	
	var markerOnMouseOver = function() {
		
		if(typeof aRelated[this.name] === 'undefined') {
		    // do nothing
		}
		else {
			
					
			var json_obj = aRelated[this.name];
		    var mapObj = ColdFusion.objectCache[_MAP_];
		    var sobj = mapObj.mapPanelObject;
		    var aChildren = new Array();			
			    
		        bounceTimer = setTimeout(function(){

					  Ext.each(json_obj, function(vobj,value) {
						if (vobj.name) {
							aChildren.push(vobj.name);										
						} });			             
		             
		             //for children
		             
					  Ext.each(sobj.cache.marker, function (marker){
					  	if (aChildren.indexOf(marker.name) != -1){
							marker.setAnimation(google.maps.Animation.BOUNCE);
						}	
					  });		             
		        },
		        500);
	    }
	}
	
	var markerOnMouseOut = function() {
		if(typeof aRelated[this.name] === 'undefined') {
		    // do nothing
		}
		else {
			var json_obj = aRelated[this.name];
		    var mapObj = ColdFusion.objectCache[_MAP_];
		    var sobj = mapObj.mapPanelObject;
		    var aChildren = new Array();					
		      
			//for children			  	
		    Ext.each(json_obj, function(vobj,value) {
			  if (vobj.name) {
				aChildren.push(vobj.name);										
			} });			             
         
		    Ext.each(sobj.cache.marker, function (marker){
		  	  if (aChildren.indexOf(marker.name) != -1){
				marker.setAnimation(null);
			  }	
		    });
     	
		    clearTimeout(bounceTimer);
		     
	  }
	}		   
	   
	   
	
	</script>
	
</cfoutput>	