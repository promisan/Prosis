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

<cfparam name="url.workflow"  default="0">

<cfif url.workflow eq "0">
    <cf_DialogProcurement>
</cfif> 

<cfparam name="Object.ObjectKeyValue1"  default="">

<!--- set url.id values based on the context --->
<cfif Object.ObjectKeyValue1 neq "">
	<cfset url.id1 = Object.ObjectKeyValue1>	    
<cfelse>
    <cfparam name="URL.ID1"    default="">
</cfif>

<cfquery name="Job" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Job
	WHERE     JobNo = '#URL.ID1#'	
</cfquery> 

<cfquery name="Vendor" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      RequisitionLineQuote
	WHERE     JobNo = '#URL.ID1#'	
	AND       Selected = 1
</cfquery> 

<cfquery name="JobOpen" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    JobLine.RequisitionNo, PurL.RequisitionNo AS Purchase
	FROM      RequisitionLine JobLine LEFT OUTER JOIN
              PurchaseLine PurL ON JobLine.RequisitionNo = PurL.RequisitionNo
	WHERE     JobLine.JobNo = '#URL.ID1#'
	GROUP BY  JobLine.RequisitionNo, PurL.RequisitionNo
	HAVING    PurL.RequisitionNo IS NULL
	</cfquery> 
		
	<cfif JobOpen.recordcount gte "1" and Vendor.Recordcount gte "1" and url.workflow eq "0">			
	
	<cfoutput>
	<table width="99%" align="center">
	   
	    <tr>
		<td class="labelmedium" style="height:40px">
				
		<a href="javascript:ProcOrder('#Job.Mission#')">		
		<cf_tl id="You may issue one or more obligations" class="message"></a>:</td>
		   	<td colspan="1" align="right" height="27">
				<cf_tl id="Create" var="1">
				<cfset cpo=#lt_text#>							
					
				<input type    = "Button" 
				    class      = "button10g" 
					style      = "width:150px;font-size:12px;height:26px" 
					mode       = "silver"
					label      = "#cpo#" 
					value      = "#cpo#"
					onClick    = "ProcOrder('#Job.Mission#')"     
					id         = "Create">   
					
			</td>
		</tr>
						
	</table>	
	</cfoutput>						
				
	</cfif>