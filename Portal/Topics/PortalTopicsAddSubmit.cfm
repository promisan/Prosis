
<cfloop index="Rec" from="1" to="#Form.Number#">

   <cfset ord = Evaluate("Form.listingorder_" & #Rec#)>
   <cfset id = Evaluate("Form.controlno_" & #Rec#)>
   
   <cfset class = Evaluate("Form.class_" & #Rec#)>
   
   <cfparam name="Form.select_#Rec#" default="0">
   <cfset sel = Evaluate("select_" & #Rec#)>
   
   <cfif sel eq "0">
		
	   <cfif class neq "Widget">

		   <cfquery name="Delete" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    DELETE FROM UserModule
			WHERE SystemFunctionId = '#id#'
			AND Account = '#SESSION.acc#'
		  </cfquery>
	  
	  <cfelse>
	  
		<cfquery name="Delete" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE UserModule
				SET    Status   = '0'
				WHERE  SystemFunctionId = '#id#'
				AND    Account = '#SESSION.acc#'
		</cfquery>
	  </cfif>
      
   <cfelse>
      
   <cfquery name="Check" 
    datasource="AppsSystem" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
	FROM   UserModule 
	WHERE  SystemFunctionId = '#id#'
	AND    Account = '#SESSION.acc#'
  </cfquery>
  
  <cfif Check.recordCount eq "1">
    <cfif class neq "Widget">
		  <cfquery name="Update" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    UPDATE UserModule
		    SET    OrderListing   = '#ord#'
		    WHERE  SystemFunctionId = '#id#'
			AND    Account = '#SESSION.acc#'
		  </cfquery>
  	<cfelse>
		 	<cfquery name="Widget" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE UserModule
					SET    Status   = '1'
					WHERE  SystemFunctionId = '#id#'
					AND    Account = '#SESSION.acc#'
			</cfquery>
	 </cfif>
  <cfelse>
  
 	 
	  <cfquery name="Insert" 
	    datasource="AppsSystem" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    INSERT INTO UserModule
		(Account,SystemFunctionId, OrderListing)
		VALUES
		('#SESSION.acc#', '#id#','#Ord#')
	  </cfquery>
	 
   
  </cfif> 
   
  </cfif>

</cfloop>  

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset url.mid = oSecurity.gethash()/>   

<cfinclude template="PortalTopics.cfm">
 