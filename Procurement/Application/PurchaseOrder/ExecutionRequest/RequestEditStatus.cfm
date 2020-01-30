<cfquery name="Get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    PurchaseExecutionRequest
		WHERE   RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Status"
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * FROM Ref_EntityStatus
	 WHERE  EntityCode = 'ProcExecution'
	 AND EntityStatus = '#Get.ActionStatus#'	
</cfquery>	
		
<cfset vtag = 0 >		

<cfif Get.ActionStatus eq "0">
  <cfset c = "6688aa">
<cfelseif Get.ActionStatus eq "9"> 
  <cfset c = "red"> 
  <cfoutput>
  <a href="javascript:showreasons('#url.id#')">
  </cfoutput>
  <cfset vtag = 1>
<cfelse>
  <cfset c = "black"> 
</cfif>

<cfoutput>
<font face="calibri" size="3" color="#c#">
#Status.StatusDescription# (#Status.EntityStatus#)</b>
</font>

</cfoutput>

<cfif vtag eq 1>
	</a>
</cfif>
