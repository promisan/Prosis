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
<cfoutput>
   
<cfajaxproxy cfc="Service.Process.System.UserController" jsclassname="systemcontroller">
   
<script language="JavaScript">
	
	function reload() { 
	   opener.location.reload();
	   window.close();
	}
	
	function setappno(app) {  
	   parent.frames[0].applicantmenu.applicantno.value = app;
	}
	
	function more(bx) {
	
	    icM  = document.getElementById(bx+"Min")
	    icE  = document.getElementById(bx+"Exp")
		se   = document.getElementById(bx)
			
		if (se.className == "hide")	{
			se.className  = "regular";
			icM.className = "regular";
	    	icE.className = "hide";
		} else	{
			se.className  = "hide";
	    	icM.className = "hide";
		    icE.className = "regular";
		}
	}
	
	function submitPHP(app) {
		ptoken.location('#SESSION.root#/Roster/Candidate/Details/PHPIssue.cfm?ID1='+app)
	}

</script>  

	
	<cfquery name="Owner" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 *
		FROM   Ref_ParameterOwner
	</cfquery>

	<cfif Owner.PathHistoryProfile eq "">
		<cfset path = "Roster/PHP/PDF/PHP_Combined_List.cfm">
	<cfelse>
	    <cfset path = "Custom/#Owner.PathHistoryProfile#">
	</cfif>
	
	<script language="JavaScript">

		function printingPHP(roster,format,script) {
						
			document.getElementById("php_"+script).className = "hide"
			document.getElementById("wait_"+script).className = "regular"
													
			var uController = new systemcontroller();

			url = "#SESSION.root#/#path#?PHP_Roster_List="+roster+"&FileNo="+script	
																			
	 		AjaxRequest.get({			
	        'url':url,    	    
			'onSuccess':function(req) { 	
			 document.getElementById("php_"+script).className = "regular"
			 document.getElementById("wait_"+script).className = "hide"
			 window.open("#SESSION.root#/cfrstage/getFile.cfm?file=php_"+script+".pdf&mid="+ uController.GetMid(),"php_"+script)
			
          	  },					
    	    'onError':function(req) { 	
			 document.getElementById("wait_"+script).className = "hide"
			 alert("An error has occurred upon preparing this PHP. A notification email was sent to the administrator.")}	
    	     });	
					
		 }

	</script>
	
</cfoutput>

<cf_actionListingScript>
<cf_FileLibraryScript>

<cf_securediv bind="url:#SESSION.root#/roster/candidate/details/applicant/ApplicantDetail.cfm?id=#url.id#" id="boxappdetail">
   