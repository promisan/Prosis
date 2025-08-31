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
<cfset client.ProgramDetail = "listing">
<cfparam name="url.print" default="0">
<cfset id = "">

<cfoutput>

<cfif url.mode eq "drillbox" and url.print eq "0">

		<table width="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr><td align="center" colspan="2"><input type="button" value="Close" name="Close" onClick="ColdFusion.Window.hide('drillbox')" class="button10g"></td></tr>
		 <tr>
		  <td width="80"><b>#URL.Select#</b></td>	
		   <td align="right" width="40%">
		   
		   	<table align="right"><tr><td>
				 <cfmenu 
				    name="drillmenu"
				    font="verdana"
				    fontsize="14"
				    bgcolor="ffffff"
				    selecteditemcolor="C0C0C0"
				    selectedfontcolor="FFFFFF">
				   
				<cfmenuitem 
				   display="Print"
				   name="drillprint"
				   href="javascript:printdetail('#url.item#','#URL.Select#','#url.mode#')"
				   image="#SESSION.root#/Images/print.gif"/> 				
				
				</cfmenu>	
			
			</td></tr></table>	
	
			</td>
		</table>
		
<cfelse>

	<cfif url.print eq "0">
		
		<table width="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		  <tr>
		  <td width="80"><b>#URL.Select#</b></td>	
		  
		  <cftry>
		  
			  <td>Unit</td>
			  <td>
			  
			  <cfquery name="Unit"
			   dbtype="query">
				SELECT  DISTINCT HierarchyCode, 
				            OrgUnitOperational, 
							OrgUnitName
				FROM    Base
				GROUP BY HierarchyCode, OrgUnitOperational, OrgUnitName
				ORDER BY HierarchyCode</cfquery> 
	
			  <input type="hidden" name="citem1" value="OrgUnitOperational">
			  <select name="cselect1" style="width: 250px;" onChange="reloadlisting()">
						<option style="width: 250px;" value="" SELECTED></option>
						<cfloop query="Unit">
						<cfset l = len(hierarchycode)>
						#OrgUnitOperational#
						<option value="#OrgUnitOperational#" <cfif url.orgunitoperational eq orgunitoperational>selected</cfif>><cfloop index="itm" from="1" to="#l-4#">&nbsp;&nbsp;</cfloop>#OrgUnitName#</option>
						</cfloop>				
			  </select>
			  
			  </td>
			  
			    <cfcatch></cfcatch>
		  </cftry>
			  
			  
		  <cftry>
			  	  
		  
		  <cfquery name="Nat" dbtype="query">
				SELECT  DISTINCT Nationality
				FROM    Base
				WHERE Nationality > ''
				ORDER BY Nationality		
		  </cfquery> 
		  <td>Nationality</td>
		  <td>
		  <input type="hidden" name="citem2" value="Nationality">
		  <select name="cselect2" onchange="reloadlisting()">
			<option value="" SELECTED></option>
				<cfloop query="Nat">
				<option value="#Nationality#" <cfif url.nationality eq nationality>selected</cfif>>#Nationality#</option>
				</cfloop>				
		  </select>
		  </td>
		  
		   <cfcatch>
		   
		   <!---
		  		  			  
		  <td>Contact</td>
		  <td>
	  
			  <input type="hidden" name="citem2" value="OfficerUserId">
			  <select name="cselect2" onchange="reloadlisting()">
				<option value="" SELECTED></option>
				<cfloop query="Contact">
				OfficerLastName,OfficerFirstName
				<option value="#OfficerUserId#" <cfif url.OfficerUserId eq OfficerUserId>selected</cfif>>#OfficerFirstName# #OfficerLastName#</option>
				</cfloop>				
			  </select>
			  
			  --->
		  		   
		   </cfcatch>
		  </cftry>
		  		  
		  <td align="right" width="40%">

			<table align="right"><tr><td>
	  
			 <cfmenu 
			    name="notemenu"
			    font="verdana"
			    fontsize="14"
			    bgcolor="transparent"
			    selecteditemcolor="C0C0C0"
			    selectedfontcolor="FFFFFF">
				
			<cfmenuitem 
			   display="Crosstab"
			   name="pivot"
			   href="javascript:pivot('sub')"
			   image="#SESSION.root#/Images/crosstab3.gif"/>	
				
			<cfmenuitem 
			   display="Summary"
			   name="summarysub"
			   href="javascript:inspect('sub')"
			   image="#SESSION.root#/Images/overview1.gif"/>
			   
			<cfmenuitem 
			   display="Print"
			   name="print"
			   href="javascript:printdetail('#url.item#','#URL.Select#','#url.mode#')"
			   image="#SESSION.root#/Images/print.gif"/> 	
			   
			 <cfmenuitem 
			   display="Excel"
			   name="excellist"
			   href="javascript:Excel.click()"
			   image="#SESSION.root#/Images/excel.gif"/>   
			   
			   </cfmenu>		
			   
			 </td>
			 
			 <td class="hide">  		
			
					<cfinvoke component="Service.Analysis.CrossTab"  
						  method="ShowInquiry"
						  buttonName     = "Excel"
						  buttonClass    = "button3"
						  buttonIcon     = "#SESSION.root#/Images/sqltable.gif"
						  reportPath     = "ProgramREM\Inquiry\Indicator\Template\"
						  SQLtemplate    = "StaffingExcel.cfm"							 
						  dataSource     = "appsQuery" 
						  module         = "Program"
						  reportName     = "Drilldown Indicator Staffing"
						  table1Name     = "Export file"
						  data           = "1"							  
						  ajax           = "1"
						  olap           = "0" 
						  excel          = "1"> 
						  
						  Excel							  
			
			</td></tr></table>
	
	    </td>
		</tr>
	   </table>
		
	<cfelse>
	
		<title>Print Selection</title>
		<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
		<link href="<cfoutput>#SESSION.root#/print.css</cfoutput>" rel="stylesheet" type="text/css" media="print">
	
		<table width="100%" cellspacing="0" cellpadding="0" bgcolor="FFFFFF">
	
		<tr>
		   <td><cfinclude template="../../../Application/Indicator/Details/DetailViewBaseTop.cfm"></td>
		</tr>
		<!---
		<tr><td align="center"><cfinclude template="GraphData.cfm"></td></tr>
		--->
		<tr><td>&nbsp;Filter : <b>#URL.Select#</b></td></tr>
	
		<script> print() </script>
		
		</table>
	
	</cfif>
	
</cfif>

</cfoutput>

