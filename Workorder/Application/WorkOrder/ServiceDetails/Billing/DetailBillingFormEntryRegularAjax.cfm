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
<cfparam name="url.servicedomain"  		default="">
<cfparam name="url.servicedomainclass" 	default="">

<cfsavecontent variable="myfeature">
	<cfset embed = "1">
    <cfinclude template="DetailBillingFormEntryRegular.cfm">	
</cfsavecontent>

<cfif unitdetail.recordcount gt "0">

    <!---
	<table width="100%">		
		<tr><td id="box_<cfoutput>#unitclass#</cfoutput>" style="padding-top:2px;padding-left:30px">									
				<table align="right">							   					   					  			   					   
					   <cfoutput>#myfeature#</cfoutput>						  
				</table>			
			</td>
		</tr>				
	</table>
	
	--->
		
	<table width="100%" style="background-color:fafafa" class="formspacing" id="box_<cfoutput>#unitclass#</cfoutput>">			  	
		<cfoutput>#myfeature#</cfoutput>						  					
		
	</table>
</cfif>
