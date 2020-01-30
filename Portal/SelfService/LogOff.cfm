<cfparam name="url.scope" default="">

<cfif url.scope eq "Portal">

	<cfquery name="delete" 
	 datasource="AppsSystem">
		DELETE UserStatus 
		WHERE  Account   = '#SESSION.acc#' 
		AND    HostName  = '#url.host#' 
		AND    NodeIP    = '#CGI.Remote_Addr#' 
	</cfquery>
		
	<!--- removing all client variables --->
	
	<cfloop list="#getClientVariablesList()#" index="var">
	
		<cfif var neq "acc" and var neq "logon" and var neq "indexno" and var neq "mission" and var neq "languageid" and var neq "lanPrefix">
		 <cfset deleteClientVariable(var)>
		</cfif>
		
	</cfloop>
	
	<cfset SESSION.authent = "0">
	<cfset vLogOut = StructClear(SESSION)>	
	
	<script language="JavaScript1.2">
		window.location.reload();
	</script>
	
<cfelse>

	<cfset host = "#SESSION.root#/Portal/SelfService/LogonAjax.cfm?link=#url.link#">
	
	<cfquery name="delete" 
	 datasource="AppsSystem">
		DELETE UserStatus 
		WHERE  Account   = '#SESSION.acc#' 
		AND    HostName  = '#host#' 
		AND    NodeIP    = '#CGI.Remote_Addr#' 
	</cfquery>	
	
	<!--- removing all client variables --->
	
	<cfloop list="#getClientVariablesList()#" index="var">
	
		<cfif var neq "acc" and var neq "logon"  and var neq "indexno">
		 <cfset deleteClientVariable(var)>
		</cfif>
		
	</cfloop>
	
	<cfset SESSION.authent = "0">
	<cfset vLogOut = StructClear(SESSION)>	
	
	<cfoutput>
	   <script language="JavaScript1.2">
		   ColdFusion.navigate('#host#','detailcontent')
	  </script>
	</cfoutput>

</cfif>

