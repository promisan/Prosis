<cfquery name="Document" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   OrganizationObjectActionReport
		WHERE  ActionId   = '#Action.ActionId#'
	</cfquery>

	<!--- --------------- --->										
	<!--- show memo/notes --->
	<!--- --------------- --->
													
	<cfif (document.recordcount gte "1" and Action.ProcessMode eq "0") or Action.EnableTextArea gte "1">
				  
	   <tr><td colspan="2">
	   		
 		   	  <cfset url.MemoActionId = Action.ActionId>					  
			  <cfset url.textmode = "edit">
			  <table width="100%" border="0" align="center">
			  <tr><td>  						 						  					  	   				   
		   		<cfinclude template="ProcessActionMemo.cfm">	  								
				</td></tr>
		      </table>						
 			
	   </td></tr>
	   
	   <cfif Action.EnableTextArea eq "0">
	   
    		  	<input type = "hidden" name = "actionmemo" id="actionmemo"  value= "#ActionMemo#">
	   </cfif>	
   
   	</cfif>