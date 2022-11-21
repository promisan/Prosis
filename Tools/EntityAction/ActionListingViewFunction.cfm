
<!--- make sure -fields- are always made visible by default based on the action --->
  	   
<cfquery name="Function" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	   
     SELECT    *
	 FROM      Ref_EntityDocument
	 WHERE     DocumentType = 'function'
	 AND       Operational = 1
	 AND       DocumentMode = 'Embed'
	 AND       DocumentId IN (SELECT DocumentId 
	                            FROM   Ref_EntityActionPublishDocument 
								WHERE  ActionCode      = '#ActionCode#'
								AND    ActionPublishNo = '#Object.ActionPublishNo#' 
								AND    Operational = 1) 
</cfquery>

<cfoutput>
			
	<cfif Function.recordcount gt "0">
		
		<cfloop query="function">
				
		<tr>
			<td colspan="#col#" align="left">
			
			<table width="98%" align="center" cellspacing="0" cellpadding="0">
															
					<cfif documentcode eq "ftme">
					
					   <cfset url.objectid   = Object.ObjectId>
					   <cfset url.actionid   = Actions.ActionId>
					   <cfset url.mode       = "work">
					   <cfset url.detailedit = "No">
					   
					   <tr><td height="0">			   
					   <cfinclude template="Details/Cost/CostList.cfm">					   
					   </td></tr>
					
					</cfif>
					
					<cfif documentcode eq "fled">
											
							<tr><td height="0" id="#DocumentCode#_#Object.ObjectId#">
												 
						 	<cf_LedgerTransaction
								 mission             = "#Object.mission#"								 
							     TransactionSource   = "WorkflowSeries" 			 
								 TransactionSourceId = "#Object.ObjectId#"
								 editmode            = "view"
								 label               = "Financial Transaction"
								 debitcredit         = "Debit"				 
								 box                 = "#DocumentCode#_#Object.ObjectId#">		
							
					
					</cfif>
							
					
					<cfif documentcode eq "fexp">
					
					   <cfset url.objectid   = Object.ObjectId>
					   <cfset url.actionid   = Actions.ActionId>
					   <cfset url.mode       = "cost">
					   <cfset url.detailedit = "No">
					   
					   <tr><td height="0">
					   <cfinclude template="Details/Cost/CostList.cfm">
					   </td></tr>				   
					
					</cfif>
										
					<cfif documentcode eq "fnts">
					
					   <cfset url.objectid   = Object.ObjectId>
					   <cfset url.actionCode = Actions.ActionCode>
					   <cfset url.actionid   = Actions.ActionId>
					   <cfset url.mode       = "note">
					   <cfset url.detailedit = "No">
					   <cfset url.box        = "myboxfnts">
					   
					    <tr><td height="0">
					   <cfinclude template="Details/Notes/NoteList.cfm">
					    </td></tr>												
					
					</cfif>
					
					<cfif documentcode eq "ftpl">
					
					   <cfset url.objectid   = Object.ObjectId>
					   <cfset url.observationid  = Object.ObjectKeyValue4>
					   <cfset url.actionCode = Actions.ActionCode>
					   <cfset url.mode       = "note">
					   <cfset url.detailedit = "No">
					   					   
					    <tr><td height="0">
					   <cfinclude template="Details/Template/TemplateFile.cfm">
					    </td></tr>
					
					</cfif>
							
			</table>
			</td>
		</tr>		
		
		</cfloop>
				
	</cfif>

</cfoutput>			
			