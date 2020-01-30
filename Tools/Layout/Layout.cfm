<cfparam name="attributes.id"					default="">
<cfparam name="attributes.name"					default="">
<cfparam name="attributes.type"					default="accordion">
<cfparam name="attributes.defaultOpen"			default="">
<cfparam name="attributes.style"				default="height:99.9%; min-height:99.9%; width:100%;">
<cfparam name="attributes.scrollFix"			default="100%">

<cfset vSpacer = "<span class='_clsSpacerIEHack' style='font-size:0.1px;'>&nbsp;</span>"> <!--- hack for IE10+ to let the browser calculate the correct height --->

<cfif thisTag.ExecutionMode is "start">
	
	<cfset vTogglerIconSize = "25px">
	
	<cfif attributes.id eq "">
		<cfset attributes.id = attributes.name>
	</cfif>
	
	<cfset vScrollFix = "100%">
	<cfset vAccordionHeightFix = "100%">
	<!--- scrollfix --->
	<cfif find("MSIE 10","#CGI.HTTP_USER_AGENT#") 
		or find("Firefox","#CGI.HTTP_USER_AGENT#") 
		or (
		    find("Mozilla/5.0","#CGI.HTTP_USER_AGENT#") 
		    and find("Trident","#CGI.HTTP_USER_AGENT#") 
		    and find("rv:11","#CGI.HTTP_USER_AGENT#") 
		    and find("like Gecko","#CGI.HTTP_USER_AGENT#")
		)
	>
		<cfset vScrollFix = attributes.scrollFix>
		<cfset vAccordionHeightFix = "auto">
       <!--- <cfset vSpacer = "">--->
	</cfif>

	<cfswitch expression="#lcase(attributes.type)#">
	
		<cfcase value="accordion">
		
			<cfoutput>
			
				<table id="#attributes.id#_accordionWrapper_#attributes.id#" style="border-collapse:separate; #attributes.style#" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td height="5"></td>
					</tr>
					
					<tr>
						<td valign="top" height="100%">
							<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
							
			</cfoutput>
					
		</cfcase>
		
		<cfcase value="border">
			
			<cfoutput>

				<table class="#attributes.id#_clsBorderWrapper" id="#attributes.id#_borderWrapper_#attributes.id#" cellpadding="0" cellspacing="0" style="border-collapse:separate; #attributes.style#" align="center">
					
					<tr class="#attributes.id#_clsBorderHEADER" style="display:none;">
						<td id="#attributes.id#_borderHEADER" class="#attributes.id#_clsBorderContainer" style="height:100px; min-height:100%; border-bottom:1px solid silver;">
							<table style="height:100%; min-height:100%; width:100%;" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top" style="height:100%; min-height:100%; width:100%;">
										#vSpacer#
										<div style="width:100%;" class="#attributes.id#_clsBorderPresenterHEADER">
											&nbsp;
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					
					<tr class="#attributes.id#_clsBorderTOP" style="display:none;">
						<td id="#attributes.id#_borderTogglerTOP" class="#attributes.id#_borderToggler" align="center" valign="top" style="height:20px; padding:3px; border:1px solid silver; cursor:pointer;" onclick="">
							<img height="#vTogglerIconSize#" width="#vTogglerIconSize#" style="cursor:pointer;">
						</td>
					</tr>
					<tr class="#attributes.id#_clsBorderTOP #attributes.id#_clsBorderTogglable" style="display:none;">
						<td id="#attributes.id#_borderTOP" class="#attributes.id#_clsBorderContainer" style="height:100px; border:1px solid silver; border-top:none;">
							<table style="height:100%; min-height:100%; width:100%;" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top" style="width:100%; display:none; border-bottom:1px dotted silver;" id="#attributes.id#_borderPresenterLabelTOP" class="#attributes.id#_clsBorderPresenterLabel">
										&nbsp;
									</td>
								</tr>
								<tr>
									<td valign="top" style="height:100%; min-height:100%; width:100%;">
										#vSpacer#
										<div style="height:#vScrollFix#; min-height:100%; width:100%;" class="#attributes.id#_clsBorderPresenterTOP">
											&nbsp;
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					
					<tr>
						<td id="#attributes.id#_borderWrapperMainContainer_#attributes.id#" style="width:100%; height:100%;">
							<table style="height:100%; min-height:100%; width:100%;" cellpadding="0" cellspacing="0">

								<tr>
								   
									<td id="#attributes.id#_borderTogglerLEFT" class="#attributes.id#_clsBorderLEFT #attributes.id#_borderToggler" align="center" valign="top" style="width:20px; padding:3px; padding-top:8px; border-left:1px solid silver; border-right:1px solid silver; cursor:pointer; display:none; height:100%;" onclick="">
										<img height="#vTogglerIconSize#" width="#vTogglerIconSize#" style="cursor:pointer;">
									</td>
																											
									<td id="#attributes.id#_borderLEFT" class="#attributes.id#_clsBorderLEFT #attributes.id#_clsBorderContainer #attributes.id#_clsBorderTogglable" style="border-right:1px solid silver; display:none; height:100%;" valign="top">
																		   
										<table style="height:100%;width:100%;" cellpadding="0" cellspacing="0">
										   
											<tr>
												<td valign="top" style="height:1%; width:100%; padding:3px; display:none; border-bottom:1px dotted silver;" id="#attributes.id#_borderPresenterLabelLEFT" class="#attributes.id#_clsBorderPresenterLabel"></td>
											</tr>											
																																	
											<tr>
												<td valign="top" style="height:100%; min-height:100%; width:100%;">
													#vSpacer# 													
													<div style="height:#vScrollFix#; min-height:100%; width:100%;" class="#attributes.id#_clsBorderPresenterLEFT">													
														&nbsp;
													</div>
												</td>
											</tr>
																						
										</table>
										
									</td>									
									
									<td id="#attributes.id#_borderCENTER" valign="top" class="#attributes.id#_clsBorderCENTER #attributes.id#_clsBorderContainer" style="width:auto; display:none; height:100%;">
										<table style="height:100%; min-height:100%; width:100%;" cellpadding="0" cellspacing="0">
											<tr>
												<td valign="top" style="height:1%; width:100%; padding:3px; display:none; border-bottom:1px dotted silver;" id="#attributes.id#_borderPresenterLabelCENTER" class="#attributes.id#_clsBorderPresenterLabel">
													&nbsp;
												</td>
											</tr>
											<tr>
												<td valign="top" style="height:100%; min-height:100%; width:100%;">
													#vSpacer#
													<div style="height:#vScrollFix#; min-height:100%; width:100%;" class="#attributes.id#_clsBorderPresenterCENTER">
														&nbsp;
													</div>
												</td>
											</tr>
										</table>
									</td>
									
									<td id="#attributes.id#_borderRIGHT"  class="#attributes.id#_clsBorderRIGHT #attributes.id#_clsBorderContainer #attributes.id#_clsBorderTogglable" style="width:300px; border-left:1px solid silver; display:none; height:100%;" valign="top">
										<table style="height:100%; min-height:100%; width:100%;" cellpadding="0" cellspacing="0">
											<tr>
												<td valign="top" style="height:1%; width:100%; padding:3px; display:none; border-bottom:1px dotted silver;" id="#attributes.id#_borderPresenterLabelRIGHT" class="#attributes.id#_clsBorderPresenterLabel">
													&nbsp;
												</td>
											</tr>
											<tr>
												<td valign="top" style="height:100%; min-height:100%; width:100%;">
													#vSpacer#
													<div style="height:#vScrollFix#; min-height:100%; width:100%;" class="#attributes.id#_clsBorderPresenterRIGHT">
														&nbsp;
													</div>
												</td>
											</tr>
										</table>
									</td>
									<td id="#attributes.id#_borderTogglerRIGHT" class="#attributes.id#_clsBorderRIGHT #attributes.id#_borderToggler" align="center" valign="top" style="width:20px; padding:3px; padding-top:8px; border-left:1px solid silver; border-right:1px solid silver; cursor:pointer; display:none; height:100%;" onclick="">
										<img height="#vTogglerIconSize#" width="#vTogglerIconSize#" style="cursor:pointer;">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					
					<tr class="#attributes.id#_clsBorderBOTTOM #attributes.id#_clsBorderTogglable" style="display:none;">
						<td id="#attributes.id#_borderBOTTOM" class="#attributes.id#_clsBorderContainer" style="height:100px; border:1px solid silver; border-bottom:none;">
							<table style="height:100%; min-height:100%; width:100%;" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top" style="width:100%; display:none; border-bottom:1px dotted silver;" id="#attributes.id#_borderPresenterLabelBOTTOM" class="#attributes.id#_clsBorderPresenterLabel">
										&nbsp;
									</td>
								</tr>
								<tr>
									<td valign="top" style="height:100%; min-height:100%; width:100%;">
										#vSpacer#
										<div style="height:#vScrollFix#; min-height:100%; width:100%;" class="#attributes.id#_clsBorderPresenterBOTTOM">
											&nbsp;
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr class="#attributes.id#_clsBorderBOTTOM" style="display:none;">
						<td id="#attributes.id#_borderTogglerBOTTOM" class="#attributes.id#_borderToggler" align="center" valign="top" style="height:20px; padding:3px; border:1px solid silver; cursor:pointer;" onclick="">
							<img height="#vTogglerIconSize#" width="#vTogglerIconSize#" style="cursor:pointer;">
						</td>
					</tr>
				</table>
			
			</cfoutput>
		
		</cfcase>
		
	</cfswitch>
	
<cfelse>
	
	<cfoutput>

		<cfswitch expression="#lcase(attributes.type)#">
		
			<cfcase value="accordion">
							
								<tr id=#attributes.id#_trFiller" style="display:table-row;">
									<td style="height:#vAccordionHeightFix#;">&nbsp;</td>
								</tr>
								
							</table>
						</td>
					</tr>
		
				</table>
				
				<cfif attributes.defaultOpen neq "">
					
					<script>
						toggleLayoutArea('#attributes.defaultOpen#', 0, function() {});	
					</script>
					
				</cfif>
				
			</cfcase>
			
			<cfcase value="border">
				<script>
					<!--- hack for IE10+ to let the browser calculate the correct height ---> 
					if (document.documentMode) {
						if (document.documentMode < 10) {
							$('._clsSpacerIEHack').css('display', 'none');
						}
					}
					
					<!--- hack for IE9- to let the browser calculate the correct height --->
					//$('###attributes.id#_borderWrapperMainContainer_#attributes.id#').css('height','94%');
					
				</script>
			</cfcase>
			
		</cfswitch>
	
	</cfoutput>

</cfif>


	
	
	
