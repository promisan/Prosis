<cfparam name="url.id1" 		default="">
<cfparam name="url.id2" 		default="">
<cfparam name="url.id3" 		default="">
<cfparam name="url.id4"			default="">
<cfparam name="url.id5" 		default="">
<cfparam name="url.id6" 		default="">
<cfparam name="url.id7" 		default="">
<cfparam name="url.id8" 		default="">
<cfparam name="url.id9" 		default="">
<cfparam name="url.id10" 		default="">
<cfparam name="URL.filename"    default="Document">

<cfset url.template = replace(url.template,"/","\","ALL")>

<cfset vTemplate = "#SESSION.rootpath##url.template#">

<cfif not DirectoryExists("#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\")>

	   <cfdirectory action="CREATE" 
            directory="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\">

</cfif>

<cfset FileNo = round(Rand()*100)>
<cfset attach = "#URL.FileName#_#FileNo#.pdf">

<cfset vpath="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#attach#">

<cfset vpath=replace(vpath,"\\","\","ALL")>
<cfset vpath=replace(vpath,"//","/","ALL")>

<cfif FileExists(vpath)>
	<cffile action="DELETE" file="#vpath#">
</cfif>

<cfreport template = "#vTemplate#" format="PDF" overwrite="yes" filename = "#vPath#">
	<cfreportparam name = "id1"  value="#url.id1#"> 
	<cfreportparam name = "id2"  value="#url.id2#">
	<cfreportparam name = "id3"  value="#url.id3#">
	<cfreportparam name = "id4"  value="#url.id4#">
	<cfreportparam name = "id5"  value="#url.id5#">
	<cfreportparam name = "id6"  value="#url.id6#">
	<cfreportparam name = "id7"  value="#url.id7#">
	<cfreportparam name = "id8"  value="#url.id8#">
	<cfreportparam name = "id9"  value="#url.id9#">
	<cfreportparam name = "id10"  value="#url.id10#">
</cfreport>

<cfoutput>
<script language="JavaScript">
		window.location = "#SESSION.root#/CFRStage/User/#SESSION.acc#/#attach#?ts=#GetTickCount()#";
</script>
</cfoutput>
