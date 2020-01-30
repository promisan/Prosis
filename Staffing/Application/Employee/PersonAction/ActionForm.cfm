

<cfif url.scope eq "Edit">
	
	<!---
	<cfquery name="Action" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_Action
		WHERE ActionCode IN (SELECT OrderType 
		                     FROM   WorkOrder 
					         WHERE  WorkOrderId = '#url.actionid#')	
	</cfquery>
	--->

<cfelse>
	
	<cfquery name="Action" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_Action
		WHERE ActionCode = '#url.actioncode#'	
	</cfquery>

</cfif>

<cfset l = len(action.customform)>		
<cfset path = left(action.customform,l-4)>	

<cfparam name="url.actionid"   default="00000000-0000-0000-0000-000000000000">
			 
<cfoutput> 

<input type="hidden" 
       name="formsave" 
       value="#SESSION.root#/Staffing/Application/Employee/PersonAction/#path#Submit.cfm?actionid=#url.actionid#">
	   
</cfoutput>		   
	
<!---
<cftry>
--->

	<cfinclude template="#Action.customform#">
	<!---
	<cfcatch>
	<font color="FF0000">Problem, custom form not found</font>
	</cfcatch>
</cftry>	

--->
