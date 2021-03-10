<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_screentop height="100%" html="No" line="no" jQuery="yes" scroll="yes" bannerheight="4" title="Result">

<cfajaximport tags="CFFORM">

<!--- Create Criteria string for query from data entered thru search form --->

<CFSET Criteria = ''>
<CF_Search_AppendCriteria
	    FieldName="#Form.Crit1_FieldName#"
	    FieldType="#Form.Crit1_FieldType#"
	    Operator="#Form.Crit1_Operator#"
	    Value="#Form.Crit1_Value#">

<CF_Search_AppendCriteria
        FieldName="#Form.Crit2_FieldName#"
        FieldType="#Form.Crit2_FieldType#"
        Operator="#Form.Crit2_Operator#"
        Value="#Form.Crit2_Value#">
		
<CF_Search_AppendCriteria
        FieldName="#Form.Crit3_FieldName#"
        FieldType="#Form.Crit3_FieldType#"
        Operator="#Form.Crit3_Operator#"
        Value="#Form.Crit3_Value#">		


<!--- Query returning search results --->
<cfquery name="SearchResult"
	datasource="AppsMaterials"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT TOP 100 *, (SELECT MAX(TransactionDate) FROM WarehouseBatch WHERE CustomerId = C.Customerid AND ActionStatus != '9') as LastDate 
    	FROM Customer C
		<cfif PreserveSingleQuotes(Criteria) neq "">
		WHERE #PreserveSingleQuotes(Criteria)#
		<cfelse>
		WHERE CustomerName is not NULL
		</cfif>
		AND   Operational = 1
		ORDER BY CustomerName
</cfquery>

<cfoutput>

<cfparam name="url.customerid" default="">
<cfparam name="url.mode" default="lookup">

<script>

	function selected(customerid,customername) {

			var cid = "#Form.fldcustomerid#";
			var cname = "#Form.fldcustomername#";

		    parent.document.getElementById(cid).value   = customerid
			parent.document.getElementById(cname).value = customername
			parent.ProsisUI.closeWindow('customer')
	}

	function search() {
		ptoken.location('LookupSearchSelect.cfm?#Form.link#')
	}

</script>

</cfoutput>

<cf_dialogLedger>

<table width="98%" height="94%" align="center">

<tr class="line"><td colspan="2" align="center" height="30">
	<input type="button" class="button10g" style="width:140;height:25" name="Search" value="Search" onClick="search()">
	</td>
</tr>

<tr><td colspan="2" valign="top" id="tablecontent">

	<table border="0" cellpadding="0" cellspacing="0" class="navigation_table" width="100%">

	<tr>
	   <td height="28" class="labelmedium" colspan="7">
		   <table width="100%">
			   <tr>
				   <td class="labelmedium" style="padding-left:20px"><cfoutput>#SearchResult.recordcount#</cfoutput> <cf_tl id="customers listed"></td>
				   <!---
				   <td>|</td>
				   <td class="labelmedium">
				      <a href="javascript:addrecord()">Register a new customer</a>
				   </td>
				   --->
			   </tr>
		   </table>
	   </td>
	   <td align="right"></td>
	</tr>

	<TR class="line labelmedium2">
	    <td height="20"></td>
		<TD><cf_tl id="Id"></TD>        
	    <TD><cf_tl id="Name"></TD>
		<TD><cf_tl id="PersonId"></TD>
		<TD><cf_tl id="Mission"></TD>
		<TD><cf_tl id="Last"></TD>
		<TD><cf_tl id="Reference"></TD>
	</TR>

	<CFOUTPUT query="SearchResult">

		<TR class="navigation_row line labelmedium2" style="height:20px" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f1f1f1'))#">
			<TD width="30" align="center" class="navigation_action" style="padding-left:7px;padding-top:3px"
			   onclick="selected('#customerid#','#customername#')"><cf_img icon="select"></TD>
            <TD><a href="javascript:editCustomer('#customerid#')">#CustomerSerialNo#</a></TD>
			<TD>#CustomerName#</TD>
			<TD>#PersonNo#</TD>
			<td>#Mission#</td>
			<td>#dateformat(LastDate,client.dateformatshow)#</td>
			<TD>#Reference#</TD>
		</TR>

	</CFOUTPUT>

	</TABLE>

</tr></td>
</table>

<cf_screenbottom>
