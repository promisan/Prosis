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
<cfparam name="url.mission"   default="">
<cfparam name="url.warehouse" default="">
<cfparam name="URL.ID"        default="Loc">
<cfparam name="URL.ID1"       default="">
<cfparam name="URL.ID2"       default="">

<cfinvoke component     = "Service.Access"  
	     method             = "function"  
		 role               = "'WhsPick'"
		 mission            = "#url.mission#"
		 warehouse          = "#url.warehouse#"
		 SystemFunctionId   = "#url.SystemFunctionId#" 
		 returnvariable     = "access">	 	

<cfif access eq "DENIED">	 

	<table width="100%" height="100%" 
	       border="0" 
		   cellspacing="0" 			  
		   cellpadding="0" 
		   align="center">
		   <tr>
		   <td align="center" height="40">
		   		<font face="Verdana" color="FF0000">
				<cf_tl id="Detected a Problem with your access"  class="Message">
			   </font>
		   </td>
		   </tr>
	</table>	
	<cfabort>	
		
</cfif>		

<cfif URL.ID eq "Loc">
	<cfset down = "hide">
	<cfset up   = "regular">	
<cfelse>
	<cfset down = "regular">
	<cfset up   = "hide">
</cfif>	

<cfoutput>
	
<table width="99%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0">

		 <cf_LanguageInput
			TableCode       = "Ref_ModuleControl" 
			Mode            = "get"
			Name            = "FunctionName"
			Key1Value       = "#url.SystemFunctionId#"
			Key2Value       = "#url.mission#"				
			Label           = "Yes">			
						
		<tr>
		    <td align="left" valign="bottom">	 
				
				<table style="overflow-x:hidden" >												
				<tr>
					
				</tr>							
				<tr>
					<td>
						<img src="#SESSION.root#/images/logos/warehouse/PriceTag.png" height="28">
					</td>
					<td style="padding-left:15px; color:45617d; font-size:25px; font-weight:bold;">
						<cfoutput>#lt_content#</cfoutput>
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
					<td></td>
					<td style="padding-left:15px; color:45617d; font-size:12px; font-weight:bold;">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>							
			   </table>
 				
		  </td>
		  
		  <td align="right" valign="bottom">
		  
			  <table cellspacing="0" cellpadding="0">
			  
				  <tr onclick="maximize('mainlocate')" style="cursor:pointer">
					<td height="21" style="padding-left;4px;padding-right:4px">
					<img src="#SESSION.root#/images/filter.gif" alt="" border="0" align="absmiddle">
					</td>
					<td style="padding-left;4px;padding-right:4px">	</td>
					<td align="right" style="padding-right:3px">
					
						<img src="#SESSION.root#/images/up6.png" 
						    id="mainlocateMin"
						    alt=""
							border="0" style="cursor: pointer;"
							class="#up#">
						<img src="#SESSION.root#/images/down6.png" 
						    alt="" style="cursor:pointer"
							id="mainlocateExp"
							border="0" 
							class="#down#">
							
					</td>
				  </tr>
						  
			  </table>		
			    
		  </td>
	   </tr>	
		
	   <tr><td colspan="2" style="padding-top:4px" class="line"></td></tr>
		
	   <tr id="mainlocate" name="mainlocate" class="#up#">
	      <td colspan="2" height="1"><cfinclude template="ControlListFilter.cfm"></td>
	   </tr>
	  		
	   <tr><td colspan="2" id="mainlisting" valign="top" height="95%"></td></tr>
	
</table>


</cfoutput>