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

	<table width="99%" border="0" bordercolor="e4e4e4" height="26" cellspacing="0" cellpadding="0" class="formpadding">	
	
	   <cfif get.EnableStatusDate eq "0">
	   
	   </cfif>	
		
		<tr>
		    <td colspan="2" class="#cl#">
			
				<table width="100%" cellspacing="0" cellpadding="0">
				<tr><td height="22" colspan="3" style="padding-left:4px" class="labelit"><img src="#SESSION.root#/Images/down2.gif" alt="" border="0" align="absmiddle"><font color="gray">&nbsp;#SESSION.first#, Mark the reason(s) for your decision:</td></tr>
			
				
					<cfoutput>
						<tr id="line">
							<td width="30" height="23" style="padding-left:4px">
							<input type="checkbox" name="DecisionCode" style="width:14px;height:14px"
								value="#DecisionCode#" 
								<cfif DecisionCode eq SelectedCode>checked</cfif>
								onClick="hr(this,this.checked); toggleRemarks('#DecisionCode#',this.checked)"></td>
							
							<td width="95%" style="padding-left:10px" class="labelmedium">#DescriptionMemo#</td>
						</tr>
						<tr>
							<cfset display="">
							<cfif DecisionCode neq SelectedCode>
								<cfset display="display:none">
							</cfif>
							<td colspan="3" id="td_remarks_#DecisionCode#" style="#display#;padding-left:4px">		
								<textarea style="-moz-border-radius: 3px;border-radius: 3px;font-size:13px;padding:3px;width:100%;height:50;" name="Remarks_#DecisionCode#" class="regular" id="Remarks_#DecisionCode#" message = "">#Remarks#</textarea>
							</td>
						</tr>
						
						<cfif CurrentRow neq Recordcount>
							<tr><td class="linedotted" colspan="3"></td></tr>
						</cfif>
						
					</cfoutput>
				</table>
			 </td>
		</tr>
	</table>	

</cfoutput>
