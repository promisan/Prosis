<cfparam name="Object.ObjectKeyValue1" default="">		  
<cfparam name="URL.ID1" default="#Object.ObjectKeyValue1#">	

<cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase P
		WHERE  PurchaseNo ='#URL.Id1#'
		AND    PurchaseNo IN (SELECT PurchaseNo 
		                      FROM   PurchaseLine
							  WHERE  PurchaseNo = P.PurchaseNo)
</cfquery>	

<cfquery name="PurchaseClass" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_OrderClass
		WHERE  Code = '#PO.OrderClass#' 
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 
</cfquery>

<cfif PO.PrintDocumentId neq "">

	<cfquery name="Document" 
  	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
  	  password="#SESSION.dbpw#">
	    SELECT * 
   		FROM   Ref_EntityDocument 
		WHERE  DocumentId  = '#PO.PrintDocumentId#' 
	</cfquery>
		
	<cfset tmp = "../../../../#Document.DocumentTemplate#">
		
<cfelse>
	
	<cfif PurchaseClass.PurchaseTemplate neq "">
		<cfset tmp = "../../../../#PurchaseClass.PurchaseTemplate#">
	<cfelseif Parameter.PurchaseTemplate neq "">
	    <cfset tmp = "../../../../#Parameter.PurchaseTemplate#"> 
	<cfelse>	
		<cfset tmp = "POViewPrintContent.cfm">  
	</cfif>

</cfif>		

<cfparam name="wfrpt" default="">

<cfif wfrpt neq "">
	
	<cfdocument 
	      format       = "PDF"
	      pagetype     = "letter"
		  overwrite    = "yes"
		  filename     = "#wfrpt#"   <!--- passed from the workflow --->
		  margintop    = "2"
		  marginbottom = "2"
	      marginright  = "0"
	      marginleft   = "0"
	      orientation  = "Portrait"
	      unit         = "cm"
	      fontembed    = "Yes"
	      scale        = "75"
	      backgroundvisible="Yes">
			  		  		  
		  <cfinclude template="#tmp#">
			  			
	</cfdocument>	

<cfelse>

	<cfinclude template="#tmp#">
	
</cfif>
