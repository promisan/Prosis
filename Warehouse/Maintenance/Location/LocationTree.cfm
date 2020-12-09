
<!--- query --->

<table width="100%" height="100%" class="tree">

<tr><td valign="top">

	<table width="98%" class="formpadding">
	
	<cfoutput>
		<tr>
		<td height="18" style="padding-top:4px;padding-left:5px" class="labelit">
		<a id="refresh" href="javascript:ptoken.navigate('LocationTree.cfm?id2=#url.id2#','tree')"><cf_tl id="Refresh">
		</a>
		</td>
		</tr>
	</cfoutput>
		  
	<tr><td class="line"></td></tr> 
	
	<tr><td height="5"></td></tr>
	
	<cfform>
		   	  
		<tr><td align="center">
				<table width="96%" align="center">
				<tr><td>
				
				<cftree name="idorg" fontsize="11" bold="No" format="html" required="No">
				     <cftreeitem 
					  bind="cfc:service.Tree.LocationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#url.id2#','LocationListing.cfm')">  		 
			    </cftree>	
						
				</td></tr>
				</table>
		</td></tr> 	
	
	</cfform>
	
	<tr><td class="line" height="1"></td></tr> 
	
	</table>

	</td>
	</tr>

</table>

