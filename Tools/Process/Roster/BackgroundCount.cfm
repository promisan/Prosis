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
<cfparam name="Attributes.ExperienceClass"	default="">
<cfparam name="Attributes.ApplicantNo"		default="">
<cfparam name="Attributes.ExperienceId"		default="">
<cfparam name="Attributes.Color"			default="ffffaf">
<cfparam name="Attributes.Join"				default="Yes">
<cfparam name="Attributes.Mode"				default="Display">

<cfset years = 0>
<cfset months = 0 >
		
<cfquery name="qResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
       SELECT 
		   <cfif Attributes.ExperienceId neq "" or Attributes.ExperienceClass neq "">
		   		E.Description, E.ExperienceFieldId,
			</cfif>						
			Count(Distinct MonthNo)  as Total
				
       FROM skBackgroundCount BC LEFT OUTER JOIN Ref_Experience E ON
	   		BC.ExperienceFieldId = E.ExperienceFieldId
       WHERE ApplicantNo 	 = '#Attributes.ApplicantNo#'
	   <cfif Attributes.ExperienceClass neq "">
		   AND   BC.ExperienceClass = '#Attributes.ExperienceClass#'
	   </cfif>
 	   <cfif Attributes.ExperienceId neq "">
		   AND   BC.Experienceid = '#Attributes.ExperienceId#'
	   </cfif>
	   <cfif Attributes.ExperienceId neq "" or Attributes.ExperienceClass neq "">
		   	GROUP BY E.Description,E.ExperienceFieldId
		</cfif>	
</cfquery>	
			
<cfoutput>

<cfif qResult.recordcount neq 0>

		<cfif attributes.mode eq "Display">
		<table width="97%">
		</cfif>
		
		<cfloop query = "qResult">
		
		<cf_MonthsToYears Months = "#qResult.Total#">
		
		   <cfif attributes.mode eq "Display">
				
			   <cfif Attributes.ExperienceId neq "" or Attributes.ExperienceClass neq "">
			   		<cfif qResult.Description neq "">
						<cfset vDescription = qResult.Description>
						<cfset vDisplay = 1>
					<cfelse>
						<cfset vDisplay = 0>	
					</cfif>	
				<cfelse>
					<cfset vDescription = "Relevant work experience:">
					<cfset vDisplay = 1>
				</cfif>
			
				<cfif vDisplay eq 1>
				
				 <cfif Attributes.ExperienceClass eq "" and Attributes.ExperienceId eq "">
				 <tr class="labelmedium2 fixlengthlist">				
					<td width="50%">#vDescription#:</td>					
					<td width="40%" align="center" style="border:1px solid silver;background-color:f1f1f1;font-size:18px;padding-left:5px;">
						<cfif years gt 0>
				   			<b>#years#</b> yr<cfif years gt 1>s</cfif>
						</cfif>
		
						<cfif months gt 0>
							<b>#months#</b> mth<cfif months gt 1>s</cfif>
						</cfif>
					</td>
				</tr>
				<cfelse>
				 <tr class="labelmedium2 fixlengthlist">				
					<td width="50%">#vDescription#:</td>					
					<td width="40%" align="center" style="background-color:f4f4f4;font-size:14px;padding-left:5px;">
						<cfif years gt 0>
				   			<b>#years#</b> yr<cfif years gt 1>s</cfif>
						</cfif>
		
						<cfif months gt 0>
							<b>#months#</b> mth<cfif months gt 1>s</cfif>
						</cfif>
					</td>
				</tr>
				
				</cfif>
				</cfif>
				
			<cfelse>
				<cfset Caller.years  = years>
				<cfset Caller.months = months>
			</cfif>							
		</cfloop>
		<cfif attributes.mode eq "Display">
		</table>
		</cfif>
<cfelse>
	<cfset Caller.years  = 0>
	<cfset Caller.months = 0>		
</cfif>
</cfoutput>