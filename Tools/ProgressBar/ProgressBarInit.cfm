
<!--- init progress bar with a variable to make it unique in case there are several progress bars in the screen --->

<cfparam name="url.name"  default="myname">

<cfset SESSION["Count_#url.name#"] = 0>
<cfset SESSION["Base_#url.name#"]  = 1>

<cfoutput>

	<script>
  	
	Prosis.busy('yes')	
	try { clearInterval ( progressrefresh_#url.name# ) } catch(e) {}								
	progressrefresh_#url.name# = setInterval('_cf_loadingtexthtml="";ColdFusion.navigate("#session.root#/tools/ProgressBar/ProgressBar.cfm?name=#url.name#","progressbox")',2500) 												
		
	</script>
	
	
</cfoutput>
