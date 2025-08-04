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

<table width="700">
<tr class="labelmedium2 line">
    <td>Entry Class</td>	
	<td colspan="1">Mail Template file</td>
	
</tr>	
	
<!--- ajax box for saving --->
<tr class="hide"><td id="saveclass"></td></tr>

<cfoutput query="Class">
	
	<tr class="labelmedium2 line">
		<td width="20%">#Description#:</td>
		<td width="80%">  
		
				<input type="Text"
			       name="duemailtemplate_#entryclass#"
		           id="duemailtemplate_#entryclass#"
			       value="#Class.duemailtemplate#"	            
				   onChange="ptoken.navigate('ParameterEditReqEntryClassSave.cfm?mission=#url.mission#&period=&class=#entryclass#&field=duemailtemplate&value='+this.value,'saveclass')"   
				   style="width:99%;border:0px;background-color:f1f1f1"
				   class="regularxxl"    
			       visible="Yes">
		
		</td>
	</tr>

</cfoutput>
</table>
