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
<cfquery name="get" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ContractEvaluation		
		WHERE  EvaluationId = '#URL.EvaluationId#'
</cfquery>

<cfquery name="set" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ContractEvaluation
		SET    Evaluation   = '#Form.Description#'
		WHERE  EvaluationId = '#URL.EvaluationId#'
</cfquery>
								
<cf_Navigation
	 Alias         = "AppsEPAS"
	 Object        = "Contract"
	 Group         = "Contract"
	 Section       = "#URL.Section#"
	 Id            = "#get.ContractId#"
	 BackEnable    = "1"
	 HomeEnable    = "1"
	 ResetEnable   = "1"
	 ProcessEnable = "0"
	 OpenDirect    = "1"
	 NextSubmit    = "0"
	 NextEnable    = "1"
	 NextMode      = "1"
	 SetNext       = "1">
	 
	