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
<table width="97%" align="center" cellspacing="0" cellpadding="0">

<cfparam name="SESSION.customerid" default="">

<cfset SESSION.CustomerId = "">
<cfif SESSION.customerId eq "">
	<cfquery name="qCustomer"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
	    FROM    Customer
		WHERE   PersonNo='#url.id#'
	</cfquery>
	
	<cfif qCustomer.recordcount neq 0>
		<cfset SESSION.CustomerId = qCustomer.CustomerId>
	</cfif>	
</cfif>	

<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  O.OrgUnitName,CP.*
    FROM    CustomerPayer CP INNER JOIN Organization.dbo.Organization O
    ON CP.OrgUnit=O.OrgUnit
	<cfif SESSION.customerid neq "">
	WHERE   CustomerId = '#SESSION.customerid#'
	<cfelse>
	WHERE   1=0
	</cfif>
	AND   Status!=9
	ORDER BY CP.DateEffective 
</cfquery>
		
<TR>

<td colspan="2" style="padding:6px">
	
	<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<cfif SearchResult.recordcount gte "1">
	<tr>
		<td colspan="8" style="height:40px" class="labellarge">
			<cfoutput>
				<a href="javascript:newInsurance('#url.owner#','#url.id#')"><font color="0080C0"><cf_tl id="Add another insurance"></font></a>
			</cfoutput>			
		</td>			
	</tr>	
	</cfif>
	
	<tr class="labelmedium line">	   
	    <td height="20"></td>
	    <td ></td>
	    <td><cf_tl id="Insurance"></td>
		<td><cf_tl id="Policy"></td>
		<td><cf_tl id="Certification"></td>
		<td><cf_tl id="Remarks"></td>
		<td><cf_tl id="Effective"></td>
		<td><cf_tl id="Expiration"></td>   		 
	</TR>
	
	<cfif SearchResult.recordcount eq "0">
	
		<tr>
			<td colspan="8" style="height:40px" class="labelmedium" align="center">
				<cfoutput>
					<a href="javascript:newInsurance('#url.owner#','#url.id#')"><font color="0080C0"><cf_tl id="Record Insurance"></font></a>
				</cfoutput>			
			</td>			
		</tr>	
	
	</cfif>
	
	
	<cfoutput query="SearchResult">
	    
	    <tr class="navigation_row line labelmedium">
			<td height="20" align="center" style="width:20;padding-top:1px;height:19">
				<cf_tl id="Edit" var="1">
			  	<cf_img icon="edit" tooltip="#lt_text#" navigation="Yes" onClick="editInsurance('#PayerId#','#url.owner#','#url.id#')">
			</td>
			<td height="20" align="center" style="width:20;padding-top:1px;height:19;padding-right:20px">
				<cf_tl id="Delete" var="1">
			  	<cf_img icon="delete" tooltip="#lt_text#" navigation="Yes" onClick="deleteInsurance('#PayerId#','#url.owner#','#url.id#')">
			</td>		
			<td>#OrgUnitName#</td>
			<td>#AccountNo#</td>		
			<td>#Reference#</td>
			<td>#Memo#</td>
			<td>#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
			<td>#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>			
	    </tr>
		
	</cfoutput>
	
	</table>

</td>
</tr>

</TABLE>

<cfset ajaxonload("doHighlight")>

<script>
	Prosis.busy('no')
</script>
