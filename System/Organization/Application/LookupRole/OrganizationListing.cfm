<!--
    Copyright © 2025 Promisan

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
<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" 
    scroll="Yes" 
	label="#URL.Mission# Unit" 
	line="no" 
	html="No"
	banner="gray" 
	jquery="Yes"
	close="parent.ColdFusion.Window.destroy('orgunitwindow',true)"
	option="Select an organization unit" 
	layout="webapp">

<cfparam name="URL.Role"    default="">
<cfparam name="URL.Mission" default="">
<cfparam name="URL.Mandate" default="">
<cfparam name="URL.Period"  default="">

<cfif URL.Mandate eq "">

    <!--- determine the related mandate period for this line --->

	<cfquery name="Mandate" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
	     FROM   Ref_MissionPeriod
	     WHERE  Mission = '#URL.Mission#'
		 AND    Period  = '#URL.Period#'				 
	    </cfquery>
		
		<cfset url.mandate = Mandate.MandateNo>
		
</cfif>

<cfquery name="Check" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
	     FROM   Ref_Mandate
	     WHERE  Mission   = '#URL.Mission#'
		 AND    MandateNo = '#URL.Mandate#'		
	    </cfquery>
		

<cfquery name="Period" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
	     FROM   Ref_Period
	     WHERE  Period    = '#URL.Period#'		 
	    </cfquery>		
		
		
<cfif check.DateExpiration lt Period.DateEffective>

	<cfoutput>
	  <table width="80%" align="center">
	    <tr><td align="center" height="60" class="labelit">
		<font face="Verdana" size="2">
		Raising a request for a staffing period [#URL.Mandate#] which expiration date (#dateformat(check.DateExpiration,CLIENT.DateFormatShow)#) lies before the period effective (#dateformat(Period.DateEffective,CLIENT.DateFormatShow)#) that does not overlap with the selected period is no longer allowed. 
		<br><br>Please contact your administrator!
		</font>
		</td></tr>
	  </table>
	 </cfoutput> 

	<cfabort>

</cfif>

<cfoutput>

<!---

<script>

     function Selected(orgunit,orgunitcode, mission, orgunitname, orgunitclass) {

	 <cfif url.formname eq "Webdialog">
	
	  returnValue = orgunit+';'+orgunitcode+';'+mission+';'+orgunitname+';'+orgunitclass
	  window.close()	

	<cfelse>
	
        var form = "#URL.FormName#";
		var id   = "#URL.fldOrgUnit#";
		var cde  = "#URL.fldOrgUnitCode#";
		var mis  = "#URL.fldMission#";
		var nme  = "#URL.fldOrgUnitName#";
		var cls  = "#URL.fldOrgUnitClass#";
		
		eval("parent.opener.document." + form + "." + id + ".value = orgunit");
		eval("parent.opener.document." + form + "." + cde + ".value = orgunitcode");
		eval("parent.opener.document." + form + "." + mis + ".value = mission");
		eval("parent.opener.document." + form + "." + nme + ".value = orgunitname");
		eval("parent.opener.document." + form + "." + cls + ".value = orgunitclass");
		parent.window.close()
		
     </cfif>
	 		
	}	
		
</script>

--->

<script>
	
	function setvalue(fld,org,scope) {
		    
		    <cfif url.script neq "">
			
			try {				    
				parent.#url.script#(fld,org,'#url.scope#','#url.action#');	
			} catch(e) {}
			
		    </cfif>
			parent.ProsisUI.closeWindow('orgunitwindow');	
			
		}		

</script>
	
</cfoutput>	

<CFSET Criteria = ''>

<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
     
<tr><td colspan="2" style="padding-top:4px">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<tr><td>
	
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		
		<TR class="line fixrow labelmedium">
		    <td height="20"></td>
		    <TD>Unit code</TD>
			<TD>Unit name</TD>
			<td></td>
			<!--- <TD class="top4N">Class</TD> --->
			<!--- <TD class="top4N">Expiration&nbsp;</TD> --->
		   
		</TR>
		
		<cfif URL.Role eq "">
		
		    <cfset full = "1">
					
		<cfelse>
		
		    <cfif getAdministrator(url.mission) eq "1">
			
				<cfset full = "1">
				
			<cfelse>
			
				<!--- define if full access --->
				<cfquery name="Full" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   OrganizationAuthorization
				WHERE  Role        = '#URL.Role#' 
				AND    Mission     = '#URL.Mission#' 
				AND    UserAccount = '#SESSION.acc#'
				AND    OrgUnit IS NULL
				</cfquery>
				
				
				<cfif Full.recordcount gte "1">
					<!--- full access all units --->
					<cfset full = "1">
				<cfelse>
					<!--- limit selection option to specific units only --->
					
					<cfset full = "0">			
					<cf_OrganizationUp Mission="#URL.Mission#" 
					                   Role="#URL.Role#" 
									   UserAccount = "#SESSION.acc#">
					
				</cfif>
			
			</cfif>
		
		</cfif>
		
		<!--- Query returning search results --->
		
		<cfif full eq "1">
		
			<cfquery name="SearchResult" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     *, '1' as Enabled 
			    FROM   #CLIENT.LanPrefix#Organization O
			    WHERE  Mission   = '#URL.Mission#'
				AND    MandateNo = '#URL.Mandate#'
				ORDER BY O.HierarchyCode
			</cfquery>
		
		<cfelse>
		
			<cfquery name="SearchResult" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    DISTINCT O.*, S.Enabled
			    FROM  #CLIENT.LanPrefix#Organization O, 
				      userQuery.dbo.#SESSION.acc#OrgUnit S 
				WHERE O.Mission   = '#URL.Mission#'
				AND   O.MandateNo = '#URL.Mandate#'
				AND   O.OrgUnit = S.OrgUnit
				ORDER BY O.HierarchyCode		
			</cfquery>
		
		</cfif>
					
		<cfoutput query="SearchResult">
		   	
		   <cfif ParentOrgUnit eq "" or autonomous is "1">
		   
			   <cfif ParentOrgUnit eq "">  
				   <cfset cl = "FFFFBF">   
			   <cfelse>
			       <cfset cl = "e4e4e4">
			   </cfif>	   
		   
		  	
			<TR bgcolor="#cl#" class="navigation_row line labelmedium">
			<td width="30" height="18" style="padding-left:6px;padding-top:1px">
			
		    <cfif enabled eq "1">
			
				<cf_img icon="select" navigation="Yes" onclick="setvalue('#url.fldorgunit#','#orgunit#','#url.script#')">
				
		    </cfif> 
			 
		    </td>
		    	
			<td style="min-width:90px;padding-left:4px;padding-right:4px"><font color="gray">#OrgUnitCode#</font></td>
				   
			<cfif enabled eq "1">
			    <TD width="60%"><cfif enabled eq "0"><font color="gray"></cfif><b>#OrgUnitName#</b></TD>
			<cfelse>
				<TD width="60%"><font color="gray"><b>#OrgUnitName#</font></b></TD>
			</cfif>	
				
			 <td style="padding-right:10px">#HierarchyCode#</td>
			 
		   </TR>
		   
		   <cfelse>
		   
			<TR bgcolor="FFFFFF" class="navigation_row linedotted">
			<td width="30" height="18" style="padding-left:6px;padding-top:1px">
			
		    <cfif enabled eq "1">
			
				<cf_img icon="select" navigation="Yes" onclick="setvalue('#url.fldorgunit#','#orgunit#','#url.script#')">
				
		    </cfif> 
		   
		    </td>
		    <td style="padding-left:10px;padding-right:4px" width="15%" class="labelit"><cfif enabled eq "0"><font color="gray"></cfif>#OrgUnitCode#</td>
		       <TD width="70%" class="labelit"><cfif enabled eq "0"><font color="gray"></cfif>#OrgUnitName#</TD>
		       <TD width="10%" style="padding-right:10px" class="labelit">#HierarchyCode#</TD> 
			</TR>
			
		   </cfif>
				
		</CFOUTPUT>
			
		</TABLE>
		
	</tr></td>
	
	</table>

</td>
</tr>
</table>

<cf_screenbottom layout="webapp">
