
<cf_screentop html="No" scroll="Yes">

<cfparam name="URL.ID2"       default="Template">
<cfparam name="URL.ID3"       default="0000">
<cfparam name="URL.Mission"   default="#URL.ID2#">
<cfparam name="URL.Mandate"   default="#URL.ID3#">

<input type="hidden" name="mission" id="mission" value="<cfoutput>#URL.Mission#</cfoutput>">

 <cfquery name="Mandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM   Ref_Mandate
   WHERE  Mission = '#URL.Mission#'
</cfquery>
           
<cfoutput>
	
	<script language="JavaScript">
	 
	function Selected(orgunit,orgunitcode, mission,orgunitname,orgunitclass)  {
	
	   if (parent.document.getElementById('mode').value == "webdialog") {  	    
	       parent.parent.applyunit(orgunit)
		   parent.parent.ColdFusion.Window.destroy('orgunitselectwindow',true)
	    } else {
		   parent.window.returnValue = orgunit+';'+orgunitcode+';'+mission+';'+orgunitname+';'+orgunitclass
		   parent.window.close()	
		}
	}
		
	</script>

</cfoutput>

<cf_dialogOrganization>

<table width="100%" border="0" frame="hsides" cellspacing="0" cellpadding="0" align="right" class="formpadding">
   
  <tr>  
  <td width="100%" colspan="2">
	
	<CFSET cond = Replace(URL.ID1, "'", "''", "ALL" )>
	<cfset cond = "OrgUnitName LIKE '%#cond#%'">
	
	<!--- Query returning search results --->
	
	<cfquery name="SearchResult" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   DISTINCT O.*
	    FROM     Organization O
		WHERE    O.Mission   = '#URL.Mission#'
		AND      O.MandateNo   = '#URL.Mandate#'
		AND      #preserveSingleQuotes(cond)#  
	    ORDER BY O.HierarchyCode 
	</cfquery>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		
		<cfoutput query="SearchResult">
			
			<tr>
			    <td><cfinclude template="OrganizationListingDetail.cfm"></td>
			</tr>
			
		</cfoutput>
		
	</TABLE>

  </td>
  </tr>

</table>
   