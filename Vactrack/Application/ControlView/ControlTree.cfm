<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes" TreeTemplate="Yes">
<cfform>
	<table width="100%" border="0" style="padding-left:3px;padding-right:3px" align="center">		
		<tr><td style="padding-left:10px;padding-top:10px" valign="top">

<!---
		<cftree name="root"
		   font="calibri"
		   fontsize="12"		
		   bold="No"   
		   format="html"    
		   required="No">   
		
		   <cftreeitem 
			  bind="cfc:Service.Tree.VacTrackTree.getNodes({cftreeitemvalue},{cftreeitempath},'','No')">  		 
			
		</cftree>
		
---->

		<cf_UItree name="idtree" font="verdana" fontsize="11" format="html">
			     <cf_UItreeitem bind="cfc:service.Tree.VacTrackTree.getNodesV2({cftreeitempath},{cftreeitemvalue})">
		</cf_UItree>

		</td></tr>			
	
	</table>

</cfform>