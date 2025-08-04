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
  
  <cfquery name="Line" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
	    FROM     RequisitionLine
		WHERE    RequisitionNo = '#URL.RequisitionNo#'				  	
  </cfquery>
  
  

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * FROM Ref_ParameterMission
	  WHERE Mission = '#Line.Mission#'	 
</cfquery>	
    	  
  <cfif url.action eq "Update">
   
   	   <cfset quantity    = replace(url.quantity,",","","ALL")> 
   
   	   <cftry>
   
	   <cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE  RequisitionLineUnit
			SET     RequestQuantity = '#quantity#'
			WHERE   RequisitionNo     = '#URL.RequisitionNo#'				  	
			AND     OrgUnit           = '#URL.OrgUnit#'
		</cfquery>
		
		<cfcatch></cfcatch>
		
		</cftry>
      
  </cfif>
   
  <cfquery name="Total" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   sum(requestQuantity) as Total
	    FROM     RequisitionLineUnit
		WHERE    RequisitionNo = '#URL.RequisitionNo#'				  	
  </cfquery>

  <cfoutput>
  <input type="text" name="requestquantity" id="requestquantity" value="#Total.Total#" class="regularh">
  
  <cfif Parameter.enableCurrency eq "1">
	   <cfset price = Line.RequestCurrencyprice>
	<cfelse>
	   <cfset price = Line.RequestCostPrice>
	</cfif>
    
  <script>
    base2('#url.RequisitionNo#','#price#','#Total.Total#')	
	tagging()	  
  </script>

  </cfoutput>