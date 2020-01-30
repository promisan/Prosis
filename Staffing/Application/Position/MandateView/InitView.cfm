
<cf_tl id="Workforce Administration" var="1">

<cfoutput>

<cf_submenuleftscript>
<cfajaximport tags="cftree,cfform">
<cf_screenTop height="100%" jquery="Yes"order="0" html="No" title="#lt_text# #URL.Mission#" scroll="no">
<cf_layoutscript>
<cf_calendarscript>
	 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

	<cf_layout attributeCollection="#attrib#">
		
	<cf_layoutarea position="top" name="header" overflow="hidden" splitter="true">			
		  <cf_ViewTopMenu label="#lt_text# #URL.Mission#" layout="webapp" background="blue">
	</cf_layoutarea>
		
	<cf_layoutarea position="left" name="tree" maxsize="360" size="320" collapsible="true" splitter="true">
	       
	        <cfset url.id = 0>			

		<cfinclude template="MandateViewTree.cfm">		
				
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box">

				<iframe name="right"
		        id="right"
		        width="100%"
				src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		        height="100%"
				scrolling="no"
		        frameborder="0"></iframe>		
						
	</cf_layoutarea>			
			
	</cf_layout>
		
</cfoutput>

