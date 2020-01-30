

<cfif FileExists('#SESSION.rootDocumentPath#\EmployeeFiles\#SESSION.acc#\#SESSION.acc#_notes.txt')>
	<cffile 
		action = "read" 
		file = "#SESSION.rootDocumentPath#\EmployeeFiles\#SESSION.acc#\#SESSION.acc#_notes.txt"
		variable = "text">	
<cfelse>
	<cfparam name="text" default="">
</cfif>
				
<div id="notepad">
	<div class="widrelwrapper">
		<div id="notepadtitle"><cf_tl id="notes"></div>
		<cfoutput>
		<form name="wfile" action="widgets/notepad/NotePadSubmit.cfm?account=#SESSION.acc#" method="post" target="tfbox" enctype="multipart/form-data">
		<div id="notepadcontent">
			<textarea rows="9" id="tanotepadcontent" name="tanotepadcontent" style="text-align:left"><cfoutput>#text#</cfoutput></textarea>
		</div>

			<button class="npsave" type="submit"><cf_tl id="Save"></button>

		</form>
		
		<div class="widgetclose" onclick="widgetclose('notepad','#SystemFunctionId#')">X</div>
	</cfoutput>
	
	<iframe name="tfbox"
		id="tfbox"
		width="5px"
		height="5px"
		scrolling="no"
		frameborder="0" 
		style="display:none">		
	</iframe>
	
	</div>
</div>