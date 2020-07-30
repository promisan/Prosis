
<cf_CalendarScript>
<cf_FileLibraryScript>
  
<cfoutput>
	
	<script language="JavaScript">
		
		function issuedocument(persno) {
		    ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/DocumentEntry.cfm?ID=' + persno,'detail');
		}
		
		function edit(persno,doc) {
		    ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/DocumentEdit.cfm?ID=' + persno + '&id1=' + doc,'detail');
		}
						
		function reloadForm(id,st) {
		    _cf_loadingtexthtml='';			
		    ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/EmployeeDocumentDetail.cfm?ID='+id+'&Status=' + st,'detail');
		}
	
	</script>

</cfoutput>