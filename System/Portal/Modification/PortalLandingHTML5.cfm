<cfset vLandingMission = "">
<cfif isDefined("client.mission")>
	<cfset vLandingMission = client.mission>
</cfif>

<cfparam name="url.mission" default="#vLandingMission#">

<cf_screentop html="no" height="100%" scroll="no" Jquery="yes" busy="busy10.gif">

<div style="width:100%; height:100%;">

	<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		
		<tr>
			<td id="portalcontent" height="100%">	
				
				<!--- main page for services --->
		
				<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">	  		
					<tr>
						<td height="100%">
							<table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">						
								<tr>
									<td id="menucontent" name="menucontent" align="center" bgcolor="white" height="100%" valign="top">	
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