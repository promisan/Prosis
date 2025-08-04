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
<!--- Create Criteria string for query from data entered thru search form --->

<cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">
				
		<tr>
		 <td colspan="9">
			 <table width="100%"  border="0">
			 <tr>
			 <td width="200" height="25" class="labelit">
							  
			 <cfset link = "BuyerListingSubmit.cfm?jobno=#url.id1#">
				
				<cf_tl id="Press HERE to insert another buyer" var="1">
										
				<cf_selectlookup
			    box          = "buyerbox"
				title        = "#lt_text#"
				link         = "#link#"
				button       = "No"
				close        = "No"
				class        = "user"
				des1         = "acc">	
					
			</td>
			</tr>
			</table>		   
			</td>
		</tr>
		
		
	<tr><td>	
	
	<cfdiv bind="url:#link#" id="buyerbox"/>
	
	</td>
	
	</tr>
	
		
</table>

</cfoutput>

