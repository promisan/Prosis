
<!--- verify stock --->

<cfquery name="get" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">							
		SELECT     *
		FROM       CustomerRequestLine
		WHERE      TransactionId = '#url.id#'								
</cfquery>

<cfquery name="warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Warehouse
	WHERE  Warehouse = (SELECT Warehouse FROM CustomerRequest WHERE RequestNo = '#get.requestno#')				
</cfquery>

<cfoutput query="get">	

<table>
		<tr>
		
		<!--- we first check if we have stock in total to satify this need in general --->
				
		<cfinvoke component  = "Service.Process.Materials.Stock"  
		   method            = "getStock" 		  
		   mission           = "#warehouse.mission#" 		  
		   ItemNo            = "#itemno#"
		   UoM               = "#TransactionUom#"		
		   returnvariable    = "check">
		   
		   <cfif check.onhand gte transactionquantity>		   
		       <td style="border:1px solid black;width:12px;height:12px;background-color:green"></td>		   
		   <cfelseif check.onhand gt "0">		       		   
  		       <td style="border:1px solid black;width:24px;height:12px;background-color:yellow"></td>			
			<cfelse>	   			
			   <td style="border:1px solid black;width:24px;height:12px;background-color:red"></td>   		   	   
		   </cfif>
		   
		   <!--- then we check if we have stock in this store --->
		   
		   <cfif check.onhand gte transactionquantity>
		   
			   <cfinvoke component  = "Service.Process.Materials.Stock"  
				   method            = "getStock" 		  
				   warehouse         = "#warehouse.warehouse#" 		  
				   ItemNo            = "#itemno#"
				   UoM               = "#TransactionUoM#"		
				   returnvariable    = "check">	
			   
			   <cfif check.onhand gte transactionquantity>		   
			       <td style="border:1px solid black;width:12px;height:12px;background-color:green"></td>		   
		       <cfelseif check.onhand gt "0">		       		   
	  		       <td style="border:1px solid black;width:12px;height:12px;background-color:yellow"></td>			
			   <cfelse>	   			
				   <td style="border:1px solid black;width:12px;height:12px;background-color:red"></td>   		   	   
		       </cfif>			   
		   
		   </cfif>
		   
		   </tr>		   
   </table>
   
   </cfoutput>