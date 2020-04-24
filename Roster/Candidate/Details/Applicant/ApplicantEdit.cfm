
<cf_screentop height="100%"  scroll="Yes" label="Edit Person" html="No" line="no" layout="webapp" jquery="Yes" user="No" banner="gray">

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT CODE, NAME 
    FROM   xl#client.languageid#_Ref_Nation
	WHERE  Operational = '1'
	ORDER BY NAME
</cfquery>

<cfquery name="Class" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_ApplicantClass
</cfquery>

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Applicant 
WHERE PersonNo = '#URL.ID#'
</cfquery>

<script>

function validate() {
	document.ApplicantEdit.onsubmit() 
	if( _CF_error_messages.length == 0 ) {         
		ColdFusion.navigate('ApplicantEditSubmit.cfm','process','','','POST','ApplicantEdit')
	 }   
}	 

</script>

<cf_dialogPosition>

<cfform action="ApplicantEditSubmit.cfm"  onsubmit="return false" style="height:100" method="POST" name="ApplicantEdit" id="ApplicantEdit">
 
<table width="92%" height="100%" cellspacing="" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="10"></td></tr>
	
	<tr class="hide"><td colspan="2" id="process"></td></tr>
	
		
	    <!--- Field: Applicant.LastName --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Last name">:<font color="FF0000">*)</font></TD>
	    <TD>
						
		  <cfoutput>
		  	<cf_tl id = "Please enter last name" var="1" class="message">
			<cfinput type="Text" name="LastName" id="LastName" value="#get.LastName#" message="#lt_text#" required="Yes" visible="Yes" enabled="Yes" size="30" maxlength="40" class="regularxl enterastab">
			<input type="Hidden" name="PersonNo" id="PersonNo" value="#get.PersonNo#">
		  </cfoutput>
			
		</TD>
		</TR>
		
		 <!--- Field: Applicant.LastName --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="2nd Last name">:</TD>
	    <TD>
		  <cfinput type="Text" name="LastName2" id="LastName2" value="#get.LastName2#" required="No" visible="Yes" enabled="Yes" size="30" maxlength="40" class="regularxl enterastab">		
		</TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Maiden name">:</TD>
	    <TD>	 
			<cfinput type="Text" name="MaidenName" id="MaidenName" value="#get.MaidenName#" message="Please enter lastname" required="No" visible="Yes" enabled="Yes" size="30" maxlength="40" class="regularxl enterastab">		
		</TD>
		</TR>
		
	    <!--- Field: Applicant.FirstName --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="First name">:<font color="#FF0000">*)</font></TD>
	    <TD class="regular">
			<cf_tl id= "Please enter a firstname" var="1" class="message">
	    	<cfinput type="Text" name="FirstName" id="FirstName" value="#get.FirstName#" message="#lt_text#" required="Yes" visible="Yes" enabled="Yes" size="30" maxlength="30" class="regularxl enterastab">
			
		</TD>
		</TR>
		

			
	    <!--- Field: Applicant.MiddleName --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Middle name">:</TD>
	    <TD class="regular">
		     <cfoutput >
			<INPUT class="regularxl enterastab" type="text" name="MiddleName" id="MiddleName" value="#get.MiddleName#" maxLength="25" size="25">
			</cfoutput>
		</TD>
		</TR>
		
	    <!--- Field: Applicant.MiddleName --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="2nd Middle name">:</TD>
	    <TD class="regular">
		     <cfoutput>
			<INPUT class="regularxl enterastab" type="text" name="MiddleName2" id="MiddleName2" value="#get.MiddleName2#" maxLength="25" size="25">
			</cfoutput>
		</TD>
		</TR>
		
		<cf_calendarscript>
				
	    <!--- Field: Applicant.DOB --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="DOB">:</TD>
	    <TD>	
	    	<cfoutput>
			
				<cf_intelliCalendarDate9
				FieldName="DOB" 
				class="regularxl enterastab"
				DateValidStart="19300101"
				Default="#DateFormat(Get.DOB, CLIENT.DateFormatShow)#"
				AllowBlank="False">	
				
			</cfoutput>
			
		</TD>
		</TR>
				
			
		<!--- Field: Applicant.Gender --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Marital Status">:</TD>
	    <TD>
				<cfoutput>
				<cfquery name = "qMarital" datasource = "AppsSelection">
					SELECT * 
					FROM   Ref_MaritalStatus
					ORDER BY ListingOrder
				</cfquery>
	
		  	 	<select name="MaritalStatus" required="No" class="regularxl enterastab">
				<cfset ms = Get.MaritalStatus>				
			    <cfloop query="qMarital">
		        		 <option value="#Code#" <cfif Code IS ms>selected</cfif>>#Description#</option>
				</cfloop> 
				<option value="">N/A</option>
			    </select>	
				</cfoutput>
		</TD>
		</TR>
		
	
	
		<!--- Field: Applicant.Gender --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Gender">:</TD>
	    <TD>
		<table cellspacing="0" cellpadding="0"><tr>				
	    	<td style="Padding-left:0px"><INPUT class="radiol enterastab" type="radio" name="Gender" id="Gender" value="M" <cfif get.gender neq "F">checked</cfif>></td>
			<td class="labelmedium" style="Padding-left:4px"><cF_tl id="Male"></td>
		    <td style="Padding-left:4px"><INPUT class="radiol enterastab" type="radio" name="Gender" id="Gender" value="F" <cfif get.gender is "F">checked</cfif>></td>
			<td class="labelmedium" style="Padding-left:4px"><cf_tl id="Female"></td>
			</tr>
		</table>	
		</TD>
		</TR>
		
	    <!--- Field: Applicant.Nationality --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Nationality">:</TD>
	    <TD>
		
		    <cfset nat = get.Nationality>
				     	
	    	<select name="Nationality" class="regularxl enterastab">
			    <cfoutput query="Nation">
				   <option value="#Code#" <cfif Code IS nat>selected</cfif>>#Name#
				</cfoutput> 
			</select>	
			
		</td>	
	    </tr>
			
		<tr>	
		<TD class="labelmedium"><cf_tl id="2nd Nationality"></TD>
	    <TD>
							
	    <!--- Field: Applicant.NationalityAdditional --->
		
			<cfset nat = Get.NationalityAdditional>
			 
	        <select name="NationalityAdditional" class="regularxl enterastab">
			      <option value="" selected>
				  <cfoutput query="Nation">
					 <option value="#Code#" <cfif Code IS nat>selected</cfif>>#Name#
				 </cfoutput> 
			 
			</select>
		
		</TD>
		</TR>
		
		 <!--- Field: Applicant.IndexNo --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Employee">:</TD>
	    <TD>
		
			<cfoutput>  
			<table cellspacing="0" cellpadding="0"><tr><td>
			<input class="regularxl enterastab" type="text" name="indexNo" id="indexNo" value="#get.IndexNo#" size="20" maxlength="20" readonly>
			</td>
			<td style="padding-left:2px;cursor:pointer">			
			<img src="#client.root#/images/search.png" height="25px" alt="" border="0" onClick="selectperson('webdialog','employeeno','indexNo','LastName','FirstName','','','','DOB','Nationality')">
		    </td></tr>
		    <input type="hidden"   name="employeeno" id="employeeno" value="#get.EmployeeNo#" size="10" maxlength="20" readonly>		       
			</table>
		    </cfoutput>					
			
			
		</TD>
		</TR>
		
		<!--- Field: Applicant.ApplicantClass --->
	    <TR>
	    <td class="labelmedium" width="150"><cf_tl id="Person Class">:</td>
		<td class="regular">
			<cf_tl id="Please define an applicant class" var="1" class="message">
		    <select name="ApplicantClass" id="ApplicantClass" message="#lt_text#" required="Yes" class="regularxl enterastab">
		    <cfoutput query="Class">
			<option value="#ApplicantClassId#" <cfif ApplicantClassId eq "#Get.ApplicantClass#">selected</cfif>>#Description#</option>
			</cfoutput>
		    </select>			
		    <input type="hidden" name="ApplicantClassOld" id="ApplicantClassOld" value="<cfoutput>#Get.ApplicantClass#</cfoutput>">
		
		</td>
		</TR>	
					
		
		<cfquery name="Source" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT * 
	    FROM Ref_Source
		</cfquery>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Source">:</TD>
	    <TD class="regular">
	     	<select name="Source" id="Source" required="Yes" class="regularxl enterastab">
		    <cfoutput query="Source"><option value="#Source#" <cfif #Source# eq "#Get.Source#">selected</cfif>>#Source#</option>
			</cfoutput>
		    </select>	
	    </TD>
		
		<TR>
		<TD class="labelmedium"><cf_tl id="Document">:</TD>
	    <TD class="regular">
		<cfoutput query="Get" maxrows=1>
		<input class="regularxl enterastab" type="text" name="DocumentReference" id="DocumentReference" value="#DocumentReference#" maxlength="30">
		</cfoutput>
	    </TD> 
		</TR>
		
	    <!--- Field: Applicant.EmailAddress --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="E-mail Address">:</TD>
	    <TD>
	    	<cfoutput query="Get" maxrows=1>  
				<cfinput type="Text"
			       name="EmailAddress"
			       value="#EmailAddress#"
			       validate="email"
			       required="No"
			       visible="Yes"
			       enabled="Yes"
			       size="30"
			       maxlength="50" class="regularxl enterastab">
		    </cfoutput>	
		</TD>
		</TR>
		
		   <!--- Field: Applicant.EmailAddress --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Mobile Number">:</TD>
	    <TD>
	    	<cfoutput query="Get" maxrows=1>  
			<cfinput type="Text"
		       name="MobileNumber"
		       value="#MobileNumber#"		      
		       required="No"
		       visible="Yes"
		       enabled="Yes"
		       size="30"
		       maxlength="50" class="regularxl enterastab">
			  </cfoutput>	
		</TD>
		</TR>
				
		
	<tr><td class="labelmedium" valign="top" style="padding-top:3px"><cf_tl id="Remarks">:</td>
	 <TD>
		 <cfoutput query="Get" maxrows=1> 
		 	<textarea class="regular" style="font-size:13px;padding:3px;width:90%;height:50" name="Remarks" id="Remarks" type="text">#Remarks#</textarea>
		 </cfoutput>
	</TD>
	</TR>
	
	<tr><td height="1"></td></tr>
	
	<tr><td height="1" colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" align="center">
	
	<table class="formspacing"><tr><td>
	<input type="button" name="close" id="close" value="Close" class="button10g" onClick="parent.ProsisUI.closeWindow('mydialog',true)">
	</td>	
	<td>
	<input class="button10g" type="submit" name="Update" id="Update" value="Save" onclick="Prosis.busy('yes');validate()">
	</td></tr>
	</table>
	
	</td></tr>
		
	</TABLE>
	
</CFFORM>

<cf_screenbottom layout="webapp">
