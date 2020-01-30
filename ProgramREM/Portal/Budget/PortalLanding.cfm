
<cf_screentop html="no">

<table cellpadding="0" cellspacing="0" width="100%" height="100%">

	<tr>
		<td>
		
			<table cellpadding="0" cellspacing="0" width="100%" height="100%">
							
				<tr>
					<td height="39px" valign="bottom" style="padding-left:50px; background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Portal/Selfservice/Extended/Images/menu/bar_bg2.png'); background-position:bottom; background-repeat:repeat-x">
						<cfinclude template="../../../Portal/SelfService/Extended/LogonProcessMenu.cfm">
					</td>
				</tr>
				
				<tr>					
					<td>
						<div style="width:100%; height:100%; overflow-y:auto">
							<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">								
								
								<tr>
									<td bgcolor="white" valign="top" id="menucontent" name="menucontent">
									
									<cfif client.personno eq "">									
										<table width="100%" height="50">
											<tr>
												<td align="center">
										    		<font face="Verdana" size="2">Your profile has not been initiatized. Please contact the Administrator</font>
										    	</td>
											</tr>
										</table>									
									<cfelse>
									
									  <cfoutput>
									  
									  <!--- iframe opening --->
									  									
									  <iframe src="#SESSION.root#/ProgramREM/Portal/Budget/BudgetView.cfm?webapp=#url.webapp#&id=#client.personno#&scope=portal&mid=#url.mid#&mission=#client.mission#" 
										    name="contentframe" 
											id="contentframe" 
											width="100%" 
											height="100%" 
											frameborder="0">									  
									  </iframe>	
									  
									  </cfoutput>								
									  
									</cfif>									
									
									</td>
								</tr>
								
							</table>
						</div>
					</td>
				</tr>
				
			</table>
			
		</td>
	</tr>
	
</table>
