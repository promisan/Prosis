
<cfquery name="Doc" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Document
	WHERE DocumentNo = '#Object.ObjectKeyValue1#'
</cfquery>

<cfoutput>

<script language="JavaScript">
	
	function rostersearch(action,actionid,ajaxid) {  
		ProsisUI.createWindow('mycandidate', 'Identify Candidates', '',{x:100,y:100,height:document.body.clientHeight-20,width:document.body.clientWidth-20,modal:true,resizable:false,center:true})    					
	    ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Identify/DocumentCandidate.cfm?mode=vacancy&wActionId='+actionid+'&docno=#Doc.DocumentNo#&functionno=#Doc.FunctionNo#','mycandidate')
	}
	
	function personprofile(doc,per) {
		ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/CandidateProfile.cfm?documentno=#Object.ObjectKeyValue1#&PersonNo='+per,'detailbox')
		expandArea('mybox','detailbox')
	}	

</script>

</cfoutput>
