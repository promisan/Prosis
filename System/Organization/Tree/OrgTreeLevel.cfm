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

<link href=css/OrgTree.css rel="stylesheet" type="text/css" media="all" />

<cfparam name="URL.UnitType"       default="">
<cfparam name="URL.Parent"         default="0">
<cfparam name="URL.Nme"            default="">
<cfparam name="URL.Direction"      default="horizontal">
<cfparam name="URL.PostClass"      default="">
<cfparam name="URL.Fund"           default="">
<cfparam name="URL.ShowColumns"    default="">
<cfparam name="URL.SelectionDate"  default="">
<cfparam name="URL.Layout"         default="hide">
<cfparam name="URL.Summary"        default="0">
<cfparam name="URL.Tree"           default="Operational">

<cfparam name="attributes.level"   default="1"> 
<cfparam name="attributes.panel"   default="Center"> 
<cfparam name="attributes.mode"    default="View"> 
<cfparam name="attributes.hierarchycode"         default="">



<!--- if you show the first level --->

<cfif attributes.level eq "1">    

	
	<cfquery name="top" 
		 datasource="AppsQuery"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
	 	 FROM  #SESSION.acc#_MissionOrganization
		 WHERE OrgUnitCode = '#url.parent#' 
	 </cfquery>	 
	 
	 <!--- selected unit is the mission, instead try to select the root unit --->
	 	 
	 <cfif top.recordcount eq "0">
	 
		 <cfquery name="top" 
			 datasource="AppsQuery"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
		 	 FROM  #SESSION.acc#_MissionOrganization
			 WHERE TreeUnit = 1 
		 </cfquery>	 
		 	 
		 <cfset url.nme = "#url.nme#<br>#top.orgunitname#">
	 	 
	 </cfif>
	
	<!--- manually set the current unit --->	
	<cfset attributes.unit = top.orgunit>
	<cfset url.orgunit = top.orgunit>
							 	 
	<cfquery name="support" 
	 datasource="AppsQuery"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  *, 0 as Operational
		 FROM    #SESSION.acc#_MissionOrganization
		 WHERE   ParentOrgUnit = '#URL.Parent#' 
		  AND    OrgUnitCode NOT IN (SELECT  OrgUnitCode
									 FROM    #SESSION.acc#_MissionOrganization
									 WHERE   ParentOrgUnit = '#URL.Parent#' 
									 AND     OrgUnitCode IN (SELECT ParentOrgUnit 
										                     FROM #SESSION.acc#_MissionOrganization)) 
		 ORDER BY Operational, TreeOrder
	</cfquery>	
		
	<cfif attributes.panel neq "left" and url.layout neq "hide">
	
		<!--- ---------------------------------------- --->
		<!--- create temp table for better performance --->
		<!--- ---------------------------------------- --->			

		<cfset AjaxOnLoad("doZoom")>
		
		<cf_OrgTreeAssignmentData	   
		   presentation  = "detail"
		   mode          = "table"
		   tree          = "#url.tree#"
		   selectiondate = "#url.selectiondate#"	  
		   postclass     = "#url.postclass#"
		   fund          = "#url.fund#">   		
    			   
	</cfif>	  
				
</cfif>		

 <cfset vl = "1">
<cf_assignId>



<cfoutput>

<cfparam name="attributes.access"        default="NONE"> 
<cfparam name="attributes.width"         default="231"> 
<cfparam name="attributes.supcnt"        default="0"> 
<cfparam name="attributes.maxlevel"      default="99"> 
<cfparam name="attributes.nme"           default="#url.nme#">
<cfparam name="Attributes.row"           default="1">
<cfparam name="Attributes.Total"         default="1">
<cfparam name="Attributes.Node"          default="1">
<cfparam name="Attributes.Parent"        default="#url.parent#">
<cfparam name="Attributes.Direction"     default="#URL.direction#">

<cfparam name="attributes.PostClass"     default="#URL.PostClass#"> 
<cfparam name="attributes.Fund"          default="#URL.Fund#"> 
<cfparam name="attributes.Layout"        default="#URL.Layout#"> 
<cfparam name="attributes.SelectionDate" default="#URL.SelectionDate#"> 
<cfparam name="attributes.Tree"          default="#URL.Tree#"> 
<cfparam name="attributes.Summary"       default="#URL.Summary#"> 

<cfset width = attributes.width - attributes.level*7>

<cfif attributes.selectiondate neq "">
	<cfset url.selectiondate = attributes.selectiondate>
</cfif>


<!--- extract the level under this --->
<cfinclude template="OrgTreeLevelData.cfm">


<!--- determine the number of TD for the complete screen --->
<cfset child = evaluate("qry_#qry#.recordcount")>

<cfif Attributes.Direction eq "Horizontal">

	 <td valign="top" align="center" class="labellarge">
	 	 
	  <cfsavecontent variable="labelme">
	  	  
	  <table align="center">
	  <tr>
	    	  
	  <cfif attributes.parent neq "">
	  	  
		   <cfquery name="ParentNode" 
			 datasource="AppsQuery"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   *
		 	 FROM     #SESSION.acc#_MissionOrganization
			 WHERE    OrgUnitCode = (SELECT ParentOrgUnit 
			                         FROM #SESSION.acc#_MissionOrganization 
									 WHERE OrgUnitCode = '#attributes.parent#')	
			</cfquery>	
		
		  <td style="padding-left:4px;width:20px">		 
		  
			  <img src="#SESSION.root#/images/arrow_up1.gif" 
			     alt="Move to higher level"
			     border="0" style="cursor:pointer" 
		    	 onclick="tree('#ParentNode.OrgUnitCode#','#ParentNode.OrgUnitName#')">
			 
		   </td>
		
		</cfif>
		
		<td style="padding-left:4px" align="center">	 	  	
		   <span style="font-size:16px;" class="clsNoPrint">#url.selectiondate#</span>
		</td> 
			 
	 </tr>
	 </table>
	 
	 </cfsavecontent>
	 	 
	 <div id="#attributes.unit#">
	 	 
	 <table style="width:95%" bgcolor="white">
	 	 
	 	 <cfset mis = evaluate("qry_#qry#.mission")>
		 
		 <cfinvoke component="Service.Access"  
	 	  method="org" 		  
		  mission="#mis#"
		  returnvariable="attributes.access">  
		  
		<!--- this portion show the top of the tree --->   
	
	    <cfif Attributes.nme neq "">
			
			<cfif evaluate("qry_#qry#.recordcount") eq "99999" and attributes.level eq "2">
			
			<!--- nada --->
			
		    <cfelse>
		
		     <tr>
				 <td colspan="#(child+1)*2#" align="center" style="padding:0px" valign="top">
				 <table width="100%" cellspacing="0" cellpadding="0">				   
				 	<tr>
					<cfset cl = "#6-attributes.level#">					
					<cfinclude template="OrgTreeLevelNode.cfm">
					</tr>					
				 </table>
				 </td>
			 </tr>
			 
			 <tr><td colspan="#(child+1)*2#" align="center"></td></tr>
			 <tr><td colspan="#(child+1)*2#" align="left" height="1"></td></tr>
			 <tr>
		
		    </cfif>
		 
		 </cfif>			 
		 
		 <!--- this portion shows the first level under the top --->		 
		 
		 <cfif attributes.level lte "#attributes.maxlevel#">
		 		 
			 <cfloop query="qry_#qry#">	
			    
				 <cfset lvl = Attributes.Level+1>
				 
				 <cfif lvl lte "5">
				 				     
				     <cfif lvl lte vl>
					    <cfset dir = "Horizontal"> 
					 <cfelse>
					    <cfset dir = "Vertical"> 
					 </cfif>			
					 					 
					 <cf_OrgTreeLevel 
					      nme       = "#orgunitname#"  
					      unit      = "#orgunit#" 
						  mode      = "#attributes.mode#"
						  maxlevel  = "#attributes.maxlevel#"
						  parent    = "#orgunitcode#" 
						  hierarchycode = "#hierarchycode#"
						  support   = "#support.recordcount#"
						  level     = "#lvl#" 
						  panel     = "#attributes.panel#"
						  width     = "#attributes.width#"						 
						  row       = "#currentRow#"
						  total     = "#recordcount#"	
						  access    = "#attributes.access#"					  
						  direction = "#dir#"
		  				  PostClass = "#attributes.PostClass#"
		 				  Fund 	    = "#attributes.Fund#"
						  SelectionDate  = "#attributes.SelectionDate#"
						  Tree		= "#attributes.Tree#"
						  Summary   = "#attributes.Summary#">
				 				 
				 </cfif>
			 </cfloop>
			 
		</cfif>	 
		 
		 </tr>
	 </table>
	 </div>
	 </td>
	 
<cfelse>

    	 	 			 
     <cfif attributes.level eq "2" and attributes.row eq "1">
							 	 
			<cfquery name="support" 
			 datasource="AppsQuery"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT  *, 0 as Operational 
			 FROM    #SESSION.acc#_MissionOrganization
			 WHERE   ParentOrgUnit = '#URL.Parent#' 
			  AND    ParentSupport = 1
			  <!---
			  AND    OrgUnitCode NOT IN (SELECT  OrgUnitCode
										 FROM    #SESSION.acc#_MissionOrganization
										 WHERE   ParentOrgUnit = '#URL.Parent#' 
										 AND     OrgUnitCode IN (SELECT ParentOrgUnit 
											                     FROM #SESSION.acc#_MissionOrganization)) --->
			 ORDER BY Operational, TreeOrder 
			</cfquery>	
									
			<cfif support.recordcount gte "1">
			
			<td valign="top">
				<cfinclude template="OrgTreeSupport.cfm">				
			</td>	 
			
			</cfif>
			 
	 </cfif> 
	 
     <cfset cl = "#6-attributes.level#">
	
	 <cfif attributes.Row eq attributes.total or (attributes.level eq "2" and attributes.panel is "Center")>
		<cfset h = "1">
	 <cfelse>
		<cfset h = "100%">
	 </cfif>
	 
	 <cfif attributes.level eq "2">
		 <cfset sz = "1">
	 <cfelse>
		 <cfset sz = "0">
	 </cfif>
	
	 <!--- show the space to the node --->		
	 
	 <td width="13" height="#h#" valign="top" style="padding:5px">
	 	 	 	   
	    <table height="#h#" cellspacing="0" cellpadding="0">
			<tr>
						
			<td height="#h#" style="padding-left:9px;border-right: #sz#px solid ##9a9c9c;"></td>
					
			<td valign="top">
			    <table>
					<tr><td height="14"></td></tr>
					<cfif attributes.level neq "1">
					<tr><td style="border-top: #sz#px solid silver;"><cf_space spaces="7"></td></tr>
					</cfif>
				</table>
			</td>
				
			</tr>	
		</table>
			
	 </td> 	
	 
	 <!--- show the content --->	
		 
     <td valign="top">
	 	 	
	 <div id="#attributes.unit#">	
	 
		 <table bgcolor="white" width="100%">
		 	     
		     <tr>
			 	<td colspan="4" align="left" valign="top" style="padding-top:0px;padding-left:2px;padding-right:7px">
				
				 <table width="#WIDTH#">	
										 			    
				 	<tr><cfinclude template="OrgTreeLevelNode.cfm"></tr>
													
					<cfif attributes.level lte "#attributes.maxlevel#">
					
						<cfif attributes.level lte "5"> <!--- limit to 6 levels --->
						
						     <cfinclude template="OrgTreeLevelData.cfm">
					
							 <!--- lookp within itself --->
							
							 <cfloop query="qry_#qry#">	
							     
									 <tr>
									 
									     <cfset lvl = Attributes.Level+1>
										 
									     <cfif lvl lte "6">
										 
										     <cf_OrgTreeLevel 
											 		nme            = "#orgunitname#" 
											        unit           = "#orgunit#" 
											        parent         = "#orgunitcode#" 
													hierarchycode  = "#hierarchycode#"
													mode           = "#attributes.mode#"
													row            = "#currentRow#"
													level          = "#lvl#" 
													panel          = "#attributes.panel#"
													width          = "#attributes.width#"
													maxlevel       = "#attributes.maxlevel#"
													total          = "#recordcount#"												
													access         = "#attributes.access#"
													direction      = "vertical"
													tree           = "#attributes.tree#"
						 		  				    PostClass      = "#attributes.PostClass#"
			 				                        Fund 	       = "#attributes.Fund#"
													SelectionDate  = "#attributes.SelectionDate#"
							  						Summary        = "#attributes.Summary#">
															  
									     </cfif>
							 		 </tr>							 
								
							</cfloop>
							
						</cfif>
					
					</cfif>
					
				</table>
				</td>
			 </tr>
		 </table>
	 </div>
	 </td>
 		 
</cfif>

</cfoutput>

<script>
	Prosis.busy('no')
</script>



