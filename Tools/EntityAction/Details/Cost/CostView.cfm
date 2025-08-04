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
<cfparam name="url.objectId" default="B8B31331-1018-0668-4387-3047F5235DDE">

<cfset client.filter = "">

<cfquery name="Object" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT   *
		FROM     OrganizationObject
		WHERE    ObjectId = '#url.ObjectId#'	
</cfquery>

<cf_screentop height="100%" html="No" band="No" label="#Object.ObjectReference#" banner="Yellow" enforcebanner="Yes" jQuery="Yes">	

<cf_textareascript>
<cfajaximport tags="cfform,cfdiv,cftree,cfmenu,cfinput-autosuggest">

<cf_dialogLedger>
<cfinclude template="../DetailsScript.cfm">
<cfinclude template="CostScript.cfm">
<cf_layoutscript>
<cf_calendarscript>
		
<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">		
	
	<cf_layoutarea 
	          position="top"
	          name="controltop"
			  overflow="hidden"
	          minsize="45"
	          maxsize="45"  
			  size="45" 			  			     
	          splitter="true">	
					
		<cfinclude template="CostMenu.cfm">
			 
	</cf_layoutarea>	
	
	<cf_layoutarea 
	        position="left"
	        name="notetree"
	        source="Cost/CostTree.cfm?objectid=#url.objectid#"
	        title="Folders"
	        size="280"
			maxsize="280"
	        overflow="auto"
	        collapsible="true"
	        splitter="true"/>
			 	
			
	<cf_layoutarea  
		    position="center" 			
			overflow="hidden"
			source="Cost/CostList.cfm?objectid=#url.objectid#"
			name="costcontainer"/>
		
	<cf_layoutarea 
    	    position="right"
            name="summary"
            title="Summary"
            maxsize="300"
            size="200"          
            overflow="hidden"
            collapsible="true"
			splitter="true"
			initcollapsed="true"
            inithide="true"/>
			
	<cf_layoutarea 
            position="bottom"
            name="notebody"
            title="Document Detail"
            maxsize="190"
			size="190"
		    splitter="True"
            collapsible="true"
            initcollapsed="true"/>
		
</cf_layout>


