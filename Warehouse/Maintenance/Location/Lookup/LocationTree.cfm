
<table width="100%" border="0" cellspacing="0" cellpadding="0">

  <tr><td>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
		  
	<tr><td>
	
	<cfform>
	    	  
		<tr><td align="center">
				<table width="96%" >
				<tr><td>
				
				<cf_UItree name="idorg" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
				     <cf_UItreeitem
					  bind="cfc:service.Tree.LocationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#mission#','LocationListing.cfm')">
			    </cf_UItree>
						
				</td></tr>
				</table>
		</td></tr> 	
		
	</cfform>	
		
	</td></tr>
	
	</table>

</td></tr>

</table>
