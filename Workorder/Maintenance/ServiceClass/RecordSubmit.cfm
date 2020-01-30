<cfparam name="Form.CustomDialog" default="">


<cfquery name="CountRec" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    *
    FROM     ServiceItem	
    <cfif ParameterExists(Form.Update)>
		WHERE ServiceClass = '#Form.CodeOld#'
	<cfelse>
		WHERE 1 = 0
	</cfif>
 </cfquery>		

<cfif ParameterExists(Form.Insert)> 
	
	<cfquery name="Verify" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM ServiceItemClass
		WHERE Code  = '#Form.Code#' 
	</cfquery>
	
	<cfif Verify.recordCount is 1>
	   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
  
   <CFELSE>
	    
	<cfquery name="Insert" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ServiceItemClass
	         (Code,
			 Description, 
			 ListingOrder,			
			 Operational,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#Form.Code#', 
	          '#Form.Description#',
	          '#Form.ListingOrder#',				  
			  #Form.Operational#,			  
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	  </cfquery>
		  
		<cf_LanguageInput
				TableCode       = "ServiceItemClass" 
				Mode            = "Save"
				DataSource      = "AppsWorkOrder"
				Key1Value       = "#Form.Code#"
				Name1           = "Description">	
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Verify" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM ServiceItemClass
			WHERE Code  = '#Form.Code#' 
	</cfquery>
	
   <cfif Verify.recordCount gt 0 and form.code neq form.codeOld>
	   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
  
   <cfelse>   				    
   
		<cfquery name="Update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ServiceItemClass
		SET   <cfif CountRec.recordCount eq 0>Code = '#Form.Code#',</cfif>
			  Description         = '#Form.Description#',
			  ListingOrder        = '#Form.ListingOrder#',
			  Operational         = #Form.Operational#		      
		WHERE Code = '#Form.CodeOld#' 
		</cfquery>	
		
		<cfset sCode = Form.CodeOld>
		<cfif CountRec.recordCount eq 0>
			<cfset sCode = Form.Code>
		</cfif>
		
			<cf_LanguageInput
			TableCode       = "ServiceItemClass" 
			Mode            = "Save"
			DataSource      = "AppsWorkOrder"
			Key1Value       = "#sCode#"
			Name1           = "Description">	
		
	</cfif>
	
</cfif>


<cfif ParameterExists(Form.Delete)>     
	
    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Service class is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>
			
		<cfquery name="Delete" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM ServiceItemClass
			WHERE Code   = '#Form.codeOld#'
	    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">   
     window.close()
	 opener.location.reload()        
</script>  