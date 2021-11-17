
<!--- 
 <cf_screentop 
	  html   = "No" 
	  label  = "#url.mission# Projects - #url.period#"
	  height = "99%" 
	  scroll = "no" 
	  banner = "blue" 
	  jquery = "yes"
	  user	 = "no"
	  layout = "webapp">
	  --->
	  
<cfoutput>

    <cfparam name="url.mid" default="">
	
	<iframe 
		name="projectListingContainer" 
		height="99%" 
		width="100%" 
		frameborder="0" 
		src="#session.root#/Procurement/Application/Requisition/Program/ProgramListingContent.cfm?mission=#url.mission#&period=#url.period#&mid=#url.mid#">
	</iframe>
</cfoutput>