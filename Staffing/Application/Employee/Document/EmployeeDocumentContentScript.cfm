
<cf_CalendarScript>
<cf_FileLibraryScript>
<cf_dialogPosition>
  
<cfoutput>
	
	<script language="JavaScript">
		
		function issuedocument(persno) {
		    ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/DocumentEntry.cfm?ID=' + persno,'detail');
		}
		
		function edit(persno,doc) {
		    ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/DocumentEdit.cfm?ID=' + persno + '&id1=' + doc,'detail');
		}
						
		function reloadDocument(id,st) {
		    _cf_loadingtexthtml='';			
		    ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/EmployeeDocumentContent.cfm?ID='+id+'&Status=' + st,'detail');
		}
	
	</script>

</cfoutput>