<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Bank Accounts">

<table width="97%" height="100%" align="center">
<TR style="height;10px"><td colspan="2" style="padding-top:10px"><cfinclude template = "../HeaderParameter.cfm"> </td></tr>      

<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  B.*, 
    	    A.GLAccount, 
			A.Description
    FROM    Ref_Bankaccount B LEFT OUTER JOIN Ref_Account A ON B.BankId = A.BankId    
</cfquery>

<cfoutput>

<script>

function recordadd(grp) {
      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=600, height=480, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id) {
      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID=" + id, "Edit", "left=80, top=80, width=600, height=480, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
</cfoutput>

<tr><td style="height:100%">
	
<cf_divscroll>

<table width="95%" align="center" class="navigation_table">

<tr class="line labelmedium2 fixlengthlist">
   
    <TD height="20"></TD>
    <TD>Bank</TD>
	<TD>Currency</TD>
	<TD>Name</TD>
	<TD>AccountNo</TD>
	<TD>ABA</TD>
    <TD>GL Account</TD>
  
</TR>

<cfoutput query="SearchResult">
    
    <TR class="navigation_row line labelmedium2 fixlengthlist">
		<td height="20" align="center" style="width:25;padding-top:1px">
		  <cf_img icon="open" navigation="Yes" onClick="recordedit('#BankId#')">
		</td>
		<TD>#BankName#</TD>
		<td>#Currency#</td>
		<TD>#AccountNo#</TD>
		<TD>#AccountName#</TD>
		<TD>#AccountABA#</TD>
		<TD>#GLAccount# #Description#</TD>
    </TR>
	
</CFOUTPUT>

</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>
