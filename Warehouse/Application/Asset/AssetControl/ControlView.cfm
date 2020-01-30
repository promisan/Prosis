
<cf_screenTop height="100%"
    title="#URL.Mission# Non Expendable Administration" 
    border="0" 
	MenuAccess="Yes"
	html="No" 	
	jQuery="yes"
	ValidateSession="Yes"
	scroll="no">
	
<cfinclude template="ControlScript.cfm">

<cf_layoutScript>

<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>
<cf_layout attributeCollection="#attrib#">
				
	<cf_layoutarea  
	      position="header" 
		  overflow="hidden"		
		  name="controlmenu"	
		  size="50"		    	  
		  source="ControlMenu.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"/>	 
		
	<cf_layoutarea 
          position="left"
          name="controltree"
          source="ControlTree.cfm?mission=#url.mission#"  
		  minsize="10"
          maxsize="390" 
		  size="270"       		 
          overflow="auto"
          collapsible="true"
          splitter="true"/>
	
	<cf_layoutarea  
	      position="center" 
		  overflow="hidden"	 
		  name="controllistC">
		    <cf_divScroll id="controllist">
		    <table height="100%" width="100%">
				<tr>
					<td valign="middle">
						<cfinclude template="../../../../Tools/Treeview/TreeViewInit.cfm">
					</td>
				</tr>
			</table> 
		    </cf_divScroll>	
	</cf_layoutarea>	 
		  
	<cf_layoutarea 	       
          position="bottom"
          name="controldetail"          
          size="250"
		  maxsize="390" 
		  source="ControlDetail.cfm?mission=#url.mission#"		 
          collapsible="true"
          initcollapsed="true"
          splitter="true"/>	

</cf_layout>

