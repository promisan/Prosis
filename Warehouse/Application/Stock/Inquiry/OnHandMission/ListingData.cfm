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
<cfparam name="url.systemfunctionid" default="">

<cf_tl id="Stock Inquiry" var="1">

<cf_screenTop border="0" 
		  height="100%" 
		  label="#lt_text# #URL.Mission#" 
		  html="yes"
		  layout="webapp"	
		  banner="blue"	 
		  bannerforce="Yes"
		  jQuery="Yes"
		  validateSession="Yes"
		  busy="busy10.gif"
		  MenuAccess="No"
		  bannerheight="50"		
		  line="no"   
		  band="No" 
		  scroll="yes">

<cfinvoke component = "Service.Access"  
	      method             = "function"  
		  role               = "'WhsPick'"
		  mission            = "#url.mission#"		  
		  SystemFunctionId   = "#url.idmenu#" 
		  returnvariable     = "access">	 		  
	
 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.idmenu#"
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

<cf_listingscript>	

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_#url.mission#_ItemStock"> 

<!--- disalbed the table round for better performance in cf7/8 --->
	  
<table width="100%" height="100%" align="center">

<tr>
	
	<td colspan="1" height="100%" valign="top" style="padding:4px">	
		<cf_securediv id="divListingContainer" style="height:100%;" 
		bind="url:../OnHandMission/ListingDataGet.cfm?mission=#url.mission#&SystemFunctionId=#url.idmenu#">        	
	</td>	

</tr>	

</table>

