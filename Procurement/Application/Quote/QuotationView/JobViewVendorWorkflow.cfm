
<cfoutput>

<cfset cnt = 1>
<cfloop index="itm" list="#url.ajaxid#" delimiters="_">
  <cfif cnt eq 1>
     <cfset job = itm>
  <cfelse>
     <cfset ven = itm>
  </cfif>
  <cfset cnt=cnt+1>
</cfloop>

<cfquery name="Vendor" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   J.JobNo, OrderClass, JobCategory, J.Period, J.Mission, J.Description, JV.OrgUnitVendor, O.OrgUnitName
     FROM     Job AS J INNER JOIN
              JobVendor AS JV ON J.JobNo = JV.JobNo INNER JOIN
              Organization.dbo.Organization AS O ON JV.OrgUnitVendor = O.OrgUnit					  
	 WHERE   J.JobNo ='#job#'	 
	 AND     JV.OrgUnitVendor = '#ven#'
</cfquery>

<cfset link = "Procurement/Application/Quote/QuotationView/JobViewGeneral.cfm?Period=#Vendor.Period#&ID1=#Vendor.JobNo#">
			   			   				
   <cf_ActionListing 
	    EntityCode       = "ProcVendor"
		EntityClass      = "Standard"
		EntityGroup      = "#Vendor.JobCategory#"
		EntityStatus     = ""
		EnforceWorkflow  = "No"		
		ToolBar          = "Hide"
		Mission          = "#Vendor.Mission#"
		OrgUnit          = ""
		RowLabel         = "No"
		RowHeight        = "25"	
		ObjectReference  = "#Vendor.Description#"
		ObjectReference2 = "#Vendor.OrgUnitName#"
		ObjectKey1       = "#Vendor.Jobno#"
		ObjectKey2       = "#Vendor.OrgUnitVendor#"
		ObjectKey3       = ""
		ObjectKey4       = ""
	  	ObjectURL        = "#link#"
		AjaxId           = "#URL.AjaxId#"
		Show             = "Yes"
		ActionMail       = "Yes"
		PersonNo         = ""
		PersonEMail      = ""
		TableWidth       = "100%"
		DocumentStatus   = "0">	

</cfoutput>