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

<!--- check for access --->

<cfparam name="url.mission"          default="">
<cfparam name="url.warehouse"        default="">
<cfparam name="url.location"         default="">
<cfparam name="url.systemfunctionid" default="">

<cfinvoke component = "Service.Access"  
	  method           = "function"  
	  role             = "'WhsPick'"
	  mission          = "#url.mission#"
	  warehouse        = "#url.warehouse#"
	  SystemFunctionId = "#url.SystemFunctionId#" 
	  returnvariable   = "access">	 	

<cfif access eq "DENIED">	 

	<table width="100%" height="100%" border="0"  cellspacing="0" cellpadding="0"  align="center">
	   <tr><td align="center" height="40">
	    <font face="Verdana" color="FF0000">
			<cf_tl id="Detected a Problem with your access"  class="Message">
		</font>
	      </td>
	   </tr>
	</table>	
	
	<cfabort>	
		
</cfif>		
  
<table width="100%" height="100%">

    <!---
	
	<cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.SystemFunctionId#"
		Key2Value       = "#url.mission#"				
		Label           = "Yes">
		
	<tr>
	  <td colspan="2" align="left" valign="bottom" height="60px">	 
	  
	    <cfoutput>
	  	<table height="60px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden">												
			<tr>
				<td style="z-index:5; position:absolute; top:6px; left:17px; ">
					<img src="#SESSION.root#/images/logos/warehouse/Sale.png">
				</td>
			</tr>							
			<tr>
				<td style="z-index:3; position:absolute; top:17px; left:90px; color:##45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
					#lt_content#
				</td>
			</tr>
			<tr>
				<td style="position:absolute; top:04px; left:90px; color:##e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
					#lt_content#
				</td>
			</tr>		
			
			<cf_LanguageInput
			TableCode       = "Ref_ModuleControl" 
			Mode            = "get"
			Name            = "FunctionMemo"
			Key1Value       = "#url.SystemFunctionId#"
			Key2Value       = "#url.mission#"				
			Label           = "Yes">
							
			<tr>
				<td style="position:absolute; top:45px; left:93px; color:##45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
					#lt_content#
				</td>
			</tr>							
		</table>
		</cfoutput>
	  
	  </td>
	</tr>		
	
	--->
		
	<tr><td width="100%"><cfinclude template="SaleListingContent.cfm"></td></tr>				
		
	
</table>

