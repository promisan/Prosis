<!--
    Copyright © 2025 Promisan B.V.

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