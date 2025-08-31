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
<cfoutput>

<!--- show total --->
<cfparam name="url.invoiceid" default="">
<cfparam name="url.vallist" default="">

<cfset t = 0>

<cfloop index="itm" list="#url.vallist#" delimiters=";">

	<cfquery name="Line" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   InvoiceIncomingLine
			WHERE InvoiceLineId = '#itm#'
	</cfquery>
	
	<cfset t = t+line.Lineamount>
	
</cfloop>

<b>#numberformat(t,",.__")#</b>

<!--- ----------------------------------------- --->
<!--- only for existing invoices that are split --->
<!--- ----------------------------------------- --->

<cfif url.invoiceid neq "">
	
	<cfquery name="Inv" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Invoice
		WHERE InvoiceId = '#url.invoiceid#'
	</cfquery>
	
	<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#Inv.Mission#' 
	</cfquery>
	
	<!--- --------------------------------------- --->
	<!--- invoices on hold will not be multiplied --->
	<!--- --------------------------------------- --->
	
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ObjectKeyValue4 
        FROM   Organization.dbo.OrganizationObject
        WHERE  EntityCode    = 'ProcInvoice'
		AND    ObjectKeyValue4 = '#url.InvoiceId#' 
   </cfquery>	   
	
	<cfif Parameter.invoiceLineCreate eq "1" and check.recordcount gte "1">
		
		<cfquery name="Prior" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  SUM(DocumentAmountMatched) as Total
		    FROM    InvoicePurchase
			WHERE   InvoiceId = '#url.invoiceId#' 
		</cfquery>
		
		<cfoutput><font color="0080FF">(was: #numberformat(Prior.Total,",__.__")#)
		<cfif prior.total gt t>
		
		    <table>
				<tr>
				<td>
				&nbsp;&nbsp; 
				<font face="Calibri" size="2" color="6688AA">
					<cf_tl id="Issue another payable for the difference in the amount of"> #numberformat(prior.total-t,",__.__")#
				</font>
				</td>
				<td style="padding-left:4px">			
				<input type="radio" class="radiol" name="remainder" id="remainder" value="1" checked onclick="javascript:showExp('show','#url.invoiceId#')">
				</td>
				<td style="padding-left:4px" class="labelit"><cf_tl id="Yes"></td>
				<td style="padding-left:4px">
				<input type="radio" class="radiol" name="remainder" id="remainder" value="0" onclick="javascript:showExp('hide','#url.invoiceId#')">
				</td>
				<td style="padding-left:4px" class="labelit"><cf_tl id="No"></td>
				<input type="hidden" name="remainderamount" id="remainderamount" value="#prior.total-t#" readonly>
				</tr>
			</table>
				
		</cfif>
		
		</cfoutput>
	
	</cfif>

</cfif>

<script>
  try {
  tagging('#t#') } catch(e) {}
</script>

</cfoutput>
