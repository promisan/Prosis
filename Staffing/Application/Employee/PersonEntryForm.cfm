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
<cfoutput>

<cfparam name="url.personno" default="">
<cfparam name="url.mode"     default="entry">
<cfparam name="url.box"      default="">
<cfparam name="url.link"     default="">


<cfquery name="Applicant" 
 datasource="AppsSelection" 
 maxrows=1 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT   *
    FROM     Applicant
    WHERE    PersonNo = '#URL.PersonNo#'
</cfquery>

<cfquery name="qLast" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT TOP 1 * 
    FROM  Person
    ORDER BY Created DESC
</cfquery>	

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   CODE, NAME 
    FROM     Ref_Nation
	WHERE    Operational = '1'
	ORDER BY NAME
</cfquery>

<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Parameter
</cfquery>

<cfquery name="PersonStatus" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_PersonStatus
	ORDER BY ListingOrder	
</cfquery>

<cfform name="formperson" onsubmit="return false">

<table width="96%" bgcolor="white" align="center">
	 		
	  <tr><td height="5"></td></tr>		 			  
	  
	  <tr><td style="height:6px" colspan="2" id="personresult"></td></tr>
	      
	  <tr>
	    <td width="100%" class="header" style="padding-left:20px">
	    <table width="100%" class="formpadding">		
		
		<!--- Person Status --->
		<cfif PersonStatus.recordcount gt 0>
		
			<tr class="labelmedium">
		        <td><cf_tl id="Modality">:</td>
		        <TD colspan="3">
					<select name="PersonStatus" message="Please select a status" required="No" class="regularxl enterastab" style="width:150px">
			   	 	<cfloop query="PersonStatus">
					<option value="#Code#">
						#Code#&nbsp;:&nbsp;#Description#
					</option>
					</cfloop>
				</TD>
			</tr>
		
		<cfelse>
		
			<input type="hidden" value="" name="PersonStatus" id="PersonStatus">
		
		</cfif>
	   	
	    <!--- Field: IndexNo --->
	    <TR>
	    <TD style="min-width:100px"><cf_space spaces="60">#CLIENT.IndexNoName# :</TD>
	    <TD colspan="3">
		
		<cfif (Parameter.Indexno neq "0" and Parameter.IndexNo neq "") and Applicant.IndexNo eq "">	
						
			<cfset indexno = Parameter.Indexno + 1>		
			
			<input class="regularxl enterastab" 
			  type="text" name="IndexNo" style="width:100px;text-align:center;background-color:f1f1f1"
			  value="#indexno#" 
			  size="16" readonly required="No" maxlength="20">		
			
		<cfelse>
		
			<cfset indexno = Applicant.IndexNo>	
			
			<cfinput class="regularxl enterastab" 
			  type="text" name="IndexNo" 
			  value="#indexno#" 
			  size="16" message="Please enter #CLIENT.IndexNoName#" required="No" maxlength="20">		
		  		
		</cfif>
		
		</TD>
		</TR>	
		
		    <!--- Field: LastName --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="Last name">: <font color="FF0000">*</font></TD>
	    <TD colspan="3">
		
			<cfinput class="regularxl enterastab" type="Text" name="LastName" value="#Applicant.LastName#" message="Please enter lastname" required="Yes" size="40" maxlength="40">
			
		</TD>
		</TR>
		
		    <!--- Field: LastName --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="Maiden name">:</TD>
	    <TD colspan="3">
		
			<cfinput class="regularxl enterastab" type="Text" name="MaidenName" value="#Applicant.MaidenName#" message="Please enter a maiden name" required="No" size="40" maxlength="40">
			
		</TD>
		</TR>
		
	    <!--- Field: FirstName --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="FirstName">: <font color="FF0000">*</font></TD>
	    <TD colspan="3">
		
			<cfinput class="regularxl enterastab" type="Text" name="FirstName" message="Please enter a firstname" value="#Applicant.FirstName#" required="Yes" size="30" maxlength="30">
			
		</TD>
		</TR>

	    <!--- Field: MiddleName --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="Middle name">:</TD>
	    <TD colspan="3">
		
			<INPUT type="text" class="regularxl enterastab" name="MiddleName" value="#Applicant.MiddleName#"  maxLength="25" size="20">
			
		</TD>
		</TR>	
	
	   
		
	    <!--- Field: BirthDate --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="Birth date">: <font color="FF0000">*</font></TD>
	    <TD colspan="3">
		
		  <cf_intelliCalendarDate9
			FieldName="DOB" 
			Default="#dateformat(Applicant.DOB,CLIENT.DateFormatShow)#"
			DateValidStart="19400101"	
			Message="Please enter a correct birth date"		
			class="regularxl enterastab"
			AllowBlank="False">	
				
		</TD>
		</TR>
		
	    <!--- Field: Gender --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="Gender">:</TD>
	    <TD colspan="3" style="height:30px;padding-top:2px">
		
			<INPUT class="enterastab radiol" type="radio" name="Gender" value="M" <cfif Applicant.gender neq "F">checked</cfif>> <cf_tl id="Male">
			<INPUT class="enterastab radiol" type="radio" name="Gender" value="F" <cfif Applicant.gender neq "M">checked</cfif>> <cf_tl id="Female">
			
		</TD>
		</TR>
		
	    <!--- Field: Nationality --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="Nationality">: <font color="FF0000">*</font></TD>
	    <TD colspan="3">
		
	    	<select name="Nationality" message="Please select a nationality" required="No" class="regularxl enterastab">
		    <cfloop query="Nation">
			<option value="#Code#" <cfif Applicant.Nationality eq Code or qLast.BirthNationality eq  Code>selected</cfif>>
			#Name#
			</option>
			</cfloop>
		    
	   	</select>	
					
		</TD>
		</TR>		
		
		<cfif Parameter.EnablePersonGroup neq "0">
		
			
			<TR class="labelmedium">
		    <TD><cf_tl id="Marital status">:</TD>
		    <TD colspan="3">
			
				<INPUT type="radio" class="enterastab" name="MaritalStatus" value="Single" checked> <cf_tl id="Single">
				<INPUT type="radio" class="enterastab" name="MaritalStatus" value="Married"> <cf_tl id="Married">
				<INPUT type="radio" class="enterastab" name="MaritalStatus" value="Divorced"> <cf_tl id="Divorced">
						
			</TD>
			</TR>
			
		<cfelse>
		
			<input type="hidden" name="MaritalStatus" value="">
		
		</cfif>
		
		<TR class="labelmedium">
		<TD><cf_tl id="Birth Nationality">:</TD>
		<TD colspan="3">
	
	  	    <cfselect name="BirthNationality" required="No" class="regularxl enterastab">
			<option value="" ></option>
		    <cfloop query="Nation">
			<option value="#Code#" <cfif qLast.BirthNationality eq Code>selected</cfif>>#Name#</option>
			</cfloop>
		    </cfselect>		
			
		</TD>
		</TR>
		
		  <!--- Field: Birth city --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="Birth city">:</TD>
	    <TD colspan="3">
		
		<INPUT type="text" name="BirthCity" value="#Applicant.BirthCity#" maxLength="50" size="50" class="regularxl enterastab">
			
		</TD>
		</TR>
		
		
	    <!--- Field: Bloodtype --->
	    <TR class="labelmedium">
	    <TD><cf_tl id="Blood type">:</TD>
	    <TD colspan="3">
		
			<INPUT type="text" name="Bloodtype" value="" maxLength="3" size="3" class="regularxl enterastab">
			
		</TD>
		</TR>
		
		
		<cfif 1 eq 0>
		    <TR class="labelmedium">
		    <TD><cf_tl id="Entry organization">:</TD>
		    <TD colspan="3">
			
			  <cf_intelliCalendarDate9
				FieldName="OrganizationStart" 
				Default=""		
				class="regularxl enterastab"
				AllowBlank="True">	
						
			</TD>
			</TR>
		<cfelse>
			<input type="hidden" id="OrganizationStart" name="OrganizationStart" value="">	
		</cfif>
		
		<TR class="labelmedium">
		<TD><cf_tl id="Recruitment Country">:</TD>
		<TD colspan="3">
					
	  	    <cfselect name="RecruitmentCountry" required="No" class="regularxl enterastab" style="width:140px">
			    <cfloop query="Nation">
				<option value="#Code#" <cfif qLast.RecruitmentCountry eq Code>selected</cfif>>#Name#</option>
				</cfloop>
		    </cfselect>		
			
			</td>	
		</tr>
		
		<TR class="labelmedium">
	    <TD><cf_tl id="Recruitment city">:</TD>
	    <TD colspan="3">						
			
			<input type="text" name="RecruitmentCity" class="regularxl enterastab" value="" size="50" maxlength="50">					
						
		</TD>
		</TR>
						
		<tr class="labelmedium"><td colspan="2"><font color="808080"><cf_tl id="Localised fields"></td></tr>
							
			<cfquery name="Topic" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT  *
			     FROM  Ref_PersonGroup
				 WHERE Code IN (SELECT GroupCode FROM Ref_PersonGroupList)
				 AND   Context = 'Person'
				 AND Operational=1
			</cfquery>
			
			<cfif Topic.recordcount gt "0">
								
				<cfset topicCol  = 2> <!--- number of columns --->
				<cfset regularWidth = "15"> <!--- to be aligned with section above --->
				<cfset cont = 0>
			
				<cfloop query="topic">
					
					<cfif cont eq 0> <tr> </cfif>		
					
						<td class="labelit" style="padding-left:10px;height:26;padding-right:10px" width="#regularWidth#%">#Description#:<font color="FF0000">*<cf_space spaces="40"></font></td>
						
						<cfif cont eq (topicCol - 1) or topic.recordcount eq 1>
							<cfset w = "#100-(regularWidth*(topicCol-1))#%">
						<cfelse>
							<cfset w = "#regularWidth#%">	
						</cfif>	
						 
						<td align="left" style="padding-left:1px;padding-right:10px" width="#w#">
						
						<cfquery name="List" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  SELECT  *
						     FROM  Ref_PersonGroupList
							 WHERE GroupCode = '#Code#'
							 ORDER BY GroupListOrder
						</cfquery>
														
						<cfselect name="ListCode_#Code#" class="regularxl enterastab">
							<cfloop query="List">
							  <option value="#GroupListCode#"><cfif GroupListCode neq "0">#Description#</cfif></option>
							</cfloop>
						</cfselect>
						</td>
					
					<cfset cont = cont + 1>
					
					<cfif cont eq topicCol> </tr> <cfset cont = 0>  </cfif>
				
				</cfloop>
					
		
			</cfif>
			
				
		 <TR>
	    <TD><cf_tl id="ExternalReference">:</TD>
	    <TD colspan="3">
		
		<cfinput type="Text"
	       name="Reference"
	       value=""
	       required="No"     
		   class="regularxl enterastab" 
	       size="15"
	       maxlength="20">
			
		</TD>
		</TR>	
				
		<TR class="labelmedium">
	        <td valign="top" style="padding-top:3px"><cf_tl id="Remarks">:</td>
	        <TD colspan="3"><textarea style="padding:3px;font-size:13;width:90%" class="regular enterastab" rows="3" name="Remarks"></textarea> </TD>
		</TR>
			
		<tr><td height="1" colspan="4" class="line"></td></tr>
			  
	    <tr><td colspan="4" height="30" align="center">
		   <cf_tl id="Reset" var="vReset">
		   <cf_tl id="Save"  var="vSave">      
		   
	       <input class="button10g" style="width:150;height:26" type="reset"  name="Reset" id="Reset" value="#vReset#">
	    		   
		   <cfif url.mode eq "lookup">
		   <input type="button" style="width:150;height:26" name="Submit" id="Submit" value=" #vSave# " class="button10g" onclick="lookuppersonvalidate('#url.mode#','#url.box#','#url.link#')">   		  
		   <cfelse>	  
		   <input type="button" style="width:150;height:26" name="Submit" id="Submit" value=" #vSave# " class="button10g" onclick="validate('#url.mode#')">   
		   </cfif>		   
		
	     </td>
	
		</table>
		</td></tr>
		
		<tr>
			<td id="result"></td>
		</tr>
		
	</table>	

</CFFORM>

<cfset ajaxOnLoad("doCalendar")>

</cfoutput>