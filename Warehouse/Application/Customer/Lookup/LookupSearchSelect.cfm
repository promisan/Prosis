<!--- Prosis template framework --->
<cfsilent>
    <proUsr>jmazariegos</proUsr>
    <proOwn>Jorge Mazariegos</proOwn>
    <proDes>Translated</proDes>
    <proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_screentop height="100%" line="no" bannerheight="4" html="No" title="Find Employee">

<script language="JavaScript">
    window.name = "lookupCustomer"
</script>

<cfquery name="qCustomer"
        datasource="AppsMaterials"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
    SELECT *
    FROM  Customer
        <cfif URL.customerId neq "">
            WHERE CustomerId = '#URL.CustomerId#'
        <cfelse>
            WHERE 1 = 0
        </cfif>
</cfquery>


<form action="LookupSearchResult.cfm" method="post">

<cfoutput>
    <INPUT type="hidden" name="Link"           id="Link"           value="#CGI.QUERY_STRING#">
        <INPUT type="hidden" name="FormName"       id="FormName"       value="#URL.FormName#">
        <INPUT type="hidden" name="fldcustomerid"   id="fldcustomerid"    value="#URL.fldcustomerid#">
        <INPUT type="hidden" name="fldcustomername"  id="fldcustomername"   value="#URL.fldcustomername#">
</cfoutput>

<TABLE width="100%" border="0" align="center" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td>

<TABLE width="94%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="CustomerName">
    <INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
    <TR>
    <TD align="left"  class="labelmedium"><cfoutput>Customer Name</cfoutput>:
        <input type="hidden" name="Crit1_Operator" id="Crit1_Operator" value="CONTAINS"></TD>
        <TD>
            <INPUT type="text" name="Crit1_Value" id="Crit1_Value" class="regularxl" size="30">
        </TD>
    </TR>

    <INPUT type="hidden" name="Crit2_FieldName" id="Crit1_FieldName" value="Reference">
    <INPUT type="hidden" name="Crit2_FieldType" id="Crit1_FieldType" value="CHAR">
    <TR>
        <TD align="left"  class="labelmedium"><cfoutput>Reference</cfoutput>:
        <input type="hidden" name="Crit2_Operator" id="Crit1_Operator" value="CONTAINS"></TD>
        <TD>
            <INPUT type="text" name="Crit2_Value" id="Crit1_Value" class="regularxl" size="30">
        </TD>
    </TR>


</TABLE>

</td>
</tr>

    <tr><td height="1" class="linedotted"></td></tr>

    <tr><td colspan="2" align="center">
    <cf_tl id="Search" var="1">
    <input type="submit" value="<cfoutput>#lt_text#</cfoutput>" style="width:200;height:25" class="button10g">
    </td></tr>

</TABLE>

</FORM>

<cf_screenbottom>

