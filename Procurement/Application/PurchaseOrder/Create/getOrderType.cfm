
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