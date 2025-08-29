<!--
    Copyright © 2025 Promisan B.V.

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
 <cf_LanguageInput
				TableCode       = "Ref_ModuleControl" 
				Mode            = "get"
				Name            = "FunctionName"
				Key1Value       = "#url.SystemFunctionId#"
				Key2Value       = "#url.mission#"				
				Label           = "Yes">

<cf_screentop html="no" jquery="yes" label="#lt_content#">

<cfparam name="URL.mission" default="UN">

<cfquery name="GetMission" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
		 	SELECT *
			FROM   Ref_Mission
			WHERE  Mission = '#URL.Mission#'		 
</cfquery>

<cfinclude template="ClaimScript.cfm">

<cf_layoutscript>

<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	  		
   <cf_layoutarea  position="header" 
	        name="controltop">	
									
			<cfquery name="Mission" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Ref_Mission
						WHERE  Mission = '#url.Mission#'
					</cfquery>
			
			
			
			<cf_ViewTopMenu background="gray"
							label="#lt_content# #Mission.MissionName#">
							
	</cf_layoutarea>						
				

   <cf_layoutarea 
          position="left"
          name="controltree"          
          size="320"
		  minsize="320"
		  maxsize="320"
          overflow="auto"			
          collapsible="true" 
          splitter="true">		  
		  
		  <table width="100%" height="100%">
		  <tr><td valign="top">
		  <cf_divscroll>
		  	<cfinclude template="ClaimTree.cfm">
		  </cf_divscroll>
		  </td></tr></table>		 
		  
	</cf_layoutarea>	  
	
   <cf_layoutarea  
	    position="center" 		
		name="content">			
		<table height="100%" width="100%">
			<tr>
				<td valign="middle" style="padding:10px" id="controllist">
					<cfinclude template="../../../../Tools/Treeview/TreeViewInit.cfm">	
				</td>
			</tr>
		</table> 		
		 
	</cf_layoutarea>	
	
	<!--- disabled 9/7/2016
		
	<cf_layoutarea
          position="bottom"
          name="controldetail"         
          size="200"
		  title="Detail"
		  maxsize="300"			 
          source="ClaimDetail.cfm?id2=#url.mission#"
          overflow="auto"
          collapsible="true"
          initcollapsed="true"         
          splitter="true"/> 	
		  
		  --->

</cf_layout>
