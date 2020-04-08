   
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
	window.location = "<cfoutput>#SESSION.root#</cfoutput>/Roster/Candidate/Details/PHPIssue.cfm?ID1="+app
}

</script>  

<cfoutput>
	
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
													

			url = "#SESSION.root#/#path#?PHP_Roster_List="+roster+"&FileNo="+script	
																			
	 		AjaxRequest.get({			
	        'url':url,    	    
			'onSuccess':function(req) { 	
			 document.getElementById("php_"+script).className = "regular"
			 document.getElementById("wait_"+script).className = "hide"
		  	 window.open("#SESSION.root#/cfrstage/user/#SESSION.acc#/php_"+script+".pdf?ts="+new Date().getTime(),"php_"+script, "location=no, toolbar=no, scrollbars=yes, resizable=yes")
			
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

<cfdiv bind="url:#SESSION.root#/roster/candidate/details/applicant/ApplicantDetail.cfm?id=#url.id#" id="boxappdetail">
   