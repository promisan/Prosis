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
<cf_compression>

<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    RequisitionLine
		WHERE   RequisitionNo = '#URL.ID#' 
</cfquery>

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Line.Mission#'
</cfquery>

<cfparam name="form.Period" default="">
<cfparam name="form.OrgUnit1" default="">
<cfparam name="form.ItemMaster" default="">

<cfif form.period neq "" and form.OrgUnit1 neq "" and form.ItemMaster neq "">
	
	<cfif line.actionStatus gte "2" and Parameter.EnableRequisitionEdit eq "0">
	
		<cfif Parameter.EnableRequisitionEditMode neq "2">
			
			<cfif Form.Period neq Line.Period or
			          Form.OrgUnit1 neq Line.OrgUnit or
			          Form.ItemMaster neq Line.ItemMaster 
					  or Form.RequestDescription neq Line.RequestDescription>
				
				<font color="FF0000"><b><cf_tl id="Attention">:</b> <cf_tl id="Requisition will be sent back to requisitioner upon saving"></font>		    			  
		
			</cfif>		
		
		<cfelse>
		
			<cfif Form.Period neq Line.Period or
			          Form.OrgUnit1 neq Line.OrgUnit or
			          Form.ItemMaster neq Line.ItemMaster>
				
				<font color="FF0000"><b><cf_tl id="Attention">:</b> <cf_tl id="Requisition will be sent back to requisitioner upon saving"></font>		    			  
		
			</cfif>		
			
		</cfif>
	
	</cfif>		  

</cfif>   	