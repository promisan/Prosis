<!--
    Copyright © 2025 Promisan B.V.

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
<script>

function more(bx) {

    icM  = document.getElementById(bx+"Min")
    icE  = document.getElementById(bx+"Exp")
	se   = document.getElementById(bx)
			
	if (se.className=="hide") {
		se.className  = "regular";		
		icM.className = "regular";
	    icE.className = "hide";
	} else	{
		se.className  = "hide";		
	    icM.className = "hide";
	    icE.className = "regular";
	}
	
	}
	
</script>	
	
<cfset url.mode = "standard">
<cfparam name="URL.site" default="">

<cf_textareascript>
<cfajaximport tags="cfform">

<cfquery name="Find" 
datasource="appsControl">
	SELECT *
	FROM   Ref_TemplateContent	
	WHERE  TemplateId = '#URL.ID#'
</cfquery>	

<cfset srvnme  = "#Find.ApplicationServer#">
<cfset filedir = "#Find.PathName#">
<cfset filenme = "#Find.FileName#">

<!--- define the last versio of the file --->

<cfquery name="Last" 
	datasource="appsControl">
	SELECT *
	FROM   Ref_TemplateContent	
	WHERE  TemplateId = '#URL.ID#' 
	AND    TemplateModified IN (SELECT Max(TemplateModified)
	                         FROM Ref_TemplateContent
							 WHERE FileName   = '#filenme#'
							 AND   PathName   = '#filedir#'
							 AND   TemplateStatus = '1'
							 AND   ApplicationServer = '#srvnme#')
	</cfquery>	
	
<cfif Find.VersionDate neq "">
    <cfset cond =  "VersionDate = '#dateformat(Find.VersionDate, client.dateSQL)#'">
    <cfset condP = "VersionDate < '#dateformat(Find.VersionDate, client.dateSQL)#'">
<cfelse>
    <cfset cond = "ObservationId = '#Find.ObservationId#' and ActionCode = '#Find.ActionCode#' and TemplateId = '#Find.TemplateId#'"> 
    <cfset condP = "ObservationId = '#Find.ObservationId#' and ActionCode = '#Find.ActionCode#' and TemplateId < '#Find.TemplateId#'"> 
</cfif>	

<cfquery name="Header" 
datasource="appsControl">
	SELECT *
	FROM   Ref_Template
	WHERE  PathName   = '#filedir#'
	AND    FileName   = '#filenme#'
</cfquery>	

<cfoutput>

<script>

function restore() {
	if (confirm("Do you want to restore to the previous template version ?")) {
	    url = "TemplateRestore.cfm?id=#URL.ID#";
		ColdFusion.navigate(url,'boxupdate')			
		}	
	}		
	
function update() {
	
	newver = document.getElementById("new").value
	oldver = document.getElementById("old").value
	
	if (confirm("Do you want to replace the master copy with the development copy ?")) {
		 url = "TemplateActionMasterUpdate.cfm?mode=log&new="+newver+"&old="+oldver;
		 ColdFusion.navigate(url,'boxupdate')	
	   }	
	}	
	
</script>	

<cf_screentop height="100%" band="no" scroll="no" bannerheight="50" banner="green" layout="webapp" label="Template Content #Find.PathName# #Find.FileName#">

<cfset attrib = {type="Tab",name="requisition",height="#client.height-190#", tabstrip="false", width="#client.width-58#"}>

<cfif Header.Operational eq "999">

    <table align="center">
	<tr><td height="54" class="labelmedium" align="center" colspan="2"><b>Attention :</b> This template was removed from the application server</b></td></tr>
	</table>
	<cfabort>
	
</cfif>

<table align="center"><tr><td align="center" style="padding:5px">
	
<cflayout attributeCollection="#attrib#">	
	
<!--- define template to compare with --->

<cfquery name="Template"
         datasource="appsControl"
         maxrows=2>
	
		<!--- left --->
		SELECT *
		FROM   Ref_TemplateContent	
		WHERE FileName   = '#filenme#' 
		AND   PathName   = '#filedir#'
		AND   ApplicationServer = '#srvnme#'
		AND   #preservesingleQuotes(cond)#	
	
	<cfif URL.compare eq "">
	 
	    <!--- nothing to compare --->
		
	<cfelseif URL.compare eq "prior">
	
		UNION ALL
		<!--- right --->
		SELECT *
		FROM   Ref_TemplateContent	
		WHERE  FileName   = '#filenme#' 
		AND    PathName   = '#filedir#'
		AND    ApplicationServer = '#srvnme#'
		AND    #preservesingleQuotes(condP)#
		AND    TemplateStatus != '9'
		ORDER BY TemplateModified DESC  
		
	<cfelse>
	    UNION ALL
		SELECT * 
		FROM   Ref_TemplateContent	
		WHERE TemplateId = '#URL.Compare#'
		AND    TemplateStatus != '9'
	    ORDER BY TemplateModified DESC 
		
	</cfif></cfquery>	
	
	<cfif template.recordcount eq "2">

		<!--- generate script file --->
		
		<cfloop query="template">	
						
			<cfset v = "">
			<cfif currentrow neq "1">
			  <cfset v = "prior_">
			</cfif>
									
			<cffile action="WRITE"
	        file="#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\#v##filenme#"
    	    output="#templatecontent#"
	        addnewline="Yes"
	        fixnewline="No">	
			
			<cfset templateid = templateid>
				
		</cfloop>		

		<cf_TemplateCompare 
			 left   = "#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\#filenme#"
			 right  = "#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\prior_#filenme#"
			 output = "#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\compare.html"
			 delete = "yes">
		 
		   <cflayoutarea  name="comparison" title="Detail Comparison of the differences">
		   
		   <table width="100%" height="100%" cellspacing="0" cellpadding="0">
			   				
				<tr><td id="com" colspan="3" align="right">
				
				 <iframe width="100%"
		    	    height="99%"
					name="right"
			        id="right"
			       	scrolling="yes"
		    	    frameborder="0"></iframe>
					
						<cf_loadpanel id="right" template="TemplateDetailCompare.cfm">	
				
				</td></tr>
		  </table>
		  
		  </cflayoutarea>
				  
	<cfelse>
	
		<cflayoutarea  name="comparison" title="Comparison">
	
				<table width="100%" height="100%">
		
					<tr><td colspan="2" height="30" align="center"><font size="2" color="gray">Attention: This is a new template </font></td></tr>	  
		
				</table>
				
		</cflayoutarea>
		  		 							
	</cfif>
				
	<cfloop query="template">	
  
		<cfif currentrow eq "1">
		
			<cfquery name="Site" 
			datasource="appsControl">
				SELECT *
				FROM   ParameterSite
				WHERE  ServerRole = 'QA'	
			</cfquery>	
		
		    <cfif url.site neq site.applicationserver and url.site neq "">
		   	
				<cflayoutarea  name="rev" source="TemplateDetailReview.cfm?site=#url.site#&TemplateId=#templateid#" title="Review Comments/Analysis"/>						
			
			</cfif>		
		
		   <cfset ti = "Revised Template">		   	
		   <cfset nm = "Revised">
		   
		<cfelse>
		
		   <cfset ti = "Prior Content">
		   <cfset nm = "Prior">
		   
		</cfif>
		
		<cflayoutarea name="#nm#" title="#ti#">		
		
		   <table width="100%" cellspacing="0" cellpadding="0">
			   	
				<tr><td id="t#currentrow#" colspan="3" class="labelit">
		
						<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
						
						<tr><td height="8"></td></tr>
						<tr class="labelit"><td width="80"><cfif #currentRow# eq "1">Path<cfelse>Path</cfif>:</td>
							<td width="90%">#ApplicationServer#:#PathName#</td></tr>
						<tr class="labelit"><td><cfif currentRow eq "1">File<cfelse>Prior</cfif>:</td>
							<td class="labelit"><b>#FileName# <!--- (#templateid#) ---></td></tr>	
						<tr class="labelit"><td>Officer:</td>
							<td class="labelit"><b>#TemplateModifiedBy#</td></tr>		
						<tr class="labelit"><td>Modified:</td>
							 <td class="labelit"><b>#dateFormat(TemplateModified,CLIENT.DateFormatShow)# #timeFormat(TemplateModified,"HH:MM")# (#TemplateSize# byte)</td></tr>
						<tr><td colspan="2" height="90%">
						
							<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
							
							<tr><td height="40" id="boxupdate">
						
							<cfif currentrow eq "1" and 
							     template.recordcount eq "2" and 
								 url.compare eq "prior" and 
								 last.recordcount eq "1">
								 
								 Restore below template to its previous state&nbsp;&nbsp;
								 		 
							   <button name="Restore" id="Restore" type="button" class="button10g" onClick="javascript:restore()">
							   		<img src="#SESSION.root#/Images/prev.gif" order="0" align="absmiddle">
									Restore 
							   </button>
							   
							   <input type="hidden" name="new" id="new" value="#templateid#">
								   
							<cfelse>
							
								<cfquery name="Site" 
									  datasource="AppsControl" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
								      SELECT * 
									  FROM   ParameterSite
									  WHERE  ApplicationServer = '#ApplicationServer#'
									  ORDER BY ServerRole
								</cfquery>
							
								<cfif currentrow eq "1" and 
								     template.recordcount eq "2" and 
									 site.serverrole eq "design">
									 
									 <button 
									   name="Udate" id="Udate" style="height:26;width:100%" type="button"
									   onclick="javascript:update()"
								       class="buttonFlat">
							  			 <img  src="#SESSION.root#/Images/refresh4.gif" 
										 order="0" align="absmiddle">&nbsp;
										 Update master copy with this template
							  		 </button>
								   
								    <input type="hidden" name="new" id="new" value="#templateid#">
								   
								</cfif>
								
							</cfif>	
											
							<cfif currentrow eq "2">
							
								<b><font color="0080C0">Show detailed comparison report of both templates&nbsp;</font>
							
							 <button 
									   name="Detail" id="Detail"
									   onclick="javascript:compare()"
								       class="button10g">
							  			 <img  src="#SESSION.root#/Images/comparison2.gif" height="15" width="15"
										 order="0" align="absmiddle">
										 Comparison
							  		 </button>
								   
							    <input type="hidden" name="old" id="old" value="#templateid#">
								  	 
							</cfif> 
						 	 
							</td>
						</tr>	
						<tr><td height="1" bgcolor="C0C0C0"></td></tr>
						 
						<tr><td height="100%" style="font-family : arial; font-size : 10pt;">
						
							<cfdiv id="c#currentrow#">	
							 <cfset url.row = currentrow>
							 <cfset url.templateid = templateid>
							 <cfinclude template="TemplateDetailContent.cfm">
							</cfdiv>			
													
						</td></tr>
						
						</table>		
						</td></tr>
						</table>
					</td></tr>
		  </table>
		 
		 </cflayoutarea>
						
	</cfloop>	
	
</cflayout>	

</td></tr></table>

<script>

function compare() {
	 w = #CLIENT.width# - 60;
     h = #CLIENT.height# - 120;
	 window.open("#SESSION.root#/cfrstage/user/#SESSION.acc#/compare.html","_blank","left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=yes, scrollbars=yes, resizable=yes")
}

</script>

<cf_screenbottom layout="webdialog">

</cfoutput>

