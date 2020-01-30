
<cfparam name="URL.ID"               default="">
<cfparam name="URL.SystemFunctionId" default="">

<cfif url.systemfunctionid neq "">

	<cfquery name="get"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  * 
	    FROM    Ref_ModuleControl 
		WHERE   SystemFunctionId   = '#URL.SystemFunctionId#'
	</cfquery>	
	
	<cfquery name="Project"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
	    FROM    HelpProject 
		WHERE   SystemModule = '#get.SystemModule#'
	</cfquery>	
	
	<cfquery name="SearchResult"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     HelpProjectTopic
		WHERE    SystemFunctionId  = '#url.systemfunctionid#'	
		ORDER BY TopicCode,
		         LanguageCode,
				 ListingOrder
	</cfquery>
	
	<cfset url.class = "General">
	
<cfelse>
	
	<cfquery name="Project"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
	    FROM    HelpProject 
		WHERE   SystemModule = '#URL.module#'
	</cfquery>	
	
	<cfquery name="SearchResult"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     HelpProjectTopic
		WHERE    ProjectCode  IN (SELECT ProjectCode 
		                          FROM   HelpProject 
					 		      WHERE  SystemModule = '#URL.module#')
		AND      TopicClass  = '#URL.Class#' 
		ORDER BY TopicCode,
		         LanguageCode,
				 ListingOrder
	</cfquery>

</cfif>

<!--- refresh button to be called from outside removed hasnno 22/9
<cfoutput>
	<input type="hidden" id="refreshbutton" 
	  onClick="javascript:ColdFusion.navigate('../HelpBuilder/RecordListing.cfm?systemfunctionid=#url.systemfunctionid#','contentbox1')">
</cfoutput>
--->

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">

	<tr><td colspan="2" class="labelmedium" style="padding-left:7px">
		
		<cfif Searchresult.recordcount eq "0">
		
		    <cfoutput>		
			    <cfif project.recordcount gte "1">
			    <a href="javascript:helpedit('#Project.SystemModule#','#Project.ProjectCode#','#url.class#','','#url.systemfunctionid#')"><font color="0080C0">[Add topic]</a>
				</cfif>
			</cfoutput>
			
		<cfelse>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
			
				<tr><td colspan="7" style="height:40px;font-weight:200;font-size:21px" class="labelmedium">
								
					<cfoutput>
						<cfif project.recordcount gte "1"><a href="javascript:helpedit('#Project.SystemModule#','#Project.ProjectCode#','#url.class#','','#url.systemfunctionid#','#systemfunctionid#')">Add Help Topic</cfif>
					</cfoutput>
						
				</td></tr>
				
				<tr class="labelmedium line">
				<td></td>
				<td></td>
				<td><cf_tl id="Name"></td>
				<td><cf_tl id="Code"></td>
				<td><cf_tl id="Label"></td>
				<td><cf_tl id="Language"></td>
				<td><cf_tl id="Status"></td>
				</tr>
				
				<cfoutput query="SearchResult">	
				  	   			  
					  	<tr class="navigation_row labelmedium line" style="height:20px">			   		   
						    <td width="10"></td>
							<td width="7%" style="padding-left:4px;padding-top:4px">			
								<cf_img icon="select" navigation="yes" onClick="helpedit('#Project.Systemmodule#','#ProjectCode#','#url.class#','#TopicId#','#systemfunctionid#')">			
							</td>	
							<td width="30%"><cfif len(TopicName) gt "50">#left(TopicName,50)#..<cfelse>#TopicName#</cfif></TD>
							<td width="8%">#TopicCode#</TD>
							<td width="40%">#UITextHeader#</TD>
							<td width="10%">#LanguageCode#</TD>
							<td style="padding-right:4px" width="8%">
								<cfif len(UITextAnswer) lt 20>
								<font color="FF0000">Pending	
								</cfif>
							</td>						
						</tr>			
										
				</cfoutput>
		
			</table>
		
		</cfif> 
	
		</td>
	</tr>

</TABLE>

<cfset ajaxonload("doHighlight")>
