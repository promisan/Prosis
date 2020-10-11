
<cf_screentop html="No" jquery="Yes">
<cf_textareaScript>
<cf_calendarscript>

<cfoutput>
	
	<script>
	
		function saveTarget(programcode,period,targetid,cat,programaccess) {
				document.frmTarget.onsubmit() 
				if( _CF_error_messages.length == 0 ) {
	            	ptoken.navigate('#SESSION.root#/ProgramREM/application/Program/Target/TargetSubmit.cfm?programcode='+programcode+'&period='+period+'&targetid='+targetid+'&category='+cat+'&programaccess='+programaccess,'targetsubmit','','','POST','frmTarget')
				 }   
			}	 
			
	</script>

</cfoutput>

<cfajaximport tags="cfform">

<table width="100%" style="height:100%"><tr><td style="height:100%;padding:15px">
	<cf_divscroll style="height:100%">
	<cfdiv bind="url:#session.root#/ProgramREM/application/Program/Target/TargetEdit.cfm?programcode=#url.programcode#&period=#url.period#&category=#url.category#&targetid=#url.targetid#&programaccess=#url.programaccess#">	
	</cf_divscroll>
</td></tr></table>