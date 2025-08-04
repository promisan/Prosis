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

<!--- ---------------------------------------- --->
<!--- ---- attention sometime the workflow is open but the track close, which depends on the moment 
  in the workflow that this template is called --->
<!--- ---------------------------------------- --->  
  		 
 <cfquery name="CheckPosition" 
   datasource="AppsVacancy" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   DocumentPost
	   WHERE  DocumentNo      = '#Object.ObjectKeyValue1#'	
 </cfquery>

 <cfquery name="CheckCandidate" 
   datasource="AppsVacancy" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   DocumentCandidate
	   WHERE  DocumentNo      = '#Object.ObjectKeyValue1#'	
	   AND    Status = '3'
 </cfquery>

 <cfif CheckPosition.recordcount lte CheckCandidate.recordcount>

	  <cfquery name="CloseTrack" 
	   datasource="AppsVacancy" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   UPDATE Document
		   SET    Status                 = '1',
		          StatusDate             = getDate(),
       		      StatusOfficerUserId    = '#SESSION.acc#',
		          StatusOfficerLastName  = '#SESSION.last#',
		          StatusOfficerFirstName = '#SESSION.first#'
		   WHERE  DocumentNo             = '#Object.ObjectKeyValue1#'	
	 </cfquery>

 </cfif>
	
