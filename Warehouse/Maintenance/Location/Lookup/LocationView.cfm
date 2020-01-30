
<cfajaximport tags="cftree, cfform">

<cf_screentop height="100%" html="Yes" layout="webapp" banner="gray" Label="Select a location" jQuery="yes">
<cf_Layoutscript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">		

	<cf_layoutarea 
          position="left"
          name="tree"
          source="LocationTree.cfm?Mission=#URL.Mission#&FormName=#URL.formname#&fldlocation=#URL.fldlocation#&fldlocationcode=#URL.fldlocationcode#&fldlocationname=#URL.fldlocationname#&fldorgunit=#URL.fldorgunit#&fldorgunitname=#URL.fldorgunitname#&fldpersonno=#URL.fldpersonno#&fldname=#URL.fldname#"          
          size="210"
          collapsible="true"
          splitter="true"
          maxsize="340"/>
	
	<cf_layoutarea  position="center" name="box">		
	
			<iframe name="right"					    
			        id="right"
			        width="100%"
			        height="100%"
			        scrolling="no"
			        frameborder="0"></iframe>							
	
	</cf_layoutarea>			
		
</cf_layout>


