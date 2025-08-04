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
	      method             = "function"  
		  role               = "'WhsPick'"
		  mission            = "#url.mission#"
		  warehouse          = "#url.warehouse#"
		  SystemFunctionId   = "#url.SystemFunctionId#" 
		  returnvariable     = "access">	 		  
	
 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">								  

<cfif access eq "DENIED">	 

	<table width="100%" height="100%" 
	       border="0" 
		   cellspacing="0" 			  
		   cellpadding="0" 
		   align="center">
		   <tr><td align="center" height="40">
		    <font face="Verdana" color="FF0000">
			<cf_tl id="Detected a Problem with your access"  class="Message">
			</font>
			</td></tr>
	</table>	
	<cfabort>	
		
</cfif>		

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_#url.warehouse#_ItemStock"> 
	  
<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">

<!---

<cfif url.location eq "">
		
		<tr>
		  <td colspan="2" align="left" valign="bottom" height="50px">	 
		  
		  
		    <cfoutput>
			
		  	<table height="60px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
				<tr>
					<td style="z-index:5; position:absolute; top:5px; left:17px; ">
					
						<img src="#SESSION.root#/images/logos/warehouse/Stock.png?" height="69">
					</td>
				</tr>							
				<tr>
					<td style="z-index:3; position:absolute; top:7px; left:100px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
						#lt_content#
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:4px; left:100px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
						#lt_content#
					</td>
				</tr>							
				<tr>
					<td style="position:absolute; top:45px; left:120px; color:45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
						#lt_content#
					</td>
				</tr>							
			</table>
			</cfoutput>
    
		  </td>
		</tr>			
		<tr><td height="28"></td></tr>	
		<tr><td height="1" class="linedotted"></td></tr>	
		
</cfif>		


--->

<tr>
	
	<td colspan="1" height="100%" valign="top">
	
		<cfdiv id="divListingContainer" style="height:100%;" bind="url:../Inquiry/OnHandTransaction/ListingDataContainer.cfm?warehouse=#url.warehouse#&location=#url.location#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#">        	
	</td>	

</tr>	
</table>

