
<cf_divscroll>

<cfform> 
	
	<table width="100%" border="0" style="padding-left:3px;padding-right:3px" align="center">		
		<tr><td style="padding-left:10px;padding-top:10px" valign="top">
			
		<cftree name="root"
		   font="calibri"
		   fontsize="12"		
		   bold="No"   
		   format="html"    
		   required="No">   
		
		   <cftreeitem 
			  bind="cfc:Service.Tree.VacTrackTree.getNodes({cftreeitemvalue},{cftreeitempath},'','No')">  		 
			
		</cftree>
		  		
		</td></tr>			
	
	</table>

</cfform>

</cf_divscroll>