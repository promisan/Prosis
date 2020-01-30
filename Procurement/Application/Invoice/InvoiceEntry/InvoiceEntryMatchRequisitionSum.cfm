
<cfoutput>

<!--- show total --->
<cfparam name="url.invoiceid" default="">
<cfparam name="FORM._requests" default="">

<cfset t = 0>

<cfloop index="itm" list="#FORM._requests#" delimiters=";">

	<cfset itm = replace(itm," ","","All")>
	<cfset itm = replace(itm,",","","All")>
	
	<cfif itm eq "">
	
	<cfelseif NOT LSisNumeric(itm)>
	
		<font color="FF0000">Error</font>
		<cfabort>
	
	<cfelse>
	
		<cfset t = t+itm>
	
	</cfif>

</cfloop>

<b>#numberformat(t,",__.__")#</font></b>

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
	    FROM Ref_ParameterMission
		WHERE Mission = '#Inv.Mission#' 
	</cfquery>
	
	<!--- --------------------------------------- --->
	<!--- invoices on hold will not be multiplied --->
	<!--- --------------------------------------- --->
	
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT ObjectKeyValue4 
               FROM Organization.dbo.OrganizationObject
       		WHERE EntityCode    = 'ProcInvoice'
			AND  ObjectKeyValue4 = '#url.InvoiceId#' 
   </cfquery>	   
	
	<cfif Parameter.invoiceLineCreate eq "1" and check.recordcount gte "1">
		
		<cfquery name="Prior" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  sum(AmountMatched) as Total
		    FROM    InvoicePurchase
			WHERE   InvoiceId = '#url.invoiceId#' 
		</cfquery>
		
		<cfoutput><font color="0080FF">(was: #numberformat(Prior.Total,",__.__")#)
		<cfif prior.total gt t>
		
		    <table>
			<tr class="labelit">
			<td style="padding-left:5px"><font color="red">
			<cf_tl id="Create a new entry for the difference in the amount of"> #numberformat(prior.total-t,",__.__")#</font>
			</td>
			<td style="padding-left:5px"><input type="radio" class="radiol" name="remainder" id="remainder" value="1" checked onclick="showExp('show','#url.invoiceId#')"></td>
			<td style="padding-left:5px">Yes</td>
			<td style="padding-left:5px"><input type="radio" class="radiol" name="remainder" id="remainder" value="0" onclick="showExp('hide','#url.invoiceId#')"></td>
			<td style="padding-left:5px">No</td>
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