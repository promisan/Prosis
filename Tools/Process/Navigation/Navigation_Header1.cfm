<cfparam name="Attributes.Subtitle" default="">
<cfparam name="Attributes.align"    default="center">
<cfparam name="Attributes.Toggle"   default="Yes">
<cfparam name="Attributes.Alias"   default="appsSelection">

<cfoutput>

<cfquery name="Candidate" 
    datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Applicant A, 
	         ApplicantSubmission S
	WHERE    A.PersonNo = S.PersonNo
	 AND     S.ApplicantNo = '#url.ApplicantNo#' 
</cfquery>

<cfparam name="client.topicheader" default="1">
<cfif client.topicheader eq "1">
	<cfset cl = "regular">
<cfelse>
	<cfset cl = "hide">	
</cfif>

	<table width="100%">
	<tr>
	   <td id="headerline" class="#cl#">
	   	   
			<table width="100%" cellspacing="0" cellpadding="0" >
			<tr><td valign="top">
			
				<cfquery name="Section" 
					datasource="#Attributes.Alias#">
					SELECT   *
					FROM     #CLIENT.LanPrefix#Ref_#Object#Section
					WHERE    Code = '#Section#'
				</cfquery>
				
				<table width="100%">
					<tr><td height="7"></td></tr>
					<tr>
						<td 
							class="labelmedium" 
							style="font-size:18px;padding-left:5px;cursor:pointer; width:1%;" 
							valign="top" 
							<cfif attributes.toggle eq "Yes">onclick="$('.navigationInstructions_#Section.code#').fadeToggle(350);"</cfif>>
							&nbsp;<img src="#SESSION.root#/Images/#section.instructionImage#" alt="" width="55" height="55" border="0">
						</td>
						<td>
							<table width="98%">
								<!--- <tr>
									<td class="labelmedium">#Section.DescriptionTooltip#</td>
								</tr> --->
								<tr>
									<td 
										class="labelmedium navigationInstructions_#Section.code#"
										style="padding:15px; padding-top:5px; font-size:16px;">
										
										#Section.Instruction#
										
									</td>
								</tr>
							</table>
						</td>
					
					</tr>
					
				</table>
				</td><td align="right"></td>
				</tr>		
					
			</table>
	   
	   </td></tr></table>

</cfoutput>