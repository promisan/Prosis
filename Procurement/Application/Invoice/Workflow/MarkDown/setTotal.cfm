
<cfset tot = 0>

<cfloop index="itm" list="#Form.SelectedPurchase#" delimiters=",">

	<cfparam name="Form.Purchase_#itm#" default="">		
	<cfset val = evaluate("Form.Purchase_#itm#")>
	<cfset val = replace(val,",","","ALL")>
	
	<cfif val neq "">
	
		<cfif IsNumeric(val)>		
		   	<cfset tot = tot + val> 	
		</cfif>
	
	</cfif>

</cfloop>

<table>
	<tr >	
    <td class="labellarge"><cfoutput>#numberformat(tot,',.__')#</cfoutput></td>
	</tr>
</table>

<cfoutput>

<script>
	document.getElementById('documentamountpayable').value = '#tot#'
</script>

</cfoutput>

