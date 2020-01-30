
<cfif Form.OrgUnit eq "">

	  <cf_waitEnd Frm="result">	
      <cf_tl id="Your have to identify a unit." var="1">
	  <cf_alert message = "#lt_text#">
	  <cfabort>
	  
</cfif>

<cf_systemscript>

<cfinclude template="RequestEntrySubmitAction.cfm">

<cfoutput>
	<script language="JavaScript">	
	     try {		     	
	     opener.document.getElementById('treerefresh').click()
		 } catch(e) {}
		 ptoken.location("document.cfm?drillid=#url.drillid#") 		 		 		 
	</script>
</cfoutput>
