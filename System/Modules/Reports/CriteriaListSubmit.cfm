
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Operational" default="0">

<cfquery name="Check" 
    datasource="AppsSystem" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ReportControlCriteriaList
	WHERE ControlId = '#URL.ID#'
	AND CriteriaName = '#URL.ID1#'
	AND ListValue = '#Form.ListValue#'
</cfquery>

<cfif #Check.recordCount# eq "1">

	   <cfquery name="Update" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE  Ref_ReportControlCriteriaList
			  SET Operational = '#Form.Operational#',
			      ListDisplay = '#Form.ListDisplay#',
				  ListOrder   = '#Form.Listorder#'
			 WHERE ControlId = '#URL.ID#'
			 AND CriteriaName = '#URL.ID1#'
			 AND ListValue = '#Form.ListValue#'
	    	</cfquery>

<cfelse>
	
	<cfif #URL.ID2# eq "">
	
		<cfquery name="Insert" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Ref_ReportControlCriteriaList
		         (ControlId,
				 CriteriaName,
				 ListValue,
				 ListDisplay,
				 ListOrder,
				 Operational,
				 Created)
		      VALUES ('#URL.ID#',
				  '#URL.ID1#',
		      	  '#Form.ListValue#',
				  '#Form.ListDisplay#',
				  '#Form.ListOrder#',
				  '#Form.Operational#',
				  getDate())
		</cfquery>
		
	<cfelse>
		
		   <cfquery name="Update" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE  Ref_ReportControlCriteriaList
			  SET Operational = '#Form.Operational#',
			  ListDisplay = '#Form.ListDisplay#'
			 WHERE ControlId = '#URL.ID#'
			 AND CriteriaName = '#URL.ID1#'
			 AND ListValue = '#URL.ID2#'
	    	</cfquery>
		
	</cfif>
	
</cfif>	
 	
<script>
 <cfoutput>
	 window.location = "CriteriaList.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#"
 </cfoutput> 
</script>	
  
