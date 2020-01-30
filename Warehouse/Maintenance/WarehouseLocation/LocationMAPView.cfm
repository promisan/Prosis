
<cfquery name="Geo" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">		 
		 SELECT    *
		 FROM      Location
		 WHERE     Location = '#url.Locationid#'		 		
</cfquery>	

<cfparam name="url.width" default="970">
<cfparam name="url.height" default="400">

<cf_mapshow scope="embed" 
	   mode="view"
	   width="#url.width-30#" 
	   height="#url.height-60#" 
	   latitude="#geo.Latitude#" 
	   longitude="#geo.Longitude#" 
	   format="map">
	