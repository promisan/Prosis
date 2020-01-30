
<cf_screentop height="100%" html="No" band="No" jQuery="Yes" busy="busy10.gif">	

<cf_layoutscript>
<cfajaximport tags="cfform,cftree,cfmenu,cfdiv,cftextarea,cfinput-datefield,cfinput-autosuggest">
<cfinclude template="../DetailsScript.cfm">
<cfinclude template="NoteScript.cfm">
<cf_menuscript>

<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>	
<input type="hidden" name="selecteditem" id="selecteditem" value="">

<cf_layout attributeCollection="#attrib#">		
			
	<cf_layoutarea 
	        position="left"
	        name="notetree"			
	        source="NoteTree.cfm?objectid=#url.objectid#"	      
	        style="height:100%;padding:2px;"
	        overflow="auto"
			minsize="250"
			size="250"   			
	        collapsible="true"
	        splitter="true"/>
	
	<cf_layoutarea  
		    position="center" 						
			overflow="hidden"
			size="300"  
			maxsize="300"
			minsize="300"
			style="height:100%;padding:0px"
			source="NoteViewList.cfm?objectid=#url.objectid#"
			name="notecontainer"/>
		
	<cf_layoutarea 
    	    position="right"
            name="notebody"   
			style="padding:2px;"   			                
            size="100%"  
            overflow="auto"
			splitter="true"/>	
			
</cf_layout>			
