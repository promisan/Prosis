
<cfoutput>

<!--- 1. pass the mission and check if user has been granted request rights --->

<cfparam name="url.idmenu" default="">
<cfparam name="url.systemfunctionid" default="#url.idmenu#">
<cfparam name="URL.Mission" default="Promisan">

<cfset access = "ALL">

<cfif access eq "NONE">

	<table align="center"><tr><td height="60" class="labelit">
	   No access was granted to your account to manage stock request and/or taskorder</font>
	      </td></tr>
	</table>
	<cfabort>

</cfif>

<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
</cfquery>
	
<cfajaximport tags="cfwindow,cfform,cfinput-datefield,cfdiv">

<cf_screentop html="No" jQuery="Yes" ValidateSession="No">  <!--- 2/11/2012 this is superseded by the parent screen called Portal/Extended/LogonProcessMenu.cfm line 114 --->

<cf_dialogMaterial>
<cf_dialogProcurement>

<cf_ActionListingScript>
<cf_calendarViewscript>
<cf_fileLibraryScript>
<cf_presentationScript>
<cf_CalendarScript>
<cf_LayoutScript>
<cf_listingscript mode="regular">

<cfinclude template="ProcessScript.cfm">

<style>
/*--------------------------------------------------------*/
/*---------------Sub Menu---------------------------------*/
/*--------------------------------------------------------*/
	 
	td.receipt {
		padding : 1px;
		border : 1px dotted silver 
		}		
	td.sel {
		background-color:##e8f2fb;
		}	
	td.regular1 {
		padding:3px;
		}
	html,
	body {
		background-color: transparent;
	}

</style>

</cfoutput>

<cfparam name="URL.Status" default="1">
<cfparam name="URL.Id"     default="0">
<cfparam name="URL.Mode"   default="regular">

<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="transparent">

<!--- menu --->

<cfif url.webapp neq "backoffice">
	
	<tr>
		<td height="45px" valign="bottom" style="padding-left:50px; background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Portal/Selfservice/Extended/Images/menu/bar_bg3.png'); background-position:bottom; background-repeat:repeat-x">
			<cfinclude template="../../Portal/SelfService/Extended/LogonProcessMenu.cfm">
		</td>
	</tr>
		
	<tr><td valign="top" bgcolor="white">
	
		<table cellpadding="0" cellspacing="0" width="100%" height="100%">
			<tr>
				<td valign="top">		
							
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					
					<tr>
						<td colspan="3" valign="top" align="center" id="menucontent" name="menucontent">
							<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cfinclude template="../../Portal/SelfService/PortalFunctionOpen.cfm">
									</td>
								</tr>
							</table>
							
						</td>
					</tr>
					
					<tr id="errorbox" class="hide">
						<td id="errorcontent" align="center" bgcolor="red"></td>
					</tr>		
						
					</table>			
		
				</td>
			</tr>
		</table>
	
	</td>
	</tr>

<cfelse>

	<TR><TD width="100%" height="100%" style="border:0px solid silver">

	<cfinclude template="Stock/InquiryWarehouse.cfm">
	
	</TD></TR>

</cfif>

</table>
