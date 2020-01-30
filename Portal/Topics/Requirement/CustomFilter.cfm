
<cfquery name="qCycle" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ReviewCycle C
	WHERE    C.Mission = '#url.mission#'
	AND      C.Period  = '#url.period#'
	AND      Operational = 1
	AND      DateBudgetEffective  is not NULL 
	AND      DateBudgetExpiration is not NULL
	AND      EnableMultiple = 0
	ORDER BY DateEffective	
</cfquery>

<cfquery name="qStatus" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_EntityStatus
	WHERE     EntityCode = 'EntProgramReview'
	AND       EntityStatus <= '3'
</cfquery>

<cfset link = "#session.root#/Portal/Topics/Requirement/RequirementContent.cfm?mission=#url.mission#&period=#url.period#&orgunit=#url.orgunit#">

<cfoutput>
	<table width="100%">
	    <tr><td>
			    <table>
			    <tr>
					<td class="label" style="color:gray;padding-left:3px;padding-right:10px"></td>
					<td style="padding-left:7px;padding-right:4px" class="labelit">
						<input type="radio" class="radiol" name="fldlayout" id="layout" value="Org" 
							onclick="if ($('##divRequirementDetail_#url.mission#').length > 0) { ColdFusion.navigate('#link#&status='+$('##fldstatus').val()+'&reviewcycle='+$('##fldreviewcycle').val()+'&layout=Org','divRequirementDetail_#url.mission#');}"
							checked></td>
					<td class="labelmedium" style="padding-right:4px"><cf_tl id="Organization"></td>
					<td style="padding-left:7px;padding-right:4px" class="labelit">
						<input type="radio" class="radiol" name="fldlayout" id="layout" value="Prg" 
							onclick="if ($('##divRequirementDetail_#url.mission#').length > 0) { ColdFusion.navigate('#link#&status='+$('##fldstatus').val()+'&reviewcycle='+$('##fldreviewcycle').val()+'&layout=Prg','divRequirementDetail_#url.mission#');}"
							></td>
					<td class="labelmedium" style="padding-right:4px"><cf_tl id="Program"></td>				
							
					<td class="label" style="color:gray;padding-left:12px">	
					  <select name="fldreviewcycle" class="regularxl" id="fldreviewcycle" onchange="if ($('##divRequirementDetail_#url.mission#').length > 0) { ColdFusion.navigate('#link#&status='+$('##fldstatus').val()+'&reviewcycle='+this.value+'&layout='+$('input[name=\'fldlayout\']:checked').val(),'divRequirementDetail_#url.mission#');}">					 		
						  <cfloop query="qCycle">				  
						  	<option value="#cycleid#">#description#</option>					  
						  </cfloop>
					  </select>	
					</td>						
					
					<cfif qStatus.recordcount gte "1">
					 <td class="label" style="color:gray;padding-left:12px">	
					  <select name="fldStatus" id="fldstatus" class="regularxl" onchange="if ($('##divRequirementDetail_#url.mission#').length > 0) { ColdFusion.navigate('#link#&status='+this.value+'&reviewcycle='+$('##fldreviewcycle').val()+'&layout='+$('input[name=\'fldlayout\']:checked').val(),'divRequirementDetail_#url.mission#');}">					 		
					      <option value="">ANY</option>
						  <cfloop query="qStatus">				  
						  	<option value="#EntityStatus#">#StatusDescription#</option>					  
						  </cfloop>
					  </select>	
					 </td>
															
					<cfelse>
					
					<input type="hidden" name="fldStatus" id="fldstatus" value="0">
					
					</cfif>			
					
					
				</tr>
				</table>
			</td>
		</tr>
	</table>
</cfoutput>