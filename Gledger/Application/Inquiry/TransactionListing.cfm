<cfparam name="URL.Page" default="1">
<cfparam name="URL.ID" default="Journal">
<cfparam name="URL.ID2" default="All">

<table width="100%" height="100%" align="center">
  
<tr><td colspan="2" style="padding:5px">

<table width="100%" height="100%" align="center">

<!--- Query returning search results --->
<cfquery name="AccountGroup"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT AccountGroup, AccountGroupName
	FROM #SESSION.acc#Gledger
</cfquery>

<cfoutput>
   <cfif URL.ID2 eq "All">
     <cfset cond = "">
   <cfelse>
     <cfset cond = "WHERE AccountGroup = '#URL.ID2#'">  
   </cfif>
</cfoutput>

<!--- Query returning search results --->
<cfquery name="SearchResult"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     #SESSION.acc#Gledger
	#PreserveSingleQuotes(cond)#
    ORDER BY Currency, #URL.ID# <cfif url.id eq "Posted">DESC</cfif>, JournalTransactionNo
</cfquery>

<cfset counted = SearchResult.recordcount>
	
<cfset currrow = 0>

<tr>
<TD height="30">

<select name="filter" id="filter" size"1" class="regularxxl" onChange="javascript:reloadForm(this.value,document.getElementById('group').value,document.getElementById('page').value)">    
    <option value="All" <cfif "All" is '#URL.ID2#'>selected</cfif>>All</option>
    <cfoutput query="AccountGroup">
	<option value="#AccountGroup#" <cfif AccountGroup is URL.ID2>selected</cfif>>
	   #AccountGroup# #AccountGroupName#
	</option>
	</cfoutput>	
</select>

<select name="group" id="group" size="1" class="regularxxl" onChange="javascript:reloadForm(document.getElementById('filter').value,this.value,document.getElementById('page').value)">
     <option value="Journal" <cfif URL.ID eq "Journal">selected</cfif>><cf_tl id="by Journal">
     <OPTION value="AccountGroup" <cfif URL.ID eq "AccountGroup">selected</cfif>><cf_tl id="by AccountGruop">
     <OPTION value="TransactionDate" <cfif URL.ID eq "TransactionDate">selected</cfif>><cf_tl id="by Transaction Date">
	 <OPTION value="Posted" <cfif URL.ID eq "Posted">selected</cfif>><cf_tl id="by Posting Date">
</SELECT> 

</TD>
 
<td align="right" style="padding-right:5px">

     <cf_PageCountN count="#counted#">
     <select name="page" id="page" size="1" style="color: gray;" class="regularxxl"
            onChange="javascript:reloadForm(document.getElementById('filter').value,document.getElementById('group').value,this.value)">
	     <cfloop index="Item" from="1" to="#pages#" step="1">
               <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
         </cfloop>	 
     </SELECT> 
</TD>
</tr>

<cfif counted eq "0">

	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="30"><b><cf_tl id="No records found"></td></tr>
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	<tr><td height="100%"></td></tr>

<cfelse>

	<cfset pages = 1>
	<cfset url.grouping = url.id>
	<cfinclude template="TransactionListingLines.cfm">
	
</cfif>	

</TABLE>

</td>

</tr>

</table> 

<cfset AjaxOnLoad("doHighlight")>	

<script>
	parent.Prosis.busy('no')
</script>

