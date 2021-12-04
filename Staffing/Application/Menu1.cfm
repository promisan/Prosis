
<cf_submenutop>

<cf_submenuLogo module="Staffing" selection="Application">

<cfparam name="URL.Operational" default="1">
	   
<cfquery name="SystemModule" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  FunctionPath = 'PostView/Staffing/PostView.cfm'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Parameter
</cfquery>

<table width="100%">
<tr><td>
	
	<cfoutput>
	
		<cfset lnk = CGI.Query_string>
		<cfif not find("operational=",CGI.Query_string)>
		   <cfset lnk = "#CGI.Query_string#&operational=1">	   
		</cfif> 
		<cfset act = replaceNoCase(lnk, "operational=0","operational=1")>
		<cfset cls = replaceNoCase(lnk, "operational=1","operational=0")>
	
		<table>
		
			<tr><td height="3"></td></tr>
		
			<tr>
			
			<td style="padding-left:6px">
	
			<table>				
				<tr id="dSearchBar">									
					<td align="left" style="padding-left:38px;padding-right:3px">
					<cf_uitooltip tooltip="Search for an entity">
					<input style="padding-left:8px;width:180;font-size:18px;height:30px" 
					class="regularxl" type="text" name="iSearch" id="iSearch"  maxlenght="40" value="">
					</cf_uitooltip>
					</td>
				</tr>	
			</table>	
		
			</td>		
			
			<cfif getAdministrator("*") eq "1">	
			
				<td style="height:50px;width:20px"></td>
				<td class="label">
				<input type="radio" class="radiol" name="toggle" value="1" onclick="Prosis.busy('yes');ptoken.location('menu1.cfm?#act#')" <cfif url.operational eq "1">checked</cfif>>
				</td><td>&nbsp;</td><td class="labellarge" style="cursor: pointer;" onclick="Prosis.busy('yes');window.location='menu1.cfm?#act#'"><cfif url.operational eq "1"><b></cfif><cf_tl id="Active"></td>						
				<td style="padding-left:10px">			
				<input type="radio" class="radiol" name="toggle" value="0" onclick="Prosis.busy('yes');ptoken.location('menu1.cfm?#cls#')" <cfif url.operational eq "0">checked</cfif>>
				</td><td>&nbsp;</td><td class="labellarge" style="cursor: pointer;" onclick="Prosis.busy('yes');window.location='menu1.cfm?#cls#'"><font color="blue"><cfif url.operational eq "0"><b></cfif><cf_tl id="Archive"></td>
				
			<cfelse>
			
				<input type="hidden" name="name" value="1">
			
			</cfif>
						
			</tr>
		
		</table>
	
	</cfoutput>

</td></tr>

<tr><td>

	<!--- mission/tree sensitve menu --->
	<cfset verifysource = "'HROfficer','HRAssistant','HRPosition','HRLoaner','HRLocator','HRInquiry'">
	<cfset verifytable  = "OrganizationAuthorization">
	<cfset menutemplate = "#client.virtualdir#/Staffing/Reporting/PostView/Staffing/PostView.cfm">
	
	<!--- mission/tree sensitve menu --->	
	<cfset target       = "mission">
	<cfset module       = "'Staffing'">
	<cfset class        = "#Parameter.AccessMode#">	
	
	<cfinclude template="../../Tools/SubmenuMission.cfm">	

</td></tr>

</table>	

<script>
	Prosis.busy('no')	
</script>
