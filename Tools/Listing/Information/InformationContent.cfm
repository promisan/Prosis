
<cfparam name="attributes.systemfunctionid" default="38c3b31e-ae5e-4083-c0b7-6ea6b2655fb6">
<cfparam name="attributes.mission" default="MINUSTAH">
<cfparam name="attributes.id"      default="00000000-0000-0000-0000-000000000000">
<cfparam name="attributes.columns" default="2">

<cfquery name="Menu" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   xl#Client.LanguageId#_Ref_ModuleControl R
	WHERE SystemFunctionId = '#attributes.SystemFunctionId#'	
</cfquery>

<br>

<table width="95%" cellspacing="0" border="0" cellpadding="0" align="center">
	
	<!---
	<cfoutput>
		<tr>
			<td colspan="2" style="padding:4px" align="center"><font face="Verdana" size="3">#Menu.FunctionName#</font></td>
		</tr>
	</cfoutput>
	--->
	
	<cfquery name="Section" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     xl#Client.LanguageId#_Ref_ModuleControlSection R
		WHERE    SystemFunctionId = '#attributes.SystemFunctionId#'	
		ORDER BY ListingOrder
	</cfquery>
		
	<cfset row = 0>
	
	<cfoutput query="Section">
					
		<cfset row = row+1>
		
		<cfif row eq "1"><tr></cfif>
		
		<cfset bgColor = "D1DFE0">
				
		<td width="50%" valign="top" style="padding:3px;border:0px solid silver" height="100%">	
		
			<cf_tableround mode="solidcolor" color="#bgColor#">
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td rowspan="3" height="80" width="120" align="center" style="padding:8px">
					
					<cfif FileExists('#SESSION.rootPath#\tools\listing\information\#sectionIcon#')>
						<img src    = "#SESSION.root#/tools/listing/information/#sectionIcon#"						
						   	title   = "#SectionName#" 
							height  = "120"						
						   	border  = "0" 
						   	align   = "absmiddle">
					</cfif>				
					</td>
					<td valign="top" height="1" height="20" style="padding:4px">					
					
					<table cellspacing="0" cellpadding="0" width="100%" class="formpadding">
					
						<tr><td><font size="4">#SectionName#</font></td></tr>					
											
						<tr><td height="1" style="border-top:1px dotted silver"></td></tr>
								
						<tr><td valign="top">				
						   <cfinclude template="InformationContentCell.cfm">										
							</td>
						</tr>	
					
					</table>		
					
					</td>
					
				</tr>		
				
			</table>	
			
		</td>
		
		</cf_tableround>
		
		<cfif row eq "#attributes.columns#"></tr><cfset row = 0></cfif>
	
	</cfoutput>

</table>
