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
<!--- update table 
      ProgramAllotmentRequest
	  Lock ProgramAllotmentRequestBatchAction
	  Update AllotmentDetail --->	  
	  
<cftransaction>

<cfquery name="Lines" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	  
	SELECT    *
	FROM      ProgramAllotmentRequestBatchAction
	WHERE     ActionId = '#url.actionid#'
</cfquery>

<cfloop query="Lines">

	<cfquery name="Request" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	  
		SELECT   * 
		FROM     ProgramAllotmentRequest	
		WHERE    RequirementId = '#RequirementId#'	
	</cfquery>
	  
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	  
		UPDATE   ProgramAllotmentRequest
		SET      RequestPrice  = '#revisedPrice#' <!--- will adjust the requestbaseamount as it is a linked field --->
		<cfif Request.AmountBaseAllotment gt RevisedAmountBase>
		, AmountBaseAllotment = '#RevisedAmountBase#'
		</cfif>		
		WHERE    RequirementId = '#RequirementId#'	
	</cfquery>
	
	<!--- ------------------------------------------------- --->
	<!--- sync budget for the revised amounts to be cleared --->
	<!--- ------------------------------------------------- --->
		
	<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#Request.ProgramCode#" 
	   Period           = "#Request.Period#"
	   EditionId        = "#Request.EditionId#"
	   ObjectCode       = "#Request.ObjectCode#">		

</cfloop>	

<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	  
	UPDATE   RequestAction
	SET      ActionStatus  = '1',
	         ActionSubmitted = getDate(),
			 ActionRemarks   = '#Form.ActionMemo#'
	WHERE    ActionId = '#url.actionid#'	
</cfquery>

</cftransaction>	  

<cfoutput>

	<script>
		ColdFusion.navigate('MarkDownRevisedList.cfm?actionid=#url.actionid#','whatifresult')
	</script>
	
</cfoutput>	  