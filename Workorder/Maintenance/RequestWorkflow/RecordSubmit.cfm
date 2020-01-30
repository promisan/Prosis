<cfparam name="Form.ServiceDomainClass" default="">
<cfparam name="Form.isAmendment" default="">
<cfparam name="Form.PointerReference" default="">

<cfquery name="validateDeleteUpdate" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT TOP 1 RequestId
	FROM	Request
	WHERE 	RequestType  = '#Form.requestTypeOld#' 
	AND		ServiceDomain = '#Form.serviceDomainOld#'
	AND		RequestAction = '#Form.requestActionOld#'
</cfquery>

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_RequestWorkflow
	WHERE 	RequestType  = '#Form.requestType#' 
	AND		ServiceDomain = '#Form.serviceDomain#'
	AND		RequestAction = '#Form.requestAction#'
	</cfquery>
	
	<cfif Verify.recordCount is 1>
	   
	   <script language="JavaScript">
	   
	     alert("A record with this request type, service domain and action has been registered already!")
	     
	   </script>  
	  
	<cfelse>
	   
		<cfquery name="Insert" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO Ref_RequestWorkflow
		          (RequestType,
		          ServiceDomain,
		          RequestAction,
		          <cfif trim(Form.requestActionName) neq "">RequestActionName,</cfif>
				  <cfif trim(Form.ServiceDomainClass) neq "">ServiceDomainClass,</cfif>
				  <cfif trim(Form.isAmendment) neq "">isAmendment,</cfif>
				  <cfif trim(Form.PointerReference) neq "">PointerReference,</cfif>
		          <cfif trim(Form.customForm) neq "">CustomForm,</cfif>
		          <cfif trim(Form.customFormCondition) neq "">CustomFormCondition,</cfif>
		          <cfif trim(Form.entityClass) neq "">EntityClass,</cfif>
				  PointerExpiration,
		          Operational,
		          OfficerUserId,
		          OfficerLastName,
		          OfficerFirstName)		          
		    VALUES
		          ('#Form.requestType#',
		          '#Form.serviceDomain#',
		          '#Form.requestAction#',
		          <cfif trim(Form.requestActionName) neq "">'#Form.requestActionName#',</cfif>
				  <cfif trim(Form.ServiceDomainClass) neq "">'#Form.ServiceDomainClass#',</cfif>
				  <cfif trim(Form.isAmendment) neq "">#Form.isAmendment#,</cfif>
				  <cfif trim(Form.PointerReference) neq "">#Form.PointerReference#,</cfif>
		          <cfif trim(Form.customForm) neq "">'#Form.customForm#',</cfif>
		          <cfif trim(Form.customFormCondition) neq "">'#Form.customFormCondition#',</cfif>
		          <cfif trim(Form.entityClass) neq "">'#Form.entityClass#',</cfif>
				  #Form.PointerExpiration#,
		          #Form.operational#,
		          '#SESSION.acc#',
		    	  '#SESSION.last#',
			  	  '#SESSION.first#')
		</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Verify" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_RequestWorkflow
	WHERE 	RequestType  = '#Form.requestType#' 
	AND		ServiceDomain = '#Form.serviceDomain#'
	AND		RequestAction = '#Form.requestAction#'
	</cfquery>
	
	<cfset isUpdatable = 0>
		
	<cfif Verify.recordcount eq 0>
		<cfset isUpdatable = 1>
	<cfelse>
		<cfif trim(#form.requestType#) eq trim(#form.requestTypeOld#) 
				and trim(#form.serviceDomain#) eq trim(#form.serviceDomainOld#) 
				and trim(#form.requestAction#) eq trim(#form.requestActionOld#)>						
			<cfset isUpdatable = 1>	
		</cfif>
	</cfif>	
	
	<cfif isUpdatable eq 1>
	   
		<cfquery name="Update" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			UPDATE Ref_RequestWorkflow
		    SET
				  <cfif validateDeleteUpdate.recordCount eq 0>
		          requestType 				= '#Form.requestType#',
		          serviceDomain 			= '#Form.serviceDomain#',
		          requestAction 			= '#Form.requestAction#',
				  </cfif>
		          requestActionName 		= <cfif trim(Form.requestActionName) eq "">null<cfelse>'#Form.requestActionName#'</cfif>,
				  serviceDomainClass 		= <cfif trim(Form.ServiceDomainClass) eq "">null<cfelse>'#Form.ServiceDomainClass#'</cfif>,
				  isAmendment 				= #Form.IsAmendment#,
				  PointerReference 			= #Form.PointerReference#,
		          customForm 				= <cfif trim(Form.customForm) eq "">null<cfelse>'#Form.customForm#'</cfif>,
		          customFormCondition 		= <cfif trim(Form.customFormCondition) eq "">null<cfelse>'#Form.customFormCondition#'</cfif>,
		          entityClass 				= <cfif trim(Form.entityClass) eq "">null<cfelse>'#Form.entityClass#'</cfif>,
				  pointerExpiration 		= #Form.pointerExpiration#,
		          operational 				= #Form.operational#
				  
			WHERE 	RequestType  			= '#Form.requestTypeOld#' 
			AND		ServiceDomain 			= '#Form.serviceDomainOld#'
			AND		RequestAction 			= '#Form.requestActionOld#'
					
		</cfquery>
		  
    <cfelse>
	
		<script language="JavaScript">alert("A record with this request type, service domain and action has been registered already!")</script>  	
	
	</cfif>  
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfif validateDeleteUpdate.recordCount eq 0>
	
	<cfquery name="Delete" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			DELETE 	Ref_RequestWorkflow
			WHERE 	RequestType  = '#Form.requestTypeOld#' 
			AND		ServiceDomain = '#Form.serviceDomainOld#'
			AND		RequestAction = '#Form.requestActionOld#'			
				
	</cfquery>	
	
	</cfif>
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
