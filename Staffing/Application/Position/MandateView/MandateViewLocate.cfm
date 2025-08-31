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
<cf_screentop html="no" jquery="Yes">

<cf_calendarscript>

<cfoutput>

<script language="JavaScript">
	
	function filter() {
	
		sel = parent.document.getElementById("selectiondate")	
		loc = document.getElementById("locationcode")
		adm = document.getElementById("orgunit1")
		org = document.getElementById("orgunitcode")
		occ = document.getElementById("occgroup")
		vac = document.getElementById("vacant")
		par = document.getElementById("parent")
		pst = document.getElementById("sourcepostnumber")
		nme = document.getElementById("name")
				
		ptoken.open('MandateViewGeneral.cfm?Act=0&ID=#URL.ID#&ID2=#URL.ID2#&ID3=#URL.ID3#&selectiondate='+sel.value+'&locationcode='+loc.value+'&orgunit1='+adm.value+'&orgunitcode='+org.value+'&occgroup='+occ.value+'&vacant='+vac.value+'&parent='+par.value+'&sourcepostnumber='+pst.value+'&name='+nme.value,'detail')
	}
	
	function applyunit(org) {    
	    ptoken.navigate('setUnit.cfm?orgunit='+org,'process')
}

</script>

</cfoutput>

<cfform method="POST" name="locate">

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
	FROM    Ref_Mandate
	WHERE   Mission   = '#URL.ID2#'
	AND     MandateNo = '#URL.ID3#'
</cfquery>

<table width="98%" border="0"  align="center" class="formspacing formpadding">

<tr class="line">		
	<td height="17" width="97%" class="labelit" style="padding-left:5px;height:45px;font-size:20px">
    
	    <cfif URL.ID eq "BOR">
			Borrowed from : <cfoutput><b>#URL.Mission#</b></cfoutput>&nbsp;
		</cfif>
    	<cfoutput>
    		Staffing period: <font color="408080"><b>#Mandate.Description#</b></font> &nbsp;Status: <font color="408080"><b><cfif #Mandate.MandateStatus# eq "1">Closed<cfelse>Draft</cfif></b> &nbsp;Period: <font color="408080"><b>#DateFormat(Mandate.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(Mandate.DateExpiration, CLIENT.DateFormatShow)#</b>
		</cfoutput>
	</td>
		
	<td width="30" align="right">
	
	<script language="JavaScript">
	
	function toggle(itm,act) {
		if (act == "hide") {
		   	frm  = document.getElementById("inquiry");
		    frm.className = "hide"
			se = document.getElementById("img1")
			se.className = "hide"
			se = document.getElementById("img2")
			se.className = "regular"
		} else	{
		  	frm  = document.getElementById("inquiry");
		    frm.className = "regular"
			se = document.getElementById("img2")
			se.className = "hide"
			se = document.getElementById("img1")
			se.className = "regular"
		}
	}
		
	</script>
		
	<cfoutput>
	<img src="#SESSION.root#/Images/up2.gif"   alt="Filter options" name="img1" id="img1" border="0" align="absmiddle" class="regular" style="cursor: pointer;" onClick="toggle(this,'hide')">
	<img src="#SESSION.root#/Images/down2.gif" alt="Filter options" onclick="toggle(this,'show')" class="hide" style="cursor: pointer;" align="absmiddle" id="img2" border="0">
	</cfoutput>
	</td>
</tr>
<tr>

<cf_dialogOrganization>

<cfquery name="OccGroup" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   DISTINCT O.*
	FROM     OccGroup O, Employee.dbo.Position P, FunctionTitle F
	WHERE    O.OccupationalGroup = F.OccupationalGroup
	AND      P.FunctionNo = F.FunctionNo
	AND      P.Mission = '#URL.ID2#'
	AND      P.MandateNo = '#URL.ID3#'
	ORDER BY Description
</cfquery>

<cfquery name="AdminUnit" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   DISTINCT OrgUnitAdministrative as OrgUnit, O.OrgUnitName, O.Mission
	FROM     Position P, Organization.dbo.Organization O
	WHERE    P.OrgUnitAdministrative = O.OrgUnit
	AND      P.Mission = '#URL.ID2#'
	AND      P.MandateNo = '#URL.ID3#'
	ORDER BY OrgUnitName
</cfquery>

<cfquery name="Location" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Location
	WHERE    Mission = '#URL.ID2#'
	ORDER BY ListingOrder, LocationName
</cfquery>

<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM    Ref_PostGradeParent
</cfquery>

<td colspan="2">	

<table width="98%" cellspacing="0" id="inquiry" align="center" class="formpadding">

	<TR class="hide">
	
	<TD class="labelit">Selection&nbsp;date:</TD>
	<TD>	
	 
	 <cfif Mandate.DateExpiration lt now()>
	 
		 	<cf_intelliCalendarDate9
				FieldName="selectiondate" 
				class="regularxl"
				Default="#Dateformat(Mandate.DateExpiration, CLIENT.DateFormatShow)#"
				AllowBlank="False">	
		
	   <cfelseif Mandate.DateEffective gt now()>
	 
		 	<cf_intelliCalendarDate9
				FieldName="selectiondate" 
				class="regularxl"
				Default="#Dateformat(Mandate.DateEffective, CLIENT.DateFormatShow)#"
				AllowBlank="False">		
		
		<cfelse>
		
			<cf_intelliCalendarDate9
				FieldName="selectiondate" 
				class="regularxl"
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				AllowBlank="False">	
		
	  </cfif>	
		
	</TD>
		
	</tr>
		
	<TR>
	
		<TD class="labelit"><cf_tl id="Unit">:</TD>
				
		<td>
		
			<cfoutput>
			
				<table cellspacing="0" cellpadding="0">
				<tr>
				<td>
				<input type="text" name="orgunitname" id="orgunitname" value="" class="regularxl" size="35" maxlength="60" readonly>
				<input type="hidden" name="orgunitcode" id="orgunitcode" value="" class="regularxl" size="35" maxlength="60" readonly>
				</td>
				<td width="1"></td>
				<td>
				
					<table style="border:1px solid silver;width:30px;height:25px" cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td align="center">
						<img src="#SESSION.root#/Images/locate3.gif"
						  alt="" 
						  height="15" 
						  width="15" 
						  align="absmiddle"
						  border="0" 
						  onClick="selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass','#URL.ID2#','#URL.ID3#','')">				   						
					</td></tr>
					</table>	
					
				</td>
				<td width="1"></td>
				<td>
					<table style="border:1px solid silver;width:30px;height:25px" cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td align="center">
					<img src="#SESSION.root#/Images/delete5.gif"
					  alt="" height="15" width="15" align="absmiddle"
					  border="0" 
					  onClick="orgblank()">				   						
					</td></tr>
					</table>	
					
				</td>
				<td id="process">
				</td></tr>
				</table>			
			
			<script>
			
			function orgblank() {
			document.getElementById("orgunitname").value = ""
			document.getElementById("orgunit1").value = ""
			}
			
			</script>
			
				<input type="hidden" name="orgunit"      id="orgunit"      value="">
				<input type="hidden" name="orgunitcode"  id="orgunitcode"  value=""> 
				<input type="hidden" name="mission"      id="mission"      value=""> 
				
			</cfoutput>	
		
		</td>	
		
		<TD class="labelit"><cf_tl id="Location">:</TD>
				
		<td>
		    <select name="locationcode" id="locationcode" size="1" class="regularxl">
			<option value="" selected>All</option>
		    <cfoutput query="Location">
				<option value="#LocationCode#">#LocationName#</option>
			</cfoutput>
		    </select>
		</td>	
			
	</TR>
	
	<TR>
		
		<TD class="labelit"><cf_tl id="Admin Unit">:</TD>
				
		<td align="left">
		
		<cfquery name="Admin" 
		datasource="AppsOrganization" 
		maxrows=1 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Ref_Mission
			WHERE Mission = '#URL.ID2#'
			AND TreeAdministrative IN (SELECT Mission FROM Ref_Mission WHERE MissionStatus = '1')
		</cfquery> 
		
		<cfif Admin.Recordcount eq "1">
		
		    <cfoutput>
		
			<table cellspacing="0" cellpadding="0">

				<tr>
				<td><input type="text" name="orgunitname1" id="orgunitname1" value="" class="regularxl" size="35" maxlength="60" readonly></td>
				<td width="1"></td>
				<td>
				
					<table style="border:1px solid silver;width:30px;height:25px">
					<tr><td align="center">
					<img src="#SESSION.root#/Images/locate3.gif"
					  alt="" height="15" width="15" align="absmiddle"
					  border="0" 
					  onClick="selectorgN('<cfoutput>#URL.ID#</cfoutput>','Administrative','orgunit','applyorgUnit','1')">				   						
					</td></tr>
					</table>	
					
				</td>
				<td width="1"></td>
				<td>
					<table style="border:1px solid silver;width:30px;height:25px">
					<tr><td align="center">
					<img src="#SESSION.root#/Images/delete5.gif"
					  alt="" height="15" width="15" align="absmiddle"
					  border="0" 
					  onClick="admblank()">				   						
					</td></tr>
					</table>	
					
				</td>
				<td class="hide" id="process"></td>
				
				</tr>
				
			</table>
			
			</cfoutput>
		
			<script>
			
			function admblank()	{
			document.getElementById("orgunitname1").value = ""
			document.getElementById("orgunit1").value = ""
			}
			
			</script>
			
						
			<input type="hidden" name="mission1"      id="mission1"      value="" class="regular" size="10" maxlength="20" readonly> 
			<input type="hidden" name="orgunit1"      id="orgunit1"      value="">
			<input type="hidden" name="orgunitcode1"  id="orgunitcode1"  value="">
			<input type="hidden" name="orgunitclass1" id="orgunitclass1" value="">	
		
		<cfelse>
				
		    <select name="orgunit1" id="orgunit1" size="1" style="width:300" class="regularxl">
			<option value="" selected>All</option>
		    <cfoutput query="AdminUnit">
				<option value="#OrgUnit#">#Mission# #OrgUnitName#</option>
			</cfoutput>
		    </select>
			
		</cfif>	
					
			
		</td>	
		  	
		<td class="labelit"><cf_tl id="Occupation">:</td>
		<td align="left">
		 <select name="occgroup" id="occgroup" size="1" class="regularxl">
			<option value="" selected>All</option>
		    <cfoutput query="OccGroup">
				<option value="#OccupationalGroup#">#Description#</option>
			</cfoutput>
		    </select>
		</td>	
		
	</tr>
		
	<TR>
	<td class="labelit"><cf_tl id="Vacancy">:</td>
	<td>
	 <select name="vacant" id="vacant" size="1" class="regularxl">
		<option value="" selected>All</option>
	    <option value="1">Vacant only</option>
		<option value="0">Incumbered only</option>
     </select>
		
	</td>
	<TD class="labelit"><cf_tl id="Category">:</TD>
	<TD>	
	
	   <select name="parent" id="parent" size="1" class="regularxl">
		<option value="" selected>All</option>
	    <cfoutput query="Parent">
			<option value="#Code#">#Description#</option>
		</cfoutput>
	    </select>
	
	</TD>
		
	</tr>
	
	<TR>
		<td class="labelit">PostNo/Title/Project:</td>
		<td>
		<input type="text" id="sourcepostnumber" name="sourcepostnumber" size="30" maxlength="30" class="regularxl">
		</td>
		<TD class="labelit">Name/Index:</TD>
		<TD class="labelit">	
		<input type="text" id="name" name="name" size="30" maxlength="30" class="regularxl">
		</TD>		
	</tr>
	
	<tr><td></td></tr>
	<tr><td height="1" colspan="4" class="line"></td></tr>
	
	<tr bgcolor="ffffff"><td colspan="4" height="30" align="center">
		<input type="reset"  class="button10g" value="Reset">
		<input type="button" name="Submit" value="Search" class="button10g" onclick="javascript:filter()">
	</td></tr>		
	
</TABLE>

</td></tr>

</table>

</cfform>