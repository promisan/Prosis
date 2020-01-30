
<cfset tot = 0>

<cfloop index="itm" list="#Form.SelectedPurchase#" delimiters=",">

	<cfparam name="Form.Purchase_#itm#" default="">	
	<cfset val = evaluate("Form.Purchase_#itm#")>
	
	<cfif val neq "">
	
		<cfif IsNumeric(val)>		
		   	<cfset tot = tot + val> 	
		</cfif>
	
	</cfif>

</cfloop>

<table>
	<tr >
	<td class="labelit"><cf_tl id="selected">:</td>
    <td class="labelmedium" style="padding-left:7px"><cfoutput>#numberformat(tot,',.__')#</cfoutput></td>
	</tr>
</table>

