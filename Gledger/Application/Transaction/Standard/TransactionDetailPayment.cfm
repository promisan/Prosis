<cfparam name="URL.ID1"     default="ReferenceName">
<cfparam name="URL.find"    default="">
<cfparam name="URL.journal" default="">
<cfparam name="URL.period"  default="">
<cfparam name="URL.page"    default="1">

<table width="99%">

<tr><td id="lineentry" style="width:100%">
	
<table width="98%">
		
	<tr style="border-bottom:1px solid silver;height:34px">
		<td colspan="2">
		
		<table><tr  class="labelmedium">
		
		<td style="padding-left:4px"><cf_tl id="Find">:</td>
		<td style="padding-left:4px">		
		  <input name="search" id="search" class="regularxl enterastab" size="10">							
		</td>
		<td height="25" style="padding-left:10px">
		
			<select name="group" id="group" class="regularxl" size="1">
			     <OPTION value="ReferenceName" <cfif URL.ID1 eq "ReferenceName">selected</cfif>><cf_tl id="Group by Vendor">
			     <option value="Journal" <cfif URL.ID1 eq "Journal">selected</cfif>><cf_tl id="Group by Journal">			     
			     <OPTION value="TransactionDate" <cfif URL.ID1 eq "TransactionDate">selected</cfif>><cf_tl id="Group by Date">
				 <OPTION value="ActionBefore" <cfif URL.ID1 eq "ActionBefore">selected</cfif>><cf_tl id="Group by DueDate">
			</select> 
			
		</td>
		
		
		</tr>
		</table>
		</td>
	</tr>	
			
	<tr>
		<td colspan="2" align="center">
		  <cfdiv id="paymentresult" 
		      name="paymentresult" 
			  bind="url:TransactionDetailPaymentResult.cfm?journal=#URL.journal#&period=#URL.Period#&find=#URL.find#&ID1={group}&search={search}" bindonload="true">			
		</td>
	</tr>

</table>

</td></tr>

</table>

