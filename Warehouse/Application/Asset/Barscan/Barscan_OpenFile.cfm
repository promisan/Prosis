

<!--- security check --->
<CFIF Find( '..', URL.ServerFile )
	or Find( '\', URL.ServerFile )
	>
	Error: You are not allowed to access this file
	<CFABORT>
</CFIF>



<!--- parameters --->
<CFSET LibraryDirectory = #SESSION.rootPath#&"\asset\barscanFiles">
<CFSET FilePath = "#LibraryDirectory#\#URL.ServerFile#">


<!--- extract the file extension --->
<CFSET SeparatorPos = Find( '.', Reverse(URL.ServerFile) )>
<CFIF SeparatorPos is 0> <!--- separator not found --->
	<CFSET FileExt = ''>
<CFELSE>
	<CFSET FileExt = Right( URL.ServerFile, SeparatorPos - 1 )>
</CFIF>


<!--- find the proper MIME type --->
<CFIF FileExt is ''>			<CFSET FileType = "unknown">
<CFELSEIF FileExt is 'pdf'>		<CFSET FileType = "application/pdf">
<CFELSEIF FileExt is 'aif'>		<CFSET FileType = "audio/aiff">
<CFELSEIF FileExt is 'aiff'>	<CFSET FileType = "audio/aiff">
<CFELSEIF FileExt is 'art'>		<CFSET FileType = "image/x-jg">
<CFELSEIF FileExt is 'cil'>		<CFSET FileType = "application/vnd.ms-artgalry">
<CFELSEIF FileExt is 'gif'>		<CFSET FileType = "image/gif">
<CFELSEIF FileExt is 'htm'>		<CFSET FileType = "text/html">
<CFELSEIF FileExt is 'html'>	<CFSET FileType = "text/html">
<CFELSE>						<CFSET FileType = "unknown">
</CFIF>


<!--- return requested file --->
<CFCONTENT TYPE="#FileType#" 
	FILE="#FilePath#"
>
