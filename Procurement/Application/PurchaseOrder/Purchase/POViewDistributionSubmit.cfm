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
<cfparam name="Form.ListingOrder"   default="1">
<cfparam name="Form.Description"    default="">
<cfparam name="Form.Amount"         default="">

<cfif not LSIsNumeric(Form.amount)>
   <script>
    alert("Invalid amount")
   </script>
</cfif>

<cfset amt      = replace("#form.Amount#",",","","ALL")>

<cfif URL.ID2 neq "">

	 <cfquery name="Update" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE PurchaseExecution
		  SET    ListingOrder        = '#Form.ListingOrder#', 
 		         Description         = '#Form.Description#',
				 Amount              = '#amt#'
		 WHERE ExecutionId = '#URL.id2#'
	</cfquery>
		
	<cfset url.id2 = "0">
				
<cfelse>
			
	<cfquery name="Insert" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO PurchaseExecution
	         (PurchaseNo,
			 Description,
			 ListingOrder,
			 Amount,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES ('#URL.ID1#',
		      '#Form.Description#',
			  '#Form.ListingOrder#',
			  '#amt#',
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#') 
	</cfquery>
					
	<cfset url.id2 = "">
	
		   	
</cfif>

<cfoutput>
  <script>
    ColdFusion.navigate('POViewDistribution.cfm?id1=#URL.id1#&ID2=#url.id2#','boxdistribution')	
  </script>	
</cfoutput>
