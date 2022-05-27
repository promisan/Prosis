
<!--- launch document from the my clearances listing --->

<cfparam name="url.target" default="0">

<cftry>

	<cfparam name="url.myclentity" default="">
	
	<cfset client.LogonPage = "default">
	
	<cfquery name="Object" 
	 datasource="AppsOrganization">
	 SELECT *
	 FROM OrganizationObject 		
	 WHERE (ObjectId = <cfqueryparam
						value="#URL.ID#"
						cfsqltype="CF_SQL_IDSTAMP"> 
	 OR ObjectKeyValue4 = <cfqueryparam
						value="#URL.ID#"
						cfsqltype="CF_SQL_IDSTAMP"> )
	 AND Operational  = 1  
	</cfquery>
	
	<cfif url.myclentity eq "">
	   <cfset mycl = object.entitycode>
	<cfelse>
	   <cfset mycl = url.myclentity>   
	</cfif>
					
	<cfif Object.recordcount gte "1" and Object.ObjectURL neq "">
	
		<cfquery name="Entity" 
		 datasource="AppsOrganization">
		 	 SELECT *
			 FROM   Ref_Entity
			 WHERE  EntityCode = '#Object.EntityCode#'	 
		</cfquery>
		
		<cfif url.target eq "0">
		
			    <cfset client.refer = "workflow">
				
				<cfparam name="hashvalue" default="">
																											
			    <cfinvoke component="Service.Process.System.Security" method="passtru" returnvariable="hashvalue"/>		
				
				<cfset hashvalue = "">
																																				
			    <cfif find("myclentity=",Object.ObjectURL)>				
				     <!--- prevent duplication --->
					<cflocation url="#SESSION.root#/#Object.ObjectURL#?mid=#hashvalue#" addtoken="No"> 
				<cfelseif find("refer=",Object.ObjectURL)>							
					<cflocation url="#SESSION.root#/#Object.ObjectURL#&mycl=1&myclentity=#mycl#&mid=#hashvalue#" addtoken="No"> 			
				<cfelse>			
					<cflocation url="#SESSION.root#/#Object.ObjectURL#&mycl=1&myclentity=#mycl#&refer=workflow&mid=#hashvalue#" addtoken="No"> 
				</cfif>	
				
		<cfelse>
		
				<cfset client.processPortalObjectId = object.objectid>
				<cfset client.processPortalActionCode = url.actionCode>
		        <cflocation  url="#session.root#/portal/selfservice/public.cfm?id=actionprocess">
		
		</cfif>			
		
		
	<cfelse>
		
	<cf_screentop html="No" title="Problem">
	
	<table width="90%" height="90" class="formpadding" cellspacing="0" cellpadding="0">
	<tr><td align="center" style="font-size:23px;color:red" class="labelmedium">

	<cfif Object.ObjectURL eq "">			
		<b>Attention:</b> Document could not be redirected.<br><font size="2">(Please contact your administrator)		
	<cfelse>	
  		<b>Attention:</b> Requested document has been processed already or does not longer exist.	
	</cfif>
		
	</td></tr>
	</table>
	
	</cfif>

<cfcatch>

	<cf_screentop html="No" title="Problem">
	
	<table width="90%" height="100" cellspacing="2" cellpadding="2">
	<tr><td align="center" style="padding-top:28px;color:red;font-size:23px" class="labelmedium">
	  Requested action could not be retrieved. <br><font size="2">(Please contact your administrator if the problem persists).</font>	
	</td></tr></table>

</cfcatch>

</cftry>

