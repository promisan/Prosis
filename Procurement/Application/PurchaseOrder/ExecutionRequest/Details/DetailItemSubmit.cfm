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
<cfoutput>
	
	<cfparam name="Form.svcquantity" default="1">
		
	<cfset qty      = replace("#Form.svcquantity#",",","","ALL")>	
	<cfset amt      = replace("#Form.svcrate#",",","","ALL")>
	<cfset amt      = replace(amt," ","","ALL")>
	<cfset des      = "#Form.svcdescription#">
	<cfset ref      = "#Form.svcreference#">
		
	<cfif not LSIsNumeric(qty)>
	
		<script>
		    alert('Incorrect quantity')
			ColdFusion.navigate('Details/DetailItem.cfm?ID2=new','iservice')		
		</script>	 
		
		<cfabort>
	
	</cfif>
		
	<cfif not LSIsNumeric(amt)>
	
		<script>
		    alert('Incorrect rate')
			ColdFusion.navigate('Details/DetailItem.cfm?ID2=new','iservice')			
		</script>	 
		
		<cfabort>
	
	</cfif>
	
	<cfif amt*qty neq "0">
	
		<cfif URL.ID2 neq "new">
		
			 <cfquery name="Update" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				   UPDATE UserQuery.dbo.#SESSION.acc#ExecutionRequest_#client.sessionNo#
				   SET    DetailDescription = '#des#',
				          DetailQuantity    = '#qty#',
				          DetailRate        = '#amt#',
						  DetailAmount      = '#amt#',
						  <!---
						  DetailAmount      = '#amt*qty#',
						  --->
					      DetailReference   = '#ref#'		   
				   WHERE  SerialNo          = '#URL.ID2#'		
		   	</cfquery>
					
		<cfelse>
				
				<cfquery name="Insert" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO UserQuery.dbo.#SESSION.acc#ExecutionRequest_#client.sessionNo#
					 (DetailDescription,DetailReference,DetailQuantity,DetailRate,DetailAmount)			    
				      VALUES ('#des#',
					          '#ref#',
							  '#qty#',
							  '#amt#',
							  '#amt#' <!--- '#amt*qty#' --->
							  )
				</cfquery>		
						
		</cfif>
			
	</cfif>
		
		<cfquery name="Total" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT   SUM(DetailAmount) AS Total
				 FROM     UserQuery.dbo.#SESSION.acc#ExecutionRequest_#client.sessionNo#			 	 
		</cfquery>
				
	<script>
	    			
		document.getElementById("RequestAmount").value  = "#numberformat(Total.Total,'__,__.__')#"	
		ColdFusion.navigate('Details/DetailItem.cfm?ID2=new','iservice')
		
	</script>		

</cfoutput>
 	

  
