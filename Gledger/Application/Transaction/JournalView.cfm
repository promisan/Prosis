
<cf_tl id="General Ledger Entity" var="1">

<cf_screenTop jQuery="Yes" height="100%" border="0" html="No" title="#lt_text#  #URL.Mission#" scroll="no" MenuAccess="Yes" validateSession="Yes"> 

<cfoutput>

<cf_layoutscript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
          position="header"		  
          name="controltop">			 		  
		
		<cf_ViewTopMenu background="gray" label="#lt_text# #URL.Mission#">
		  		 
	</cf_layoutarea>		 

	<cf_layoutarea 
	    position="left" name="left" minsize="400" maxsize="400" size="400" overflow="yes" collapsible="true" splitter="true">
	
		<cfinclude template="JournalViewTree.cfm">
		
	</cf_layoutarea>

	<cf_layoutarea  position="center" name="box">
	
		<table style="width:100%;height:100%"><tr><td>
	
			<iframe name="right"
		        id="right"
		        width="100%"
		        height="100%"
		        align="middle"
		        scrolling="no"
		        frameborder="0"
				src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"></iframe>		
				
				</td></tr></table></tr>
		
	</cf_layoutarea>			
		
</cf_layout>
	
</cfoutput>


