
<!--- populate entry class --->


<cfquery name="Period" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT Mission, 
	       Period, 
		   Code 
	FROM   Organization.dbo.Ref_MissionPeriod P, 
	       Ref_EntryClass C
	WHERE  P.Mission = '#URL.Mission#' 
</cfquery>

<cfloop query="Period">

	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMissionEntryClass
		WHERE  Mission    = '#Mission#'
		AND    Period     = '#Period#'
		AND    EntryClass = '#Code#'	
	</cfquery>
	
	<cfif Check.recordcount eq "0">

		<cfquery name="Insert" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO  [dbo].[Ref_ParameterMissionEntryClass]
			(Mission, Period, EntryClass)
		VALUES ('#Mission#','#Period#','#Code#')	
		</cfquery>
	
	</cfif>

</cfloop>	

<!--- show only relevant class --->	
				
<cfquery name="Class" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMissionEntryClass R, 
		       Ref_EntryClass C
		WHERE  Mission    = '#URL.Mission#'
		AND    Period     = '#URL.Period#' 
		AND    R.EntryClass = C.Code 
		AND    R.EntryClass IN (
		                       SELECT DISTINCT EntryClass
		                       FROM   ItemMaster I, ItemMasterMission IM
							   WHERE  I.Code = IM.ItemMaster
             			       AND    I.Operational = 1
		                       AND    IM.Mission = '#url.Mission#' 
							   )	
		ORDER BY ListingOrder					   	
							  
</cfquery>

<cfif Class.recordcount eq "0">
	
	<cfquery name="Class" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMissionEntryClass R, 
			       Ref_EntryClass C
			WHERE  Mission    = '#URL.Mission#'
			AND    Period     = '#URL.Period#' 
			AND    R.EntryClass = C.Code 
			ORDER BY ListingOrder		
	</cfquery>
	
<cfelse>

	<cfquery name="reset" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_ParameterMissionEntryClass 
		SET  Operational = 0
		WHERE  Mission    = '#URL.Mission#'
		AND    Period     = '#URL.Period#' 		
		AND    EntryClass NOT IN (
		                       SELECT DISTINCT EntryClass
		                       FROM   ItemMaster I, ItemMasterMission IM
							   WHERE  I.Code = IM.ItemMaster
             			       AND    I.Operational = 1
		                       AND    IM.Mission = '#url.Mission#' 
							   )					   	
							  
	</cfquery>	

</cfif>		

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AllotmentEdition
	WHERE  EditionClass = 'Budget' 
	AND    (Period is NULL or Period = '#URL.Period#')
	AND    Mission = '#URL.Mission#'
</cfquery>

<cfquery name="WorkFlow" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_EntityClass
	WHERE  EntityCode = 'ProcReview'
</cfquery>

<table style="border-top:1px solid silver;min-width:1000">
<tr class="labelmedium2 line" style="height:28px">
    <td style="width:200px;padding-left:3px">Entry Class</td>
	<td>Oper.</td>
	<td align="center" colspan="1" bgcolor="F0F2CC">Preparation</td>
	<td align="center" colspan="3" bgcolor="ffffaf">Substantive Review and clearance</td>
	<td align="center" colspan="2" bgcolor="f4f4f4">Approval</td>
	<td align="center" bgcolor="E3FBE8">Funding</td>
	<td align="center" bgcolor="d3d3d3" colspan="2">Certification</td>
	<!---
	<td style="border-left:1px solid silver" bgcolor="D8EEFC">Buyer</td>
	--->
</tr>	

<tr class="labelmedium2 line" style="height:28px">
	<td></td>
	<td></td>
	<td style="padding-left:3px;" bgcolor="F0F2CC"><font color="808080"><cf_UIToolTip  tooltip="Enabled through role : ProcReqDefine">Workflow</cf_UIToolTip></td>
	<td style="padding-left:3px;" bgcolor="ffffaf"><font color="808080"><cf_UIToolTip  tooltip="Enabled through role : ProcReqDefine">Enforce Workflow</cf_UIToolTip></td>
	<td bgcolor="ffffaf"><font color="808080">Internal Budget</td>
	<td align="right" bgcolor="ffffaf" style="cursor: pointer;padding-right:4px"><cf_UIToolTip tooltip="Enforce budget sufficiency at the funding review clearance."><font color="808080">Force</cf_UIToolTip></td>
	<td style="padding-left:3px;" bgcolor="f4f4f4" align="center"><font color="808080"><cf_UIToolTip  tooltip="Enabled through role : ProcReqApprove">Level 1</cf_UIToolTip></td>
	<td style="padding-left:3px;" bgcolor="f4f4f4" align="center"><font color="808080"><cf_UIToolTip  tooltip="Enabled through role : ProcReqBudget">Level 2</cf_UIToolTip></td>
	<td style="padding-left:3px;" bgcolor="E3FBE8" align="center"><font color="808080"><cf_UIToolTip  tooltip="Enabled through role : ProcReqObject">Oper.</cf_UIToolTip></td>
	<td style="padding-left:3px;" bgcolor="d3d3d3" align="center"><font color="808080"><cf_UIToolTip  tooltip="Enabled through role : ProcReqCertify">Oper.</cf_UIToolTip></td>
	<td bgcolor="d3d3d3"><font color="808080">Threshold</td>
	<!---
	<td style="border-left:1px solid silver" bgcolor="D8EEFC"></td>	
	--->
</tr>
	
</tr>
<!--- ajax box for saving --->
<tr class="hide"><td id="saveclass"></td></tr>

<cfoutput query="Class">

	<tr class="labelmedium2 line">
	
	<td style="padding-left:4px">#Description#:</td>
	<td style="padding-left:1px">
	
	 <select name="Operational_#entryclass#" id="Operational_#entryclass#" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
	    onChange="ptoken.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=#url.period#&class=#entryclass#&field=operational&value='+this.value,'saveclass')">
		 <option value="0">--</option>
		 <option value="1" <cfif 1 eq Class.Operational>selected</cfif>>Yes</option>	
	 </select>	
	 
	</td>
	<td style="padding-left:1px">
	
	 <select name="Collaboration_#entryclass#" id="Collaboration_#entryclass#" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
	     onChange="ptoken.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=#url.period#&class=#entryclass#&field=collaboration&value='+this.value,'saveclass')">
		  <option value="0">--</option>
		 <option value="1" <cfif 1 eq Class.Collaboration>selected</cfif>>Yes</option>		
	 </select>	
	 
	</td>
	<td style="padding-left:1px">
	
	 <select name="EntityClass_#entryclass#" id="EntityClass_#entryclass#" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
	     onChange="ptoken.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=#url.period#&class=#entryclass#&field=entityclass&value='+this.value,'saveclass')">
		 <option value="">Default (Batch Approval)</option>
		 <cfloop query="Workflow">
			   <option value="#EntityClass#" <cfif EntityClass eq Class.EntityClass>selected</cfif>>#EntityClassName#</option>
		 </cfloop>
	 </select>	
	 
	</td>
	<td style="padding-left:1px">
	
	 <select name="EditionId_#entryclass#" id="EditionId_#entryclass#" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
	    onChange="ptoken.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=#url.period#&class=#entryclass#&field=editionid&value='+this.value,'saveclass');se=document.getElementById('EnforceBudget_#entryclass#');if (this.value=='') {se.disabled=true} else {se.disabled=false}">
		 <option value="">N/A</option>
		 <cfloop query="Edition">
			   <option value="#EditionId#" <cfif editionId eq Class.EditionId>selected</cfif>><cfif Period neq ""> - #Period#</cfif> - #Version#</option>
		 </cfloop>
	 </select>	
	 
	</td>
	
	<td style="padding-left:1px">
	
	 <select name="EnforceBudget_#entryclass#" style="border:0px;border-left:1px solid silver;border-right:1px solid silver" id="EnforceBudget_#entryclass#" class="regularxl" <cfif editionId eq "">disabled</cfif>
	    onChange="ptoken.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=#url.period#&class=#entryclass#&field=enforcebudget&value='+this.value,'saveclass')">
		 <option value="0">--</option>
		 <option value="1" <cfif 1 eq Class.EnforceBudget>selected</cfif>>Yes</option>		 
	 </select>	
	 
	</td>
	
	<td style="padding-left:1px">
	
	 <select name="EnableClearance_#entryclass#" id="EnableClearance_#entryclass#" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
	    onChange="ptoken.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=#url.period#&class=#entryclass#&field=EnableClearance&value='+this.value,'saveclass')">
		 <option value="0">--</option>
		 <option value="1" <cfif 1 eq Class.EnableClearance>selected</cfif>>Yes</option>	
	 </select>	 
	 
	</td>
	
	<td style="padding-left:1px">
	 <select name="EnableBudgetReview_#entryclass#" id="EnableBudgetReview_#entryclass#" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
	    onChange="ptoken.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=#url.period#&class=#entryclass#&field=EnableBudgetReview&value='+this.value,'saveclass')">
		 <option value="0">--</option>
		 <option value="1" <cfif 1 eq Class.EnableBudgetReview>selected</cfif>>Yes</option>	
	 </select>	 
	</td>
	
	<td style="padding-left:1px">
	
	 <select name="EnableFundingClear_#entryclass#" id="EnableFundingClear_#entryclass#" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
	    onChange="ptoken.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=#url.period#&class=#entryclass#&field=EnableFundingClear&value='+this.value,'saveclass')">
		 <option value="0">--</option>
		 <option value="1" <cfif 1 eq Class.EnableFundingClear>selected</cfif>>Yes</option>	
	 </select>	
	  
	</td>
	
	<td style="padding-left:1px">
	
	 <select name="EnableCertification_#entryclass#" id="EnableCertification_#entryclass#" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
	    onChange="ptoken.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=#url.period#&class=#entryclass#&field=EnableCertification&value='+this.value,'saveclass')">
		 <option value="0">--</option>
		 <option value="1" <cfif 1 eq Class.EnableCertification>selected</cfif>>Yes</option>	
	 </select>	 
	 
	</td>
	
	<td style="padding-left:1px">
	
		<input type = "Text"
	       name     = "certificationthreshold_#entryclass#"
	       id       = "certificationthreshold_#entryclass#"
	       value    = "#Class.CertificationThreshold#"
	       validate = "integer"	      
		   onChange = "ptoken.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=#url.period#&class=#entryclass#&field=certificationthreshold&value='+this.value,'saveclass')"   
		   size     = "4"
		   class    = "regularxl"
		   style    = "text-align:center;border:0px;border-left:1px solid silver;border-right:1px solid silver"		  
	       visible  = "Yes">
	
	</td>
	
	</tr>

</cfoutput>

</table>
