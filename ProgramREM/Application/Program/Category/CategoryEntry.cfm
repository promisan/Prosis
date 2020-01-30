
<cf_tl id="Do you want to remove this target ?" var="vDeleteQuestion">



<cfparam name="url.script" default="1">
<cfif url.script eq "1">
	<cfajaximport tags="cfform">
	<cfinclude template="CategoryScript.cfm">
	<cf_calendarscript>
	<cf_textareascript>
	<cf_screenTop height="100%" html="No" jQuery="Yes" scroll="yes" >
</cfif>

<cfparam name="url.header" default="0">


	
	<table width="100%" height="100%" border="0">
	
		<cfif url.header eq "1">	
		
			<tr><td colspan="2" height="10" style="padding:10px">
			    <cfset url.attach = "0">
				<cfinclude template="../Header/ViewHeader.cfm">			
			</tr>
			
		<cfelse>
		
			<cfset programaccess = "Edit"> 
			<tr><td colspan="2" style="height:10px"></td></tr>
			
		</cfif>
					
		<cfquery name="Program" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  P.*,
					O.Mission as OrgUnitMission
			FROM    #CLIENT.LanPrefix#Program P
					INNER JOIN ProgramPeriod PP
						ON P.ProgramCode = PP.ProgramCode
					INNER JOIN Organization.dbo.Organization O
						ON PP.OrgUnit = O.OrgUnit
			WHERE   P.ProgramCode = '#URL.ProgramCode#'
			AND		PP.Period = '#URL.Period#'
		</cfquery>
		
	   <cfset mission      = program.OrgUnitMission>
		<cfset programclass = program.programclass>
								
		<tr><td colspan="2" style="padding-left:3px;padding-right:10px" height="100%">
		
		   <cf_divscroll height="100%">
						
			   <cfform action="CategoryEntrySubmit.cfm" method="POST" name="program">	
			        <cfset url.programaccess = programaccess>   
				    <input type="hidden" name="ProgramCode" value="<cfoutput>#url.programcode#</cfoutput>">
					<input type="hidden" name="Period"      value="<cfoutput>#url.period#</cfoutput>">
			        <cfinclude template="CategoryEntryDetail.cfm">
			   </cfform>	
		   
		   </cf_divscroll>
		   
		   </td>
		</tr>   
	
	</table>

<cf_screenbottom html="No">
