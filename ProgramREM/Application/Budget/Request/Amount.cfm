
<cfquery name="FundList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Ref_AllotmentEditionFund
		WHERE    EditionId = '#URL.EditionId#' 
</cfquery>		

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Ref_AllotmentEdition
		WHERE    EditionId = '#URL.EditionId#' 
</cfquery>		

<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM     Ref_ParameterMission
		WHERE    Mission = '#Edition.Mission#'
</cfquery>

<cfif FundList.recordcount neq "0">

	<cfoutput>

	<table cellspacing="0" cellpadding="0" style="cursor: pointer;"><tr> 
					
			<td>&nbsp;</td>					
			<td>
			<img id="edit_#url.Editionid#_#url.ObjectCode#" stlye="cursor: pointer;" 
								src="#SESSION.root#/Images/contract.gif" 
								align="absmiddle" height="11" width="9"
								onclick="alldetinsert('#url.editionid#_#url.objectcode#','#url.editionid#','#url.objectcode#','','view')">
			</td>	
				
			<cfloop query="FundList">			
			 
			 	<cfquery name="Total" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     sum(Amount) as Total
					FROM        ProgramAllotmentDetail
					WHERE       ProgramCode = '#Url.programCode#'	
					AND         Period      = '#url.period#'    
					AND         EditionId   = '#url.EditionId#'
					AND         ObjectCode  = '#url.ObjectCode#'
					AND         Fund        = '#Fund#' 
					AND         Status <> '9'
				</cfquery>					
										
				<td align="right" onClick="alldet('#url.Editionid#_#Url.objectCode#','#url.editionid#','#url.ObjectCode#');">
				
					<cf_space spaces="25">
					
					<cfset val = evaluate("total.total")>
					<cfif val eq "">  <cfset val = 0> </cfif>
																			
					<cfif Parameter.BudgetAmountMode eq "0">
						<cf_numbertoformat amount="#val#" present="1" format="number">
					<cfelse>
						<cf_numbertoformat amount="#val#" present="1000" format="number1">
					</cfif>				
					#val#
					
				</td>	
				 
			</cfloop>	
			
	    </tr>

	</table> 

	</cfoutput>

</cfif>