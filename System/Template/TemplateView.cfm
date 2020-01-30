
<cfoutput>

<script language="JavaScript">

function load(site) {
	window.parent.right.location = "TemplateLog.cfm?site="+site
}

function batch() {
      window.parent.right.location = "#SESSION.root#/tools/template/TemplateCheck.cfm?ts="+new Date().getTime();
}

</script>

<cf_screenTop 
    height="100%" 
	bannerheight="10" 
	title="#SESSION.welcome# Source Code Manager" 
	band="no" 
	html="No"
	jquery="Yes"
	scroll="no">
	
<cf_layoutscript>	
<cfajaximport tags="cftree,cfform">
		
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">	

	<cf_layoutarea  position="header" 
		name="topbox"
		source="TemplateMenu.cfm"/>	
	 
<cf_layoutarea source="TemplateViewTree.cfm" position="left" collapsible="true" name="tree" minsize="200px" size="300px" maxsize="50%" splitter="true">
	<cfoutput>
		<table>
			<tr>
				<td style="padding-left:5px; padding-top:10px;">
					<img src="#session.root#/Images/wait.gif" align="absmiddle">
				</td>
				<td class="labelit" style="padding-left:2px; padding-top:10px;">
					<cf_tl id="loading template view tree...">
				</td>
			</tr>
		</table>
	</cfoutput>
</cf_layoutarea>

<cf_layoutarea  position="center" name="box">	
	
    	<iframe src="#SESSION.root#/Tools/Template/TemplateCheck.cfm"
	        name="right"
	        id="right"
	        width="100%"
	        height="100%"
			scrolling="0"
	        frameborder="0">
		</iframe>

</cf_layoutarea>
		
</cf_layout>	


</cfoutput>
