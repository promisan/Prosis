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
<cfparam name="url.addressid" default="">

<cfif url.addressid eq "">
		  
	<cfswitch expression="#url.context#">
		
		<cfcase value="TaxCode">
		
		   <cfquery name="TaxCode" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * FROM CountryTaxCode
					WHERE  TaxCode = '#url.contextid#'	
			</cfquery>	
		
		</cfcase>
	
	</cfswitch>	
	
	<cfset addressid = TaxCode.addressid>	  
	
	
<cfelse>

   <cfset addressid = url.addressid>

</cfif>


<cfset url.mode = "edit"> 

<cfoutput>

<cfform name="theaddress" onsubmit="return false">

<table align="center" class="formpadding">
	
	<tr><td colspan="2" id="addressprocess"></td></tr>
	
	<tr><td colspan="2">
			
		    <!--- a NEW ddress object --->	
			<cf_address mode="#url.mode#" styleclass="labelmedium" addressid="#addressid#" addressscope="Tax" mission="#url.mission#" emailrequired="No">
						
		</td>
	</tr>
		
	<tr><td colspan="2" align="center">
	
	<input type="hidden" name="Addressid" value="#addressid#">
	
	<table>
	<tr>
	<td><input type="button" class="button10g" name="Close" value="Close" onclick="ProsisUI.closeWindow('address')"></td>
	<td><input type="button" class="button10g" name="Save" value="Save" onclick="saveaddress('#addressid#','#url.context#','#url.contextid#')"></td>
	</tr>
	</table>
	</td></tr>
	
</table>	

</cfform>

</cfoutput>