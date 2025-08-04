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

<cftransaction>
  
  <cfquery name="Parameter" 
  datasource="AppsSelection" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	  SELECT *
	  FROM   Ref_ParameterOwner
	  WHERE  Owner = '#URL.Owner#'
  </cfquery>
		
	<!--- logging --->
	
	<cf_RosterActionNo ActionRemarks="Batch retirement" 
	                   ActionCode="FUN"> 
					   	
		
	<cfquery name="UpdateFunctionStatusAction" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO  ApplicantFunctionAction
			   (ApplicantNo,
			   FunctionId, 
			   RosterActionNo, 
			   Status,
			   StatusDate)
		SELECT ApplicantNo, 
		       FunctionId, 
			   '#RosterActionNo#', 
			   '5', 
			   '#dateformat(now(),client.dateSQL)#'
		FROM   ApplicantFunction
		WHERE  FunctionId = '#URL.ID#'
		AND    Created < getDate() - #Parameter.ProcessDays#
		AND    Status = '0'
	</cfquery>
			
	<cfquery name="RetireNow" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		UPDATE ApplicantFunction 
		
		SET    Status                = '5',
		       StatusDate            = '#dateformat(now(),client.dateSQL)#',
	    	   FunctionJustification = 'Batch retirement' 
			   
		WHERE  FunctionId = '#URL.Id#'
		AND    Created < getDate() - #Parameter.ProcessDays#		
		AND    Status = '0'
		
	</cfquery>	
	
</cftransaction>

<cfoutput>
<script>
  Prosis.busy('no')  
  <!---  listing('#url.occ#','show','#url.mode#','#url.filter#','#url.level#','#url.line#','','#url.exerciseclass#') --->
  listing('#url.occ#','show','#url.mode#','#url.filter#','#url.level#','#url.line#','','')
</script>
</cfoutput>



	
	