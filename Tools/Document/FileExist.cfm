
<cfparam name="attributes.type"       default="File">
<cfparam name="attributes.datasource" default="AppsSystem">
<cfparam name="attributes.listinfo"   default="name">

<cfquery name="Attachment" 
			datasource="#attributes.datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
		    FROM      System.dbo.Ref_Attachment
			WHERE     DocumentPathName = '#Attributes.DocumentPath#'	
		</cfquery>
		
<cfif Attachment.recordcount eq "1">

    <CFParam name="Attributes.DocumentHost"    default="#attachment.documentfileserverroot#">

<cfelse>

	<CFParam name="Attributes.DocumentHost"    default="#SESSION.rootDocumentPath#\">

</cfif>		

<cfset DocumentHost = Attributes.DocumentHost> 
<cfset DocumentPath = Attributes.DocumentPath> 
<cfset subdirectory = Attributes.subdirectory> 
<cfset filter       = Attributes.filter> 

<cfdirectory action="LIST"
             directory="#documenthost#\#DocumentPath#\#SubDirectory#"
             name="GetFiles"
             filter="#Filter#*.*"
             sort="DateLastModified DESC"
             type="#attributes.type#"
             listinfo="#attributes.listinfo#">

<cfset caller.filelist = getfiles>		
<cfset caller.files    = getfiles.recordcount>	