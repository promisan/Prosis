<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.idmenu" default="">
<cfparam name="url.mode"   default="edit">
<cfparam name="url.ID1"    default="">

<cfset url.idmenu = replace(url.idmenu,",","")>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Source Code Site Control" 
			  menuAccess="Yes" 
			  banner="gray"
			  systemfunctionid="#url.idmenu#">

 <cfajaximport tags="cfform">
 
<script>
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function hl(itm,fld){
	
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }
		 
		 	 		 	
		 if (fld != false){
			
		 itm.className = "highLight2";
		 }else{
			
	     itm.className = "regular";		
		 }
	  }

</script>

<cfif URL.mode eq "edit">
	<cfquery name="AllDirectories"
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT C.TemplateGroup, PG.TemplateGroup as SelectedGroup
		FROM   Ref_TemplateContent C LEFT OUTER JOIN ParameterSiteGroup PG ON PG.TemplateGroup = C.TemplateGroup
		 AND   PG.ApplicationServer = '#URL.ID1#'
		ORDER BY C.TemplateGroup 
	</cfquery>
	
	<cfquery name="Get"
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM ParameterSite
		where ApplicationServer='#URL.ID1#'
		ORDER BY ServerLocation
	</cfquery>
	
<cfelse>

	<cfquery name="AllDirectories"
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT C.TemplateGroup, '' as SelectedGroup
		FROM  Ref_TemplateContent C
		ORDER BY C.TemplateGroup 
	</cfquery>

	<cfquery name="Get"
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM ParameterSite
		WHERE ApplicationServer = '#URL.ID1#'
		AND 1=0
		ORDER BY ServerLocation
	</cfquery>

	
</cfif>	
  
<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this Parameter Site?")) {	
		return true 	
		}	
		return false	
	}	

</script>

<cf_dialogOrganization>

<!--- edit form --->
<cfoutput>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">
	
	<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	    <tr class="hide"><td id="process"></td></tr>
	
		<tr><td height="7"></td></tr> 
	    <TR class="labelmedium">
	    <TD>Site Application Server:</TD>
	    <TD><table cellspacing="0" cellpadding="0">
		    <tr><td>
	  	     <input type="text" name="ApplicationServer" id="ApplicationServer" value="#get.ApplicationServer#" size="20" maxlength="20"class="regularxl">
		     <input type="hidden" name="ApplicationServerOld" id="ApplicationServerOld" value="#get.ApplicationServer#" size="20" readonly="yes" class="regular">
		   </td>
		   <td>&nbsp;</td>
		   <td>
		   <input type="checkbox" class="radiol" name="operational" id="operational" value="1" <cfif get.operational eq "1">checked</cfif>>
		   </td>
		   <td class="labelmedium">Enabled</td>
		   </tr>
		   </table>
	    </TD>
		</TR>	
		
		<cfquery name="Unit" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	    	  SELECT  *
		      FROM    #LanPrefix#Organization
			  WHERE   OrgUnit = '#get.OrgUnit#'
	    </cfquery>
		
		<TR class="labelmedium">
	    <TD><cf_space spaces="75"><cf_UIToolTip tooltip="Organization unit that operates this server">Unit:</cf_UIToolTip>:</TD>
	    <TD height="25" width="90%">
		
			<script language="JavaScript">
			
				function unitblank() {
				document.getElementById("orgunit0").value = ""
				document.getElementById("mission0").value = ""
				document.getElementById("orgunitname0").value = ""		
				}	
				
			</script>
			
			<cfoutput>
			
			 <table><tr><td>
			
			 <img src="#SESSION.root#/Images/contract.gif" alt="Select " name="img5" 
				  onMouseOver="document.img5.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img5.src='#SESSION.root#/Images/contract.gif'"
				  style="cursor: pointer;" alt="" width="20" height="20" border="0" align="absmiddle" 
				  onclick="selectorgN('','','orgunit','applyorgunit','0','')">
				 
				</td>
				<td>
			<input type="text" name="mission0" id="mission0" value="#Unit.Mission#" class="regularxl" size="8" maxlength="20" readonly> 
				</td>
				<td>
			<input type="text" name="orgunitname0" id="orgunitname0" value="#Unit.orgunitName#" class="regularxl" size="50" maxlength="80" readonly>	
			    </td>
				
				<td>
				
				<button type="button" name="blank" id="blank" type="button" class="button3" onClick="unitblank()">
					<img src="#SESSION.root#/Images/delete5.gif" alt="" border="0">
				</button> 
			</td>
			<input type="hidden" name="orgunit0" id="orgunit0" value="#Unit.orgunit#">
			<input type="hidden" name="orgunitcode0" id="orgunitcode0" value="#Unit.orgunitcode#"> 		
			</tr></table> 
			
			</cfoutput>	
		</TD>
		</TR>	
			
		<TR class="labelmedium">
	    <TD class="labelmedium">Owner:</TD>
	    <TD>
			<input type="text" name="Owner" id="Owner" value="#get.Owner#" size="10" maxlength="10"class="regularxl">
	    </TD>
		</TR>	
	
		<TR class="labelmedium">
	    <TD>Site Role:<font color="FF0000">*</font></TD>
	    <TD>
		   <table cellspacing="0" cellpadding="0">
		   <tr>
		   	   <td><input type="radio" class="radiol" name="ServerRole" id="ServerRole" value="Production" <cfif get.ServerRole eq "Production">checked</cfif>></td>
			   <td><font face="Calibri" size="2"><i>Production</td>
		   </tr>
		   <tr>	   
			   <td><input type="radio" class="radiol" name="ServerRole" id="ServerRole" value="QA" <cfif get.ServerRole eq "QA">checked</cfif>></td>
		       <td><font face="Calibri" size="2"><i>Quality Assurance and Deployment server(QA)</td>
		   </tr>
		   <tr>	   
			   <td><input type="radio" class="radiol" name="ServerRole" id="ServerRole" value="Design" <cfif get.ServerRole eq "Design">checked</cfif>></td>
		       <td><font face="Calibri" size="2"><i>Development/Fresh code <font color="C0C0C0">(allows for bi-directional synchronization to QA)</td>
		   </table>
	    </TD>
		</TR>	
		
		
		<TR class="labelmedium">
	    <TD><cf_UIToolTip  tooltip="The server name on the network">Server Host Name:<font color="FF0000">*</font></cf_UIToolTip></TD>
	    <TD> <table cellspacing="0" cellpadding="0">
		   <tr>
		   	<td>
		  	   <cfinput type="Text"
		       name="HostName"
		       value="#get.HostName#"
		       message="please enter a Hostname"
		       required="Yes"      
		       size="30"
		       maxlenght="30"
		       class="regularxl">
	    	</TD>
			<td>&nbsp;</td>
			<TD><cf_UIToolTip  tooltip="The IP and Port of the server on the local network">IP(:PORT) :</cf_UIToolTip></TD>
			<td>&nbsp;</td>
		    <TD>
	  		   <input type="text" name="NodeIP" id="NodeIP" value="#get.NodeIP#" size="20"  maxlenght = "20" class= "regular">
		    </TD>
			</TR>
			</table>
		</td>
		</tr>	
			
		<TR class="labelmedium">
	    <TD><cf_UIToolTip  tooltip="Release packages will be sent to this eMail account">Contact E-Mail:</cf_UIToolTip><font color="FF0000">*</font></TD>
	    <TD>
		   <cfinput type="Text"
	       name="DistributionEMail"
	       value="#get.DistributionEMail#"
	       validate="email"
	       required="Yes"
	       visible="Yes"      
	       size="50"
	       maxlength="50"
	       class="regularxl">
	    </TD>
		</TR>	
		
		<script>
		
		 function loc(val) {
		 
		 count = 0
		 se = document.getElementsByName("location")
		 
		 if (val == "Local") {
		 	  
			  while (se[count]) {
		    	  se[count].className = "regular"
				  count++
			  }
			  
		 } else {
		 
		 	while (se[count]) {
		    	  se[count].className = "hide"
				  count++
			  }
		 
		 }
		 
		 }
		
		</script>
		
		<TR class="labelmedium">
	    <TD>Server Location:<font color="FF0000">*</font></TD>
	    <TD>
		   <table width="120" cellspacing="0" cellpadding="0">
		   <tr class="labelmedium">
		   <td><input type="radio" class="radiol" name="ServerLocation" ID="ServerLocation" value="Local" onclick="loc(this.value)" <cfif get.ServerLocation eq "Local">checked</cfif>>
		   </td><td>Local</td>
		   <td><input type="radio" class="radiol" name="ServerLocation" id="ServerLocation" value="Remote" onclick="loc(this.value)" <cfif get.ServerLocation eq "Remote">checked</cfif>></td>
		   <td>Remote</td>
		   </tr>
		   </table>
	    </TD>
		</TR>	
		
		<TR class="labelmedium">
	    <TD>Code Encryption:</font></TD>
	    <TD>
		   <table cellspacing="0" cellpadding="0">
		   <tr class="labelmedium">
		   	   <td><input class="radiol" type="radio" name="EnableCodeEncryption" id="EnableCodeEncryption" value="1" <cfif get.EnableCodeEncryption eq "1">checked</cfif>></td>
			   <td>Yes, a zip package containing all updates will be created when deploying</td>
			   <td><input class="radiol" type="radio" name="EnableCodeEncryption" id="EnableCodeEncryption" value="0" <cfif get.EnableCodeEncryption eq "0">checked</cfif>></td>
		       <td>No</td>
		   </table>
	    </TD>
		</TR>		
	
		<TR class="labelmedium">
	    <TD><cf_UIToolTip  tooltip="The location that contains a full copy of the code used by the CM tool to determine which code needs to be deployed and which will be updated for each deployment">Replica Path:</cf_UIToolTip>
		<font color="FF0000">*</font>
		</TD>
	    <TD>
		   <table cellspacing="0" cellpadding="0">
		   <tr>
		   <td>
	  	 	   <input type="text"
			       name="replicapath"
				   id="replicapath"
			       value="#get.ReplicaPath#"
			       size="50"
			       class="regularxl"
			       maxlenght="50">
		   </td>
		   <td>&nbsp;</td>
		   <td>
		   <cfdiv bind="url:SiteVerify.cfm?id={replicapath}" id="replica"/>		
		   </td>
		   </tr>
		   </table>
	     </TD>
		</TR>	
		
		<TR id="location" class="labelmedium">
	    <TD>Deployment Mode:</TD>
	    <TD>
		   <table cellspacing="0" cellpadding="0">
		   <tr class="labelmedium">
		   <td><input class="radiol" type="radio" name="EnableBatchUpdate" id="EnableBatchUpdate" value="1" <cfif get.EnableBatchUpdate eq "1">checked</cfif>></td>
		   <td>Batch Deployment</td>
		   <td><input class="radiol" type="radio" name="EnableBatchUpdate" id="EnableBatchUpdate" value="0" <cfif get.EnableBatchUpdate eq "0">checked</cfif>></td>
		   <td>One by one after processed clearance</td>
		   </tr>
		   </table>
	    </TD>
		</TR>	
		
		
		<TR id="location" class="labelmedium">
	    <TD>Source Code Root Path:</TD>
	    <TD>
		   <table cellspacing="0" cellpadding="0">
		   <tr>
		   <td>
	  	   <input type   = "text" 
		       name      = "sourcepath"
			   id        = "sourcepath" 
			   value     = "#get.SourcePath#" 
			   size      = "50"  
			   maxlenght = "50" 
			   class     = "regularxl">
		   </td>
		   <td>&nbsp;</td>
		   <td>
		   <cfdiv bind="url:SiteVerify.cfm?id={sourcepath}" id="source"/>
			
		   </td>
		   </tr>
		   </table>
	    </TD>
		</TR>	
			
		<tr id="location" class="labelmedium">
			<td></td>
			<td>
			<font face="Calibri" size="2"><i>
			 In order to sync source code through CM deployment tool define Replica path as : [Source Code Root path]</td>
			</td>	
		</tr>
		
		<tr id="location" class="regular"><td height="4"></td></tr>
		
		<TR id="location" class="labelmedium">
	    <TD width="140"><cf_UIToolTip  tooltip="The name of the production database server that services the code. If code services several database instances, list all instances separated by a colon : like ASP01\Account01;ASP01\Account02">Database server(s):</cf_UIToolTip></TD>
	    <TD>
	  	   <input type="text" name="DatabaseServer" id="DatabaseServer" value="#get.DataBaseServer#" size="50"  maxlenght= "50" class= "regularxl">
	    </TD>
		</TR>		
		
		<tr id="location" class="labelmedium">
			<td></td>
			<td>
			<font face="Calibri" size="2"><i>
			 In order to deploy reports through the Report Framework CM tool (workflow) record the names of the databases that would need to be updated.</td>
			</td>	
		</tr>
			
		<script>
			loc("#get.serverlocation#")
		</script>
		
	   <tr><td height="1" colspan="2" class="linedotted"></td></tr>
		
	   <TR><td colspan="2" width="100%">
		   <table cellspacing="0" cellpadding="0" class="formpadding">
		   
			    <tr class="labelmedium"><td colspan="2">The following directories will be deployed to this site:</font></td></tr>
						
				<tr><td height="1" colspan="2" class="linedotted"></td></tr>
						
			   	<TR valign="top">
				    	<TD style="padding-left:40px"></TD>
					    <TD width="100%" valign="top">
						
						<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						
						<cfset row = 0>				
						
							    <cfloop query="AllDirectories"> 
								     <cfset row = row + 1>
									 <cfif SelectedGroup neq "">
										<cfset cl = "f4f4f4">
									<cfelse>
						    			<cfset cl = "ffffff">
									</cfif>
								     <cfif row eq "1"><TR></cfif>
							    	 <TD bgcolor="#cl#" class="labelit" style="padding-left:5px">#TemplateGroup#/</TD>
							         <TD bgcolor="#cl#" align="right" style="padding-right:7px">
									 	<cfif SelectedGroup eq "">
								            <input class="radiol" type="checkbox" name="TemplateGroup" id="TemplateGroup" value="#TemplateGroup#" onClick="hl(this,this.checked)">
									    <cfelse>
								    	    <input class="radiol" type="checkbox" name="TemplateGroup" id="TemplateGroup" value="#TemplateGroup#" checked onClick="hl(this,this.checked)">
										</cfif>
							          </TD>
									  <cfif row eq "6"></TR><cfset row = 0></cfif>
							    </cfloop> 
					   	 </table>
						
					    </TD>
				</TR>	
				
				<tr><td height="1" colspan="2" class="linedotted"></td></tr>
				
		    </table>
		</td></tr>
		
		<tr>
			
		<td align="center" colspan="2">
			<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">		
			<cfif url.mode eq "edit">
			    <input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
				<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
			<cfelse>
			    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Insert ">
			</cfif>
		</td>	
		</tr>	
			
	</TABLE>
	
</cfform>

</cfoutput>
