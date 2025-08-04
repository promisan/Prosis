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

<cfquery name="Claim" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Claim
	WHERE   ClaimId = '#URL.ClaimId#'	
</cfquery>

<cfquery name="Claimant" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Person
	WHERE   PersonNo = '#Claim.PersonNo#'
</cfquery>

<cfquery name="qType" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ClaimantType
</cfquery>

<cfquery name="qRank" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Rank
</cfquery>

<cfquery name="qNation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Nation
	WHERE   Code = '#Claimant.Nationality#'
</cfquery>

<cfquery name="get" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ClaimPerson
	WHERE   ClaimId='#URL.ClaimId#'
</cfquery>

<cfinvoke component="Service.Access"  
     method="CaseFileManager" 
     mission="#Claim.Mission#" 
	 claimtype="#claim.claimtype#"
     returnvariable="access">

<cfif get.recordcount eq "0" and (Access eq "ALL" or Access eq "EDIT")>
	    <cfset URL.ID2="new">
<cfelse>
	    <cfset URL.ID2="update">
</cfif>

<cfif access eq "EDIT" or access eq "ALL">
    <cfset mode = "Edit">
<cfelse>
	<cfset mode = "View">
</cfif>   

<cfoutput>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td align="right" style="height:20px" class="labelit" id="personalprocess"></td></tr>
	
<tr><td>

<cf_divscroll>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td>
		
	<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formspacing">
	
		<tr><td height="4"></td></tr>
					
	    <tr class="linedotted">
			<td height="25" width="10%" class="labelmedium"><cf_tl id="IndexNo">:</td>
			<td height="25" class="labelmedium"><A title="View profile" HREF ="javascript:EditPerson('#claimant.PersonNo#')"><font color="0080FF">#Claimant.IndexNo#</font></td>
			<td height="25" width="10%" class="labelmedium"><cf_tl id="Nationality">:</td>
			<td height="25" class="labelmedium">#qNation.Name# (#Claimant.Nationality#)</td>
		</tr>		
	    <tr class="linedotted">
			<td height="25" width="10%" class="labelmedium"><cf_tl id="Full Name">:</td>
			<td height="25" class="labelmedium">#Claimant.LastName#, #Claimant.FirstName# (#Claimant.Gender#)</td>
			<td height="25" width="10%" class="labelmedium"><cf_tl id="Date of birth">:</td>
			<td height="25" class="labelmedium">#DateFormat(Claimant.Birthdate,CLIENT.DateFormatShow)#</td>
			
		</tr>		
	   
	    <tr class="linedotted">
			<td height="25" width="10%" class="labelmedium"><cf_tl id="Type of person"></td>
			<td height="25" class="labelmedium">
			<cfif mode eq "Edit">
			    <select name="Type" style="font:10px" onchange="ptoken.navigate('#session.root#/CaseFile/Application/Case/Personal/PersonalSubmit.cfm?claimid=#url.claimid#&field=type&value='+this.value,'personalprocess')" class="regularxl">
			      <cfloop query="qType">
				  	<cfif Code eq get.Type or (get.recordcount eq "0" and #Code# eq "UNDEFINED")>
					    <option value="#Code#"  selected>#Description#</option>
					<cfelse>
			  		    <option value="#Code#">#Description#</option>
					</cfif>
				  </cfloop>
				</select>
			<cfelse>
				<cfquery dbtype="query" name="DType">
					Select * from qType
					where Code='#get.Type#'
				</cfquery>
				
				#Dtype.Description#
			
			</cfif>
			</td>
			<td height="25" width="10%" class="labelmedium"><cf_tl id="Marital Status">:</td>
			<td height="25" class="labelmedium">#Claimant.MaritalStatus#</td>
		</tr>
 
	    <tr>
			<td height="25" width="10%" class="labelmedium"><cf_tl id="Military Rank">:</td>
			<td height="25" class="labelmedium">
			<cfif mode eq "Edit">
			    <select name="Rank" style="font:10px" onchange="ptoken.navigate('#session.root#/CaseFile/Application/Case/Personal/PersonalSubmit.cfm?claimid=#url.claimid#&field=rank&value='+this.value,'personalprocess')" class="regularxl">
				      <cfloop query="qRank">
					  	<cfif Code eq get.Rank or (get.recordcount eq "0" and Code eq "UNDEFINED")>
						    <option value="#Code#" selected>#Description#</option>
						<cfelse>
				  		    <option value="#Code#">#Description#</option>
						</cfif>
					  </cfloop>
				</select>
			<cfelse>
				<cfquery dbtype="query" name="DRank">
					Select * from
					qRank where Code='#get.Rank#'
				</cfquery>
				
				#Drank.Description#
			
			</cfif>
			
			</td>
			<td height="25" width="10%" class="labelmedium"><cf_tl id="Passport">:</td>
			<td height="25" class="labelmedium">
			
				<cf_tl id="Please enter a valid passport" var="1">
			
				<cfif mode eq "Edit">
					<input type="Text" 
					   onchange="ptoken.navigate('#session.root#/CaseFile/Application/Case/Personal/PersonalSubmit.cfm?claimid=#url.claimid#&field=passport&value='+this.value,'personalprocess')"
					   name="Passport"
				       required="No"
					   message="#lt_text#"
					   class="regularxl"
					   value="#get.Passport#"
			    	   visible="Yes"
				       enabled="Yes"
					   size = "10"
					   maxLength = "10">
				<cfelse>
					#get.Passport#
				</cfif>
			</td>
		</tr>
						
		<cfset url.id = claimant.personno>		
		<cfset url.header = "0">
		
		<!---
		<tr><td colspan="4" height="45" align="center">		
		   <cfinclude template="../../../../Staffing/Application/Employee/PersonViewHeaderContract.cfm">
		</td></tr>	
		--->
		
	</td>
	</tr>
	
	</table>
		
	</td>
	</tr>
	
	<tr>
		<td height="100%" style="padding-top:6px">			
			
			<table width="99%" height="100%" cellspacing="0" cellpadding="0" align="center" >
				<tr>
					<td valign="top" id="addressdetail" style="height:500px;">
						<cfinclude template="../../../../Staffing/Application/Employee/Address/EmployeeAddressDetail.cfm">
					</td>
				</tr>
			</table>
							
		</td>
	</tr>	
				
	</table>	
	
	</cf_divscroll>
				
</td>
</tr>	
				
</table>	
	
</cfoutput>	