
<cfoutput>

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM UserDashboard
	WHERE Account = '#SESSION.acc#'
	AND DashBoardFrame = '#frm#' 
</cfquery>

<cfif #Get.ReportType# eq "Topic" and #Get.ReportId# neq "">

	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Ref_ModuleControl 
		WHERE    SystemFunctionId = '#Get.ReportId#'
	</cfquery>
	
	<cfset id     = "#SearchResult.SystemFunctionId#">
	<cfset name   = "#SearchResult.FunctionName#">
	<cfset cls    = "Topic">
	<cfset type   = "Portal topic">
	<cfset format = "HTML">
	<cfset pubL   = "#SearchResult.OfficerLastName#">
	<cfset pubF   = "#SearchResult.OfficerFirstName#">
	<cfset pubD   = "#SearchResult.Created#">
	<cfset path   = "#Searchresult.FunctionPath#">
			
<cfelseif #Get.ReportId# neq "">
	
	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     UserReport U, Ref_ReportControlLayout L
		WHERE    ReportId = '#Get.ReportId#'
		AND      U.LayoutId = L.LayoutId
	</cfquery>
	
	<cfset id       = "#SearchResult.ReportId#">
	<cfset name     = "#SearchResult.DistributionSubject#">
	<cfset cls      = "Report">
	<cfset format   = "#SearchResult.FileFormat#">
	<cfset type     = "#SearchResult.LayoutClass#">
	<cfset pubL     = "#SearchResult.OfficerLastName#">
	<cfset pubF     = "#SearchResult.OfficerFirstName#">	
	<cfset pubD     = "#SearchResult.Created#">
	<cfset path     = "">
		
<cfelse>

    <cfset id      = "">
    <cfset type    = "">
	<cfset format  = "HTML">
	<cfset name    = "blank">
	<cfset pubL    = "">
	<cfset pubF    = "">	
	<cfset pubD    = "">
	<cfset path     = "">
	
</cfif>	

<cfif #col# eq "1">
<td width="#w#" height="#h#" colspan="#col#">
<cfelse>
<td width="100%" height="#h#" colspan="#col#">
</cfif>
<cfif #pubD# eq "">
     <cfset cl = "F9F9F9">
   <cfelse>
     <cfset cl = "white">
   </cfif>
<table width="100%" height="100%" bgcolor="#cl#">
   <tr>
     <td height="23" class="top3n">&nbsp;Frame: <b>#frm#.</td>
	 <td align="right" class="top3n">
	 <cfif #Id# neq "">
		    <button class="button3" onclick="javascript:edit('#id#','#cls#','#path#')">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/info.gif" alt="" border="0" 
			onMouseOver="window.status='Variant parameter definition'"
			onMouseOut="">
			</button>
		</cfif>
	 </td>
   </tr>
   <tr><td colspan="2" valign="top">
   
   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
   <cfif #pubD# neq "">
   
	   <tr>
	        <td>Class:</td>
	        <td><b>#type#</b></td>
	   </tr>
	   
	   <tr>
	        <td>Format:</td>
	        <td><b>#format#</b></td>
	   </tr>
	  	  
	   
   </cfif>
   
   <tr>
      <td>Item:</td>
	  <td><b>#name#</b>
 	   
      </td>
   </tr>
   <tr><td>Frame:</td><td>
   <input type="button" class="button7" name="Select" onclick="javascript:item('#id#','#frm#')" value="Set item">
   </td></tr>
   <cfif #pubD# neq "">
      <tr>
	    <td>Scrolling:</td>
	    <td><input type="checkbox" name="Scrollbar" value="1" <cfif #Get.Scrolling# eq "1">checked</cfif> onclick="javascript:scr('#frm#',this.checked)"></td>
	  </tr>
   </cfif>   
   <tr><td height="5"></td></tr>
   <tr><td height="2" colspan="2" class="top3n"></td></tr>
   <tr><td height="5"></td></tr>
   <cfif #pubD# neq "">
   <tr><td>Published by:</td><td>#pubF# #pubL#</td></tr>
   <tr><td>Date:</td><td>#dateFormat(pubD,CLIENT.DateFormatShow)#</td></tr>
   </cfif>
    </table>
   
   </td></tr>
</table>
</td>
</cfoutput>