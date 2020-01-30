
<cfquery name="ServiceItem" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItem
		WHERE  Code = '#URL.ID1#'		
</cfquery>	 	

<cf_screentop height="100%" label="Provisioning #serviceitem.description#" scroll="No" jquery="Yes" option="Service Item Unit Maintenance [#url.id1#]" bannerheight="75"  line="no" layout="webapp" banner="gray">
	
<table height="100%" width="100%" class="formpadding" cellspacing="0" cellpadding="0" align="center">
			
 <tr class="hide"><td><iframe name="process" id="process" frameborder="0"></iframe></td></tr>
 
 <tr><td height="100%">

<CFFORM style="height:100%" action="ItemUnitSubmit.cfm?id1=#url.id1#&id2=#url.id2#" target="process" method="post" name="formunit">

	<cf_divscroll style="height:100%" id="divServiceItemUnit">
	<cfinclude template="ItemUnitEditContent.cfm">
	</cf_divscroll>

</cfform>

</td></tr>

</table>

	<script language="JavaScript">
		
		function ask() {
			if (confirm("Do you want to remove this record ?")) {			
			return true 			
			}			
			return false			
		}	
		
		function labelme(val) {
		
		   if (val == "Detail") {
		    document.getElementById("labelling").className = "regular"
		   } else {
		    document.getElementById("labelling").className = "hide"
		   }
		}
	
	</script>
	

