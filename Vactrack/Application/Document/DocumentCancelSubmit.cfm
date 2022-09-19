<!--- 
1. set document status = 9	  
--->

<cfquery name="Doc" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Document	
	 WHERE  DocumentNo  = '#URL.ID#' 
	</cfquery>

<cftransaction action="BEGIN">

	<cfquery name="Status" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE Vacancy.dbo.Document
	 SET    Status                  = '#URL.Status#', 
	        StatusDate              = getDate(), 
			StatusOfficerUserid     = '#SESSION.acc#',
			StatusOfficerLastName   = '#SESSION.last#',
			StatusOfficerFirstName  = '#SESSION.first#'
	 WHERE  DocumentNo  = '#URL.ID#' 
	</cfquery>
	
	<!--- log the action as well --->
	
	<cfquery name="getLog" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT TOP 1 ActionId
		 FROM Vacancy.dbo.DocumentAction
		 WHERE DocumentNo = '#url.id#'
		 ORDER BY ActionId DESC		 
	</cfquery>
	
	<cfif getLog.recordcount eq "0">
		<cfset ser = 1>
	<cfelse>
		<cfset ser = getLog.ActionId+1>	
	</cfif>
	
	<cfquery name="LogStatus" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 INSERT INTO Vacancy.dbo.DocumentAction
		 (DocumentNo,ActionId, ActionDateActual,ActionMemo,ActionStatus,ActionUserId,ActionLastName,ActionFirstName,ActionDate)
		 VALUES
		 ('#url.id#','#ser#',getDate(),'#form.Memo#','#url.status#','#SESSION.acc#','#SESSION.last#','#SESSION.first#', getDate())	
	</cfquery>
		
	<cfquery name="Status" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	
		UPDATE    OrganizationObject
		SET       EntityStatus        = '#URL.Status#'
		WHERE     EntityCode IN ('VacCandidate', 'VacDocument')
		AND       ObjectKeyValue1    = '#URL.ID#'
	</cfquery>	
	
   <cfif url.status eq "9">
		 
	   <cfset show = "No">   		    
	   <cfset enf  = "Yes">
	   
	   <!--- finish the workflow --->
	     
	   <cf_ActionListing 
		    EntityCode       = "VacDocument"		
			EntityClass      = "#Doc.EntityClass#"			
			EntityGroup      = ""
			EntityStatus     = ""					
		    ObjectKey1       = "#URL.ID#"			
			Show             = "#show#"				
			CompleteCurrent  = "#enf#">	 
		
	</cfif>	
	     
</cftransaction>

<cfoutput>
<script>
 ptoken.open('DocumentEdit.cfm?ID=#URL.ID#')
</script>
</cfoutput>

