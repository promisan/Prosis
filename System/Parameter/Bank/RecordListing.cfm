<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" html="No">

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Bank Accounts">
<cfinclude template = "../HeaderParameter.cfm"> 

<table width="97%" align="center" cellspacing="0" cellpadding="0">

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
	
<TR>

<td colspan="2" style="padding-top:10px">

<table width="95%"  border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="line labelmedium">
   
    <TD height="20"></TD>
    <TD>Bank</TD>
	<TD>Currency</TD>
	<TD>Name</TD>
	<TD>AccountNo</TD>
	<TD>ABA</TD>
    <TD>GL Account</TD>
  
</TR>

<cfoutput query="SearchResult">
    
    <TR class="navigation_row line labelmedium">
		<td height="20" align="center" style="width:25;padding-top:4px;height:19">
		  <cf_img icon="edit" navigation="Yes" onClick="recordedit('#BankId#')">
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

</td>
</tr>

</TABLE>
