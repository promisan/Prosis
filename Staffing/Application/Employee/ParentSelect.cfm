
<!--- Query returning search results --->
<cfquery name="SearchResult" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   * 
    FROM     stParentOffice
    ORDER BY ParentOffice, ParentLocation
</cfquery>

<!---
<cf_screentop height="100%" 
    close="ProsisUI.closeWindow('myparent',true)" 
	layout="webapp" 
	html="no" 
	scroll="yes" 
	label="Parent Office">
	--->

<cf_divscroll>
	  
	<table width="96%" align="center" class="navigation_table">
		
	<TR class="labelmedium2 line fixrow fixlengthlist">    
	    <td style="height:30px;padding-left:4px"><cf_tl id="Office"></TD>
		<td></td>
	    <td><cf_tl id="Location"></TD>
	    <td><cf_tl id="Contact"></TD>
	    <td style="padding-right:4px"><cf_tl id="Title"></TD>	
	</TR>
	
	<cfset prior = "">
	
		<cfoutput query="SearchResult">
		
			<cfset off = replace(ParentOffice, ",", "", "ALL")> 
			<cfset off = replace(off, "'", "", "ALL")> 
			<cfset par = replace(ParentLocation, ",", "", "ALL")> 
			<cfset par = replace(par, "'", "", "ALL")> 
				
			<TR class="line labelmedium2 navigation_row fixlengthlist" style="height:20px">
			 
			 <cfif parentoffice neq prior>
			 <td style="border-top:1px solid silver;font-size:14px;padding-left:4px">#ParentOffice#</td>
			 <cfelse>
			 <td style="border-bottom:0px"></td>
			 </cfif>
			 <TD style="padding-top:3px;padding-right:6px">					
				<cf_img onclick="parentselect('#url.parentoffice#','#url.parentlocation#','#off#','#Par#')" navigation="Yes" icon="select">	 
			 </TD> 
			 <TD>#ParentLocation#</TD>
			 <TD>#ContactFirstName# #ContactLastName#</TD>
			 <TD>#ContactTitle#</TD>	 	 
			</TR>
			
			<cfset prior = parentoffice>
		
		</CFOUTPUT>
	
	</TABLE>
	
</cf_divscroll>	

<cfset ajaxonload("doHighlight")>
