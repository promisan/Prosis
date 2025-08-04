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


<!--- establish the workflow object --->

<cfset link = "Warehouse/Application/Asset/Disposal/DisposalView.cfm?disposalid=#url.disposalid#">
	
<cf_ActionListing 
		EntityCode       = "assDisposal"
		Mission          = "#url.mission#"
		EntityGroup      = "#Form.Workgroup#"
		EntityClass      = "#Form.EntityClass#"		
		ObjectReference  = "Disposal request under No:#Form.Reference#"
		ObjectKey4       = "#url.disposalid#"
		ObjectURL        = "#link#"
		Show             = "No"
		EntityStatus     = "1"
		Toolbar          = "No"
		Framecolor       = "ECF5FF"
		CompleteFirst    = "Yes">	
		
<cftransaction>

	<cfquery name="Update" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE AssetDisposal
		 SET DisposalMethod  = '#Form.DisposalMethod#',
		     DisposalRemarks = '#Form.DisposalRemarks#',
			 DisposalValue   = '#Form.DisposalValue#',
			 ActionStatus    = '1'	 
		 WHERE DisposalId    = '#url.disposalid#'
	</cfquery>	

</cftransaction> 
  			
<cfoutput>

	<script language="JavaScript">	   
	   try { parent.opener.listreload('#url.id#','#url.id1#','#url.id2#','#url.page#','#url.sort#','#url.view#','#url.mde#') } catch(e) {}
	   parent.window.close()	  
    </script>
	
</cfoutput>



