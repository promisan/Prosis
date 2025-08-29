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
<cfparam name="URL.PHP"         default="Roster">

<cfif URL.ID neq "">
	
	<cfset vId = URL.ID>
		
<cfelse>

	<cfset vId = '00000000-0000-0000-0000-000000000000'>
		
</cfif>				

<cfquery name="GroupAll" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT   F.*, 
				 P.ExperienceClass,
				 P.Description,
				 P.ListingOrder,
				 P.Operational,
				 P.KeywordsMinimum as ClassMin,
				 P.KeywordsMaximum as ClassMax,
				 P.Parent,			
				 Par.KeywordsMaximum AS KeywordsMaximum, 
				 
				 <cfif url.php eq "Roster">
				 
				 (SELECT count(*) 
				  FROM   ApplicantBackgroundField
				  WHERE  ExperienceId = '#vId#'
				  AND    ExperienceFieldId = F.ExperienceFieldId
				  AND    Status != '9') as Selected
				  
				 <cfelse>
				 
				  (SELECT count(*) 
				  FROM   ApplicantFunctionSubmissionField
				  WHERE  SubmissionId = '#vId#'
				  AND    ExperienceFieldId = F.ExperienceFieldId
				  AND    Owner        = '#url.owner#' 
				  AND    Status != '9') as Selected
				 
				 </cfif> 
				 
		FROM     #CLIENT.LanPrefix#Ref_ExperienceClass P INNER JOIN
                 #CLIENT.LanPrefix#Ref_Experience F ON P.ExperienceClass = F.ExperienceClass INNER JOIN
                 Ref_ParameterSkillParent Par ON P.Parent = Par.Parent
				 
		WHERE    F.Status = 1
		AND      F.ExperienceClass = '#URL.Ar#'
		AND      Par.Code          = '#URL.ID1#' 
		
		ORDER BY F.ListingOrder, F.Description 		
</cfquery>
		 		
<table width="96%" align="center" border="0" align="left" cellspacing="0" cellpadding="0">

    <tr><td height="5"></td></tr>
								
	<cfset rows = 0>
	<cfset det = "">
					
	<cfoutput query="GroupAll">
														
	<cfif rows eq "2">
	
		    <TR>
			<cfset rows = 0>
			
	</cfif>
				
	    <cfset rows = rows + 1>
		
			<td width="33%" style="border-right:1px solid silver;padding-left:3px;<cfif Color neq "">background-color:#Color#</cfif>">
			
				<table width="100%">
					
					<cfif Selected eq "0">
			            <TR class="fixlengthlist">
					<cfelse>
						<TR class="highlight1 fixlengthlist">
					</cfif>
					<td width="2%" style="padding-left:4px;padding-right:6px;" align="left">
										
					<cfif KeywordsMaximum neq "0">
					 <cfset x = KeywordsMaximum+1>
					<cfelse>
					 <cfset x = 0>
					</cfif>
										
					<cfif url.owner eq "">
					
																										
						<cfset suf = replaceNoCase(url.id,"-","","ALL")>
																																								
						<cfif Selected eq "0">
							<input type = "checkbox" 
						       name     = "fieldid_#suf#" 
							   value    = "'#ExperienceFieldId#'" 
							   onClick  = "hl(this,this,this.checked,'#parent#','#x#','#vID#','#ExperienceClass#','#ClassMin#','#ClassMax#');"></TD>
						<cfelse>
						<cfset det = det&","&#ExperienceFieldId#>
							<input type = "checkbox" 
						       	name    = "fieldid_#suf#"
							   	value   = "'#ExperienceFieldId#'" 
							   	checked onClick="hl(this,this,this.checked,'#parent#','#x#','#vID#','#ExperienceClass#','#ClassMin#','#ClassMax#');">
						 </cfif>	 
						 
					<cfelse>
																									
						<cfset suf = replaceNoCase(url.id,"-","","ALL")>
														
						<cfif Selected eq "0">
							<input type = "checkbox" 
						       	name    = "fieldid_#suf#"
							   	value   = "'#ExperienceFieldId#'" 
							   	onClick = "hl(this,this,this.checked,'#parent#','#x#','#URL.ID#','#ExperienceClass#','#ClassMin#','#ClassMax#');">
						<cfelse>
						<cfset det = det&","&#ExperienceFieldId#>
							<input type    = "checkbox" 
							       name    = "fieldid_#suf#"
								   value   = "'#ExperienceFieldId#'" 
								   checked onClick="hl(this,this,this.checked,'#parent#','#x#','#URL.ID#','#ExperienceClass#','#ClassMin#','#ClassMax#');">
						 </cfif>	 
					
					</cfif>
						   
					</td>
					
					<td width="98%" class="labelmedium fixlength" title="#description#" style="padding-left:5px;padding-right:20px">#Description#</td>
					
					</tr>
					
				</table>
			</td>			
			<cfif GroupAll.recordCount eq "1">
 			<td width="25%" class="regular"></td>
			</cfif>
		
	</CFOUTPUT>
															
</table>
