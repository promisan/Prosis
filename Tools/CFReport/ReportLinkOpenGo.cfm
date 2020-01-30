

<cfoutput>
	<script>
	    <!--- stop and start the progress bar --->	
		try{
		    ColdFusion.ProgressBar.stop('pBar', true)	
		    ColdFusion.ProgressBar.start('pBar')					
		}	
		catch(ex){}

		window.report.location = "ReportSQL8.cfm?reportId=#URL.reportid#&mode=#url.mode#&category=#url.category#&userid=#url.userid#"	
	</script>	
</cfoutput>

<cf_compression>
