<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->


<cfparam name="URL.docid"        default="">
<cfparam name="URL.id0"          default="">
<cfparam name="URL.id1"          default="">
<cfparam name="URL.id2"          default="">
<cfparam name="URL.id3"          default="">

<cfparam name="URL.mode"           default="dialog">
<cfparam name="URL.templatepath"   default="#url.id0#">

<cfparam name="URL.subject"        default="#URL.ID1#">
<cfparam name="URL.to"             default="xxxx@un.org">
<cfparam name="URL.filename"       default="Document">
<cfparam name="URL.format"         default="PDF">
<cfparam name="URL.marginTop"      default="2.2">
<cfparam name="URL.marginBottom"   default="0.5">
<cfparam name="URL.scale"          default="89">
<cfparam name="URL.orientation"    default="portrait">
<cfparam name="URL.renderer"       default="CFDOC">

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

	<cfset renderer = "#URL.renderer#">
	<cfset password = "">
	<cfset encryption = "none">
	
</cfif>		 

<TITLE><cfoutput>#URL.ID1#</cfoutput></TITLE>

<cfif not DirectoryExists("#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\")>

	   <cfdirectory 
	     action="CREATE" 
            directory="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\">

</cfif>

<cfif not DirectoryExists("#SESSION.rootdocumentpath#\CFRStage\User\#SESSION.acc#\")>

	   <cfdirectory 
	     action="CREATE" 
            directory="#SESSION.rootdocumentpath#\CFRStage\User\#SESSION.acc#\">

</cfif>

<cfset FileNo = round(Rand()*100)>

<cfset attach = "#URL.FileName#_#FileNo#">

<cfset vpath="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#attach#">
<cfset vpath=replace(vpath,"\\","\","ALL")>
<cfset vpath=replace(vpath,"//","/","ALL")>

<cfset vspath="#SESSION.rootdocumentpath#\CFRStage\User\#SESSION.acc#\#attach#">


<cfif URL.ID eq "Mail">	
  		
	<cfif FindNoCase(".cfm", URL.templatepath)>
	
		<cfif renderer neq "HTMPDF">
	
			<cfdocument 
		      format            = "#URL.format#"
		      pagetype          = "letter"
			  overwrite         = "yes"
			  filename          = "#vsPath#.pdf"
			  margintop         = "#URL.marginTop#"
			  marginbottom      = "#URL.marginBottom#"
		      marginright       = "0"
		      marginleft        = "0"
		      orientation       = "#URL.orientation#"
		      unit              = "cm"
		      fontembed         = "Yes"
		      scale             = "#URL.scale#"
		      backgroundvisible = "Yes">
			  
			  <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">		  		  		  		  
			  <cfinclude template="../../#URL.templatepath#">
			  			
			</cfdocument>	
		
		<cfelse>
		
		    <cfsavecontent variable="documentcontent">		
				<cfinclude template="../../#URL.templatepath#">
			</cfsavecontent>		
		
			<cffile action="WRITE" 
	          file="#vsPath#.htm" 
			  output="#DocumentContent#" 
			  addnewline="Yes" 
			  fixnewline="No">	
											 
			 <!--- on-the-fly converter of htm content to pdf --->  
		     <cf_htm_pdf fileIn= "#vsPath#">		

		</cfif>							
				
	<cfelse>
	
		<cfquery name="Parameter" 
		datasource="AppsInit">
			SELECT * 
			FROM   Parameter
			WHERE  HostName = '#CGI.HTTP_HOST#'  
		</cfquery>
			
		<cfset rep    = replace(url.templatepath,"/","\","ALL")>		
		<cfset vspath = replace(vspath,"\\","\","ALL")>		
		
		<cfreport 
		   template     = "#SESSION.rootPath##rep#" 
		   format       = "#URL.Format#" 
		   overwrite    = "yes" 
		   encryption   = "none"
		   filename     = "#vsPath#.pdf">
			
			<!--- other variables --->					
			<cfreportparam name = "root"            value="#SESSION.root#">
			<cfreportparam name = "logoPath"        value="#Parameter.LogoPath#">
			<cfreportparam name = "logoFileName"    value="#Parameter.LogoFileName#">
			<cfreportparam name = "system"          value="#SESSION.welcome#">	
			<cfreportparam name = "ID"              value="#URL.ID1#">
			<cfreportparam name = "ID2"  			value="#URL.ID2#">
			<cfreportparam name = "ID3"  			value="#URL.ID3#">
			<cfreportparam name = "dateformatshow"  value="#CLIENT.DateFormatShow#"> 
			
		</cfreport>	

	</cfif>
				
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/> 	
		
	<cfoutput>
	<script language="JavaScript">	        
			window.location = "#SESSION.root#/Tools/Mail/Mail.cfm?mode=#url.mode#&Subject=#URL.Subject#&ID1=#URL.ID1#&ID2=#attach#.pdf&Source=Action&Sourceid=#URL.ID#&ID=#url.to#&mid=#mid#"
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
		
		     <!--- CF format --->
	    
		 	<cfdocument 
			      format            = "#URL.Format#"
			      pagetype          = "letter"
				  overwrite         = "yes"
				  filename          = "#vsPath#.pdf"
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
	          file="#vsPath#.htm" 
			  output="#DocumentContent#" 
			  addnewline="Yes" 
			  fixnewline="No">	
											 
			 <!--- on-the-fly converter of htm content to pdf --->  
		     <cf_htm_pdf fileIn= "#vsPath#">		
	
		</cfif>		
	
	<cfelse>	
		
		<cfset rep=replace(url.templatepath,"/","\","ALL")>
		
		
		<cfset vspath=replace(vspath,"//","/","ALL")>
		<cfset vspath=replace(vspath,"\\","\","ALL")>

		<cfreport 
		   template     = "#SESSION.rootPath##rep#" 
		   format       = "#URL.Format#" 
		   overwrite    = "yes" 
		   encryption   = "none"
		   filename     = "#vspath#.pdf">
				<cfreportparam name = "ID"  value="#URL.ID1#">
				<cfreportparam name = "ID2"  value="#URL.ID2#">
				<cfreportparam name = "ID3"  value="#URL.ID3#">

		</cfreport>	
		
	</cfif>
	
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/> 
	<cfset vFile = "#SESSION.acc#\#attach#.pdf">
	<cfoutput>

	<script language="JavaScript">	
			window.location = "#SESSION.root#/CFRStage/getFile.cfm?id=#EncodeForURL(vFile)#&mid=#mid#"
	</script>
	</cfoutput>

</cfif>
