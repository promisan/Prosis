
<cf_screentop label="Process Budget Action" 
     height="100%" line="no" 
	 jQuery="Yes" 	
	 banner="red" 
	 bannerforce="Yes"
	 scroll="Yes" 
	 layout="webapp" 
	 html="Yes">
	 
<!--- view of the action to be processed --->

<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_dialogREMProgram>
<cfajaximport tags="cfform">
<cfoutput>

<script language="JavaScript">

	function changeReference(id) {
	   _cf_loadingtexthtml='';	
		ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Budget/Action/AllotmentActionReferenceEdit.cfm?editreference=1&id='+id, 'tdReference');
	}
	
	function submitActionReference(id) {
	    _cf_loadingtexthtml='';	
		ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Budget/Action/AllotmentActionReferenceEditSubmit.cfm?id='+id, 'tdReference','','','POST','editreference');	
	}

</script>
</cfoutput>

<cf_divscroll>

<cfinclude template="AllotmentActionViewContent.cfm">

</cf_divscroll>

<cf_screenbottom layout="webapp">
