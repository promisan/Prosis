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