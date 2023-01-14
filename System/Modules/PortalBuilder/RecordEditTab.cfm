
<cfajaximport tags="cfform,cfdiv,cfwindow">

<cf_menuscript>

<cfquery name="Line" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       #client.lanPrefix#Ref_ModuleControl	 
	 WHERE		<cfif url.id neq "">SystemFunctionId = '#url.id#'<cfelse>1 = 0</cfif>
</cfquery>

<cfinclude template="../Functions/FunctionScript.cfm">

<cfset vTitleNew = "Portal"> 
<cfif lcase(url.functionClass) eq "pmobile">
	<cfset vTitleNew = "Prosis Mobile"> 
</cfif>

<cfif url.id eq "">
	<cf_screentop height="100%" banner="gray" scroll="Yes" html="Yes" label="#vTitleNew# [#url.class#]" option="Add #vTitleNew# Line" layout="webapp" JQuery="yes">
<cfelse>
	<cf_screentop height="100%" banner="gray" scroll="Yes" html="Yes" label="#vTitleNew# [#url.class#]" option="Maintain #vTitleNew# Line - #line.FunctionClass# - #line.FunctionName#" layout="webapp" JQuery="yes">
</cfif>

<cfinclude template="RecordScript.cfm">

<cfset url.functionClass = "#url.name#">

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfoutput>
<tr><td height="34" style="padding:10px">

		<!--- top menu --->
				
		<table width="97%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
									
			<cfset ht = "64">
			<cfset wd = "64">			
			
			<tr>		
						
					<cfset itm = 0>
					
					<cfset itm = itm+1>			
										
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Function-Tab.png" 
								targetitem = "1"
								padding    = "3"
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "Function Tab"
								class      = "highlight1"
								source 	   = "RecordEditLines.cfm?id=#url.id#&name=#url.name#&class=#url.class#&systemmodule=#url.systemmodule#&functionclass=#url.functionclass#">
													
					<cfif url.id neq "">
					
						<cfset itm = itm+1>											
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Logos/Roles.png" 
									targetitem = "2"
									padding    = "3"
									iconwidth  = "#wd#" 								
									iconheight = "#ht#" 
									name       = "Roles and UserGroup"
									source 	   = "#SESSION.root#/System/Modules/Functions/FunctionRole.cfm?id=#url.id#&dialogHeight=400&systemmodule=#url.systemmodule#&functionclass=#url.functionclass#">
						
						<cfif lcase(url.systemmodule) eq "pmobile">
							<cfset itm = itm + 1>	
							<cf_menutab item  = "#itm#" 
					            iconsrc    = "Logos/System/section.png" 
								iconwidth  = "#wd#" 
								targetitem = "1"
								iconheight = "#ht#" 
								name       = "Dashboard"
								source     = "#SESSION.root#/System/Modules/PortalBuilder/Section/FunctionSection.cfm?id=#URL.ID#&systemmodule=#url.systemmodule#&functionclass=#url.functionclass#">
						</cfif>
									
					</cfif>
						
						<td width="20%"></td>								 		
				</tr>
		</table>

	</td>
 </tr>
 </cfoutput>
 
<tr><td height="1" colspan="1" class="linedotted"></td></tr>

<tr><td height="100%">
	
	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0" 
		  align="center">
		  
			<!--- <tr class="hide"><td valign="top" height="100" id="result" name="result"></td></tr> --->
			
			<cf_menucontainer item="1" class="regular">
				<cf_securediv bind="url:RecordEditLines.cfm?id=#url.id#&name=#url.name#&class=#url.class#&systemmodule=#url.systemmodule#&functionclass=#url.functionclass#" style="height:100%;">
			</cf_menucontainer>							
			
			<cf_menucontainer item="2" class="hide">			
			
												
	</table>

</td></tr>

</table>

