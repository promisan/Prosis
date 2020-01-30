
<cfoutput>
	
	<cfset Criteria = ''>
	
	<cf_divscroll style="height:100%">
		<table width="100%" height="100%" class="tree formpadding">
		  <tr><td valign="top" style="padding-left:7px">
		   <cfform>
		    <table width="99%" align="center">	    	  
			  <tr class="line">
		          <td style="height:40px" class="labelmedium"><a href="javascript:refreshTree()"><img src="#SESSION.root#/images/Reload_Blue.png" width="24" height="24" style="vertical-align: middle"><span style="color:##033f5d;font-size: 14px;display:inline-block;position:relative;top:2px;left:2px;"><cf_tl id="Reload"></span></a></td>
		      </tr>	      
		      
		      <tr><td style="padding-top:10px">
			 
					<cf_UItree name="idtree" font="verdana" fontsize="11" format="html">
					     <cf_UItreeitem bind="cfc:service.Tree.WorkflowTree.getNodesV2({cftreeitempath},{cftreeitemvalue})">
					</cf_UItree>
			  
			  </td></tr>    
			
		    </table>
			</cfform>
		  </td></tr>	  
		</table>
	</cf_divscroll>


</cfoutput>
