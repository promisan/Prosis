
<table width="100%" height="100%" class="formpadding">
<tr><td width="100%" height="100%" style="overflow:hidden">

<cfoutput>

    <cfparam name="url.formname"        default="">
    <cfparam name="url.fldcustomerid"   default="00000000-0000-0000-0000-000000000000">
    <cfparam name="url.fldcustomername" default="">
	<cfparam name="url.mid"             default="">

        <iframe name="result" id="result"
                src="#session.root#/Warehouse/Application/Customer/Lookup/LookupSearchSelect.cfm?FormName=#URL.FormName#&fldcustomerid=#URL.fldcustomerid#&fldcustomername=#URL.fldcustomername#&CustomerId=#URL.customerId#&mid=#url.mid#" width="100%" height="100%" frameborder="0"></iframe>

</cfoutput>
</td></tr>
</table>
