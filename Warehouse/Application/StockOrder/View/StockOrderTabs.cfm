
<cf_screentop height="100%" scroll="No" band="No" jQuery="Yes" border="0" html="No">
 
<cfparam name="URL.mission" default="">

<cf_dialogOrganization>
<cf_dialogStaffing>

<cf_dialogWorkOrder>
<cf_dialogProcurement>

<cf_ActionListingScript>

<cf_FileLibraryScript>
<cf_ListingScript>

<cf_StockOrderScript>
<cf_MenuScript>

<script>
function toggleMenu(){
	t = document.getElementById('menuMaximized');
	if (t.className == 'show'){
		t.className = 'hide';
		t2 = document.getElementById('menuMinimized');
		t2.className = 'show';
	}else{
		t.className = 'show';
		t2 = document.getElementById('menuMinimized');
		t2.className = 'hide';
	}
}
</script>

<cfajaximport tags="cfform,cftree,cfdiv,cfinput-datefield">

<style>
.x-panel-body {
    border-color:#99bbe8;
    background-color:#ffffff;
    border-style:none;
	
}
</style>

<input type="hidden" name="selecteditem" id="selecteditem" value="">

<cf_layoutScript>

<cfset attrib = {type="Border",name="myboxInside",fitToWindow="Yes"}>
	 
<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
          type        = "Border"
          position    = "left"
          name        = "treebox"
		  minsize     = "280"
          size        = "280"
          collapsible = "true"
          splitter    = "true">
	
	   <cfinclude template="StockOrderTree.cfm">
	   
	</cf_layoutarea>

	<cf_layoutarea  type="Border" position="center" name="detail" overflow="auto">

		<cfoutput>
		<iframe name="initTree"
		        id="initTree"
		        width="100%"
		        height="98%"				
				scrolling="no"
		        frameborder="0" 
				src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm">
		        </iframe>
		</cfoutput>
									
	</cf_layoutarea>			
		
</cf_layout>		


<!---

<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr><td height="100%">
		  
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="100%" bgcolor="white">
									
			<table height="100%" cellspacing="0" cellpadding="0" class="formpadding">
				
				<tr>	
							
				    <cfoutput>
					
					<td width="30" bgcolor="f1f1f1" height ="100%" align="left" id="menuMinimized" class="hide" valign="middle" style="border-bottom:1px solid silver;border-left:1px solid silver;border-top:1px solid silver;background-image:url('#SESSION.root#/Images/border.png'); background-repeat:repeat-y; background-position: top right; padding-left:7px; cursor:pointer;" onClick="javascript:toggleMenu()">
					
						<img src="#SESSION.root#/Images/collapse_right_menu.png">
						
					</td>
					
					<td width="325" height="100%" align="right" id="menuMaximized" class="show" valign="top" 
					   style="border-bottom:1px solid silver;border-left:1px solid silver;border-top:1px solid silver;background-image:url('#SESSION.root#/Images/border.png'); background-repeat:repeat-y; background-position: top right; padding-left:7px; padding-top:5px;">
					   
					   <table width="325" height="100%">
					   <tr style="cursor:pointer" onclick="toggleMenu()">
					   <td class="labelit">Options</td>
					   <td align="right" style="padding-right:4px"><img src="#SESSION.root#/Images/collapse_left1.png"></td>						
					   </tr>
					   <tr><td height="5"></td></tr>
					   <tr><td colspan="2" class="linedotted"></td></tr>
					   
					   <tr><td colspan="2" height="100%" style="padding-right:5px;padding-bottom:5px">
					     <cf_divscroll>					    				 
					  	 <cfinclude template="StockOrderTree.cfm">
						 </cf_divscroll>
						
					   </td>
					   </tr>
					   </table>
					 </td>
					 
					 </cfoutput>
					 
				</tr>
				
			</table>
			
		</td>
							
		<td width="100%" height="100%" valign="top"
		   style="overflow:auto;padding-top:6px; padding-bottom:6px; padding-left:6px; padding-right:6px">		
		    <cf_divscroll id="detail" name="detail"></cf_divscroll>						
		</td>				   
	</tr>
</table>					   
	
</td></tr>

</table>

--->