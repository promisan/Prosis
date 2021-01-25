
<cfsavecontent variable="option">
Attention: <u>Blue colored</u> fields will trigger a person action.
</cfsavecontent>

<cf_screentop height="100%" close="parent.ProsisUI.closeWindow('personedit',true)" 
  layout="webapp" html="No" option="#option#" jquery="Yes" banner="gray" line="no" user="yes" scroll="yes" label="Person Profile">

<cfajaximport tags="cfform">

<cf_calendarScript>

<!--- check if additional fields are needed --->

<cfquery name="Parameter" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     Parameter				
</cfquery>

<cfoutput>
	
	<script>
	
	    function actioncodelog(per,act) {
		
		    se = document.getElementById('box'+act+'_log')
			ex = document.getElementById(act+'_exp')
			cl = document.getElementById(act+'_col')
			
			if (se.className == "hide") {
			    se.className = "regular"				
				ex.className = "hide"				
				cl.className = "regular"				
				
			    ptoken.navigate('PersonEditActionLog.cfm?id='+per+'&actioncode='+act,act+'_log')
			} else {			
			    se.className = "hide"
				ex.className = "regular"
				cl.className = "hide"
			}					 
		}
	
		function checkaction(field,val,mode,prior) {		  
		  <cfif Parameter.actionMode eq "1">		
		      _cf_loadingtexthtml='';	  	    
			  ptoken.navigate('PersonEditActionCheck.cfm?mode='+mode+'&personno=#url.id#&field='+field+'&value='+val+'&prior='+prior,field+'_actioncontent')		  
		  </cfif>		
		}
		
		function checkdob() {				 							
			 ptoken.navigate('PersonEditActionDOB.cfm?field=birthdate','checkbox')						
		}		
				
		function formvalidate(val) {
			document.personentry.onsubmit() 
			Prosis.busy('no')
			if( _CF_error_messages.length == 0 ) {			
       			ptoken.navigate('PersonEditSubmit.cfm?action='+val,'process','','','POST','personentry')
	         }   
        }	
	
	</script>

</cfoutput>

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   Code, Name 
    FROM     Ref_Nation
	WHERE    Operational = '1'
	ORDER BY Name
</cfquery>

<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Parameter
</cfquery>

<cfquery name="Assignment" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   PersonAssignment
	WHERE  PersonNo = '#URL.ID#'
	AND    AssignmentStatus IN ('0','1')
</cfquery>

<cfquery name="Status" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_PersonStatus
</cfquery>

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Person
	WHERE  PersonNo = '#URL.ID#'
</cfquery>

<cf_dialogStaffing>
<cf_dialogOrganization>

<cf_divscroll>

<cfform onsubmit="return false" method="POST" name="personentry">

	<table width="94%" align="center" border="0" cellspacing="0" cellpadding="0">
		
	<tr class="xhide">
	       <td style="height:1px" id="process"></td>
	</tr>
	
	<tr class="hide"><td id="checkbox"></td></tr>
	
	<tr class="line"><td>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">  
	      
	  <tr>
	    <td width="100%">
	    <table border="0" class="formpadding" align="center" width="100%">
			
		<cfoutput>
	   	
		<TR>
	    <TD style="width:15%;min-width:270px" class="labelmedium">#Parameter.IndexNoName#:</TD>
	    <TD class="labelmedium" colspan="5">
	
			<cfinvoke component="Service.Access" method="System" returnvariable="Access">
		   <!---
			<cfif Access eq "EDIT" or Access eq "ALL">
			--->
			<cfif 1 eq 1>
				<input type="text" name="IndexNo" class="regularxl enterastab" value="#Person.Indexno#" size="15" maxlength="20">
			<cfelse>
				<input type="hidden" name="IndexNo" class="regularxl enterastab" value="#Person.Indexno#" size="15" maxlength="20">
				#Person.IndexNo#		
			</cfif>
			<input type="hidden" name="PersonNo" value="#Person.PersonNo#" size="10" maxlength="20" readonly>
					
		</TD>
		</TR>	
		
				 <!--- Field: eMailExternal --->
	    <TR>
	    <td class="labelmedium" height="18" style="color:0B8EDD">
		  <cfset actcode = "1004">
		 <table width="100%">
				<tr class="labelmedium"><td style="color:0B8EDD"><cf_tl id="EMail Address">:</td>
						
				<td align="right" style="padding-right:4px">
							  				
					   <img src="#SESSION.root#/images/expand1.gif" 
					      onclick="actioncodelog('#url.id#','#actcode#')"
					      alt="" 	
						  height="16"
						  width="16"		  
						  id="#actcode#_exp"
						  class="regularxl"			 
						  style="border:0px solid gray;cursor;pointer">
						  
					     <img src="#SESSION.root#/images/collapse1.gif" 
					      onclick="actioncodelog('#url.id#','#actcode#')"
					      alt="" height="16"  width="16"		
						  id="#actcode#_col"
						  class="hide"			
						  style="border:0px solid gray; cursor;pointer">  
						
				</td>
				
				</tr>
				</table>
		
		</td>
		
	    <TD colspan="5">
			
			<cfquery name="getAction" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				  SELECT  *
				  FROM     Ref_Action
				  WHERE    ActionCode = '#actcode#'
				  AND      Operational = 1			
			</cfquery>
			
			<cfif getAction.operational eq "1">		
						
				<cfinput type="Text"
			      name="emailaddress" 
				  value="#Person.eMailAddress#" 
				  onchange="checkaction('emailaddress',this.value,'person','')"
				  message="Please enter a valid eMail address" 
				  validate="email"
				  required="No" 
				  size="30" 
				  maxlength="40" 
				  class="regularxl enterastab">
								
			  
			<cfelse>
						 
			 	<cfinput type="Text"
			      name="emailaddress" 
				  value="#Person.eMailAddress#" 		  
				  message="Please enter a valid eMail address" 
				  validate="email"
				  required="No" 
				  size="30" 
				  maxlength="40" 
				  class="regularxl enterastab">
				
			</cfif> 
							  
			</TD>
			
		</TR>
		
		<tr class="hide" id="box#actcode#_log">
			<td></td>
	    	<td colspan="5" style="padding: 3px;" id="#actcode#_log"></td>
		</tr>	
			
		<tr id="emailaddress_action" class="hide">
			<td colspan="6" style="padding: 10px;" id="emailaddress_actioncontent">
			    <!---
				<cfset field = "emailaddress">
				<cfinclude template="PersonEditAction.cfm">			
				--->
			</td>
		</tr>		
		
		<cfset actcode = "1001">
				
	    <!--- Field: LastName --->
	    <TR>
		    <TD class="labelmedium" width="100" style="color:0B8EDD">
			
			    <table width="100%">
				<tr class="labelmedium"><td style="color:0B8EDD"><cf_tl id="Last Name">:</td>
						
				<td align="right" style="padding-right:4px">
							  				
					   <img src="#SESSION.root#/images/expand1.gif" 
					      onclick="actioncodelog('#url.id#','#actcode#')"
					      alt="" 	
						  height="16"
						  width="16"		  
						  id="#actcode#_exp"
						  class="regularxl"			 
						  style="border:0px solid gray;cursor;pointer">
						  
					     <img src="#SESSION.root#/images/collapse1.gif" 
					      onclick="actioncodelog('#url.id#','#actcode#')"
					      alt="" height="16"  width="16"		
						  id="#actcode#_col"
						  class="hide"			
						  style="border:0px solid gray; cursor;pointer">  
						
				</td>
				
				</tr>
				</table>
			
			</td>
		
		    <TD colspan="5">
						
				   <cfinput type="Text" 
				    name="LastName" 
					class="regularxl enterastab" 
					onchange="checkaction('lastname',this.value,'person','')"
					value="#Person.LastName#" 
					message="Please enter lastname" 
					required="Yes" 
					size="40" 
					maxlength="40">					
												
			</TD>
			
		</TR>
						
		<tr id="lastname_action" class="hide">
			<td colspan="2" style="padding: 10px;" id="lastname_actioncontent">
			   <!--- 
				<cfset field = "LastName">
				<cfinclude template="PersonEditAction.cfm">			
				--->
			</td>
		</tr>		   
		
	    <!--- Field: FirstName --->
	    <TR>
	    <TD class="labelmedium"  style="color:0B8EDD"><cf_tl id="First name">:</TD>
	    <TD colspan="5">	
				
			  <cfinput type="Text"
			   name="FirstName" 
			   class="regularxl enterastab" 
			   value="#Person.FirstName#" 
			   message="Please enter a firstname" 
			   required="Yes" 
			   onchange="checkaction('firstname',this.value,'person','')"
			   size="30" 
			   maxlength="30">
								
			
		</TD>
		</TR>
		
		<tr class="hide" id="box#actcode#_log">
			<td></td>
	    	<td colspan="5" style="padding: 3px;" id="#actcode#_log"></td>
		</tr>	
		
		<tr id="firstname_action" class="hide">
			<td colspan="2" style="padding: 10px;" id="firstname_actioncontent">
			   <!---
				<cfset field = "FirstName">
				<cfinclude template="PersonEditAction.cfm">			
				--->
			</td>
		</tr>		
		
		 <!--- Field: Maiden  --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Maiden name">:</TD>
	    <TD colspan="5">
		
			<cfinput type="Text" 
			   name="MaidenName" 
			   class="regularxl enterastab" 
			   value="#Person.MaidenName#" 
			   message="Please enter a maiden name" 
			   required="No" 
			   size="40" 
			   maxlength="40">
			
		</TD>
		</TR>
				
		 <!--- Field: MiddleName --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Middle name">:</TD>
	    <TD colspan="5">	
			<INPUT type="text" name="MiddleName" class="regularxl enterastab" value="#Person.MiddleName#" maxLength="25" size="20">		
		</TD>
		</TR>
			
		<cfset actcode = "1002">
		
	    <!--- Field: BirthDate --->
	    <TR>
	    <TD class="labelmedium"  style="color:0B8EDD">
			<table width="100%">
			<tr class="labelmedium"><td  style="color:0B8EDD"><cf_tl id="Birth date">:</td>
					
			<td align="right" style="padding-right:4px">
						  				
				   <img src="#SESSION.root#/images/expand1.gif" 
				      onclick="actioncodelog('#url.id#','#actcode#')"
				      alt="" 	
					  height="16"
					  width="16"		  
					  id="#actcode#_exp"
					  class="regularxl"			 
					  style="border:0px solid gray;cursor;pointer">
					  
				     <img src="#SESSION.root#/images/collapse1.gif" 
				      onclick="actioncodelog('#url.id#','#actcode#')"
				      alt="" height="16"  width="16"		
					  id="#actcode#_col"
					  class="hide"			
					  style="border:0px solid gray; cursor;pointer">  
					
			</td>
			
			</tr>
			</table>
		</td>
		
	    <TD colspan="5">
			
				<cf_intelliCalendarDate9
				FieldName="birthdate" 
				Default="#Dateformat(Person.BirthDate, CLIENT.DateFormatShow)#"
				DateValidStart="19400101"	
				scriptdate="checkdob"
				class="regularxl enterastab"
				AllowBlank="False">	
								
		</td>
		</tr>		
		<tr class="hide" id="box#actcode#_log">
			<td></td>
	    	<td colspan="5" style="padding: 3px;" id="#actcode#_log"></td>
		</tr>	
			
						
		<tr id="birthdate_action" class="hide">
			<td colspan="5" style="padding: 10px;" id="birthdate_actioncontent">
			    <!---
				<cfset field = "BirthDate">
				<cfinclude template="PersonEditAction.cfm">			
				--->
			</td>
		</tr>		
		
	    <!--- Field: Gender --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Gender">:</TD>
	    <TD class="labelmedium" colspan="5" style="height:30px">
		
			<INPUT class="enterastab" class="radiol" type="radio" name="Gender" value="M" <cfif Person.Gender eq "M" or Person.Gender eq "">checked</cfif>> Male
			<INPUT class="enterastab" class="radiol" type="radio" name="Gender" value="F" <cfif Person.Gender eq "F">checked</cfif>> Female
			
		</TD>
		</TR>
		
			
		<!--- Field: Status --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Modality">:</TD>
	    <TD colspan="5">	
	    	<select name="PersonStatus" class="regularxl enterastab" message="Please select a status" required="No">
		    <cfloop query="Status">
			<option value="#Status.Code#" <cfif Person.PersonStatus eq "#Status.Code#">selected</cfif>>#Description#</option>
			</cfloop>	    
		   	</select>	
					
		</TD>
		</TR>
				
	    <!--- Field: Bllodtype --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Blood type">:</TD>
	    <TD colspan="5">	
			<INPUT type="text" name="Bloodtype" class="regularxl enterastab" value="#Person.Bloodtype#" maxLength="3" size="3">
			
		</TD>
		</TR>
			
	    <!--- Field: Nationality --->
	    <TR>
	   
	    <cfset actcode = "1003">
		<TD class="labelmedium"  style="color:0B8EDD">
			<table width="100%">
			<tr class="labelmedium"><td style="color:0B8EDD"><cf_tl id="Nationality">:</td>
					
			<td align="right" style="padding-right:4px">
						  				
				   <img src="#SESSION.root#/images/expand1.gif" 
				      onclick="actioncodelog('#url.id#','#actcode#')"
				      alt="" 	
					  height="16"
					  width="16"		  
					  id="#actcode#_exp"
					  class="regularxl"			 
					  style="border:0px solid gray;cursor;pointer">
					  
				     <img src="#SESSION.root#/images/collapse1.gif" 
				      onclick="actioncodelog('#url.id#','#actcode#')"
				      alt="" height="16"  width="16"		
					  id="#actcode#_col"
					  class="hide"			
					  style="border:0px solid gray; cursor;pointer">  
					
			</td>
			
			</tr>
			</table>
		</td>
			 
		<TD colspan="5">
				
				<select name="Nationality" 
			    class="regularxl enterastab"
				onchange="checkaction('nationality',this.value,'person','')"
				message="Please select a nationality" 
				required="No">
		
			    <cfloop query="Nation">
					<option value="#Nation.Code#" <cfif Person.Nationality eq "#Nation.Code#">selected</cfif>>#Name#</option>
				</cfloop>	    
			
		   	</select>	
				
		</td>
		</tr>	
			
		<tr class="hide" id="box#actcode#_log">
			<td></td>
	    	<td colspan="5" style="padding: 3px;" id="#actcode#_log"></td>
		</tr>	
		
		<tr id="nationality_action" class="hide">
			<td colspan="5" style="padding: 10px;" id="nationality_actioncontent">
			    <!---
				<cfset field = "Nationality">
				<cfinclude template="PersonEditAction.cfm">			
				--->
			</td>
		</tr>		
					
		<cfif Parameter.EnablePersonGroup neq "0">
						
			<TR class="labelmedium">
		    <TD><cf_tl id="Marital status">:</TD>
		    <TD colspan="5" style="height:30px">
			
				<INPUT type="radio" class="enterastab" name="MaritalStatus" value="Single"   <cfif Person.MaritalStatus eq "Single" or Person.MaritalStatus eq "">checked</cfif>> <cf_tl id="Single">
				<INPUT type="radio" class="enterastab" name="MaritalStatus" value="Married"  <cfif Person.MaritalStatus eq "Married">checked</cfif>> <cf_tl id="Married">
				<INPUT type="radio" class="enterastab" name="MaritalStatus" value="Divorced" <cfif Person.MaritalStatus eq "Divorced">checked</cfif>> <cf_tl id="Divorced">
						
			</TD>
			</TR>
			
		<cfelse>
	
			<input type="hidden" name="MaritalStatus" value="#Person.MaritalStatus#">
		
		</cfif>
		
		<TR class="labelmedium">
		<TD><cf_tl id="Country">|<cf_tl id="City"> <cf_tl id="Birth">:</TD>
		<TD colspan="5">
		
			<table cellspacing="0" cellpadding="0"><tr><td>
	
	  	    <cfselect name="BirthNationality" required="No" class="regularxl enterastab" style="width:190px">
			    <cfloop query="Nation">
				<option value="#Code#" <cfif Person.BirthNationality eq Code>selected</cfif>>#Name#
				</option>
				</cfloop>
		    </cfselect>		
			
			</td>
						
			<td style="padding-left:2px">			
			<input type="text" name="BirthCity" class="regularxl enterastab" value="#Person.BirthCity#" size="30" maxlength="50">					
			</td></tr>
			
			</table>	
			
		</TD>
		</TR>
		
		
		<TR class="labelmedium">
		<TD><cf_tl id="Country">|<cf_tl id="City"> <cf_tl id="Recruitment">:</TD>
		<TD colspan="5">
		
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td>
	
	  	    <cfselect name="RecruitmentCountry" required="No" class="regularxl enterastab" style="width:190px">"
			    <option value="">----<cf_tl id="Undefined">----</option>
			    <cfloop query="Nation">
				<option value="#Code#" <cfif Person.RecruitmentCountry eq Code>selected</cfif>>#Name#
				</option>
				</cfloop>
		    </cfselect>		
			
			</td>						
			<td style="padding-left:2px">			
			<input type="text" name="RecruitmentCity" class="regularxl enterastab" value="#Person.RecruitmentCity#" size="30" maxlength="50">					
			</td>
			</tr>			
			</table>	
			
		</TD>
		</TR>
		
		<TR class="labelmedium">
	    <TD><cf_tl id="Parent Office">:</TD>
	    <TD colspan="5">
		
			<table>
			<tr>
			<td><input type="text" id="parentoffice"   name="parentoffice" value="#Person.parentoffice#" style="width:139px" maxlength="20" readonly class="regularxl enterastab"></td>
			<td style="padding-left:4px"><input type="text" id="parentlocation" name="parentlocation" value="#Person.parentofficelocation#" size="30" maxlength="20" readonly class="regularxl enterastab"></td>
			<td style="padding-left:2px">
			
				  <img src="#SESSION.root#/Images/search.png" name="img5" 
					  onMouseOver="document.img5.src='#SESSION.root#/Images/contract.gif'" 
					  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
					  style="cursor: pointer;" width="27" height="27" border="0" align="absmiddle" 
					  onClick="javascript:showparent('Webdialog','parentoffice','parentlocation')">
							  
				</td>
			</tr>
			</table>
			
		</TD>
		</TR>			
		
		<!---
		<cfif 1 eq  0>
		--->
		<TR class="labelmedium">
	    	<TD><cf_tl id="Entry organization">:</TD>
		    <TD colspan="5">
			  <cf_intelliCalendarDate9
				FieldName="OrganizationStart" class="regularxl enterastab"
				Default="#Dateformat(Person.OrganizationStart, CLIENT.DateFormatShow)#"		
				AllowBlank="True">	
			</TD>
		</TR>
		<!---
		<cfelse>
			<input type="hidden" id="OrganizationStart" name="OrganizationStart" value="#Dateformat(Person.OrganizationStart, CLIENT.DateFormatShow)#">
	    </cfif>
		--->
			  	
		<cf_verifyOperational module = "Accounting" Warning = "No">
				
		<cfif operational eq "1">
		
			<cf_verifyOperational module = "Payroll" Warning = "No">
			
			<cfif operational eq "1">
			
				<cf_dialogLedger>
			
				<cfquery name="Gledger" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT  *
				     FROM  Ref_AreaGLedger		
				</cfquery>		
				
				<script>
					function applyglaccount(acc,scope) {				  
					   ptoken.navigate('setAccount.cfm?account='+acc+'&scope='+scope,'checkbox')					  	
					}
				</script>
						
				<cfloop query="gledger">
				
					<cfquery name="Account" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT    P.*, A.Description
					  FROM      PersonGLedger P, 
					            Accounting.dbo.Ref_Account A
					  WHERE     PersonNo = '#Person.PersonNo#'
					    AND     Area     = '#Area#'
						AND     P.GLAccount = A.GLAccount
					</cfquery>	
							
					<tr>
						<td class="labelmedium"><cf_tl id="Ledger"> #Description#: <font color="FF0000">*</font></td>
						<td id="#area#td" colspan="5" style="height:29px">	
						
						<cfif Account.glaccount eq "">
						
							<cfquery name="Account" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							  DELETE FROM PersonGLedger
							  WHERE   PersonNo = '#Person.PersonNo#'
							    AND   Area     = '#Area#'
							</cfquery>	
									
						 <input type="button" 
						    name="Create" 
							class="button10g" style="width:130;height:24"
							value="Create Account" 
							onclick="_cf_loadingtexthtml='';ptoken.navigate('PersonGLCreate.cfm?personno=#Person.PersonNo#&area=#Area#','#area#td')">
						
						<cfelse>
						
						    <table cellspacing="0" cellpadding="0">
						    <tr>
							<cfoutput>	 
							  
								<td>  
							    <input type="text"   name="#Area#" id="#Area#" size="8"  value="#Account.glaccount#"   class="regularxl" readonly style="padding-left:4px;">
								</td>
								<td style="padding-left:2px">
							    <input type="text"   name="#Area#description" id="#Area#description" value="#Account.Description#" class="regularxl" size="40" readonly style="padding-left:4px">
								</td>
								<td style="padding-left:2px">
							    <img src="#SESSION.root#/Images/search.png" name="img3#area#" 
									  onMouseOver="document.img3#area#.src='#SESSION.root#/Images/contract.gif'" 
									  onMouseOut="document.img3#area#.src='#SESSION.root#/Images/search.png'"
									  style="cursor: pointer;" width="27" height="27" border="0" align="absmiddle" 
									  onClick="selectaccountgl('','glaccount','','','applyglaccount','#Area#');">
								</td>
								<input type="hidden" name="#Area#cls">
							</cfoutput>	
							</tr>
							</table>
						
						</cfif>
					 			
						</td>
					</tr>
				
				</cfloop>	
				
			</cfif>	
					
		</cfif>
		  
	    <TR class="labelmedium">
	    <TD><cf_tl id="ExternalReference">:</TD>
	    <TD colspan="5">
		
			<table><tr>
			<td>
			<cfinput type="Text"
		       name="Reference"
		       value="#Person.Reference#"
		       required="No"     
			   class="regularxl" 
		       size="10"
		       maxlength="20">
			   </td>
			   
			   <cfif getAdministrator("*") eq "1">				   
			  	    
			    <TD style="padding-left:8px" class="labelmedium"><cf_tl id="Listing Order">:</TD>
			    <TD style="padding-left:4px">
				
					<cfinput type="Text"
				       name="ListingOrder"
				       value="#Person.ListingOrder#"
				       validate="integer"
				       required="No"    
					   class="regularxl" 
					   style="width:30px;text-align:center" 
				       size="2"
				       maxlength="4">
					
				</TD>
		
			   <cfelse>
			
			    <td class="hide">
					
					<input type="Text"
				       name="ListingOrder"
				       value="#Person.ListingOrder#"
				       validate="integer"
				       required="No"    
					   type="hidden"
					   style="width:30px;text-align:center" 
				       size="2"
				       maxlength="4">
				   
				   </td>
		
			   </cfif>
						   
			</tr>
			</table>
			
		</TD>
		</TR>				
		
		<cfinvoke component="Service.Access"  
			 method="employee"  
			 owner = "Yes" 
			 personno="#URL.ID#" 
			 returnvariable="HRAccess"> 			
			
		<cfquery name="Topic" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		     FROM  Ref_PersonGroup
			 WHERE Code IN (SELECT GroupCode FROM Ref_PersonGroupList)			 
			 AND   Operational = 1			 
			 AND   Context = 'Person'
			 
			 <cfif getAdministrator("*") eq "1" OR Access eq "ALL">
			
				<!--- no filtering --->

		     <cfelse>		
			
			 AND   Code IN (SELECT GroupCode 
			                FROM   Ref_PersonGroupRole						
							WHERE  Role IN  (SELECT DISTINCT Role 
			                                 FROM   Organization.dbo.OrganizationAuthorization
											 WHERE  UserAccount = '#SESSION.acc#')
							)	
												
			 		   
															   
			 </cfif>	
			 
			 AND   Code IN (SELECT GroupCode
			                FROM   Ref_PersonGroupOwner				
							WHERE  Owner IN (SELECT MissionOwner
							                 FROM   Organization.dbo.Ref_Mission
											 WHERE  Mission IN (SELECT DISTINCT P.Mission 
											                    FROM   PersonAssignment PA, Position P 
															    WHERE  PA.PositionNo = P.PositionNo
															    AND    PA.PersonNo = '#URL.ID#')
											)
						  )							
			 											   
		</cfquery>
		
		<cfif Topic.recordcount gt "0">
						
			<cfset cnt = 0>
		
			<cfloop query="topic">		
			
			<cfset cnt = cnt+1>
			
			<cfif cnt eq "1"><tr class="labelmedium"></cfif>
			
				<td>
				
				<cfif ActionCode eq "">
				
				      #Description#
				
				<cfelse>
				
					<table width="100%" >
					<tr class="labelmedium">
					<td style="color:0B8EDD"><cf_tl id="#Description#">:</td>
							
					<td align="right" style="padding-right:4px">
								  				
						   <img src="#SESSION.root#/images/expand1.gif" 
						      onclick="actioncodelog('#url.id#','#actioncode#')"
						      alt="" 	
							  height="16"
							  width="16"		  
							  id="#actioncode#_exp"
							  class="regularxl"			 
							  style="border:0px solid gray;cursor;pointer">
							  
						     <img src="#SESSION.root#/images/collapse1.gif" 
						      onclick="actioncodelog('#url.id#','#actioncode#')"
						      alt="" height="16"  width="16"		
							  id="#actioncode#_col"
							  class="hide"			
							  style="border:0px solid gray; cursor;pointer">  
							
					</td>
					
					</tr>
					</table>
				
				</cfif>
				
				</td>
				
				<td>	
					
					<cfquery name="List" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						  SELECT  *
						  FROM     Ref_PersonGroupList
						  WHERE    GroupCode = '#Code#'
						  AND      Operational = 1
						  ORDER BY GroupListOrder
					</cfquery>
					
					<cfquery name="PersonTopic" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						  SELECT   TOP 1 G.*,L.Description
						  FROM     PersonGroup G, Ref_PersonGroupList L
						  WHERE    G.PersonNo      = '#URL.ID#'
						  AND      G.GroupCode     = '#Code#'
						  AND      L.GroupCode     = G.GroupCode
						  AND      G.GroupListCode = L.GroupListCode
						  ORDER BY L.GroupListOrder
				    </cfquery>
														
					<select name="ListCode_#Code#" 
					    required="No" 						
						class="regularxl enterastab"
						onchange="<cfif ActionCode neq ''>checkaction('#Code#',this.value,'group','#PersonTopic.Description#')</cfif>">
						<cfloop query="List">
							<option value="#GroupListCode#" <cfif PersonTopic.GroupListCode eq GroupListCode>selected</cfif>>#Description#</option>
						</cfloop>
					</select>
					
					
				</td>					
				
				</tr>
				
																
			<cfif ActionCode neq "">
			
				<tr class="hide" id="box#actioncode#_log">
				<td></td>
		    	<td colspan="5" style="padding: 3px;" id="#actioncode#_log"></td>
				</tr>	
							
				<tr id="#code#_action" class="hide">
					<td colspan="6" style="padding: 3px;" id="#code#_actioncontent"></td>
				</tr>					
							
			</cfif>			
						
			</cfloop>
		
		
		</cfif>
				
		<TR class="labelmedium">
	        <td valign="top" style="padding-top:5px"><cf_tl id="Memo">:</td>
	        <TD colspan="5" style="padding-top:2px"><textarea class="regular" style="height:50px;font-size:13px;padding:3px;width:90%" rows="1" name="Remarks">#Person.Remarks#</textarea> </TD>
		</TR>
		
		
		</cfoutput>
			
	    </TABLE>
		
		</td></tr>
		
	</table>
		
	</td></tr>
				
	<tr><td>
		
		   <table width="99%" cellspacing="0" cellpadding="0">
		   <tr>
			   <td style="height:40px" align="center">
			   <cfoutput>
			    <cf_tl id="Close" var="1">	
			   <input type="button" name="cancel" value="#lt_text#" style="width:120;height:25" class="button10g" onClick="parent.parent.ProsisUI.closeWindow('personedit',true)">  
			   <cfif assignment.recordcount eq "0">
			   		<cf_tl id="Delete" var="1">
			     	<input class="button10g" style="width:120;height:25" type="submit"  name="Delete" value="#lt_text#" onclick="Prosis.busy('yes');formvalidate('delete')">
			   </cfif>   
			   <cf_tl id="Save" var="1">			   
			   <input class="button10g" style="width:120;height:25" type="button" name="Submit" value="#lt_text#" onclick="Prosis.busy('yes');formvalidate('update')">	
			   </cfoutput>	   
			   </td>
		   </tr>
		   </table>
	   
	</td></tr>
	   
   </table>
   
</CFFORM>   
   
</cf_divscroll>   
   

