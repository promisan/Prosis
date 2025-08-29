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
  <cfquery name="Doc" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			SET     TextSize 2500000 
			SELECT  O.*, R.DocumentMode, R.DocumentCode,R.DocumentLayout
			FROM    OrganizationObjectActionReport O INNER JOIN
                    Ref_EntityDocument R ON O.DocumentId = R.DocumentId
			WHERE   O.ActionId   = '#url.MemoActionID#'
			AND     O.DocumentId = '#url.documentid#' 
	  </cfquery>		  	  

<cfdiv id="MarginHold" class="hide">   <!--- dummy div to use for ColdFusion.navigate update of top margin --->
<cfset text = replace(doc.DocumentContent,"<script","<disable","all")>
<cfset text = replace(text,"<iframe","<disable","all")>				
<cfoutput>#text#</cfoutput>

	