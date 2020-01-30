
<head>
<cfoutput>
<script type="text/javascript">
  // Change cf's AJAX "loading" HTML
  _cf_loadingtexthtml="<div><img src='#Client.VirtualDir#/images/busy5.gif'/>";
</script>
<LINK REL=StyleSheet HREF="#SESSION.root#/Portal/Selfservice/extended/style.css" TYPE="text/css">
<LINK REL=StyleSheet HREF="#SESSION.root#/Portal/Logon/Bluegreen/pkdb.css" TYPE="text/css">
</cfoutput>
</head>

<!--- load the scripts --->

<cfquery name="System" 
datasource="AppsSystem">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  IN ('SelfService','Portal')
	AND    FunctionName   = '#url.id#' 
</cfquery>

<cfquery name="Main" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   #CLIENT.LanPrefix#Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  = 'SelfService'
	AND    FunctionName   = '#url.id#'
	AND    (MenuClass     = 'Mission' or MenuClass = 'Main')
	ORDER BY MenuOrder 
</cfquery>

<cfparam name="URL.Label"    default="ICT">
<cfparam name="URL.PersonNo" default="#client.PersonNo#">

<cfajaximport>

<div style="width:100%; height:100%; position:relative; z-index:3">

<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	
<!--- top menu --->

<cfif url.mission eq "">
	<cfset url.mission  = "#system.FunctionCondition#">
</cfif>
		
<cfquery name="Parameter" 
datasource="AppsWorkOrder">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.mission#'	
</cfquery>
	
	<tr>
	<td id="portalcontent">	
		
		<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">	
		
			<cfoutput>  
						
			<tr>
				<td height="39px" valign="bottom" style="background-image:url('Images/menu/bar_bg.png'); background-position:bottom; background-repeat:repeat-x">
					<div style="position:relative;  z-index:7">
					<table height="39px" width="100%" cellpadding="0" cellspacing="0" border="0">
					<!--- menu --->
						<tr>
							<td height="45px" valign="bottom" style="padding-left:50px; background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Portal/Selfservice/Extended/Images/menu/bar_bg2.png'); background-position:bottom; background-repeat:repeat-x">
								<cfset show.personNo = "yes">
								<cfinclude template="../../Portal/SelfService/Extended/LogonProcessMenu.cfm">								
							</td>						
						</tr>
					</table>
					</div>
				</td>
			</tr>	
			<tr>
				<td height="1px" bgcolor="silver"></td>
			</tr>
			<tr>
				<td height="100%">
					<table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">						
						<tr>
							<td id="menucontent" name="menucontent" valign="top" bgcolor="white" height="100%">								
								<cfinclude template="CaseOpen.cfm"> 
							</td>
						</tr>
					</table>
				</td>
			</tr>
							
			</cfoutput>
			
		</table>
									
	</td>
	</tr>				
			
</table>
</div>

