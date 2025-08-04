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
<cfparam name="url.requisitionno" default="">
<cfparam name="url.action" default="">

<cfquery name="ReqLine" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  * 
		FROM    RequisitionLine
		WHERE   RequisitionNo = '#url.requisitionno#'
</cfquery>

<cfif url.action eq "delete">

	<cfquery name="delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM  RequisitionLine
		WHERE   RequisitionNo = '#url.requisitionno#'
	</cfquery>

<cfelse>

	<cf_copyRequisitionLine requisitionNoFrom="#url.requisitionno#" workorder="Yes">
	
	<script>
	
	<cf_tl id="Requisition has been cloned" var="vMessage" class="message">
	<cfoutput>
		// alert('#vMessage#.');
	</cfoutput>
	
	</script>
		
</cfif>	

<cfoutput>

<script>			
		
	try {				
	   parent.document.getElementById('refreshbutton').click()	  
	} catch(e) {}
	
	_cf_loadingtexthtml='';	
	ptoken.navigate('../Requisition/RequisitionEntryListing.cfm?add=0&Mission=#ReqLine.Mission#&Period=#ReqLine.Period#&Mode=Entry&ID=#url.requisitionno#&ajax=1','contentbox1')
	
	Prosis.busy('no');	
	
</script>

</cfoutput>