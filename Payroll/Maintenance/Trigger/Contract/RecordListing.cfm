<cfquery name="GetGroups"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    R.SalaryTrigger, R.ContractType, C.Description, R.Operational, R.OfficerUserId, R.OfficerLastName, R.OfficerFirstName, R.Created
   FROM        Ref_PayrollTriggerContractType AS R INNER JOIN
               Employee.dbo.Ref_ContractType AS C ON R.ContractType = C.ContractType
   WHERE  SalaryTrigger = '#URL.payrollTrigger#'  
</cfquery>

<table width="100%" class="navigation_table">
	
	<tr class="line labelmedium2">
		<td align="center" width="2%"></td>
		<td style="padding-left:10px;"><cf_tl id="Code"></td>
		<td><cf_tl id="Name"></td>
		<td><cf_tl id="Operational"></td>		
		<td><cf_tl id="Created"></td>
	</tr>
	
	<cfoutput query="GetGroups">
		<tr class="navigation_row">
			<td>
				<table width="100%">
					<tr class="labelmedium2">
						<td style="padding-left:5px;padding-top:2px">
							<cf_img icon="edit" navigation="yes" onclick="editContract('#url.payrollTrigger#', '#ContractType#');">
						</td>
						<td style="padding-left:5px;;padding-top:4px">
							<cf_img icon="delete" onclick="removeContract('#url.payrollTrigger#', '#ContractType#');">							
						</td>
					</tr>
				</table>
			</td>
			<td style="padding-left:10px;">#ContractType#</td>
			<td>#Description#</td>
			<td>#Operational#</td>			
			<td>#dateformat(Created,client.dateformatshow)#</td>
		</tr>
	</cfoutput>
	
</table>

<cfset ajaxOnLoad("doHighlight")>