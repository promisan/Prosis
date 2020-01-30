
<cf_screenTop height="100%" html="No" scroll="yes">

<cfoutput>
<script>

function reload() { 
   opener.location.reload();
   window.close();
}

function EditMission() {
	    window.open(root + "/System/Organization/Application/MissionEdit.cfm?ID2=#URL.ID2#", "AddPosition", "width=500, height=600, status=yes, toolbar=no, scrollbars=yes, resizable=no");
}

function hierarchy(mis) {
	    window.open("LocationHierarchy.cfm?ID2=#URL.ID2#", "AddPosition", "width=500, height=600, status=yes, toolbar=no, scrollbars=yes, resizable=no");
}

</script>
</cfoutput>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Ref_Mission
    WHERE Mission = '#URL.ID2#'
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
AND (ParentOrgUnit NOT IN
             (SELECT     OrgUnitCode
              FROM          Organization
              WHERE      Mission = '#URL.ID2#' 
			  AND MandateNo = '#URL.ID3#')) 
ORDER BY Mission, TreeOrder
</cfquery>

<table width="99%" border="0"  cellspacing="0" cellpadding="0" bordercolor="silver" align="center" frame="all" style="border-collapse: collapse">

<tr><td>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="gray" frame="all" style="border-collapse: collapse">
	  <tr class="noprint">
	    <cfoutput> 
	    <td style="height:40px" class="labellarge">
		#Mission.Mission#
	    </td>
		<td align="right">
	    <input type="button" 
		    value="Verify" 
			class="button10g" 
			style="width:130px" 
			onClick="javascript:hierarchy('#Mission.Mission#');">&nbsp;
		</cfoutput>			
		</td>
	  </tr> 	
	  
	  <tr><td colspan="2" height="1" class="line"></td></tr>
	 
	  <tr>
	    <td width="100%" colspan="2" style="padding-top:4px">
	    <table border="0" cellpadding="0" cellspacing="0" width="100%">
	
		 <cfoutput query="Mission"> 
		 	
		<!---			  
	     <tr class="labelmedium" style="height:22px">
	        <td width="16%" height="20">&nbsp;&nbsp;&nbsp; <cf_tl id="Tree acronym">:</td>
	        <td colspan="1">#Mission.Mission#</td>
		    <td height="20">&nbsp;&nbsp;&nbsp; Effective:</td>
	        <td colspan="1">#DateFormat(Mission.DateEffective, CLIENT.DateFormatShow)#</td>
		
	     </tr>			
		 --->
		 
	      <tr class="labelmedium" style="height:22px">
	        <td height="20">&nbsp;&nbsp;&nbsp; <cf_tl id="Name">:</td>
	        <td width="40%" colspan="3">#Mission.MissionName#</td>
		   </tr>
		  
		  <tr class="labelmedium" style="height:22px">
	        <td width="10%" height="20">&nbsp;&nbsp;&nbsp; <cf_tl id="Prefix">:</td>
	        <td colspan="1">#Mission.MissionPrefix#</td>
			<td height="20">&nbsp;&nbsp;&nbsp; <cf_tl id="Expiration">:</td>
	        <td colspan="1" >#DateFormat(Mission.DateExpiration, CLIENT.DateFormatShow)#</td>	   
	       </tr>
			  
		   <tr class="labelmedium" style="height:22px">
	        <td height="20">&nbsp;&nbsp;&nbsp; <cf_tl id="Type">:</td>
	        <td colspan="1">#Mission.MissionType#</td>
	        <td height="20">&nbsp;&nbsp;&nbsp; <cf_tl id="Recorded by">:</td>
	        <td colspan="1">#Mission.OfficerFirstName# #Mission.OfficerLastName#</td>
	      </tr>
		  <tr><td height="3"></td></tr>
			  
		  <cfif Check.recordcount gt "0">		    
		    <tr><td height="3"></td></tr>
		    <tr><td colspan="2" class="labelit">&nbsp;&nbsp;&nbsp; 
    		  <img src="#SESSION.root#/images/caution.gif" alt="" border="0"> 
	    	  <a href="LocationListing.cfm?ID1=NULL&ID2=#Mission.Mission#&ID3=#URL.ID3#">
		      Problem : <b><font color="FF0000">#Check.recordcount# location(s) are orphaned!</b></font>
		      </a>
		      </td>
		    </tr>
		  </cfif>
		     						 	  	  
		  </cfoutput>
			   
	    </table>
		
	    </td>
		
	  </tr>
	  
	</table>

</td></tr>

<tr><td colspan="2" class="line"></td></tr>

</table> 		  
