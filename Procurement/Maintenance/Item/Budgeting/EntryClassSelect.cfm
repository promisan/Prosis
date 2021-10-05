
<cfparam name="url.initial" default="no">

	<cfquery name="Entry" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM     Ref_EntryClass
			WHERE Code = '#url.entryclass#'
		</cfquery>
		
  <cfif Entry.CustomDialog neq "Contract">
		
	   <cfset link = "#SESSION.root#/Procurement/Maintenance/Item/Budgeting/RecordStandard.cfm?itemmaster=#URL.ID1#">	
	
	   <cf_tl id="Procurement Standards" var="vProcurement">
	
	   <cf_selectlookup
	    class    = "Standard"
	    box      = "l#URL.ID1#_standard"
		title    = "#vProcurement#"
		link     = "#link#"		
		icon     = "insert.gif"						
		dbtable  = "Procurement.dbo.ItemMasterStandard"
		des1     = "StandardCode">
	
  <cfelse>
  
	  <cfset link = "#SESSION.root#/Procurement/Maintenance/Item/Budgeting/RecordFunction.cfm?itemmaster=#URL.ID1#">
	  
	  <cf_tl id="Functional Titles" var="vFunction">
	  
	  <cf_selectlookup
	    class    = "Function"
	    box      = "l#URL.ID1#_standard"
		title    = "#vFunction#"
		link     = "#link#"			
		icon     = "insert.gif"					
		dbtable  = "Procurement.dbo.ItemMasterFunction"
		des1     = "FunctionNo">	
		
  </cfif>	
  
  <cfif url.initial eq "No">
  
	  <cfoutput>
		  <script>
			  ptoken.navigate('#link#','l#url.id1#_standard')
		  </script>
	  </cfoutput>
  
  </cfif>