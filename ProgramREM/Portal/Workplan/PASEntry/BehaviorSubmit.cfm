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
	 <cfquery name="Verify" 
		datasource="appsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  COUNT(*) AS Entries, 
			        SUM(DISTINCT C.MinEntries) AS MinEntries
			FROM    ContractBehavior CB,
                    Ref_Behavior R,
					Ref_BehaviorClass C 
			WHERE   CB.BehaviorCode = R.Code 
			AND     R.BehaviorClass = C.Code
			AND     CB.Contractid = '#URL.ContractId#' 
			AND 	R.Operational=1
			AND 	C.Operational=1
	 </cfquery>	
	 
	  <cfquery name="Verify2" 
		datasource="appsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_BehaviorClass C 
			WHERE   Operational = 1
			and   Code NOT IN (SELECT BehaviorClass 
			                     FROM   ContractBehavior CB,
					                    Ref_Behavior R
								 WHERE  CB.BehaviorCode = R.Code 
								 AND    CB.Contractid = '#URL.ContractId#')
	 </cfquery>	

	  <cf_Navigation
			 Alias         = "AppsEPAS"
			 Object        = "Contract"
			 Group         = "Contract"
			 Section       = "#URL.Section#"
			 Id            = "#URL.ContractId#"
			 OpenDirect    = "1"
			 NextEnable    = "1"
			 reload        = "1"
			 NextMode      = "1"
			 SetNext       = "1">
