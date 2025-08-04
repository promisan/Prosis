<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cf_screentop html="no" height="100%" scroll="no" Jquery="yes" busy="busy10.gif">

<cfajaximport tags="cfform,cfdiv,cfmediaplayer,cfwindow">
<cf_listingscript mode="standard">
<cf_actionListingScript>
<cf_fileLibraryScript>
<cf_presentationScript>
<cf_dialogStaffing>
<cf_layoutScript>
<cf_calendarViewScript>
<cf_paneScript>

<cfoutput>
	
	<script language="JavaScript">
		
		function actionsave(id,line) {   
			ColdFusion.navigate('#SESSION.root#/workorder/portal/customer/action/WorkOrderActionSubmit.cfm?line='+line+'&workactionid='+id,'process_'+id,'','','POST','form_'+id)
		}
		
		function workflowaction(key,box) {	
				  
		    se = document.getElementById(box)
			ex = document.getElementById("exp"+key)
			co = document.getElementById("col"+key)
						
			if (se.className == "hide") {		
			   se.className = "regular" 		   
			   co.className = "regular"
			   ex.className = "hide"	
			   ColdFusion.navigate('#client.root#/workorder/application/workorder/ServiceDetails/Action/WorkActionWorkflow.cfm?ajaxid='+key,key)		   
					   
			} else {se.className = "hide"
			        ex.className = "regular"				
			   	    co.className = "hide" 
		    } 		
		}
	
	</script>

</cfoutput>

<!--- Defines the picture profile update container --->
<cf_UserProfilePictureContainer>		

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
		
		<!--- main page for services --->

		<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">	
		
			<cfoutput>  
			
			<tr>
				<td height="39px" valign="bottom" style="background-image:url('Images/menu/bar_bg.png'); background-position:bottom; background-repeat:repeat-x">
					<div style="position:relative;  z-index:7">
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
											<cf_UserProfilePicture mode="edit">
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
				<td height="1px" bgcolor="silver"></td>
			</tr>
								
			<tr>
				<td height="100%">
					<table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">						
						<tr>
							<td id="menucontent" name="menucontent" align="center" bgcolor="white" height="100%">																								
								<cfinclude template="../../../Portal/SelfService/PortalFunctionOpen.cfm"> 
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