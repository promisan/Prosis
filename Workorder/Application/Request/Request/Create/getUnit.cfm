
<cfparam name="url.requestid"  default="">
<cfparam name="url.orgunit"    default="0">

<cfquery name="Line" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    Request
		<cfif url.requestid eq "">
	WHERE 1=0
	<cfelse>
	WHERE  Requestid = '#url.requestid#'
	</cfif>		
</cfquery>

<cfif url.orgunit neq "0" and url.orgunit neq "">
		
	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization
		WHERE  OrgUnit = '#url.orgunit#'	
	</cfquery>
	
<cfelse>
	
	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization
		WHERE  OrgUnit = '#line.orgunit#'			
	</cfquery>
	
	<cfif Org.recordcount eq "0" and url.requestid eq "">
	
	    <!--- do no longer inherit this 21/9/2011
		
		<cfquery name="Last" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM   Request
			WHERE  OfficerUserid = '#SESSION.acc#'	
			ORDER BY Created DESC
		</cfquery>
		
		<cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Organization
			WHERE  OrgUnit = '#Last.orgunit#'			
		</cfquery>
		
		--->
		
		<cfparam name="org.orgunit"     default="">
		<cfparam name="org.orgunitname" default="">
				
	</cfif>
	
</cfif>

<table width="400" height="100%" cellspacing="0" cellpadding="0">

<tr>

	<cfif org.recordcount eq "0">
		<td style="height:25px;font-size:13px;padding-left:3px;border-left:1px solid silver;padding-top:1px;padding-bottom:1px;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;"></td>	
	</cfif>

	<cfoutput query="Org">
	
	<td style="width:2px">
		<script>
			document.getElementById('orgunit').value = "#org.orgunit#"
		</script>
	
	</td>
	<td style="height:25px;font-size:13px;padding-left:3px;border-left:1px solid silver;padding-top:1px;padding-bottom:1px;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
	#Org.OrgUnitName#
	</td>
	
	</cfoutput>
	
</tr>

</table>
