

<div id="fileshelf">
	<div class="widrelwrapper">
		<div id="fileshelftitle">
			<cf_tl id="File Shelf">
			<div id="addfile">+</div>
		</div>
		
		<div id="fileshelfcontent">

		<cfinclude template="FileShelfContent.cfm">

		
		</div>
		<cfoutput>
		<div class="widgetclose" onclick="widgetclose('fileshelf','#SystemFunctionId#')">X</div>
		</cfoutput>
	</div>
</div>