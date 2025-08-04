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
<cfparam name="url.functionid" default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="url.applicantno" default="">

<cfquery name="get" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT    *
 FROM      Ref_StatusCode
 WHERE     Id     = 'Fun' 
 AND       Owner  = '#url.Owner#'
 AND       Status = '#URL.Status#'
</cfquery>

<!--- show the effective date --->

<cfif get.EnableStatusDate eq "0">
  
  <script>
   try {
   document.getElementById('boxstatusdate').className = "hide"
   } catch(e) {}
  </script>
  
<cfelse>

  <script>
   try {
   document.getElementById('boxstatusdate').className = "regular"
   } catch(e) {}
  </script>
	   
</cfif>	

<cfquery name="Decision" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT    C.Status, R.Code as DecisionCode, R.Description, R.DescriptionMemo,
	 		   AD.DecisionCode AS SelectedCode, AD.Remarks AS Remarks
	 FROM      Ref_StatusCodeCriteria C INNER JOIN
	           Ref_RosterDecision R ON C.DecisionCode = R.Code
			   LEFT JOIN 
			   (
			   			SELECT * FROM
						ApplicantFunctionActionDecision D
						WHERE FunctionId = '#URL.FunctionId#'
						AND   ApplicantNo = '#URL.ApplicantNo#'
						AND   RosterActionNo = (
							SELECT TOP 1 A.RosterActionNo
							FROM   ApplicantFunctionAction A 
								   INNER JOIN  RosterAction R ON A.RosterActionNo = R.RosterActionNo 
							WHERE  A.FunctionId = D.FunctionId
							AND    A.ApplicantNo = D.ApplicantNo
							ORDER BY R.ActionSubmitted DESC, A.RosterActionNo DESC
						)
				) AD
			   	ON AD.DecisionCode = C.DecisionCode
	 WHERE     C.Id     = 'Fun' 
	 AND       C.Owner  = '#url.Owner#'
	 AND       C.Status = '#URL.Status#'
	 ORDER BY C.Status
</cfquery>

<cfoutput query="Decision" group="status"> 

<cfset cl = "regular">

	<table width="99%" class="formpadding">	
	
	   <cfif get.EnableStatusDate eq "0">
	   
	   </cfif>	
		
		<tr>
		    <td colspan="2" class="#cl#">
			
				<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
				<tr><td colspan="3" style="padding-left:4px" class="labelit"><img src="#SESSION.root#/Images/down2.gif" alt="" border="0" align="absmiddle"><font color="gray">&nbsp;#SESSION.first#, Mark the reason(s) for your decision:</td></tr>
							
					<cfoutput>
						<tr class="line labelmedium2 navigation_row" id="line">
							<td style="padding-left:4px;padding-right:4px">
							<input type="checkbox" name="DecisionCode" style="width:14px;height:14px"
								value="#DecisionCode#" 
								<cfif DecisionCode eq SelectedCode>checked</cfif>
								onClick="hr(this,this.checked); toggleRemarks('#DecisionCode#',this.checked)"></td>
							
							<td width="100%" style="padding-left:10px" class="labelmedium">#DescriptionMemo#</td>
						</tr>
						<tr>
							<cfset display="">
							<cfif DecisionCode neq SelectedCode>
								<cfset display="display:none">
							</cfif>
							<td></td>
							<td colspan="2" id="td_remarks_#DecisionCode#" style="#display#;padding:4px">		
								<textarea style="font-size:13px;padding:3px;width:99%;height:60px;" name="Remarks_#DecisionCode#" class="regular" id="Remarks_#DecisionCode#">#Remarks#</textarea>
							</td>
						</tr>
												
						
					</cfoutput>
				</table>
			 </td>
		</tr>
	</table>	

</cfoutput>

<cfset ajaxonload("doHighlight")>
