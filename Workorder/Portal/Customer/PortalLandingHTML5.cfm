<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.mission" default="#client.mission#">

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
<cf_UserProfilePictureContainer>


<cfinclude template="../../../Warehouse/Portal/ProcessScript.cfm">

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

<div style="width:100%; height:100%;">

	<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		
		<tr>
			<td id="portalcontent" height="100%">	
				
				<!--- main page for services --->
		
				<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">	  		
					<tr>
						<td height="100%">
							<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">						
								<tr>
									<td id="menucontent" name="menucontent" align="center" height="100%" valign="top">																								
										<cfinclude template="../../../Portal/SelfService/HTML5/PortalFunctionOpen.cfm"> 
									</td>
								</tr>
							</table>
						</td>
					</tr>			
				</table>
											
			</td>
		</tr>				
				
	</table>

</div>