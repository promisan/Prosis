<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Award">

<cfinclude template="../../Parameter/HeaderParameter.cfm"> 

<cf_dialogOrganization>

<cfajaximport tags="cfform,cfwindow,cfdiv">

<cfoutput>

<script>

	function recordadd() {
	    // window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 390, height= 240, toolbar=no, status=yes, scrollbars=no, resizable=no");
		ColdFusion.navigate('RecordListingDetail.cfm?code=new','listing');
	}
	
	
	function recordedit(code) {
	    // window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 390, height= 240, toolbar=no, status=yes, scrollbars=no, resizable=no");
		ColdFusion.navigate('RecordListingDetail.cfm?code='+code,'listing');
	}

	function editApplication(code){
		alert('Under development');
	}
	
	function showModules(code){
		line = document.getElementById(code+'_list');
		if (line.className == "hide"){
			line.className ="regular";
			ColdFusion.navigate('List.cfm?code='+code,code+'_list');
		}else{
			line.className = "hide";
		}
	}
	
	function submitModule(application,module){
		cell = document.getElementById('td_'+application+'_'+module);

		if (cell.style.backgroundColor == '##ffffcf')
			cell.style.backgroundColor = 'ffffff'
		else
			cell.style.backgroundColor = 'ffffcf'
		
		ColdFusion.navigate('ListSubmit.cfm?application='+application,'submit_'+application,'','','POST','moduleform_'+application)
	}
	
	function save(action) {
	   document.applicationform.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ColdFusion.navigate('RecordListingSubmit.cfm?action='+action,'listing','','','POST','applicationform')
		 }   
	 }
	 
	 function deleteApplication(application){
		if (confirm('Are you sure you want to delete this record?')){
			 ColdFusion.navigate('RecordListingPurge.cfm?application='+application,'listing');
		}
	 }
	
</script>

</cfoutput>

<table width="98%">
	<tr>
		<td id="listing">
			<cfinclude template="RecordListingDetail.cfm">
		</td>
	</tr>
</table>