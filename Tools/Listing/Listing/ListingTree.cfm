
<cfoutput>

<cfset Criteria = "">

<cfset vContentTreeHeight = "100%">		

<!--- ------------------------------------------------ --->
<!--- provision to fix the height bug in IE10 and IE11 --->
<!--- ------------------------------------------------ --->

<cfif client.browser eq "Explorer">
	<cfset vContentTreeHeight = url.height-250>		
</cfif>
<!--- ----------------------------------------------- --->

<cfform>
<table style="height:100%; width:100%;" border="0" cellspacing="0" cellpadding="0">  
  <tr><td valign="top" style="padding-top:2px;padding-left:4px" style="height:100%; width:100%">
  		<cf_divscroll height="#vContentTreeHeight#" width="100%" overflowy="auto" overflowx="auto">
		  	
				<cftree name="idtree"  font="Calibri" fontsize="13" format="html"> 				  
				   	<cftreeitem bind="cfc:service.Tree.BuilderTree.getNodes({cftreeitempath},{cftreeitemvalue},'#url.systemfunctionid#','#url.FunctionSerialNo#','#url.box#')">				 
				</cftree>
			
		</cf_divscroll>
  </td></tr>  
</table>
</cfform>	

</cfoutput>

