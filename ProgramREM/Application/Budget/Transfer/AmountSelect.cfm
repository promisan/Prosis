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

<!--- show the current values --->

<cfparam name="editionid" default="#url.editionid#">
<cfparam name="period" default="#url.period#">
<cfparam name="programcode" default="#url.programcode#">
<cfparam name="fund" default="#url.fund#">
<cfparam name="objectcode" default="#url.objectcode#">

<cfoutput>

	<cfquery name="Amount" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    SUM(Amount) as Amount
			FROM      ProgramAllotmentDetail
			WHERE     ProgramCode = '#programcode#'
			AND       Period      = '#period#'
			AND       EditionId   = '#editionid#' 
			AND       ObjectCode  = '#objectcode#'
			AND       Fund        = '#fund#'
			<cfif url.status eq "Pending">
			AND       Status = '0'
			<cfelse>
			AND       Status = '1'
			</cfif>
	</cfquery>	
			 
	<input type="text"
		   size="10" id="#url.status##url.direction#" 
		   name="#url.status##url.direction#" 
		   style="text-align:right;width:96%;border:0px;" 
		   class="regularxl" 
		   value="#numberformat(Amount.Amount,',.__')#" readonly>		   
				
</cfoutput>


