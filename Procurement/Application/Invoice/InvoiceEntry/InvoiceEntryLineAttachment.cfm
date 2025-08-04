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
<cfparam name="access"                default="">
<cfparam name="Invoice.ActionStatus"  default="">

<cfquery name="Parameter" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfif  (access eq "edit") and (Access eq "Edit" or Invoice.ActionStatus eq "0" or Invoice.ActionStatus eq "9" or Access eq "ALL") >
	
	<cf_filelibraryN
			DocumentPath="#Parameter.InvoiceLibrary#"
			SubDirectory="#URL.lineid#" 
			Box="#URL.lineid#"
			Filter=""
			LoadScript="no"
			Insert="yes"
			Remove="yes"
			reload="true">	
			
<cfelse>

	<cf_filelibraryN
		DocumentPath="#Parameter.InvoiceLibrary#"
		SubDirectory="#URL.lineid#" 
		Box="#URL.lineid#"
		Filter=""
		LoadScript="no"
		Insert="no"
		Remove="no"
		reload="true">	

</cfif>	
