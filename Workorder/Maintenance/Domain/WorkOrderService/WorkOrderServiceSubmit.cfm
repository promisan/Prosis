<cfif trim(url.id2) eq ""> 

	<cfquery name="Verify" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	WorkOrderService
		WHERE 	ServiceDomain = '#Form.serviceDomain#'
		AND 	Reference  = '#Form.Reference#' 
	</cfquery>

   <cfif Verify.recordCount gt 0>
   
	   <script language="JavaScript">
	   
	     alert("A record with this domain and reference has been registered already!")
	     
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO WorkOrderService
		         (ServiceDomain,
				 Reference,
				 <cfif trim(Form.description) neq "">Description,</cfif>
				 ListingOrder,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#url.id1#',
		  		  '#Form.Reference#',
		  		  <cfif trim(Form.description) neq "">'#Form.description#',</cfif>
				  #Form.listingOrder#,
		          '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		  
    </cfif>		  
           
<cfelse>

	<cfquery name="Update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	  WorkOrderService
			SET       Description      = <cfif trim(Form.description) eq "">null<cfelse>'#Form.Description#'</cfif>,
					  ListingOrder     = #Form.ListingOrder#
			WHERE     ServiceDomain    = '#url.id1#'
			AND		  Reference		   = '#url.id2#'
	</cfquery>
	
	<cfinclude template="WorkOrderServiceMissionSubmit.cfm">

</cfif>	

<cfoutput>
	<script language="JavaScript">
		ProsisUI.closeWindow('mydialog'); 	
    	ptoken.navigate('#SESSION.root#/Workorder/Maintenance/Domain/WorkOrderService/WorkOrderServiceListing.cfm?ID1=#url.id1#','workOrderServiceListing')   
	</script> 
</cfoutput>

