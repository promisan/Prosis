
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Operational" default="0">

<cfif ParameterExists(Form.Insert)> 
        
	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	INSERT INTO MissionProfile
		(Mission, FunctionName, ListingOrder, FunctionMemo,
		 OfficerUserId,
		 OfficerLastName,OfficerFirstName) 
		
	VALUES (
		'#Form.Mission#', 
		'#Form.FunctionName#', 
		'#Form.ListingOrder#', 
		'#Form.FunctionMemo#', 		
		'#SESSION.acc#',
	    '#SESSION.last#',		  
		'#SESSION.first#')
	
	</cfquery>
	
	 <cf_LanguageInput
		TableCode       = "MissionProfile" 
		Mode            = "Save"
		Datasource      = "AppsOrganization"
		Key1Value       = "#url.id1#"
		Name1           = "FunctionName">
				
	<script language="JavaScript">        
    	 parent.opener.applyfilter('5','','content')
	     parent.window.close()	      
	</script>  
	           
</cfif>

<cfif ParameterExists(Form.Update)>

	<!--- check --->
	
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM MissionProfile
	WHERE ProfileId = '#Form.ProfileId#'
   </cfquery>
   
   <cftransaction>
  	
   <cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE MissionProfile
		SET   FunctionName  		  = '#Form.FunctionName#', 
		   	  Operational   		  = '#Form.Operational#',
			  ListingOrder            = '#Form.ListingOrder#'			
		WHERE ProfileId = '#Form.ProfileId#'
	</cfquery>
	
	 <cf_LanguageInput
		TableCode       = "MissionProfile" 
		Mode            = "Save"
		Datasource      = "AppsOrganization"
		Key1Value       = "#Form.ProfileId#"
		Name1           = "FunctionName">
	
	</cftransaction>
	
	<cfoutput>
	<script language="JavaScript">        
    	 parent.opener.applyfilter('1','','#Form.ProfileId#')
	     parent.window.close()	      
	</script> 
	</cfoutput>
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
      datasource="AppsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
		SELECT   *
		FROM     MissionProfileUser  
      	WHERE    ProfileId  = '#Form.ProfileId#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">    
	   alert("Profile is in use. Operation aborted.")     
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM MissionProfile
			WHERE ProfileId = '#Form.ProfileId#'
	    </cfquery>
	
	</cfif>
	
	<cfoutput>
	<script language="JavaScript">        
    	 parent.opener.applyfilter('1','','#Form.ProfileId#')
	     parent.window.close()	      
	</script> 
	</cfoutput>
		
</cfif>	

