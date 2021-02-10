
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#'
</cfquery>

<cfparam name="URL.role" default="">
<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">

<cf_divscroll style="height:100%">

<table width="95%" align="center">
   	 			
	  <tr><td style="padding-top:17px; padding-left:5px">	
	  	  	  	    	   
		    <cf_EntitlementTreeData
				 mission     = "#URL.Mission#"
				 period      = "#URL.Period#"				 
				 destination = "EntitlementViewOpen.cfm">
			
	 </td></tr>	
		 		 
</table>	
	 

</cf_divscroll>

