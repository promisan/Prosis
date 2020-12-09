
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
		
			<tr><td colspan="2" height="10" style="padding-left:10px;padding-right:10px">
			    <cfset url.attach = "0">
				<cfinclude template="../Header/ViewHeader.cfm">			
			</tr>
			
		<cfelse>
		
			<cfset programaccess = "Edit"> 
			<tr><td colspan="2" style="height:5px"></td></tr>
			
		</cfif>
		
		<!--- option to manage status fields and immediately save them --->
		
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
		
		<!--- status field for data entry --->
						
		<tr><td colspan="2" style="height:35px;padding-left:22px">
		
			<cfquery name="StatusList" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  F.Code, 
					        F.Description, 					   
							F.StatusClass,					    							   							    	
						    S.Created,
							S.OfficerFirstName, 
						    S.OfficerLastName, 
						    S.ProgramStatus as Selected
					FROM    ProgramStatus S RIGHT OUTER JOIN
				            Ref_ProgramStatus F ON S.ProgramStatus = F.Code AND S.ProgramCode = '#URL.ProgramCode#'
					WHERE   F.Code IN (SELECT ProgramStatus
					                   FROM   Ref_ProgramStatusMission	   
								 	   WHERE  Mission = '#Program.OrgUnitMission#') 
					 AND    F.Operational = 1 
						 
				    ORDER By Description
				
				</cfquery>	
			
				<cfquery name="statusclasslist" dbtype="query">
					SELECT DISTINCT StatusClass
					FROM StatusList
				</cfquery>			
				
				<table width="98%">
											    		
					<cfoutput query="statusclasslist">						
					
							<tr class="labelmedium line" style="height:35px">
						    <td style="width:145px" class="labelmedium"><cf_tl id="Status #StatusClass#">:</td>
							    <td>
								
									<cfquery name="StatusSelect" dbtype="query">
								       SELECT *
								       FROM   StatusList
									   WHERE  StatusClass = '#StatusClass#'					
								    </cfquery>
																																																	 							 																								
									<select class="regularxxl" 
										  style="border:0px" 
										  onchange="ptoken.navigate('#session.root#/ProgramREM/Application/Program/Category/setProgramStatus.cfm?programcode=#url.programcode#&statusclass=#statusclass#&programstatus='+this.value,'processclass')">												 					
										 <cfloop query="StatusSelect">
										     <option value="#Code#" <cfif Selected eq Code> selected</cfif>>#Description#</option>
										 </cfloop>								
									</select>
								
								</td>
								<td class="hide" id="processclass"></td>
							</tr>
					
					</cfoutput>	
				
				</table>
		
		</td></tr>		
		
		
				
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
