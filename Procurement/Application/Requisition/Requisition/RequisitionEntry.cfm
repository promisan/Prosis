

<cf_screentop height="100%" scroll="No" html="No" jQuery="Yes" label="Requisition">

<cfset add = 1>

<cfif URL.ID eq "new">
	<cfset add = 1>
<!--- creates --->
	<cfinclude template="RequisitionEntryRecord.cfm">

</cfif>


<table width="100%" height="100%">

  <cfoutput>

	<tr><td colspan="2" height="100%" valign="top">

	    <cf_divscroll style="height:100%">

		    <cfset status =  "1">
			<cfinclude template="RequisitionEdit.cfm">

		</cf_divscroll>

		</td>
	</tr>

  </cfoutput>

</table>

