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

<cfparam name="Form.Extension" default="0">

   <cfif Form.Extension eq "1">

	<cfset dateValue = "">
	<cfif Form.DateExtension neq ''>
		<CF_DateConvert Value="#Form.DateExtension#">
		<cfset EXT = dateValue>
	<cfelse>
	    <cfset EXT = 'NULL'>	
	</cfif>		
			
	<cfif EXT gt MEND and END eq MEND>
	
		<cfquery name="CheckExtension" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   PersonExtension 
			WHERE  PersonNo     = '#Form.PersonNo#'
			AND    Mission      = '#Form.Mission#' 
			AND    MandateNo    = '#Form.MandateNo#'
		</cfquery>
		
		<cfif CheckExtension.recordcount eq "0">
			
			<cfquery name="InsertExtension" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO PersonExtension 
				(PersonNo, 
				 Mission,
				 MandateNo,
				 ActionStatus,
				 DateExtension,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
				VALUES('#Form.PersonNo#',
				       '#Form.Mission#',
					   '#Form.MandateNo#',
					   '1',
					   #EXT#,
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#')
				</cfquery>
			
		<cfelse>
		
			<cfquery name="Update" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE PersonExtension 
				SET DateExtension = #EXT#
				WHERE PersonNo     = '#Form.PersonNo#'
				AND   Mission      = '#Form.Mission#' 
				AND   MandateNo    = '#Form.MandateNo#'
			</cfquery>
		
		</cfif>	
	
	<cfelse>
	
		<cfquery name="CheckExtension" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM PersonExtension 
			WHERE PersonNo     = '#Form.PersonNo#'
			AND   Mission      = '#Form.Mission#' 
			AND   MandateNo    = '#Form.MandateNo#'
		</cfquery>
	
	</cfif>
	
	<cfelse>
	
	<cfquery name="CheckExtension" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM PersonExtension 
			WHERE PersonNo     = '#Form.PersonNo#'
			AND   Mission      = '#Form.Mission#' 
			AND   MandateNo    = '#Form.MandateNo#'
		</cfquery>
	  
 </cfif>