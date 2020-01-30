
		
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

</cfif>		

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_AllotmentEdition
	WHERE EditionClass = 'Budget' 
	AND (Period is NULL or Period = '#URL.Period#')
	AND Mission = '#URL.Mission#'
</cfquery>

<cfquery name="WorkFlow" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClass
	WHERE EntityCode = 'ProcReview'
</cfquery>

<table width="700" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td class="labelit">Entry Class</td>	
	<td colspan="1" class="labelit">Mail Template file</td>
	
</tr>	
	
<!--- ajax box for saving --->
<tr class="hide"><td id="saveclass"></td></tr>

<tr><td colspan="10" height="1" class="linedotted"></td></tr>

<cfoutput query="Class">
	
	<tr>
		<td width="20%" class="labelit">#Description#:</td>
		<td width="80%">  
		
				<input type="Text"
			       name="duemailtemplate_#entryclass#"
		           id="duemailtemplate_#entryclass#"
			       value="#Class.duemailtemplate#"	            
				   onChange="ColdFusion.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=&class=#entryclass#&field=duemailtemplate&value='+this.value,'saveclass')"   
				   style="width:300"
				   class="regularxl"    
			       visible="Yes">
		
		</td>
	</tr>

</cfoutput>
</table>
