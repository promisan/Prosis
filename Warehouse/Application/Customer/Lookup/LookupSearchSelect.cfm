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
<!--- Prosis template framework --->
<cfsilent>
    <proUsr>jmazariegos</proUsr>
    <proOwn>Jorge Mazariegos</proOwn>
    <proDes>Translated</proDes>
    <proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_screentop height="100%" line="no" bannerheight="4" html="No" title="Find Employee">

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

<TABLE width="94%" align="center" class="formpadding">

    <INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="CustomerSerialNo">
    <INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
    <TR>
        <TD style="width:200px" align="left"  class="labelmedium"><cfoutput>Id</cfoutput>:
        <input type="hidden" name="Crit3_Operator" id="Crit3_Operator" value="CONTAINS"></TD>
        <TD>
            <INPUT type="text" name="Crit3_Value" id="Crit3_Value" class="regularxl" size="10">
        </TD>
    </TR>

    <INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="CustomerName">
    <INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
    <TR>
    <TD align="left"  class="labelmedium"><cfoutput>Customer Name</cfoutput>:
        <input type="hidden" name="Crit1_Operator" id="Crit1_Operator" value="CONTAINS"></TD>
        <TD>
            <INPUT type="text" name="Crit1_Value" id="Crit1_Value" class="regularxl" size="30">
        </TD>
    </TR>

    <INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="Reference">
    <INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
    <TR>
        <TD align="left"  class="labelmedium"><cfoutput>Reference</cfoutput>:
        <input type="hidden" name="Crit2_Operator" id="Crit2_Operator" value="CONTAINS"></TD>
        <TD>
            <INPUT type="text" name="Crit2_Value" id="Crit2_Value" class="regularxl" size="20">
        </TD>
    </TR>
	
	


</TABLE>

</td>
</tr>

    <tr><td height="1" class="line"></td></tr>

    <tr><td colspan="2" align="center">
    <cf_tl id="Search" var="1">
    <input type="submit" value="<cfoutput>#lt_text#</cfoutput>" style="width:200;height:25" class="button10g">
    </td></tr>

</TABLE>

</FORM>

<cf_screenbottom>

