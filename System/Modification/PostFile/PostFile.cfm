
<cf_screentop height="100%" title="Application Code Inquiry" scroll="no" html="No" jQuery="Yes" TreeTemplate="Yes">

<cf_layoutscript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">	

	<cf_layoutarea 
          position="top"
          name="controltop"         
		  overflow="hidden"
          splitter="true">	
		  
		 <cfinclude template="PostFileMenu.cfm">
		  
	</cf_layoutarea>		  

	<cf_layoutarea 
	    position="left" name="tree" maxsize="400" size="260" collapsible="true" splitter="true">
	
			<table width="100%" height="100%" class="tree formpadding">
			<tr><td valign="top">
			
				<cfform>
					<cf_UItree name="idfolder" font="tahoma" fontsize="11" bold="No" format="html" required="No">
						 <cf_UItreeitem bind="cfc:service.Tree.FolderTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#SESSION.rootpath#')">
					</cf_UItree>
				</cfform>


			</td></tr>
			</table>
		
	</cf_layoutarea>	
	
	<cf_layoutarea 
	    position="center" name="boxfiles">				
	
	   <iframe name="right" id="right" width="100%" height="100%" scrolling="no" frameborder="0" border="0"></iframe>
		   
	</cf_layoutarea>	

</cf_layout>	   
