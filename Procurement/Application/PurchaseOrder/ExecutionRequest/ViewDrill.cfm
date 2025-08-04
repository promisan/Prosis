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

<cfset currrow = 0>
		
<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		
	SELECT     *
	FROM      PurchaseExecutionRequest
	WHERE     PurchaseNo  = '#url.purchaseno#' 
	AND       ExecutionId = '#url.executionid#'
	AND       ActionStatus != '9'		
 </cfquery>			
		
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">

<TR class="linedotted">
    <td width="5%" height="20"></td>
	<td width="100" class="labelit"><cf_tl id="Purchase"></td>
	<td width="8%"  class="labelit"><cf_tl id="Reference"></td>
	<td width="30%" class="labelit"><cf_tl id="Description"></td>
	<td width="140" class="labelit"><cf_tl id="Officer"></td>
	<td width="100" class="labelit"><cf_tl id="Date"></td>		
	<td width="10%" class="labelit" align="right"><cf_tl id="Amount"></td>		
</TR>

<cfif SearchResult.recordcount eq "0">
	
	<tr><td height="30" colspan="7" align="center"><font color="808080"><cf_tl id="There are no items to show in this view">.</td></tr>
	
<cfelse>		

	<cfoutput query="SearchResult">
	
			<cfset currrow = currrow + 1>	
					
		    <cfif actionstatus eq "1">			
			   <tr bgcolor="FCFED3">			   
			<cfelse>			
			   <tr bgcolor="ffffff">				   
			</cfif>
				
		    <td height="20" width="5%" align="center">						
			 <cf_img icon="edit" onclick="editRequest('#RequestId#')">																					
			</td>
		    <td class="labelit"><a href="javascript:ProcPOEdit('#purchaseno#','view')"><font color="0080C0">#PurchaseNo#</a></td>
			<td class="labelit" id="ref_#requestid#">#Reference#</td>
			<td class="labelit" id="des_#requestid#">#RequestDescription#</TD>
			<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>	
			<cfif RequestDate neq "">	
				<td class="labelit">#DateFormat(RequestDate, CLIENT.DateFormatShow)#</td>	
			<cfelse>		
				<td class="labelit">#DateFormat(Created, CLIENT.DateFormatShow)# #TimeFormat(Created, "HH:MM")#</td>	
			</cfif>
			<td class="labelit" align="right" id="amt_#requestid#">#numberformat(RequestAmount,"__,__.__")#</td>
					
			</tr>
							
	</cfoutput>   
	
</cfif>	

</TABLE>	
