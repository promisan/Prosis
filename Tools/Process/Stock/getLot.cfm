
<!---
  <cfdiv bind="url:service.Process.Materials.Lot.checklot('#PO.mission#',{TransactionLot_#rw#})" id="validatelot">
  --->
  
  
<cfparam name="url.Mission"        default="">
<cfparam name="url.TransactionLot" default="0">
  
<cfparam name="Attributes.Mission"        default="#url.mission#">
<cfparam name="Attributes.TransactionLot" default="#url.transactionlot#">
 
<cfif attributes.TransactionLot neq "">

	<cfinvoke component = "Service.Process.Materials.Lot"  
		   method           = "checklot" 
		   mission          = "#Attributes.Mission#" 
		   transactionlot   = "#Attributes.TransactionLot#"
		   returnvariable   = "result">	
	
	<cfif result eq "1">
		<font color="008000">Exists</font>
	<cfelse>
		<font color="FF8000">New</font>
	</cfif>  
	
</cfif> 