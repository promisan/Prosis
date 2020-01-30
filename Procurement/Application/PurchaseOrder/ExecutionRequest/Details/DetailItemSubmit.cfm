
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
 	

  
