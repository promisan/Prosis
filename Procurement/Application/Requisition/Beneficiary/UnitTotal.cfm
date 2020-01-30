  
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