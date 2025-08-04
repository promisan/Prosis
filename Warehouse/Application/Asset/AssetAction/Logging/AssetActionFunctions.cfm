<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
