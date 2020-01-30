<head>
<cfoutput>
<script type="text/javascript">
  // Change cf's AJAX "loading" HTML
  _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy5.gif'/>";
</script>

<script type="text/javascript" src="#SESSION.root#/Scripts/Drag/draggable.js"></script>

	<script language="JavaScript">
	
	  function faqpage (dir,op,op2)	{
		ColdFusion.navigate('../../../../custom/portal/muc/faq.cfm?dir='+dir+'&id='+op+'&id2='+op2,'faqdetail');
		}

	  function goToBalance(url) {
	  ColdFusion.navigate(url,'menucontent');
	  }
	  
	  function addRequest(mission,domain,status,wid,wol) {			
	    w = #CLIENT.width# - 130;  
        h = #CLIENT.height# - 140;	
		window.open("#SESSION.root#/WorkOrder/Application/Request/Request/Create/Document.cfm?scope=portal&mission=" + mission + "&domain=" + domain + "&status=" + status + "&workorderid="+wid+"&workorderline="+wol, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ",toolbar=no,menubar=no,status=yes,scrollbars=no,resizable=yes");
	  }
	  
	</script>
	
	<LINK REL=StyleSheet HREF="#SESSION.root#/Portal/Selfservice/extended/style.css" TYPE="text/css">
	<LINK REL=StyleSheet HREF="#SESSION.root#/Portal/Logon/Bluegreen/pkdb.css" TYPE="text/css">
</cfoutput>
</head>

<cfajaximport tags="cfwindow,cfform,cfdiv,cfmediaplayer">
<cf_listingscript>

<cfparam name="url.id" default="muc">

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

<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	
<!--- top menu, take the mission from the ref_module control entry, but more correctly we
need to select it like for fuel: hanno 01/02/2012 --->

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
		
		<!--- main page for services --->

		<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0" >	
			<cfoutput>  
			<cfif client.personno eq "">
			<tr>
				<td height="30px" align="center" valign="middle" style="color:red; font-size: 18px; font-family: Calibri; font-weight: bold; padding-top:45px">
					You do not have Services associated to your account. Please click on the link below to request access.
				</td>
			</tr>
			
			<tr>
		    	<td height="20px" align="center" valign="top" style="font: normal 14px Calibri; color: silver; padding-top:12px">    		
					<a onClick="ColdFusion.navigate('#SESSION.root#/Portal/selfservice/Extended/requestaccess.cfm?id=#url.id#&sfx=0','dError')" style="cursor:pointer">
						Request Access
					</a>
				</td>
			</tr>	
			<tr><td id="dError">&nbsp;</td></tr>
				
			<cfelse>
			
			<tr>
				<td height="39px" valign="bottom">
					<div style="position:relative;  z-index:1">
					<table height="39px" width="100%" cellpadding="0" cellspacing="0" border="0">
					<!--- menu --->
						<tr>
							<td height="45px" valign="bottom" style="padding-left:50px; background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Portal/Selfservice/Extended/Images/menu/bar_bg2.png'); background-position:bottom; background-repeat:repeat-x">
								<cfset show.personNo = "no">
								<cfinclude template="../../../Portal/SelfService/Extended/LogonProcessMenu.cfm">								
							</td>						
						
							<td align="right" valign="middle" style="padding-right:30px; background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Portal/Selfservice/Extended/Images/menu/bar_bg2.png'); background-position:bottom; background-repeat:repeat-x ">
								<table cellpadding="0" cellspacing="0" border="0" width="30px" height="100%">
									<tr>										
										<td width="30px" align="left">
										<cf_PictureView documentpath="User"
								                subdirectory="#SESSION.acc#"
												filter="Picture_" 							
												width="30" 
												height="30" 
												mode="view">
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					</div>
				</td>
			</tr>	
			
			<tr>
				<td height="1px" bgcolor="silver" id="dprocess" name="dprocess"></td>
			</tr>
			
			<tr>
				<td height="100%">
					<table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">						
						<tr>
							<td id="menucontent" name="menucontent" valign="top" bgcolor="white" height="100%">									
							   <cfinclude template="../../../Portal/SelfService/PortalFunctionOpen.cfm">	
							</td>
						</tr>
					</table>
				</td>
			</tr>	
			</cfif>
			</cfoutput>
		</table>
									
	</td>
	</tr>				
			
</table>

