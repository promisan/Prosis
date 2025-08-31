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
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM stLedgerRouting
	WHERE RoutingNo = '#Form.RoutingNo#' 
</cfquery>


<cfif Verify.RecordCount eq 1> 
	<cfquery name="qUpdate" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE stLedgerRouting
		SET 
		ReconcileMode  = '#FORM.mode#',
		NOVA_GlAccount = '#FORM.glaccount#' ,
		NOVA_Object    = '#FORM.obj#',
		NOVA_Fund      = '#FORM.fund#'
		WHERE RoutingNo = '#FORM.RoutingNo#'
    </cfquery>
    <cfoutput>
	<script language="JavaScript">
		 try {			   	   
			window.opener.applyfilter('1','','#FORM.RoutingNo#') } 
		 catch(e) 
		 	{
				alert('test');	 
				returnValue = 1
			}
	     window.close()
	</script>
	</cfoutput>      
</cfif>	
	
