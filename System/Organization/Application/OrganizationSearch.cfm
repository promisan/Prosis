
<cfparam name="url.mission"       default="">
<cfparam name="URL.Mode"          default="">
<cfparam name="URL.Script"        default="">
<cfparam name="URL.Scope"         default="">
<cfparam name="url.singleMission" default="0">

<cfoutput>

	<script>
	      
		function selected(orgunit,orgunitcode, mission, orgunitname, orgunitclass) {	
	
			se  = orgunit+";"+orgunitcode+";"+mission+";"+orgunitname+";"+orgunitclass
			if (se != "") {
				self.returnValue = se
			} else {
				self.returnValue = "blank"
			}
			self.close();		
		}		
			
		function setvalue(fld,org,scope) {	    		
			
		    <cfif url.script neq "">
			
			try {				
				parent.#url.script#(fld,org,'#url.scope#','enable');				
			} catch(e) {}
			
		    </cfif>
			parent.ProsisUI.closeWindow('orgunitwindow')	
			
		}		
			   	   
		function search() {
		
			if(window.event) {
			  keynum = window.event.keyCode;
			  } else {
			  keynum = window.event.which;
			}
			
			if (keynum != 13) {	find() }	
		}
		
		function find() {
		
			mis = document.getElementById("missionselect")
				cls = document.getElementById("class")
				uni = document.getElementById("orgunitname")
				url = "OrganizationSearchResult.cfm?field=#fldorgunit#&mode=#url.mode#&mis="+mis.value+"&cls="+cls.value+"&uni="+uni.value;						 
				_cf_loadingtexthtml='';	
				ptoken.navigate(url,'result')		
		}
				   
	</script>

</cfoutput>

<cfparam name="URL.OrgType" default="Operational">

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *  
    FROM   Ref_Mission
	WHERE  Operational = 1
	<cfif URL.OrgType eq "Administrative" and 
		Check.treeadministrative neq "" and 
		check.recordcount eq "1">
		AND Mission = '#Check.TreeAdministrative#'
	<cfelseif URL.OrgType eq "Functional" and 
		Check.treefunctional neq "" and
		check.recordcount eq "1">
	AND   Mission = '#Check.TreeFunctional#'
	</cfif>
	<!---
	AND MissionStatus = '0' hide the trees without mandate removed from DPA project partners
	--->
	AND   Operational = 1
	AND   MissionType NOT IN ('Template','Planning')
	ORDER BY MissionType
</cfquery>

<cfquery name="Class" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT OrgUnitClass
    FROM   Ref_OrgUnitClass
	<cfif url.singleMission eq "1">
	WHERE  OrgUnitClass IN (SELECT OrgUnitClass FROM Organization WHERE Mission = '#url.mission#')
	</cfif>
</cfquery>

<!--- Search form --->

<cfif url.singleMission eq "1">
	<cf_screentop height="100%" close="parent.ProsisUI.closeWindow('orgunitwindow',true)" html="No" user="yes" jQuery="Yes" scroll="No" layout="webapp" label="Find Organization" line="no" banner="gray">
<cfelse>
	<cf_screentop height="100%" close="parent.ProsisUI.closeWindow('orgunitwindow',true)" html="No" user="yes" jQuery="Yes" scroll="No" layout="webapp" label="Find Unit" line="no" title="Find Unit" bannerheight="55" banner="gray">
</cfif>

<cfform style="height:100%" name="organizationsearch" id="organizationsearch" onsubmit="return false">

	<table width="100%" height="100%">
	 
	<tr><td colspan="2" valign="top">
	
	<table width="100%" height="100%" align="center">
	
		<tr style="height:37px" class="line">
	   	 
		<cfif url.mission eq "" or url.mission eq "undefined" or url.orgtype neq "Operational">
			 
			<cfif url.singleMission eq "1">
			
			 <cfoutput>
			 <input type="Hidden" name="missionselect" id="missionselect" value="#url.mission#">
			 </cfoutput>
			 
			<cfelse> 		 
					
				<TD style="padding-left:17px">
					<cfselect name="missionselect" size="1" group="MissionType" query="Mission" value="Mission" 
					display="MissionName" style="width:180px" selected="#url.mission#" id="missionselect" class="regularxxl"></cfselect>					
				</TD>
					
			</cfif>
					
		<cfelse>
		
		    <cfoutput>
				<input type="hidden" name="missionselect" id="missionselect" value="#url.mission#">
			</cfoutput>
		
		</cfif>
		
		<TD style="padding-left:10px" class="labelmedium" align="left"><cf_tl id="Class">:</TD>
		<TD>			
	    	<select name="class" id="class" size="1" class="regularxxl">
				<option value="all"></option>
			    <cfoutput query="Class">
					<option value="'#OrgUnitClass#'">
			    		#OrgUnitClass#
					</option>
				</cfoutput>
		    </select>					
		</TD>
		
		<TD align="left" class="labelmedium"><cf_tl id="Name">:</TD>
		<TD><input type="text" name="orgunitname" id="orgunitname" class="regularxxl" size="20" maxlength="40" onKeyUp="search()"></TD>			
			
		</TR>	
		
		<tr><td height="1" colspan="6" class="line"></td></tr>	
		<tr>  
		  <td colspan="6" style="height:30px;padding-left:15px" width="100%">
		   <button class="button10g" type="button" name"Submit" id="Submit" value="Search" style="height:25;width:120px" onclick="search()">
		    <cf_tl id="Search">
		   </button>	
		  </td>
		</tr> 	
					
		<tr><td valign="top" colspan="6" style="padding:6px" height="100%">		
		   <cf_divscroll style="height:100%" id="result"/>			
		</td></tr>
			
	     </TABLE>
	
	</td></tr>
	
	</table>

</CFFORM>

<cf_screenbottom layout="webapp">

<cfif url.singlemission eq "1">
	<script>
		 find() 
	</script>
</cfif>	

