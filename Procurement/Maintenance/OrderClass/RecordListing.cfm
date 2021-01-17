<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_OrderClass 
	ORDER BY code
</cfquery>

<cf_screentop layout="webapp" 			  
			  html="No"			 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">

<cfloop query="SearchResult">

	  <!--- used for creating a workflow per class : bidding etc. --->	
		<cf_insertEntityClass  
	      Code        = "ProcJob"   
          Class       = "#Code#" 
   		  Description = "#Description#">	
						
</cfloop>	

<table width="100%" height="100%">

<cfset add          = "1">
<cfset Header       = "Order Class">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 590, height=570, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 590, height=570, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>
	
<tr><td colspan="2">

<cf_divscroll>

<table width="94%" align="center" class="navigation_table formpadding">

<tr class="labelmedium2 line">
   
	<TD width="5%"></TD>
    <TD>Code</TD>
	<td>Entity</td>
	<TD>Description</TD>
	<td>Mode</td>
	<td>Print Template</td>
	<TD>Officer</TD>
    <TD>Entered</TD>
  
</TR>

<cfoutput query="SearchResult">
    		
    <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#" class="navigation_row labelmedium2 line"> 
		<TD align="center">
			<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">					  
		</TD>		
		<TD>#Code#</TD>
		<TD><cfif mission eq ""><font color="808080">all</font><cfelse>#Mission#</cfif></TD>
		<TD>#Description#</TD>
		<td>#PreparationMode#</td>
		<td>
		
			<cfif PurchaseTemplate eq "">Default<cfelse>
		
				<cfif not FileExists("#SESSION.rootpath#/#PurchaseTemplate#")>
					<font color="FF0000">	
				<cfelse>
					<font color="6688aa">	   
				</cfif>
				#PurchaseTemplate#
				</font>
			
			</cfif>
		
		</td>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>	
	
</CFOUTPUT>

</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>


