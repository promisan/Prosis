
<cf_screentop jquery="Yes" width="100%" height="100%" html="No" scroll="Yes" label="Select an Unit">

<cfparam name="URL.Source" default="Lookup">

<input type="hidden" name="mission" id="mission" value="<cfoutput>#URL.Mission#</cfoutput>">

 <cfquery name="Mandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
     SELECT  * 
     FROM    Ref_Mandate
     WHERE   Mission = '#URL.Mission#'
</cfquery>
 

<script language="JavaScript">
	
	function Selected(orgunit,orgunitcode, mission,orgunitname,orgunitclass)  {					  
	     
	    if (parent.parent.applyunit) {	
			parent.parent.applyunit(orgunit)
			///parent.parent.applyOrgUnit(orgunit,orgunitcode,mission,orgunitname,orgunitclass);
			parent.parent.ColdFusion.Window.destroy('orgunitselectwindow',true);
		} else {
			parent.opener.applyunit(orgunit);
			parent.opener.ColdFusion.Window.destroy('orgunitselectwindow',true);
		}
	
	}				
			
</script> 

<cf_dialogOrganization>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr> 
<td width="100%" colspan="2" valign="top" style="padding:10px">

<form action="PostEntry.cfm" name="result" id="result">

<cfset cond = "AND O.OrgUnitCode = '#URL.ID1#'">
 
<!--- Query returning search results --->

<cfquery name="SearchResult" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  SELECT   DISTINCT O.*
	  FROM     Organization O
	  WHERE    O.Mission     = '#URL.Mission#'
	  AND      O.MandateNo   = '#URL.Mandate#'
		       #preserveSingleQuotes(cond)# 
	  ORDER BY O.Mission, TreeOrder 
</cfquery>

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
	
	<cfoutput query="SearchResult" group="TreeOrder">
		
	     <cfinclude template="OrganizationListingDetail.cfm">
		
		 <cfquery name="Level02" 
		    datasource="AppsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT   DISTINCT O.*
			    FROM     Organization O
				WHERE    O.ParentOrgUnit = '#SearchResult.OrgUnitCode#'
				AND      O.Mission   = '#URL.Mission#'
				AND      O.MandateNo = '#URL.Mandate#'
				ORDER BY O.Mission, TreeOrder
		 </cfquery>
	   
	    <cfloop query="Level02">
				 
		    <cfinclude template="OrganizationListingDetail.cfm">
		
			<cfquery name="Level03" 
		      datasource="AppsOrganization" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      SELECT    DISTINCT O.*
			       FROM     Organization O
				   WHERE    ParentOrgUnit = '#Level02.OrgUnitCode#'
			       AND      O.Mission     = '#URL.Mission#'
			       AND      O.MandateNo   = '#URL.Mandate#'
				   ORDER BY O.Mission, TreeOrder
		    </cfquery>
	
		    <cfloop query="Level03">
			
		       <cfinclude template="OrganizationListingDetail.cfm">
			 
			 	  <cfquery name="Level04" 
			      datasource="AppsOrganization" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
				      SELECT    DISTINCT O.*
				       FROM     Organization O
					   WHERE    ParentOrgUnit = '#Level03.OrgUnitCode#'
				       AND      O.Mission     = '#URL.Mission#'
				       AND      O.MandateNo   = '#URL.Mandate#'
					   ORDER BY O.Mission, TreeOrder
			    </cfquery>
		
			    <cfloop query="Level04">				
				   <cfinclude template="OrganizationListingDetail.cfm">	 
				</cfloop> 	 
				  
		    </cfloop>	     
			
	    </cfloop> 
		
		<tr><td colspan="3" class="line"></td></tr></tr> 
	     
	</CFOUTPUT>
		   
	</table>
	
</td></tr>

</table>   