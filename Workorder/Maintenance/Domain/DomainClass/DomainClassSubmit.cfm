
<cfquery name="CountRec" 
      datasource="AppsWorkOrder" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	SELECT	RequestId as id
		FROM	Request
		WHERE	ServiceDomain = '#form.serviceDomain#'
		<cfif ParameterExists(Form.Update)>AND ServiceDomainClass = '#form.codeOld#'<cfelse>AND 1=0</cfif>
		UNION
		SELECT	WorkorderId as id
		FROM	Workorderline
		WHERE	ServiceDomain = '#form.serviceDomain#'		
		<cfif ParameterExists(Form.Update)>AND ServiceDomainClass = '#form.codeOld#'<cfelse>AND 1=0</cfif>
</cfquery>

<cfif trim(url.id2) eq ""> 

	<cfquery name="Verify" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ServiceitemDomainClass
		WHERE 	ServiceDomain = '#Form.serviceDomain#'
		AND 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount gt 0>
   
	   <script language="JavaScript">
	   
	     alert("A record with this domain and class code has been registered already!")
	     
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_ServiceitemDomainClass
		         (ServiceDomain,
				 Code,
				 <cfif trim(Form.description) neq "">Description,</cfif>
				 ListingOrder,
				 ServiceType,
				 PointerRequest,
				 PointerSale,
				 PointerOverdraw,
				 PointerStock,
				 Operational,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.serviceDomain#',
		  		  '#Form.Code#',
		  		  <cfif trim(Form.description) neq "">'#Form.description#',</cfif>
				  #Form.listingOrder#,
				  '#Form.ServiceType#',
				  #Form.pointerRequest#,
				  #Form.pointerSale#,
				  #Form.pointerOverdraw#,
				  #Form.pointerStock#,
				  #Form.operational#,
		          '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		  
    </cfif>		  
           
<cfelse>

	<cfquery name="Verify" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ServiceitemDomainClass
		WHERE 	ServiceDomain = '#Form.serviceDomain#'
		AND 	Code          = '#Form.Code#' 
	</cfquery>
	
	<cfif Verify.recordCount gt 0 and form.code neq form.codeOld>
   
	   <script language="JavaScript">
	   
	     alert("A record with this domain and class code has been registered already!")
	     
	   </script>  
  
   <cfelse>
   
		<cfquery name="Update" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE 	  Ref_ServiceitemDomainClass
			SET       <cfif #CountRec.recordCount# eq 0> Code = '#Form.Code#',</cfif>
			  		  Description      = <cfif trim(Form.description) eq "">null<cfelse>'#Form.Description#'</cfif>,
					  ListingOrder     = #Form.ListingOrder#,
					  ServiceType      = '#Form.ServiceType#',
					  PointerRequest   = #Form.PointerRequest#,
					  PointerSale      = #Form.PointerSale#,
					  PointerStock     = #Form.PointerStock#,
					  Operational      = #Form.Operational#
			WHERE     Code             = '#Form.CodeOld#'
		</cfquery>
		
	</cfif>

</cfif>	

<cfoutput>
	<script language="JavaScript">
		ColdFusion.Window.hide('mydialog'); 	
    	ptoken.navigate('#SESSION.root#/Workorder/Maintenance/Domain/DomainClass/DomainClassListing.cfm?ID1=#Form.ServiceDomain#','domainClassListing')   
	</script> 
</cfoutput>

