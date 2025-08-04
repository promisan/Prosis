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

 <cfquery name="getDefault" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_OrderClassMission 
			WHERE  Mission = '#url.mission#'
			AND    Code    = '#url.orderclass#'			
 </cfquery>

 <cfquery name="OrderType" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_OrderType R
			WHERE  Code IN (SELECT Code 
			                FROM   Ref_OrderTypeMission 
						    WHERE  Mission = '#url.mission#'
						    AND    Code = R.Code)	
 </cfquery>
		
 <cfif OrderType.recordcount eq "0">
		
			<!--- show all --->
			
			<cfquery name="OrderType" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_OrderType	
			</cfquery>
		
 </cfif>
  
<cfoutput> 
	   
 <select name="ordertype" id="ordertype" style="width:200px" class="regularxxl" 
     onchange="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/Procurement/maintenance/ordertype/Info.cfm?code='+this.value,'infobox')">
	  <cfloop query="OrderType">
	     <option value="#Code#" <cfif getDefault.OrderType eq Code>selected</cfif> >#Description#</option>
	  </cfloop>
 </select>

 <script>
	ColdFusion.navigate('#SESSION.root#/Procurement/maintenance/ordertype/Info.cfm?code=#OrderType.code#','infobox')
 </script>
 
</cfoutput>