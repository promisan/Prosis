<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Set system defined reference numbers">
		
	<cffunction name="RequestSerialNo"
         access="public"
         returntype="string"
         displayname="Return true if the valid UoM exists if not, it returns false">

			<cfargument name = "Mission"	type="string"  required="true"   default="">	
			<cfargument name = "Alias"	    type="string"  required="true"   default="AppsMaterials">
			
			<cftransaction>
			
			  <cfquery name="AssignNo" 
			     datasource="#alias#" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     UPDATE  Ref_ParameterMission
				 SET     RequestSerialNo = RequestSerialNo+1,
					OfficerUserId 	 = '#SESSION.ACC#',
					OfficerLastName  = '#SESSION.LAST#',
					OfficerFirstName = '#SESSION.FIRST#',
					Created          =  getdate()				 
				 WHERE   Mission         = '#mission#'
			  </cfquery>
		
			  <cfquery name="LastNo" 
			     datasource="#alias#" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT RequestPrefix, RequestSerialNo
			     FROM   Ref_ParameterMission
				 WHERE  Mission = '#mission#'
			  </cfquery>
		  
			  <cfif LastNo.RequestSerialNo lt 10>
			     <cfset pre = "000">
			  <cfelseif	LastNo.RequestSerialNo lt 100>
			     <cfset pre = "00">
			  <cfelseif LastNo.RequestSerialNo lt 1000>
			  	 <cfset pre = "0">
			  <cfelse>
			     <cfset pre = "">
			  </cfif>
		  
		  </cftransaction>	
		  
		  <cfset reqNo = "#LastNo.RequestPrefix#-#pre##LastNo.RequestSerialNo#">	
	  
	  <cfreturn reqno>				
					 
	</cffunction>	
		
</cfcomponent>