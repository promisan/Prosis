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


<!--- Query returning search results --->
<cfquery name="SearchResult"
datasource="AppsMaterials"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT TOP 100 *
    FROM Customer
	<cfif PreserveSingleQuotes(Criteria) neq "">
	WHERE #PreserveSingleQuotes(Criteria)#
	<cfelse>
	WHERE CustomerName is not NULL
	</cfif>
	ORDER BY CustomerName</cfquery>


<cfoutput>

<cfparam name="url.customerid" default="">
<cfparam name="url.mode" default="lookup">

<script>

	function selected(customerid,customername) {

			var cid = "#Form.fldcustomerid#";
			var cname = "#Form.fldcustomername#";

		    parent.opener.document.getElementById(cid).value = customerid
			parent.opener.document.getElementById(cname).value = customername

			parent.window.close();
	}

	function search() {
		window.location = "LookupSearchSelect.cfm?#Form.link#"
	}



</script>

</cfoutput>

<cf_dialogStaffing>

<table width="98%" height="94%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td colspan="2" align="center" height="30">
	<input type="button" class="button10s" style="width:140;height:25" name="Search" value="Search" onClick="search()">
	</td>
</tr>

<tr><td height="1" colspan="7" class="line"></td></tr>

<tr><td colspan="2" valign="top" id="tablecontent">

	<table border="0" cellpadding="0" cellspacing="0" class="navigation_table" width="100%">

	<tr>
	   <td height="28" class="labelmedium" colspan="7">
		   <table width="100%">
			   <tr>
				   <td class="labelmedium" style="padding-left:20px"><cfoutput>#SearchResult.recordcount#</cfoutput> <cf_tl id="employees listed"></td>
				   <td>|</td>
				   <td class="labelmedium">
				      <a href="javascript:addrecord()"><font color="6688aa">Register a new person</font></a>
				   </td>
			   </tr>
		   </table>
	   </td>
	   <td align="right"></td>
	</tr>

	<TR class="line">
	    <td height="20"></td>
        <TD class="labelit"><cf_tl id="Reference"></TD>
	    <TD class="labelit"><cf_tl id="Name"></TD>
	</TR>

	<CFOUTPUT query="SearchResult">


		<TR class="navigation_row line labelmedium" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f7f7f7'))#">

			<TD width="30" align="center" class="navigation_action" style="padding-left:10px;padding-top:5px"
			   onclick="selected('#customerid#','#customername#')">
			   <cf_img icon="select">
			</TD>
            <TD>#Reference#</TD>
			<TD>#CustomerName#</TD>

		</TR>

	</CFOUTPUT>

	</TABLE>

</tr></td>
</table>

<cf_screenbottom>
