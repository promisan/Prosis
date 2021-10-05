<cf_param name="url.acc" 		  default="#session.acc#" type="string">
<cf_param name="url.width" 		  default="54px"			type="string">
<cf_param name="url.height" 	  default="44px"			type="string">
<cf_param name="url.destination"  default="EmployeePhoto" type="string">
<cf_param name="url.style" 		  default="" 				type="string">

<cfoutput>

	<cf_assignid>
	
	<cfif FileExists("#SESSION.rootDocumentPath#\#url.destination#\#url.acc#.jpg") and url.acc neq "">
		
		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		<cfset mid = oSecurity.gethash()/>
		
		<cftry>
			<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\CFRStage\EmployeePhoto">
			<cfcatch></cfcatch>
	    </cftry>
				
		<cffile action="COPY"
				source="#SESSION.rootDocumentpath#\#url.destination#\#url.acc#.jpg"
				destination="#SESSION.rootDocumentPath#\CFRStage\EmployeePhoto\#url.acc#.jpg" nameconflict="OVERWRITE">
			
		<img src="#SESSION.root#/CFRStage/getFile.cfm?id=#url.acc#.jpg&mode=EmployeePhoto&mid=#mid#"
			border="0px"
			style="display:block; cursor:pointer; height:#url.height#; width:#url.width#; #url.style#"
			align="absmiddle">

	<cfelse>
	
		<img src="#SESSION.root#/Images/Logos/no-picture-male.png"			
			title="Click here to add a Profile Picture"
			border="0px"
			align="absmiddle"
			style="display:block; cursor:pointer; height:#url.height#; width:#url.width#; #url.style#">

	</cfif>

</cfoutput>