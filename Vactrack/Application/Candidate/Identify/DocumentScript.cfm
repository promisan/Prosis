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
	
	function rostersearch(action,actionid,ajaxid,param) {  	
		ProsisUI.createWindow('mycandidate', 'Identify Candidates', '',{x:100,y:100,height:document.body.clientHeight-120,width:document.body.clientWidth-120,modal:true,resizable:false,center:true})    					
	    ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Identify/DocumentCandidate.cfm?wparam='+param+'&mode=vacancy&wActionId='+actionid+'&docno=#Doc.DocumentNo#&functionno=#Doc.FunctionNo#','mycandidate')
	}
	
	function personprofile(doc,per) {
	
	    if (document.getElementById('detailbox')) {
	    	ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/CandidateProfile.cfm?documentno=#Object.ObjectKeyValue1#&PersonNo='+per,'detailbox')
		    expandArea('mybox','detailbox')
		} else {
		  	ProsisUI.createWindow('detailbox', 'Profile', '',{x:100,y:100,height:document.body.clientHeight-40,width:document.body.clientWidth-120,modal:true,resizable:false,center:true})    					
			ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/CandidateProfile.cfm?documentno=#Object.ObjectKeyValue1#&PersonNo='+per,'detailbox')	
		}
	}	

</script>

</cfoutput>
