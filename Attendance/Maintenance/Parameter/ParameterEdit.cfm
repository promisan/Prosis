<cf_menuscript>

<cfajaximport tags="cfdiv, cfform">

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "0">
<!--- <cfset save         = "1"> ---> 
<cfinclude template = "../HeaderMaintain.cfm"> 

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<table width="95%" border="0" cellspacing="0" cellpadding="0" class="formpadding" align="center" bordercolor="silver">

	<tr><td height="8"></td></tr>

	<tr>
			
		<td valign="top">
		
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
				
				<tr><td height="4"></td></tr>
				<tr><td class="labelit"><b><font color="6688aa">Attention:</td></tr>
				<tr><td height="3"></td></tr>
				<tr><td class="labelit"><font color="808080">
				Attendance Setup Parameters should <b>only</b> be changed if you are absolutely certain of their effect on the system.
				</td></tr>
				<tr><td height="5"></td></tr>			
				<tr><td class="labelit"><font color="808080">In case you have any doubt always consult your assignated focal point.</td></tr>
				<tr><td height="5"></td></tr>
				
			</table>
			
		</td>
	</tr>

	<tr>
		<td>
	
		<table width="25%">		  		
						
			<cfset ht = "32">
			<cfset wd = "32">
							
			<tr>					
						
					<cf_menutab item       = "1" 
					            iconsrc    = "Logos/System/config.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								padding    = "0"
								class      = "highlight1"
								name       = "Global Settings"
								source     = "ParameterGeneralSettings.cfm?idmenu=#URL.IDMenu#">			
			</tr>
										
		</table>
		
		</td>
	</tr>
	
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>

	<tr><td height="100%">
	
	<cf_menucontainer item="1" class="regular">
		<cfdiv bind="url:ParameterGeneralSettings.cfm?idmenu=#URL.IDMenu#">
	</cf_menucontainer>

	</td></tr>

</table>