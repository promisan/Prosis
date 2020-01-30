
<cfajaximport tags="cfdiv,cfform,cfinput-autosuggest">

<cfsavecontent variable="option">
	<cfoutput>
		<input type="button" class="button10g" name="Search" id="Search" value="New Search" onClick="javascript: window.location = 'ItemSearch.cfm?idmenu=#url.idmenu#';">
	</cfoutput>
</cfsavecontent>

<cfoutput>
<script>

function recordadd(transaction) {
	recordeditcustomermapping('new','#url.getNulls#');
}

function recordeditcustomermapping(transaction,getnulls) {
	wd = 750;
    ht = 275;
 	ptoken.open("#SESSION.root#/workorder/maintenance/customerMapping/RecordEdit.cfm?ID1="+transaction+"&ts="+new Date().getTime(), null, "left=100, top=100, width="+wd+", height="+ht+",menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");			
}
 
</script>

</cfoutput>
	
<cf_divscroll>
	
<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		
	
<table width="99%" border="0"  cellspacing="0" cellpadding="1" align="center">

	<tr><td class="line"></td></tr>
    <tr><td height="4"></td></tr>				
	<tr>
	
	    <td width="100%" id="listing">
		   <cfinclude template="RecordListingDetail.cfm">
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	
				
</cf_divscroll>