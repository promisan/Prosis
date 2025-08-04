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

<!--- define last order --->

<cfif url.id neq "">
	
	<cfquery name="Clear" 
	 datasource="appsSystem">
	 DELETE  FROM UserReportOutput 
	 WHERE    UserAccount = '#SESSION.acc#'
	 AND      OutputId    = '#url.id#' 
	 AND      OutputClass = '#url.class#'
	</cfquery>
	
	<cfif URL.Value eq "1">
	
		<cfquery name="Insert" 
		 datasource="appsSystem">
		 INSERT INTO UserReportOutput 
		 (UserAccount, OutputId, OutputClass, FieldName, FieldNameOrder, GroupFormula)
		 VALUES
		 ('#SESSION.acc#','#URL.ID#','#URL.Class#','1','0','None')
		</cfquery>
	
	</cfif>
	
</cfif>