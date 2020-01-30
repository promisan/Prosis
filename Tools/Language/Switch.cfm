<cf_param name="url.id" default="" type="String">


<cfset CLIENT.LanguageId    = "#URL.ID#">

<cfquery name="Language" 
 datasource="AppsSystem">
 	 SELECT *
	 FROM   Ref_SystemLanguage
	 WHERE  Code = '#URL.ID#'
</cfquery> 

<!--- CONSIDER REMOVAL DEPRECATED --->
<cfif Language.SystemDefault eq "1" or Language.Operational eq "1">
   <cfset CLIENT.LanPrefix     = ""> 
<cfelse>   
   <cfset CLIENT.LanPrefix     = "xl#URL.ID#_">
</cfif>

<cfoutput>

	<cfif URL.Menu eq "yes">
								
		<cfquery name="Language" 
		 datasource="AppsSystem">
		 	 SELECT *
			 FROM   Ref_SystemLanguage	
		</cfquery> 	
		
		<cfset link = CGI.HTTP_REFERER>
		
		<cf_param name="link" default="" type="String">
		<cf_param name="CGI.HTTP_HOST"   default="" type="String">
		
		<cfquery name="Parameter" 
				datasource="AppsInit">
				SELECT *
				FROM   Parameter 
				WHERE  HostName    = '#CGI.HTTP_HOST#'
				AND    Operational = 1
		</cfquery>
		
		<cfif Parameter.recordcount neq 0>
		
			<cfif FindNoCase(CGI.HTTP_HOST,CGI.HTTP_REFERER) gt 0>
		
				<cfloop query="Language">
					<cfset link = replace("#link#","?mde=language#code#","")>
					<cfset link = replace("#link#","&mde=language#code#","")>
				</cfloop>
												
				<cfif find("?","#link#")>
				 
					<script language="JavaScript">			  
					   ptoken.location("#link#&mde=language#URL.ID#");
					</script>
				
				<cfelse>
				
					<script language="JavaScript">			  
					   ptoken.location("#link#?mde=language#URL.ID#");
					</script>
				
				</cfif>	

			</cfif>
			
		</cfif>
	</cfif>

</cfoutput>	