<cffunction name="CheckMetric" access="remote" returntype="boolean" 
description="Return if the asset is allowed for the metric or not">  
 <cfargument name="AssetId" type="string" required="yes">  
 <cfargument name="Metric" type="string" required="yes">  


	<cfquery name="qCheck1" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
     SELECT * 
	 FROM AssetItemSupplyMetric
	 WHERE AssetId = '#AssetId#'
    </cfquery>  

	<cfif qCheck1.recordcount eq 0>
		<cfreturn true>
	<cfelse>
	
		<cfquery name="qCheck2" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	     SELECT * 
		 FROM AssetItemSupplyMetric
		 WHERE AssetId = '#AssetId#'
		 AND Metric = '#Metric#' 
	    </cfquery>  	
		
		<cfif qCheck2.recordcount eq 0>
			<cfreturn false>		
		<cfelse>
			<cfreturn true>
		</cfif>	
	</cfif>

</cffunction>  
