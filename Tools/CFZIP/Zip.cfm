<cfparam name="attributes.output">
<cfparam name="attributes.filelist"            default = "">
<cfparam name="attributes.savepath"            default = "No">
<cfparam name="attributes.recursedirectory"    default = "Yes">


<cfsetting enablecfoutputonly="yes">

<cfzip file         = "#attributes.output#"
		overwrite   = "yes">
	<cfloop list="#attributes.filelist#" index="vFile">			
		<cfif fileexists(vFile)>
			<cfset vFile = replace(vFile,"//","/","all")>
			<cfset vFile = replace(vFile,"\\","\","all")>			
			
			<cfset vFileDestination = replace(vFile,SESSION.rootpath,"./")>
			
			<cfif attributes.savepath eq "Yes">				
				<cfzipparam
					entrypath  = "#vFile#" 
					source     = "#vFile#"/>
			<cfelse>
				<cfzipparam
					source     = "#vFile#"/>
			</cfif>
		</cfif>			
	</cfloop>			
</cfzip>


<cfsetting enablecfoutputonly="no">
