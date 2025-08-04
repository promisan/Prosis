<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
