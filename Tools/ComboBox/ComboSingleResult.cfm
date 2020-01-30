	
<!--- Query returning search results --->

<cfparam name="URL.Page" default="1">

<cfquery name="Base" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     TOP 1 *
	 FROM  		Ref_ReportControlCriteria R
	 WHERE  	ControlId     = '#URL.ControlId#' 
	  AND    	CriteriaName  = '#URL.par#'  
</cfquery>

<cfoutput query="Base">

	<cfif Base.LookupDataSource eq "">
		<cfset ds = "appsQuery">
	<cfelse>
		<cfset ds = "#Base.LookupDataSource#">
	</cfif> 

    <cfset tmp = "">
    <cfinclude template="FormHTMLComboQuery.cfm">
								
	<cfquery name="Total" 
	    datasource="#ds#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT count(*) as total
    	FROM #LookupTable#
		#preserveSingleQuotes(con)# 
	</cfquery> 
	
	<cfset show = "22">
	
	<cfset No = URL.Page*show>
	
	<cfif No gt "#Total.Total#">
		  <cfset No = "#Total.Total#">
	</cfif> 
	
	<cfquery name="Current" 
	    datasource="#ds#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT  #LookupFieldValue#,
	            CONVERT(varchar, #LookupFieldValue#) as PK,  
	            #LookupFieldDisplay# as Display, *
			
	 	<cfif not Find("FROM ", "#preserveSingleQuotes(CriteriaValues)#")>
		 FROM #LookupTable#
		 </cfif>	
		 WHERE #LookupFieldDisplay# = '#url.cur#'
	</cfquery> 
						
	<cfquery name="SearchResult" 
	    datasource="#ds#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT #dis# TOP #No#
		        #LookupFieldValue#,
	            CONVERT(varchar, #LookupFieldValue#) as PK,  
	            #LookupFieldDisplay# as Display, *
			
	 	<cfif not Find("FROM ", "#preserveSingleQuotes(CriteriaValues)#")>
		 FROM #LookupTable#
		 </cfif>	
		 #preserveSingleQuotes(Crit)#
	</cfquery> 
	
</cfoutput>
   
<table width="100%" border="0" cellspacing="0" cellpadding="0" frame="all" scrolling="Auto">   

	<cfif SearchResult.recordcount eq "0">
	
	<tr><td align="center"><font face="Verdana" color="FF0000"><b>No records found</b></font></td></tr>
	
	<cfelse>
	
	<cfinclude template="FormHTMLComboNavigation.cfm">
	
	<tr><td colspan="4" align="center" bgcolor="e4e4e4"></td></tr>
							
	<tr bgcolor="CAEEF4">
	   	
	    <td height="17" width="10%"></td>
	    <TD><font face="Verdana">Code</TD>
		<td width="2">&nbsp;</td>
		<TD><font face="Verdana">Display</TD>
		
	</TR>
	<tr><td colspan="4" align="center" bgcolor="e4e4e4"></td></tr>
		
	<cfoutput query="Current">
				
	<tr bgcolor="E2E2C7" style="cursor: pointer;" onClick="selected('#PK#','#Display#')" onMouseOver="hl(this,'1')" onMouseOut="hl(this,'0')">
			
	<td width="50" height="20" align="center">
	<!---
	<img src="#SESSION.root#/Images/pointer.gif" name="sel#currentRow#" 
	   onMouseOver="document.sel#currentRow#.src='#SESSION.root#/Images/button.jpg'" 
	   onMouseOut="document.sel#currentRow#.src='#SESSION.root#/Images/pointer.gif'" 
	   style="cursor: pointer;" 
	   alt="Select" 
	   height="9"
	   width="9"
	   onClick="javascript:selected('#PK#','#Display#')"
	   border="0">
	   --->
	</td>
		
	<TD>
	  #PK#
	</TD>
	<td></td>
			
	<td style="word-wrap: normal;">
	  <cfif len(display) gt "65">
	    <a href="##" title="#Display#">#left(Display,65)#...</a>
	  <cfelse>
	    #display#	
	  </cfif>
	  
	</td>
		
	</TR>
		
	<tr><td height="1" colspan="5" bgcolor="EAEAEA"></td></tr>
	
	</CFOUTPUT>
				
	<cfoutput query="SearchResult" startrow="#Str#">
	
	<cfif PK neq Current.PK>
			
		<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f8f8f8'))#"  
			style="cursor: pointer;" 
			onMouseOut="hl(this,'0')" 
			onMouseOver="hl(this,'1')" class="linedotted"
			onClick="selected('#PK#','#Display#')">
				
			<td width="50" height="20" align="center">
			
			<img src="#SESSION.root#/Images/pointer.gif" name="sel#currentRow#" 
			   onMouseOver="document.sel#currentRow#.src='#SESSION.root#/Images/button.jpg'" 
			   onMouseOut="document.sel#currentRow#.src='#SESSION.root#/Images/pointer.gif'" 
			   style="cursor: pointer;" 
			   alt="Select" 
			   height="9"
			   width="9"
			   onClick="javascript:selected('#PK#','#Display#')"
			   border="0">
			   
			</td>
			
			<TD>#PK#</TD>
			<td></td>
				
			<td style="word-wrap: normal;">
			  <cfif len(display) gt "65">
			    <a href="##" title="#Display#">#left(Display,65)#...</a>
			  <cfelse>
		    	#display#	
			  </cfif>	  
			</td>
			
		</TR>
			
	</cfif>
	
	</CFOUTPUT>
	
	</cfif>
			
</table>