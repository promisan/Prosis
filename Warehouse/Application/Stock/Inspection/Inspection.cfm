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
<table width="100%"
       height="100%"
       border="0"
	   align="center"
       cellspacing="0"	   
	   cellpadding="0"> 
	   
 <tr>
 <td height="100%" valign="top"> 
   	
 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">  
   
  <table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" align="center" class="formpadding">		
     
  <!---
  	  	    
  <tr><td height="5px"></td></tr>
  <tr><td align="center" valign="top" height="57px">
  		<table height="57px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
				<tr>
					<td style="z-index:5; position:absolute; top:15px; left:37px; ">
						<cfoutput><img src="#SESSION.root#/images/logos/warehouse/inspection.png" height="42" ></cfoutput>
					</td>
				</tr>							
				<tr>
					<td style="z-index:3; position:absolute; top:17px; left:90px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:4px; left:90px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>							
				<tr>
					<td style="position:absolute; top:45px; left:90px; color:45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
						
					</td>
				</tr>							
			</table>	   
  </td>
  </tr>
  <tr><td height="1px" class="linedotted"></td></tr>
  
  --->
  
  <tr valign="top"><td id="contentListing">
  
	<cfinclude template="InspectionListing.cfm">
  
  </td></tr>
    
  <!--- the table is WarehouseLocationInspection 
    
	  allow to create a record for the selected warehouse,
	  keep location is NULL
	  select the entityclass -> drives the workflow
	  the date of the inspection
	  and a reference
	  
	  then submit which triggers the workflow
	  
	  under InspectionWorkflow
	  
	  this view lists the inspections and shows the workflows under it with a twistie
  
  --->
  
  
  </table>
    
  </td>
  </tr>
  
</table>  