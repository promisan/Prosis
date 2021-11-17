
<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Parameter 
</cfquery>

<cfquery name="Owner" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AuthorizationRoleOwner
</cfquery>

<cfquery name="Language" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT Code, SystemDefault
	FROM   Ref_SystemLanguage
	WHERE  Operational > 0
</cfquery>

<cfform action="ParameterSystemSubmit.cfm" method="POST" name="parameter" target="myresult">		

<table width="98%" align="center" class="formpadding">

<tr><td height="3"></td></tr>

<tr class="hide"><td colspan="5" height="300">
	<iframe name="myresult" id="myresult" width="100%" height="500" scrolling="no" frameborder="0"></iframe>
</td></tr>

<tr><td colspan="5">
	<table><tr><td class="labellarge">
	<font color="808080">Installation Parameters apply to ALL application server instances.</font>
	</td></tr>
	</table>
</td></tr>
	
<cf_menuscript>
	
<tr><td class="line"></td></tr>
		
<tr><td valign="top" height="90%" width="100%">
	
	<cfset ht = "54">
	<cfset wd = "54">
	
	<table height="98%">
	
	<tr>				

			<cfif url.action eq 1><cfset vclass="highlight1"><cfelse><cfset vclass="normal"></cfif>													
			<cf_menutab item       = "1" 
		        iconsrc    = "Logos/System/Authorization.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 				
				class      = "#vclass#"								
				name       = "User Authentication">		
				
			<cfif url.action eq 2><cfset vclass="highlight1"><cfelse><cfset vclass="normal"></cfif>						
			<cf_menutab item       = "2" 
		        iconsrc    = "Release.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 				
				class      = "#vclass#"				
				name       = "Registration and release">			

			<cfif url.action eq 3><cfset vclass="highlight1"><cfelse><cfset vclass="normal"></cfif>										
			<cf_menutab item       = "3" 
		        iconsrc    = "Logos/System/Servers.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 				
				class      = "#vclass#"								
				name       = "Servers">					
				
			<cfif url.action eq 4><cfset vclass="highlight1"><cfelse><cfset vclass="normal"></cfif>						
			<cf_menutab item       = "4" 
		        iconsrc    = "Logos/System/Reports.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 				
				class      = "#vclass#"								
				name       = "Reporting Framework">					
							
			<cfif url.action eq 5><cfset vclass="highlight1"><cfelse><cfset vclass="normal"></cfif>						
			<cf_menutab item       = "5" 
		        iconsrc    = "Logos/System/Modules.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 				
				class      = "#vclass#"								
				name       = "Modules and License">				
	
	</tr>
	
	</table>
	
</td>
	
</tr>

<tr><td class="line"></td></tr>
	
<tr>

	<td width="100%" style="padding-left:30px" height="100%" valign="top">
	
	<table width="100%" border="0" align="center">
	
		<cfif url.action eq 1><cfset vclass="regular"><cfelse><cfset vclass="hide"></cfif>
		<cf_menucontainer item="1" class="#vclass#">
		     <cfinclude template="ParameterSystemEditAuthentication.cfm">
		<cf_menucontainer>
		
			
		<cfif url.action eq 2><cfset vclass="regular"><cfelse><cfset vclass="hide"></cfif>
		<cf_menucontainer item="2" class="#vclass#">
			 <cfinclude template="ParameterSystemEditRegistration.cfm">
		<cf_menucontainer>		
				
		<cfif url.action eq 3><cfset vclass="regular"><cfelse><cfset vclass="hide"></cfif>
		<cf_menucontainer item="3" class="#vclass#">
			<cfinclude template="ParameterSystemEditServer.cfm">
		<cf_menucontainer>
				
		<cfif url.action eq 4><cfset vclass="regular"><cfelse><cfset vclass="hide"></cfif>
		<cf_menucontainer item="4" class="#vclass#">
			<cfinclude template="ParameterSystemEditReporting.cfm">
		<cf_menucontainer>
						
		<cfif url.action eq 5><cfset vclass="regular"><cfelse><cfset vclass="hide"></cfif>		
		<cf_menucontainer item="5" class="#vclass#">
			<cfinclude template="ParameterSystemEditLicense.cfm">
		<cf_menucontainer>
				
	
	</table>
	
	</td>
	
</tr>

<tr><td height="10">
	
		<table height="100%" cellspacing="0" cellpadding="0" class="formpadding">	
		
		<tr><td class="labelmedium2" style="padding:4px"><font color="C10000">Installation Parameters should <b>only</b> be changed if you are absolutely certain of their effect on the system.</font>
		<font color="808080">Change to any of the Parameters values <b>IS</b> logged in an Audit Trail. In case you have any doubt always consult your assignated focal point.</td></tr>
		</table>
	
	</td></tr>

</table>

</cfform>

