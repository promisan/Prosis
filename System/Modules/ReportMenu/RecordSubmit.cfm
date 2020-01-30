
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 
		
	<cfquery name="Verify" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Ref_ReportMenuClass
		WHERE MenuClass = '#Form.MenuClass#' 
		AND   SystemModule = '#Form.SystemModule#'
	</cfquery>

   <cfif Verify.recordCount is 1>
   
	   <script language="JavaScript">
	   
	     alert("a menu class with this code has been registered already!")
		 	     
	   </script>  
	   
	   <cfabort>
  
   <cfelse>
   				
		<cfquery name="Insert" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ReportMenuClass
	         (SystemModule,
			  MenuClass,		 
			  Description,
			  ListingOrder,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
			 VALUES ('#Form.SystemModule#',
			  '#Form.MenuClass#',		
	          '#Form.Description#', 
			  '#Form.ListingOrder#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
		  </cfquery>		 
		  
    </cfif>		
	    	          
</cfif>

<cfif ParameterExists(Form.Update)>

		<cfquery name="Get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_ReportMenuClass
			SET    MenuClass = '#Form.MenuClass#',
			       Description    = '#Form.Description#' ,
			       ListingOrder   = '#Form.ListingOrder#'			
			WHERE  MenuClass = '#Form.MenuClassOld#' 
			AND    SystemModule = '#url.id#'
		</cfquery>
		        
</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsSystem" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT *
      FROM  Ref_ReportControl
      WHERE SystemModule  = '#url.id#' 
	  AND MenuClass = '#Form.MenuClassOld#'
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">
	    
		   alert("Menu class is in use for one or more report. Operation aborted.")
		        
	     </script>  
		 
		 <cfabort>
	 
    <cfelse>
	
		<cfquery name="Delete" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM  Ref_ReportMenuClass
			WHERE MenuClass = '#Form.MenuClass#' 
			AND   SystemModule = '#url.id#'
	    </cfquery>
		
	</cfif>	
    		
</cfif>	

<script language="JavaScript">
   
     parent.window.close()
	 parent.opener.location.reload()
        
</script>  
