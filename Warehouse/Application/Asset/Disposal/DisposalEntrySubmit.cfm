

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



