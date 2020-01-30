
<cfparam name="url.openas" default="edit">

<cf_screentop label="Edit #path#" height="100%" scroll="No" banner="gray" line="no" layout="webapp">
	
	<cfoutput>
	
		<iframe src    = "#SESSION.root#/Tools/Document/FileContent.cfm?openas=#url.openas#&mode=edit&path=#SESSION.rootpath#\#path#&subdir=&name=" 
		   width       = "100%" 
		   height      = "100%" 
		   frameborder = "0">
	    </iframe>
	
	</cfoutput>

<cf_screenbottom layout="webapp">
