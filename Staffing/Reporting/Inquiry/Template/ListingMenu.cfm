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

<!--- ensure that nexttime screen is loaded in this mode --->
<cfset client.ProgramDetail = "listing">
<cfparam name="url.print" default="0">
<cfset id = "">

<!--- does not have to be changed usually --->
<cfparam name="url.Nationality" default="">
<cfparam name="url.OrgUnitOperational" default="">
<cfparam name="url.OfficerUserId" default="">
<cfparam name="url.Print" default="0">

<cfoutput>

<cfif url.mode eq "drillbox" and url.print eq "0">

		<table width="98%" class="formpadding" align="center">
		<tr><td align="center" colspan="2"><input type="button" value="Close" name="Close" onClick="ColdFusion.Window.hide('drillbox')" class="button10g"></td></tr>
		 <tr>
		  <td width="80" class="labellarge" style="font-size:20px">#URL.Select#</td>	
		   <td align="right" width="40%">
		   
		   	<table align="right"><tr><td>	

				<cf_tl id="Print" var="1">
				<cf_button2 
					mode="icon" 
					image="print_gray.png" 
					onclick="printdetail('#url.item#','#URL.Select#','#url.mode#')" 
					text="#lt_text#" 
					title="#lt_text#" 
					onmouseover="this.style.backgroundColor='E0E0E0';"
					onmouseout="this.style.backgroundColor='';">
											
			</td></tr></table>	
	
			</td>
		</table>
		
<cfelse>

	<cfif url.print eq "0">
		
		<table width="99%" class="formpadding" align="center">
		  <tr>
		  <td height="35" class="labellarge" style="font-size:20px">#URL.Select#</td>	
		  
		  <cftry>
		  
			  <td class="labelit">Unit</td>
			  <td>
			  
			  <cfquery name="Unit"
			   dbtype="query">
				SELECT  DISTINCT HierarchyCode, 
				            OrgUnitOperational, 
							OrgUnitName
				FROM    Base
				GROUP BY HierarchyCode, OrgUnitOperational, OrgUnitName
				ORDER BY HierarchyCode</cfquery> 
	
			  <input type="hidden" id="citem1"  name="citem1" value="OrgUnitOperational">
			  <select name="cselect1" id="cselect1" class="regularxl" onChange="reloadlisting()">
						<option style="width: 250px;" value="" SELECTED>--select--</option>
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
		  <td class="labelit">Nationality</td>
		  <td>
		  <input type="hidden" id="citem2"  name="citem2" value="Nationality">
		  <select name="cselect2" id="cselect2" class="regularxl" onchange="reloadlisting()">
			<option value="" SELECTED>--select--</option>
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
		  
			<table align="right">
			<tr>
			
			<!---
			<td>

			<cf_tl id="Crosstab" var="1">
			<cf_button2 
				mode="icon" 
				image="Crosstab.png" 
				onclick="pivot('sub')" 
				text="#lt_text#" 
				title="#lt_text#" 
				onmouseover="this.style.backgroundColor='E0E0E0';"
				onmouseout="this.style.backgroundColor='';">

			</td>
			<td style="padding-left:5px; padding-right:5px">|</td>
			--->
			<td>

			<cf_tl id="Summary" var="1">
			<cf_button2 
				mode="icon" 
				image="Summary.png" 
				onclick="inspect('sub')" 
				text="#lt_text#" 
				title="#lt_text#" 
				onmouseover="this.style.backgroundColor='E0E0E0';"
				onmouseout="this.style.backgroundColor='';">

			</td>
			<td style="padding-left:5px; padding-right:5px">|</td>
			<td>

			<cf_tl id="Excel" var="1">
			<cf_button2 
				mode="icon" 
				image="excel.png" 
				onclick="document.getElementsByName('Excel')[0].click()" 
				text="#lt_text#" 
				title="#lt_text#" 
				width="75px"
				onmouseover="this.style.backgroundColor='E0E0E0';"
				onmouseout="this.style.backgroundColor='';">

			</td>
			<td style="padding-left:5px; padding-right:5px">|</td>
			<td>

			<cf_tl id="Print" var="1">
			<cf_button2 
				mode="icon" 
				image="print_gray.png" 
				onclick="printdetail('#url.item#','#URL.Select#','#url.mode#')" 
				text="#lt_text#" 
				title="#lt_text#" 
				onmouseover="this.style.backgroundColor='E0E0E0';"
				onmouseout="this.style.backgroundColor='';">
			   
			  			   
			 </td>
			 
			 <td class="hide">  		
			
					<cfinvoke component="Service.Analysis.CrossTab"  
						  method="ShowInquiry"
						  buttonName     = "Excel"
						  buttonClass    = "button3"
						  buttonIcon     = "#SESSION.root#/Images/sqltable.gif"
						  reportPath     = "Staffing\Reporting\Inquiry\Template\"
						  SQLtemplate    = "StaffingExcel.cfm"							 
						  dataSource     = "appsQuery" 
						  module         = "Program"
						  reportName     = "Drilldown Indicator Staffing"
						  table1Name     = "Export file"
						  fileno         = "#url.fileNo#"
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
		<tr><td align="center"><cfinclude template="../Vacancy/GraphData.cfm"></td></tr>		
		<tr><td>&nbsp;Filter : <b>#URL.Select#</b></td></tr>	
		<script> print() </script>		
		</table>
	
	</cfif>
	
</cfif>

</cfoutput>

