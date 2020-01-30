
<cfparam name="url.toggle" default="0">

<cfoutput>

<cfif url.toggle eq "1">
	
	<cfquery name="Record"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   OrganizationObjectActionCost
		WHERE  ObjectCostId = '#ObjectCostId#'
	</cfquery>
	
	<cfif record.actionStatus is "0">
	  <cfset st = "1">
	   <script>
		   document.getElementById("check#url.row#").className = "regular"
       </script>
	<cfelse>  
	  <cfset st = "0">
	   <script>
		   document.getElementById("check#url.row#").className = "hide"
	   </script>
	</cfif>

	<cfquery name="Update"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE OrganizationObjectActionCost
	SET actionStatus    = '#st#',
	   actionStatusUserId = '#SESSION.acc#',
	   actionStatusDate = getDate() 
	WHERE  ObjectCostId = '#ObjectCostId#'
   </cfquery>
   		
</cfif>

<cfquery name="Record"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   OrganizationObjectActionCost
	WHERE  ObjectCostId = '#ObjectCostId#'
</cfquery>

<!--- show result --->

	<table cellspacing="0" cellpadding="0" class="formpadding"><tr>		
		<td width="45" align="center">	
				
			   <cfif record.actionstatus eq "0">
		
			    <img src="#SESSION.root#/Images/light_red3.gif"
			     border="0"
				 alt="Enable"
				 onClick="costtoggle('#ObjectCostId#','#url.row#')"
				 align="absmiddle"
			     style="cursor: pointer;">	
			
			   <cfelse>
			    
			     <img src="#SESSION.root#/Images/light_green2.gif"
			     border="0"
				 alt="Disable"
				 onClick="costtoggle('#ObjectCostId#','#url.row#')"
				 align="absmiddle"
			     style="cursor: pointer;">
									
   			   </cfif>			  
		</td>
			
</cfoutput>	

</tr></table>
