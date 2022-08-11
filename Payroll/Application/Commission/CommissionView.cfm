
<cfoutput>

<cf_tl id="Sales Commission calculation and submission" var="1">

<cf_screenTop height="100%" title="#URL.Mission# #lt_text#" 
    jQuery="Yes" html="No" border="0" scroll="no" MenuAccess="Yes" validateSession="Yes">
	 
<cf_LayoutScript>
<cfajaximport tags="cfform">	
	 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	      type="Border"
          position="header"
          name="controltop">	
				
		 <cf_ViewTopMenu label="#URL.Mission# #lt_text#" background="gray">
				 
	</cf_layoutarea>		

	<cf_layoutarea 
	    type="Border" position="left" name="treebox" maxsize="400" size="270" overflow="hidden" style="height:100%" collapsible="true" splitter="true">
		
	       <cfinclude template="CommissionViewTree.cfm">			
										
	</cf_layoutarea>

	<cf_layoutarea type="Border" position="center" name="box" style="height:100%" overflow="hidden">		

		   <iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm" name="right" id="right" width="100%" height="100%" scrolling="0" frameborder="0"></iframe>
									
	</cf_layoutarea>			
		
</cf_layout>		

</cfoutput>


