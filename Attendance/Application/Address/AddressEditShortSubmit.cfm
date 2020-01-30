

<cfparam name="Form.AddressType" default = "">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<!--- verify if record exist --->

<cfquery name="Address" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT A.*
FROM vwPersonAddress A
WHERE PersonNo = '#Form.PersonNo#' AND AddressId  = '#Form.AddressId#'
</cfquery>

<cfif Address.recordCount eq 1> 

  <!----
 <cfquery name="UpdateContract" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   DELETE FROM  PersonAddress 
   WHERE PersonNo = '#Form.PersonNo#' AND AddressId  = '#Form.AddressId#' 
   </cfquery>
  ---->

 
 <cftransaction>

	 <cfquery name="UpdateContract" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   UPDATE PersonAddress 
		   SET   <cfif Form.AddressType neq "">
			    	 AddressType         = '#Form.Addresstype#',
				 </cfif> 
				 Address             = '#Form.Address#',
				 Address2            = '#Form.Address2#',
				 AddressCity         = '#Form.AddressCity#',
		 		 AddressRoom         = '#Form.AddressRoom#', 
				 <cfif Form.AddressZone	neq "">
				 	 AddressZone         = '#Form.AddressZone#',
				 </cfif>	 
				 Country             = '#Form.Country#',
				 State               = '#Form.State#'
		   WHERE PersonNo = '#Form.PersonNo#' AND AddressId  = '#Form.AddressId#' 
    </cfquery>
	
	
   
	   
	   <!--- provision for contacts --->
	   
   
   </cftransaction>
  
   
</cfif>   
	