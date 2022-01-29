
<cfquery name="Funding" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT        P.Mission,
	              R.ProgramCode, 
	              P.ProgramName, 
				  R.Period, 
				  R.EditionId, E.Description AS EditionName, 
				  (SELECT count(*)
				   FROM  ProgramAllotmentDetail PAD INNER JOIN ProgramAllotmentDetailRequest PADR ON PAD.TransactionId = PADR.TransactionId
				   WHERE PAD.Status = '1' AND PADR.RequirementId = R.RequirementId) as Allotment,
				  R.ObjectCode, 
				  R.Fund, 
				  R.PositionNo, 
	              R.RequestQuantity, 
				  R.RequestAmountBase, 
				  R.ResourceQuantity,
				  R.OfficerLastName,
				  R.OfficerFirstName,
				  R.Created
	FROM          ProgramAllotmentRequest AS R INNER JOIN
	              Program AS P ON R.ProgramCode = P.ProgramCode INNER JOIN
	              Ref_AllotmentEdition AS E ON R.EditionId = E.EditionId INNER JOIN
				  <!--- only for the period for which execution period of the edition is recorded if Ref_MissionPeriod to exclude draft periods ---> 
	              Organization.dbo.Ref_MissionPeriod ON P.Mission = Organization.dbo.Ref_MissionPeriod.Mission AND E.Period = Organization.dbo.Ref_MissionPeriod.Period AND 
	              R.Period = Organization.dbo.Ref_MissionPeriod.PlanningPeriod
	WHERE         R.PositionNo IN  ( SELECT  PositionNo
									 FROM 	 Employee.dbo.Position
							    	 WHERE 	 PositionParentId = '#URL.ID#' )
	AND           R.ActionStatus != '9'								 
	
</cfquery>


<cfif Funding.recordcount eq "0">

<table align="center"><tr><td class="labelmedium" align="center" style="height:30px"><font color="FF0000">No budget requirements found for this position</font></td></tr></table>

<cfelse>
	
	<cfquery name="Param" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT       *
		FROM         Ref_ParameterMission
		WHERE        Mission = '#Funding.mission#'	
	</cfquery>

	<table width="100%" class="navigation_table">
	
		<tr class="line labelmedium fixlengthlist">
		   <td style="padding-left:5px"><cf_tl id="Period"></td>
		   <td><cf_tl id="Plan period"></td>		   
		   <td><cf_tl id="Fund"></td>		   
		   <td><cf_tl id="Program"></td>	
		   <td><cf_tl id="Object"></td>	  		    
		   <td><cf_tl id="Quantity"></td>
		   <td><cf_tl id="Amount"><cfoutput>#Param.BudgetCurrency#</cfoutput></td>
		   <td><cf_tl id="Status"></td>
		   <td><cf_tl id="Officer"></td>
	    </tr>
		
		<cfoutput query="Funding">
		
			<tr class="<cfif currentrow neq recordcount>line</cfif> fixlengthlist labelmedium navigation_row">
			<td style="padding-left:5px">#EditionName#</td>
			<td>#Period#</td>		
			<td>#Fund#</td>		
			<td>#ProgramName#</td>
			<td>#ObjectCode#</td>
			<td>#RequestQuantity#</td>
			<td>#numberformat(RequestAmountBase,",__")#</td>
			<td><cfif Allotment gte "1"><cf_tl id="Cleared"><cfelse><cf_tl id="Requested"></cfif></td>
			<td>#OfficerLastName# (#dateformat(Created, client.dateformatshow)#)</td>
			</tr>
		
		</cfoutput>
	
	</table>

</cfif>

<cfset ajaxonload("doHighlight")>