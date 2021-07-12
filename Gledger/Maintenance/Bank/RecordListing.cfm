<!--- Create Criteria string for query from data entered thru search form --->



<cfset add          = "1">
<cfset Header       = "Bank Accounts">

<cf_screentop html="No" jquery="Yes">

<table height="100%" width="94%" align="center" cellspacing="0" cellpadding="0" align="center">

<tr><td style="height:10">

<cfinclude template = "../HeaderMaintain.cfm"> 

</td></tr>


<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT B.*, R.GLAccount, R.Description
	FROM    Ref_BankAccount B LEFT OUTER JOIN
        Ref_Account R ON B.BankId = R.BankId
</cfquery>

<cfoutput>
	
	<script>
	
	function recordadd(grp) {
         ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=890, height=790, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id) {
         ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID=" + id, "Edit", "left=80, top=80, width=890, height=790, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	

</cfoutput>

<tr><td>
	
	<cf_divscroll>
	
		
		<table width="99%" align="center" class="navigation_table">
		
			<tr class="labelmedium2 fixrow">
			    <td></td>
			    <td><cf_tl id="Bank"></td>
				<td><cf_tl id="Curr"></td>				
				<td><cf_tl id="AccountNo"></td>
				<td><cf_tl id="Bank Address"></td>
			    <td><cf_tl id="GL Account"></td>
			</tr>			
			
				<cfoutput query="SearchResult">
				    <tr class="navigation_row line labelmedium2">
						<td align="center" style="width:30px">
							  <cf_img icon="select" navigation="yes" onclick="recordedit('#BankId#')">
						</td>
						<td>#BankName#</td>
						<td>#Currency#</td>
						<td>#AccountNo#</td>
						<!---
						<td>#AccountName#</td>
						--->
						<td>#BankAddress#</td>
						<td>#GLAccount# #Description#</td>
				    </tr>
				</cfoutput>
			
		
		</table>
	
	</cf_divscroll>

</td>

</table>

<cfset ajaxonload("doHighlight")>