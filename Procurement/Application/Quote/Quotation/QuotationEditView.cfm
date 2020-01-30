
<cf_tl id="Edit Quotation" var="1">
	
	<cf_screenTop height="100%" label="#lt_text#" line="no"
	      bannerheight="50" 
		  band="no" 
		  scroll="no" 
		  layout="webapp" 
   	      option="View and update quoted lines"
	      banner="blue">
		  
<cfoutput>
    
	<script language="JavaScript">

		function reloadForm(role,per) {
		  ptoken.location("QuotationTree.cfm?ID=#URL.ID#&Mode=#Mode#")
		}

	</script>
	   
	<table width="100%" height="100%" style="padding:10px" cellspacing="0" cellpadding="0" background="1">
		<tr>
			<td valign="top" width="260">
				<cfinclude template="QuotationTree.cfm">		
			</td>
			<td style="border-left: 1px solid Silver;">
				<iframe src="QuotationEdit.cfm?ID=#URL.ID#&Mode=#URL.Mode#"
		        name="right"
		        id="right"
		        width="100%"
		        height="100%"
				scrolling="auto"
		        frameborder="0"></iframe>
			</td>
		</tr>
	</table>
	<cf_screenbottom  layout="webapp">

</cfoutput>
