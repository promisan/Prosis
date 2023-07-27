<!--- ajax saving on the fly --->		
	
<!--- saves the report selection fields --->

<cfscript>
function cleanText(inputText){
	returnText = inputText;
//these steps are not working..need to reveiew	
	returnText = REReplaceNoCase(returnText, "<span [A-Za-z0-9_]*>", "", "ALL");
	returnText = ReplaceNoCase(returnText, "</span>", "", "ALL"); 
	return returnText;
	}
</cfscript>

<cfquery name="Documents" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   OrganizationObjectActionReport
		WHERE  ActionId   = '#URL.memoactionID#' 
		AND    DocumentId = '#URL.documentid#' 
</cfquery>


<cfloop query="documents">
		
	<cfif url.element eq "DocumentContent">
	
		<cfparam name="Form.Field#url.frm#" default="">
		<cfset content = evaluate("Form.Field#url.frm#")>		
				
		<!---
			cfset content = cleanText(content)
		--->
		 														
		<cfquery name="UpdateMemo" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 UPDATE OrganizationObjectActionReport 		
			 SET    #url.element#   = '#content#', 
			        ActionStatus    = '1'
			 WHERE  ActionId        = '#URL.MemoActionId#' 		 
			 AND    DocumentId      = '#URL.DocumentId#' 			 
		</cfquery>				
				
	<cfelse>
	
		<cfparam name="form.MarginTop"    default="2">
		<cfparam name="form.MarginBottom" default="2">
	
		<cfparam name="Form.hdrField#url.frm#" default="">
		<cfset header = evaluate("Form.hdrField#url.frm#")>
		<cfparam name="Form.ftrField#url.frm#" default="">
		<cfset footer = evaluate("Form.ftrField#url.frm#")>
				
		<cfquery name="UpdateMemo" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 UPDATE OrganizationObjectActionReport 		
			 SET    DocumentHeader        = '#header#', 
			        DocumentFooter        = '#footer#', 
			        DocumentMarginTop     = '#form.MarginTop#',
					DocumentMarginBottom  = '#form.MarginBottom#',
			        ActionStatus          = '1'
			 WHERE  ActionId              = '#URL.MemoActionID#' 		 
			 AND    DocumentId            = '#URL.DocumentId#'
			 
		</cfquery>
		
	</cfif>	
			
</cfloop>

<cfoutput>Saved #timeformat(now(),"HH:MM:SS")#</cfoutput>

