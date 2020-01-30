<cfparam name="Attributes.ExperienceClass"	default="">
<cfparam name="Attributes.ApplicantNo"		default="">
<cfparam name="Attributes.ExperienceId"		default="">
<cfparam name="Attributes.Color"			default="ffffef">
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
		<table width="100%">
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
				<cfset vDescription = "Overall relevant work experience:">
				<cfset vDisplay = 1>
			</cfif>
			
			<cfif vDisplay eq 1>
			 <tr class="labelit" bgcolor="#Attributes.Color#">				
				<td width="80%">
					- #vDescription#:
				</td>					
				<td width="20%" align="right" style="padding-left:5px;">
					<cfif years gt 0>
			   			#years#yr <!--- <cfif years gt 1>s</cfif> --->
					</cfif>
	
					<cfif months gt 0>
						#months#mt <!--- <cfif months gt 1>s</cfif> --->
					</cfif>
				</td>
			</tr>
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