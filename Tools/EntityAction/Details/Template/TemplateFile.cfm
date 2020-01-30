
<cfparam name="url.detailedit" default="yes">
<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

<cfquery name="Site" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   ParameterSite
	  WHERE  ServerRole = 'QA'	
	</cfquery>

	<cfquery name="Check" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   ObservationTemplate
	  WHERE  ObservationId  =  '#url.observationid#'
	  AND    ActionCode    = '#URL.actionCode#'
	  AND    PathName      = '#URL.PathName#' 
	  AND    FileName      = '#URL.FileName#' 
	</cfquery>
	
	<cfif Check.recordcount eq "0">
			
		<!--- copy from Master --->
		
		<cfquery name="Template" 
          datasource="AppsControl" 
          username="#SESSION.login#" 
          password="#SESSION.dbpw#">
             INSERT INTO ObservationTemplate
                 (ObservationId,ActionCode,PathName,FileName)
	          VALUES(    
	             '#url.observationid#',
	             '#URL.actionCode#',
	             '#URL.PathName#',
	             '#URL.FileName#') 
        </cfquery>

		<cfquery name="PriorContent" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_TemplateContent
			   (ApplicationServer,
			    PathName, 
				FileName,
				ObservationId, 
			    ActionCode, 
				TemplateModified, 
				TemplateOfficer, 
				TemplateGroup, 
				TemplateModifiedBy, 
				TemplateComments, 
	            TemplateSize, 
				TemplateContent)
			SELECT  TOP 1 
			          '#Site.ApplicationServer#',
			          PathName, 
					  FileName, 					  
					  '#url.observationid#',
					  '#URL.actionCode#',
					  TemplateModified, 
					  TemplateOfficer, 
					  TemplateGroup, 
					  TemplateModifiedBy, 
					  'Initial content', 
	                  TemplateSize, 
					  TemplateContent
			FROM      Ref_TemplateContent
			WHERE     ApplicationServer = '#Site.ApplicationServer#' 
			AND       PathName = '#URL.PathName#'
			AND       FileName = '#URL.FileName#'
			AND       VersionDate is not NULL <!--- take from daily batch --->
			ORDER BY  Created DESC		
		</cfquery>
		
				
		<!--- scan --->
		
		<!--- save the content --->
	
		<cfif URL.PathName eq "[root]">
											
			<cffile action = "read" 
			  file = "#SESSION.rootpath#\#url.filename#"
			  variable = "content">
			  
		<cfelse>
			
			<cffile action = "read" 
			  file = "#SESSION.rootpath#\#URL.PathName#\#URL.FileName#"
			  variable = "content">
			  
		</cfif>  
		
		<!--- scan content for structured fields --->
						
		<!---						
		<cfparam name="usr" default="Administrator">		
		<cfparam name="nme" default="Administrator">							
		<cfset com = "">
		<cfset des = "">
		--->
				
		<cfset grp = "[root]">
		<cfloop index="itm" list="#url.pathname#" delimiters="\">
		   <cfif grp eq "[root]">
		     <cfset grp = "#itm#">
		   </cfif>
		</cfloop>
		
		<cfif url.pathName eq "[root]">
		
				<cfdirectory action="LIST" 
			 directory="#SESSION.rootpath#\" 
			 name="myfile" 
			 filter="#url.filename#">	
		
		<cfelse>
				
				<cfdirectory action="LIST" 
			 directory="#SESSION.rootpath#\#url.pathname#" 
			 name="myfile" 
			 filter="#url.filename#">	
		 
		 </cfif>
					 
		 <cfoutput query="myfile">
						
			<cfquery name="Check" 
			datasource="AppsControl" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT * FROM Ref_TemplateContent
			  WHERE ObservationId    =  '#url.observationid#'
			  AND   ActionCode       = '#URL.actionCode#'
			  AND   PathName         = '#URL.PathName#' 
			  AND   FileName         = '#URL.FileName#' 
			  AND   TemplateModified = '#dateformat(DateLastModified,dateSQL)#'  
			</cfquery>							
			
			<cfif check.recordcount eq "0">
									
				<cfquery name="Log" 
					datasource="AppsControl">
				   		INSERT INTO Ref_TemplateContent
								(ApplicationServer,
								ObservationId, 
							    ActionCode, 
								PathName, 
								FileName, 
								TemplateModified, 
								TemplateOfficer, 
								TemplateGroup, 
								TemplateModifiedBy, 
								TemplateComments, 
					            TemplateSize, 
								TemplateContent)
						VALUES
							('#Site.ApplicationServer#',
							 '#url.observationid#',
						     '#URL.actionCode#',
							 '#URL.PathName#',
							 '#URL.FileName#',
							 '#dateformat(DateLastModified,dateSQL)#', 
							 '#SESSION.acc#',
							 '#grp#',
							 '#SESSION.last#',
							 'Content at identification',
							 '#myfile.size#',
							 '#content#') 
				</cfquery>
			
			</cfif>
		
		</cfoutput>
				
	
	</cfif>
	
	
<cfelseif url.action eq "delete">	

	<cfquery name="Clear" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM ObservationTemplate
	  WHERE ObservationId  = '#url.observationid#'
	  AND ActionCode       = '#URL.actionCode#'
	  AND PathName         = '#URL.PathName#' 
	  AND FileName         = '#URL.FileName#'
	</cfquery>
	
	<cfquery name="Clear" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM Ref_TemplateContent
	  WHERE ObservationId  = '#url.observationid#'
	  AND ActionCode       = '#URL.actionCode#'
	  AND PathName         = '#URL.PathName#' 
	  AND FileName         = '#URL.FileName#'
	</cfquery>
	
</cfif>

<cfquery name="Listing" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ObservationTemplate INNER JOIN
             Ref_Template ON ObservationTemplate.PathName = Ref_Template.PathName and 
			 ObservationTemplate.FileName = Ref_Template.FileName
	 WHERE   ObservationId  =  '#url.observationid#'
	  AND    ActionCode     = '#URL.actionCode#'
</cfquery>
	
    <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table formpadding">			
	
	<cfif listing.recordcount neq "0">
    <tr class="labelit">
	   <td></td>
       <td height="25%" class="labelit">Path </td>
	   <TD height="15%" class="labelit">FileName</TD>
	   <TD height="15&" class="labelit">Size</TD>
	   <TD height="15%" class="labelit">Last updated</TD>	 
	   <td></td>   
   </TR>
   
   </cfif>
      
   <tr><td height="1" class="linedotted" colspan="7"></td></tr> 
	 
   <cfoutput query="Listing">
    
	   <tr class="navigation_row linedotted">
	   	  <td class="labelit" height="20" style="padding-left:4px">#currentrow#</td>
	      <td class="labelit">#PathName#</td>
		  <td class="labelit">#FileName#</td>
		  <td class="labelit">#numberformat(fileSize/1024,"_._")#Kb</td>
		  <td class="labelit">#dateformat(lastupdated,CLIENT.DateFormatShow)# #timeformat(lastupdated,"HH:MM")#</td>
		  <cfset path = replace(pathname,'\','\\','ALL')> 
		  <td class="labelit">
		  <cfif detailedit eq "Yes">
			  <cf_img icon="delete" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/template/TemplateFile.cfm?action=delete&box=#url.box#&Observationid=#URL.ObservationId#&ActionCode=#URL.ActionCode#&PathName=#Path#&fileName=#fileName#','#url.box#')">			
		  </cfif>	  
		  </td>
	   </tr> 
	   
	   <tr><td></td><td colspan="6">
	   
	   <cfset url.observationid = observationid>
	   <cfset url.actioncode    = actioncode>
	   <cfset url.pathname      = pathname>
	   <cfset url.filename      = filename>
	   
	   <cfdiv id="#templateid#">
	   
	  		 <cfinclude template="TemplateHistory.cfm">
	   
	   </cfdiv>
	   
	   </td></tr>
	  
   </CFOUTPUT>   
   
   </table>
   