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
<cfset session.status = 0>
<cf_tl id="Calculating standard reevaluation" var="1">
<cfset session.StatusStr = lt_text>

<cftransaction>
	
	<cfif url.revaluation eq "false">
		
		<cfinvoke component = "Service.Process.Materials.Stock"  
		   method           = "RedoIssuanceTransaction" 
		   Mode             = "Standard" <!---  and now also handles 0 initial stock values --->
		   filtermission    = "#url.mission#"   
		   filteritemno     = "#url.id#"
		   finalStatus		= "0.3"
		   revaluation      = "0">	 

		<cf_tl id="Calculating forced completed" var="1">
		<cfset session.StatusStr = lt_text> 
			      					
		<cfinvoke component = "Service.Process.Materials.Stock"  
		   method           = "RedoIssuanceTransaction" 
		   Mode             = "Force" <!--- removes small differences --->
		   filtermission    = "#url.mission#"   
		   filteritemno     = "#url.id#"
		   initialStatus  	= "0.6"
		   revaluation      = "0">	
		
			
	<cfelse>
		
		  <cfinvoke component = "Service.Process.Materials.Stock"  
		   method           = "RedoIssuanceTransaction" 
		   Mode             = "Standard"
		   filtermission    = "#url.mission#"   
		   filteritemno     = "#url.id#"
		   revaluation      = "1">	 
	   
	</cfif>		
   
</cftransaction>   

<cfset session.status = 1>
<cf_tl id="Reevaluation completed" var="1">
<cfset session.StatusStr = lt_text> 						

<cfinclude template="ItemStock.cfm">   
   
   	