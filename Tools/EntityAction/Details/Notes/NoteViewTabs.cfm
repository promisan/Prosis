<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cf_screentop height="100%" html="No" band="No" jQuery="Yes" busy="busy10.gif">	

<cf_layoutscript>
<cf_textareascript>
<cfajaximport tags="cfform,cftree,cfmenu,cfdiv,cfinput-datefield,cfinput-autosuggest">
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
