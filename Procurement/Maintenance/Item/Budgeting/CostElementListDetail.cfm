<cfquery name="qItemStandard" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   I.*, 
				 L.*,
				 IML.TopicValue
		FROM     ItemMasterStandardCost I
				 LEFT OUTER JOIN Payroll.dbo.Ref_PayrollLocation L
				 	ON I.Location   = L.LocationCode
				 LEFT OUTER JOIN ItemMasterList IML
				 	ON I.ItemMaster = IML.ItemMaster
					AND I.TopicValueCode = IML.TopicValueCode
		WHERE    I.ItemMaster = '#URL.id1#'
		<cfif url.location neq "">
		AND		 I.Location = '#url.location#'
		</cfif>
		ORDER BY Mission, Location, I.DateEffective DESC, TopicValueCode, I.CostOrder
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table formpadding">
		
		<tr class="line labelmedium">
			<td width="2%"></td>
			<td></td>
			<td></td>
			<td style="padding-left:3px"><cf_tl id="Date Effective"></td>
			<td style="padding-left:3px"><cf_tl id="Budget Object"></td>									
			<td style="padding-left:3px"><cf_tl id="Cost Element"></td>										
			<td style="padding-left:3px" align="right"><cf_tl id="Number"></td>			
			<td width="2%"></td>
		</tr>
				
		<cfoutput query="qItemStandard" group="Mission">
		
			<cfquery name="Param" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_ParameterMission
				WHERE    Mission = '#mission#'
			</cfquery>
		
			<tr class="line">
				<td width="2%"></td>
				<td class="labelmedium" style="font-size:23px;font-weight:bold;" colspan="5">#Mission#</td>				
				<td class="labelmedium" align="right" style="padding-right:5px">in #param.BudgetCurrency#</td>
				<td></td>
			</tr>		
						
			<cfoutput group="Location">
			
				<tr class="line labelmedium">
				<td colspan="2"></td>	
				<td colspan="7" style="padding-left:4px;font-size:23px;font-weight:200"><cfif trim(Location) eq "">[ <cf_tl id="All locations"> ]<cfelse>#Description#</cfif></td>	
				</tr>
				<cfset prior = "">
				<cfoutput group="TopicValueCode">				
				<cfoutput>								
				<tr class="navigation_row line labelmedium" style="height:20px">
					<td colspan="2"></td>						
					<td style="padding-left:4px;padding-top:2px"><cf_img icon="delete" onclick="delete_cost_element('#URL.id1#', '#Mission#','#TopicValueCode#','#CostElement#','#DateEffective#','#Location#')"></td>										
					<td>#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
					<td><cfif prior neq topicvalue>#TopicValue#<cfelse>&nbsp;&nbsp;,,</cfif></td>					
					<td><font size="1">#CostOrder#.</font> #CostElement#</td>										
					<td align="right">#Numberformat(CostAmount,"__,___.__")# <cfif CostBudgetMode eq "1">%</cfif>	</td>
					<td width="2%"></td>
				</tr>	
				<cfset prior = topicvalue>
				</cfoutput>
				
				</cfoutput>
			</cfoutput>
			
		</cfoutput>			

</table>

<cfset AjaxOnLoad("doHighlight")>