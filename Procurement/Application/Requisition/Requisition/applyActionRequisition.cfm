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
	ColdFusion.navigate('../Requisition/RequisitionEntryListing.cfm?add=0&Mission=#ReqLine.Mission#&Period=#ReqLine.Period#&Mode=Entry&ID=#url.requisitionno#&ajax=1','contentbox1')
	
	Prosis.busy('no');	
	
</script>

</cfoutput>