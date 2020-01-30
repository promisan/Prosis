
<cfparam name="url.created" default="">

<cf_screentop label="#SESSION.welcome# System Notification Framework" 
   height="100%"     
   html="no">
   
   <cfajaximport tags="cfform">
	
   <script>
				
			function addEvent(){
				window.open("NotificationEditTab.cfm", "AddEvent", "left=40, top=40, width=700, height= 650, status=yes, scrollbars=no, resizable=yes");
			}
					
   </script>
	
   <cf_calendarscript>
   <cf_ListingScript>
	
	<cfif url.created neq "">
		<cf_tl id="Notification was added succesfully" class="message" var="1">
		<cfoutput>
		<script>
			alert('#lt_text#');
		</script>
		</cfoutput>
	</cfif>

<table border="0" width="100%" height="100%" align="center" cellspacing="0" cellpadding="0">		
	<tr>
		<td height="100%">		
			<table width="97%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">	
			
			    <!---
									
				<tr>
					<td height="80px">						
						<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="white">
							<tr>
								<td width="5%">
								</td>
				
								<td height="80" valign="middle" align="left" width="98%" style="top; padding-left:10px">
									<table width="100%" cellpadding="0" cellspacing="0" border="0" >
										<tr>
											<td style="z-index:1; width:646px; height:78px; position:absolute; right:0px; top:0px; background-image:url(<cfoutput>#SESSION.root#</cfoutput>/images/logos/BGV2.jpg); background-repeat:no-repeat">							
											</td>
										</tr>
										<tr>
											<td style="z-index:5; position:absolute; top:30px; left:35px; ">
												<img src="<cfoutput>#SESSION.root#</cfoutput>/images/features.png">
											</td>
										</tr>
										<tr>
											<td style="z-index:3; position:absolute; top:25px; left:90px; color:45617d; font-family:calibri; font-size:25px; font-weight:bold;">
												<cf_tl id="System Notification">
											</td>
										</tr>
										<tr>
											<td style="position:absolute; top:5px; left:90px; color:e9f4ff; font-family:calibri; font-size:55px; font-weight:bold; z-index:2">
												<cf_tl id="System Notification">
											</td>
										</tr>						
										<tr>
											<td style="position:absolute; top:50px; left:90px; color:45617d; font-family:calibri; font-size:12px; font-weight:bold; z-index:4">
												<cf_tl id="Global Message System">
											</td>
										</tr>
				
										<tr>
											<td height="10"></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>	
				
				--->
				
				<tr>
					<td class="linedotted" height="1px">
					</td>
				</tr>
				
				<tr>
					<td>
						<cfinclude template="NotificationListing.cfm">
					</td>
				</tr>				
				
			</table>
		</td>
	</tr>		
</table>	

<cf_screenBottom>
	