
<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>

<cf_screentop height="100%"
        html="Yes"
        scroll="Yes"
        label="Locate Customer"
        option="Enter your search criteria"
        layout="webapp"
        banner="gray"
        bannerforce="Yes">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td width="100%" height="100%" style="overflow:hidden">

<cfoutput>

    <cfparam name="url.formname"        default="">
    <cfparam name="url.fldcustomerid"   default="00000000-0000-0000-0000-000000000000">
    <cfparam name="url.fldcustomername" default="">

        <iframe name="result" id="result"
                src="LookupSearchSelect.cfm?FormName=#URL.FormName#&fldcustomerid=#URL.fldcustomerid#&fldcustomername=#URL.fldcustomername#&CustomerId=#URL.customerId#&mid=#mid#" width="100%" height="100%" frameborder="0"></iframe>

</cfoutput>
</td></tr>
</table>

<cf_screenbottom layout="webapp">