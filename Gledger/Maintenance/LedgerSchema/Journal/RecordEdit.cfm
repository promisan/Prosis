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
<cfajaximport tags="cfform">

<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Journal
	WHERE  Journal = '#URL.ID1#'
</cfquery>
 
<cfoutput>
	
	<script language="JavaScript">
	
	function validate() {
		document.editform.onsubmit() 
		if( _CF_error_messages.length == 0 ) {        
			ptoken.navigate('RecordSubmit.cfm?action=save','contentbox1','','','POST','editform')
		 }   
	}	 	
	
	function validatereq() {
		document.reqform.onsubmit() 
		if( _CF_error_messages.length == 0 ) {        	
			ptoken.navigate('ServiceItemRequestSubmit.cfm?id1=#url.id1#','contentbox2','','','POST','reqform')
		 }   
	}	
	
	function applyaccount(acc) {
   		ptoken.navigate('setAccount.cfm?account='+acc,'process')
	}   
	
	function askjournal() {
		if (confirm("Do you want to remove this Journal ?")) {		
		ptoken.navigate('RecordSubmit.cfm?mode=delete','contentbox1','','','POST','f_journal_edit')
		}	
		return false	
	}	
	
	function do_submit() {	
		ptoken.navigate('RecordSubmit.cfm?mode=update','contentbox1','','','POST','f_journal_edit');
		ptoken.navigate('RecordActionSubmit.cfm?mode=update','contentbox2','','','POST','f_journal_action');
		
	}
	
	</script>

</cfoutput>

<!--- edit form --->

<cf_screentop height="100%" label="#get.Journal# #get.Description#" 
   option="Maintain journal settings" line="no" scroll="No" layout="webapp" jquery="Yes" banner="blue">

<table width="94%" height="100%" cellspacing="0" cellpadding="0" align="center">
	
	<cfoutput>
			
	<tr><td colspan="2" style="padding-top:8px">
    	<cfinclude template="RecordEditTab.cfm">
	</td></tr>
		
    </cfoutput>
 	
</TABLE>

<cf_screenbottom layout="webapp">

