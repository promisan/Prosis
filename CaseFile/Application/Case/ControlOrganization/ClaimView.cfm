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

<cfparam name="URL.mission" default="UN">

<cfquery name="GetMission" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 	SELECT *
			FROM   Ref_Mission
			WHERE  Mission = '#URL.Mission#'
		 
</cfquery> 

<cf_screentop height="100%" layout="innerbox" jQuery="Yes" html="No" border="0" title="Case registration #GetMission.MissionName#" menuAccess="Yes" validateSession="Yes">

	<cfinclude template="ClaimScript.cfm">
	
	<cf_layoutscript>
		
	<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>

	<cf_layout attributeCollection="#attrib#">
	   	   
	<cf_layoutarea 
          position="header"
          name="controltop"
		  source="ClaimMenu.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"/>		
	
	   <cf_tl id="Folders" var="1">

	   <cf_layoutarea 
	          position="left"
	          name="controltree"
	          source="ClaimTree.cfm?ID2=#url.mission#"	         
			  size="280"
			  minsize="280"
			  maxsize="280"          
	          overflow="auto"
	          collapsible="true"			  
	          splitter="true"/>
		
	   <cf_layoutarea  
		    position="center" 
			name="controllist">
			
			<table height="100%" width="100%">
				<tr>
					<td valign="middle">
						<cfinclude template="../../../../Tools/Treeview/TreeViewInit.cfm">	
					</td>
				</tr>
			</table> 
			
		</cf_layoutarea>	
	
	   <cf_tl id="Detail" var="1">
		
	   <cf_layoutarea
	          position="bottom"
	          name="controldetail"         
	          size="200"
			  title="#lt_text#"
			  maxsize="300"			 
	          source="ClaimDetail.cfm?id2=#url.mission#"
	          overflow="auto"
	          collapsible="true"
	          initcollapsed="true"	          
	          splitter="true"/> 
	
</cf_layout>
