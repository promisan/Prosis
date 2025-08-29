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
<cfajaximport tags="cfform">


<cfquery name="get"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT FO.*, S.ActionStatus as SubmissionStatus
	FROM   FunctionOrganization FO, Ref_SubmissionEdition S
	WHERE  FunctionId           = '#url.idfunction#'
	AND    FO.SubmissionEdition = S.SubmissionEdition
</cfquery>

<cfquery name="language"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_SystemLanguage
	WHERE    LanguageCode != '' AND Operational != '0'
	ORDER BY LanguageCode	
</cfquery>

<table width="100%" height="100%" align="center">


	<cfif get.SubmissionStatus lte "3">

	<tr><td height="40">
					
		<table width="100%" height="100%" align="center">		  		
						
			<cfset ht = "30">
			<cfset wd = "40">
					
			<tr>							
										
				<cfset itm = 1>				
				
			    <cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Roster/Profile.png" 
							iconwidth  = "#wd#" 								
							iconheight = "#ht#" 		
							class      = "highlight"						
							name       = "Summary"
							source     = "../Bucket/BucketProfile/BucketText.cfm?idfunction=#url.idfunction#">
											
				<cfoutput query="language">		
							
					<cfset itm = itm+1>	
					
					<cfif itm eq "1">
					    <cfset cl = "highlight">
					<cfelse>
						<cfset cl = "regular">
					</cfif>
								
				    <cf_menutab item       = "#itm#" 
					            iconsrc    = "Flag/#code#.gif" 
								iconwidth  = "#wd#" 								
								iconheight = "#ht#" 		
								class      = "#cl#"						
								name       = "Job Profile"
								source     = "../Bucket/BucketProfile/BucketProfile.cfm?accessmode=view&idfunction=#url.idfunction#&languagecode=#languagecode#">
								
				</cfoutput>																								
																	 		
			</tr>
			
		</table>
		
		</td>
	</tr>
	
	<tr><td class="linedotted"></td></tr>		
	
	</cfif>
		
	<tr><td style="height:100%">
		
			<cf_divscroll>
						
			<table width="100%" 
			      border="0"
				  height="100%"
				  cellspacing="0" 
				  cellpadding="0" 
				  align="center" 
			      bordercolor="d4d4d4">	  	 		
																		
					<cfset itm = 1>
					
					<cf_menucontainer item="#itm#" class="regular">	
						<cfinclude template="BucketText.cfm">
					</cf_menucontainer>
					
					<cfoutput query="language">		
					
						<cfset itm = itm+1>
						
						<cfif itm eq 1>
						  <cfset cl = "regular">
						<cfelse>
						  <cfset cl = "hide">
						</cfif>    
						
						<cf_menucontainer item="#itm#" class="#cl#"/>	
						 						
					</cfoutput>				
					
			</table>
			
			</cf_divscroll>
			
			</td>
	</tr>				
	
</table>	

<cf_screenbottom layout="innerbox">
