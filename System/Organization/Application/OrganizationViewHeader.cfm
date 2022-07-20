
<cfparam name="url.header" default="0">

<cfif url.header eq "1">
	<cf_screenTop height="100%" html="No" title="Tree Settings" scroll="Yes">
</cfif>

<cf_dialogOrganization>

<cfoutput>
	<script>
	
	function reload() { 
	   opener.location.reload();
	   window.close();
	}	
	</script>
</cfoutput>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mission
    WHERE  Mission = '#URL.ID2#'
</cfquery>

<cfparam name="URL.ID3" default="">

<cfif URL.ID3 eq "">

	<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	    FROM Ref_Mandate
	    WHERE Mission = '#URL.ID2#'
		ORDER BY MandateNo DESC
	</cfquery>
	<cfset URL.ID3 = "#Mandate.MandateNo#">

</cfif>

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT O.*
FROM      #LanPrefix#Organization O	
WHERE     (Mission = '#URL.ID2#') 
AND (MandateNo = '#URL.ID3#') 
AND (HierarchyCode IS NULL) 
<!---
AND (ParentOrgUnit NOT IN
             (SELECT     OrgUnitCode
              FROM          Organization
              WHERE      Mission = '#URL.ID2#' 
			  AND MandateNo = '#URL.ID3#')) 
			  --->
ORDER BY Mission, TreeOrder
</cfquery>

<script language="JavaScript">

function hierar(mis) {
 	
	    Prosis.busy('yes');
	    url = "OrganizationHierarchy.cfm?mission="+mis
		ptoken.navigate(url,'process')		
 }	
 
 </script>	

<table width="100%">

  <tr class="noprint fixlengthlist">
  	<cfoutput>	
    <td style="height:49px">
	<table>
		<tr>	
			<td><img src="#SESSION.root#/Images/tree3.gif" alt="" border="0"></td>
			<td style="font-size:25px" class="labellarge">#Mission.Mission# [#URL.ID3#]</td>
		</tr>
	</table>
    </td>
	
	<td style="font-weight:bold">
	<cfif Check.recordcount eq "0">
	<font color="008000"><cf_tl id="Structure is ok, no orphans" class="message"></font>
	</cfif>
	</td>
	
	<td align="right" id="process" colspan="2">
		<button name="Edit" id="Edit" style="width;190px" class="button10g" type="button" onClick="hierar('#Mission.Mission#')">
			  <img src="#SESSION.root#/Images/status_overview.gif" alt="Settings" border="0" align="absmiddle"> <cf_tl id="Verify">
		</button>	
	</td>
    </cfoutput>
	
  </tr> 	
   
  <tr>
    <td width="100%" colspan="3">
    <table width="100%">

	 <cfoutput query="Mission"> 
	 	 		  
       <tr class="labelmedium line">
        <td style="padding-left:20px" height="17"><cf_tl id="Acronym">:</td>
        <td>#Mission.Mission# (#Mission.MissionPrefix#)</td>
	    <td style="padding-left:10px"><cf_tl id="Effective">:</td>
        <td>#DateFormat(Mission.DateEffective, CLIENT.DateFormatShow)#
		<cfif Mission.DateExpiration eq ""><cf_tl id="undefined">
			<cfelse>
			- #DateFormat(Mission.DateExpiration, CLIENT.DateFormatShow)#
			</cfif>
		
		</td>	
       </tr>			
	   
       <tr class="labelmedium2 line">
        <td style="padding-left:20"><cf_tl id="Name">:</td>
        <td colspan="3">#Mission.MissionName#</td>
	   </tr>
	  	   		  
	   <tr class="labelmedium2">
        <td style="padding-left:20px"><cf_tl id="Type">:</td>
        <td>#Mission.MissionType#</td>
        <td style="padding-left:10px"><cf_tl id="Recorded by">:</td>
        <td>#Mission.OfficerFirstName# #Mission.OfficerLastName#</td>
       </tr>
	 		  
	  <cfif Check.recordcount gt "0">
		 				 
		 <tr><td colspan="4" align="center" class="labelmedium2" style="font-size:16px"> 
			  <img src="#SESSION.root#/Images/caution.gif" alt="" border="0" align="absmiddle"> 
			  <a href="OrganizationListing.cfm?ID1=NULL&ID2=#Mission.Mission#&ID3=#URL.ID3#&ID4=#URL.ID4#">
			  <cf_tl id="Problem"> : <font color="FF0000"> #Check.recordcount#
			  <cfif Check.recordcount eq "1"> <cf_tl id="unit is orphaned">.
			   <cfelse>
			   <cf_tl id="units are orphaned">!
			  </cfif>
			  <cf_tl id="Please review or try running the update hierachy function" class="message">.
			   </font>
			  </a>
	  		</td>
		 </tr>	  
	 	  	   
	  </cfif>
	     						 	  	  
	  </cfoutput>
		   
    </table>
	
    </td>
  </tr>
  
</table>
