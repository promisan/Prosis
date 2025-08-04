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
<cfcomponent>
    <cfproperty name="name" type="string">
    <cfset this.name = "System License controller">

	<cffunction name="getSerialNo"
        access="public"
        returntype="string">

		<cfargument name="Module"  type="string"  required="true">	 
		<cfargument name="Mission" type="string"  required="true" default="ALL">	 		
		<cfargument name="Year"    type="string"  required="true">	 				
		<cfargument name="Quarter"   type="string"  required="true">	 						
		
		   		<cfset key    = Module & "124EFCD" & Mission & "45778EE" & Year & "2232122" & Quarter>
				<cfset hash   = Hash(key, "SHA")>
				<cfreturn hash>	
	</cffunction>	

	
	<cffunction name = "getDatabaseLicense" returnType="string">
		<cfargument name="DatabaseServer" type="string" required="false" default="">
		<cfargument name="Year"           type="string"  required="true">	 				
		<cfargument name="Quarter"        type="string"  required="true">	 						

   		<cfset key    = DatabaseServer & "124EFCD" & Year & "2232122" & Quarter>
		<cfset hashkey = Hash(key, "SHA")>
		<cfreturn hashkey>		
	</cffunction>	

</cfcomponent>			 