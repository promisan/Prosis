
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
		     
		    if (parent.parent.applyunit) {	
				parent.parent.applyunit(orgunit)
				///parent.parent.applyOrgUnit(orgunit,orgunitcode,mission,orgunitname,orgunitclass);
				parent.parent.ProsisUI.closeWindow('orgunitselectwindow',true);
			} else {
				parent.opener.applyunit(orgunit);
				parent.opener.ProsisUI.closeWindow('orgunitselectwindow',true);
			}
		
		}				
				
	</script> 
	

</cfoutput>

<cf_dialogOrganization>

<cf_divscroll>

<table width="100%" align="right" class="formpadding">
   
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
	
	<table cellspacing="0" width="100%">
		
		<cfoutput query="SearchResult">
			
			<tr>
			    <td><cfinclude template="OrganizationListingDetail.cfm"></td>
			</tr>
			
		</cfoutput>
		
	</TABLE>

  </td>
  </tr>

</table>

</cf_divscroll>
   