
<cfparam name="URL.mode" default="regular">

<cf_verifyOnBoard PersonNo="#url.id#">

<cfinvoke component="Service.Access"
	Method="PayrollOfficer"
	Role="PayrollOfficer"
	Mission="#mission#"
	ReturnVariable="PayrollAccess">		

<cfinvoke component="Service.Access"
	Method="employee"
	PersonNo="#url.id#"	
	ReturnVariable="HRAccess">			

<cfif PayrollAccess neq "NONE" or HRAccess neq "NONE" or CLIENT.PersonNo eq URL.ID>
	
	<cfif url.mode eq "full">
	
		<html>
		<head><title>Statement</title></head>
		<cfinclude template="../../../Staffing/Application/Employee/PersonViewHeader.cfm">
	
	</cfif>
	
	<table width="100%" border="0" cellspacing="0" align="center">
				
		<tr class="line">
			<td colspan="2">
			<table width="100%" align="center">
				<tr>
					<td class="labelmedium" style="padding-left:10px;height:40px;font-size:25px;font-weight:300">			
					<cf_tl id="Statement of Earnings and Deductions">
					</td>
				</tr>
			</table>
			</td>
		</tr>
							  
		<cfset label = "labelmedium">
		<cfset field = "labelmedium">	
		
		<tr class="line">
		<td style="padding-left:15px;padding-right:5px;padding-bottom:10px">		
			<cfinclude template="SalarySlipDetail.cfm">
		</td>		
		</tr>	
				
	</table>		
	
<cfelse>
	
		No access granted
	
</cfif>