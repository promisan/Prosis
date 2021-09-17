
<cfparam name="URL.docid"          default="">
<cfparam name="URL.id0"            default="">
<cfparam name="URL.templatepath"   default="#url.id0#">

<cfparam name="URL.subject"        default="#URL.ID1#">
<cfparam name="URL.filename"       default="Document">
<cfparam name="URL.format"         default="PDF">
<cfparam name="URL.marginTop"      default="2.2">
<cfparam name="URL.marginBottom"   default="0.5">
<cfparam name="URL.scale"          default="89">
<cfparam name="URL.orientation"    default="portrait">

<cfif url.docid neq "">

	<cfquery name="Document" 
  	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
  	  password="#SESSION.dbpw#">
	    SELECT * 
   		FROM   Ref_EntityDocument 
		WHERE  DocumentId  = '#url.docid#'
	</cfquery>
	
	<cfset url.templatepath = Document.DocumentTemplate>
	<cfset password         = Document.DocumentPassword>
	
	<cfif Document.documentEditor eq "HTMPDF">
		<cfset renderer = Document.DocumentEditor>
	<cfelse>
		<cfset renderer = "CFDOC">
	</cfif>	
	
	<cfset encryption = "128-bit">

<cfelse>

	<cfset renderer = "CFDOC">
	<cfset password = "">
	<cfset encryption = "none">
	
</cfif>		 


<TITLE><cfoutput>#URL.ID1#</cfoutput></TITLE>

<cfif not DirectoryExists("#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\")>

	   <cfdirectory 
	     action="CREATE" 
            directory="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\">

</cfif>


<cfset FileNo = round(Rand()*100)>

<cfset attach = "#URL.FileName#_#FileNo#">

<cfset vpath="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#attach#">

<cfset vpath=replace(vpath,"\\","\","ALL")>
<cfset vpath=replace(vpath,"//","/","ALL")>


<cfif URL.ID eq "Mail">	
  		
	<cfif FindNoCase(".cfm", URL.templatepath)>
	
		<cfdocument 
	      format       = "#URL.format#"
	      pagetype     = "letter"
		  overwrite    = "yes"
		  filename     = "#vPath#.pdf"
		  margintop    = "#URL.marginTop#"
		  marginbottom = "#URL.marginBottom#"
	      marginright  = "0"
	      marginleft   = "0"
	      orientation  = "#URL.orientation#"
	      unit         = "cm"
	      fontembed    = "Yes"
	      scale        = "#URL.scale#"
	      backgroundvisible="Yes">
		  
		  
		  <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
		  		  		  		  
		  <cfinclude template="../../#URL.templatepath#">
		  			
		</cfdocument>	
				
	<cfelse>
	
		<cfquery name="Parameter" 
		datasource="AppsInit">
			SELECT * 
			FROM Parameter
			WHERE HostName = '#CGI.HTTP_HOST#'  
		</cfquery>
	
		<cfset rep=replace(url.templatepath,"/","\","ALL")>
		
		<cfreport 
		   template     = "#SESSION.rootPath##rep#" 
		   format       = "#URL.Format#" 
		   overwrite    = "yes" 
		   encryption   = "none"
		   filename     = "#vPath#.pdf">
			
			<!--- other variables --->					
			<cfreportparam name = "root"            value="#SESSION.root#">
			<cfreportparam name = "logoPath"        value="#Parameter.LogoPath#">
			<cfreportparam name = "logoFileName"    value="#Parameter.LogoFileName#">
			<cfreportparam name = "system"          value="#SESSION.welcome#">	
			<cfreportparam name = "ID"              value="#URL.ID1#"> 			
			<cfreportparam name = "dateformatshow"  value="#CLIENT.DateFormatShow#"> 
			
		</cfreport>	

	</cfif>
		
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/> 
		
	<cfoutput>
	<script language="JavaScript">
			window.location = "#SESSION.root#/Tools/Mail/Mail.cfm?Subject=#URL.Subject#&ID1=#URL.ID1#&ID2=#attach#&Source=Action&Sourceid=#URL.ID#&Mode=Dialog&GUI=HTML&mid=#mid#"
	</script>
	</cfoutput>
		
<cfelseif URL.Id eq "HTM">

	  <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
	
	  <cfinclude template="../../#URL.templatepath#">		
	  
	  <script>	  
	   window.print()	  
	  </script>

<cfelse>
	  	
	<cfif FindNoCase(".cfm", URL.templatepath)>
	
		<cfif renderer neq "HTMPDF">	
		
		     <!--- format --->
	    
		 	<cfdocument 
			      format            = "#URL.Format#"
			      pagetype          = "letter"
				  overwrite         = "yes"
				  filename          = "#vPath#.pdf"
				  margintop         = "#URL.marginTop#"
				  marginbottom      = "#URL.marginBottom#"
			      marginright       = "0"
			      marginleft        = "0"
			      orientation       = "#URL.orientation#"
			      unit              = "cm"
			      encryption        = "none"
			      fontembed         = "No"
			      scale             = "#URL.scale#"
			      backgroundvisible = "Yes">
					  
				  <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
				  
				  <cfinclude template="../../#URL.templatepath#">
				 		
			</cfdocument>	
		
		<cfelse>
		
			<cfsavecontent variable="documentcontent">		
			<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
			<cfinclude template="../../#URL.templatepath#">
			</cfsavecontent>		
		
			<cffile action="WRITE" 
	          file="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#attach#.htm" 
			  output="#DocumentContent#" 
			  addnewline="Yes" 
			  fixnewline="No">	
			  
			  <cfoutput>#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#attach#.pdf</cfoutput>	
								 
								<!--- on-the-fly converter of htm content to pdf --->  
		      <cf_htm_pdf fileIn= "#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#attach#">
		
		</cfif>
		
		
	
	<cfelse>	
		
		<cfset rep=replace(url.templatepath,"/","\","ALL")>
			
		<cfreport 
		   template     = "#SESSION.rootPath##rep#" 
		   format       = "#URL.Format#" 
		   overwrite    = "yes" 
		   encryption   = "none"
		   filename     = "#vpath#.pdf">
				<cfreportparam name = "ID"  value="#URL.ID1#"> 
		</cfreport>	

	</cfif>

	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/> 
	
	<cfoutput>
	<script language="JavaScript">
			window.location = "#SESSION.root#/CFRStage/User/#SESSION.acc#/#attach#.pdf"
	</script>
	</cfoutput>

</cfif>
