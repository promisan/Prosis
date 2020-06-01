
<cf_dialogPosition>
<cf_dialogOrganization>
<cf_calendarScript>
<cfajaximport tags="cfform">

<cfparam name="URL.Mode" default="Lookup">
<cfparam name="URL.occ" default="">		
<cfparam name="url.edition" default="">

<cfoutput>
	
	<script>
	
	function verify(org,fun) { 	
	
		if (org == "") { 
	
			alert("You did not define a Organization unit")		
			document.getElementById('btnorg').click()		
			return false
		}
			
		if (fun == "") { 
			alert("You did not define a Function")
			document.getElementById('btnfun').click()		
			return false
		}
	
		if( _CF_error_messages.length == 0 ) {            
			ptoken.navigate('PositionEntrySubmit.cfm?Mission=#URL.ID#','process','','','POST','PositionEntry');        
		}   
							
	}	
	
	function admblank() {
		document.PositionEntry.orgunit1.value = ""
		document.PositionEntry.mission1.value = ""
		document.PositionEntry.orgunitname1.value = ""
		document.PositionEntry.orgunitclass1.value = ""
	}	
	
	
	function applyunit(org) {    
		ptoken.navigate('#SESSION.root#/Staffing/Application/Position/Position/setUnit.cfm?orgunit='+org,'process')
	}
	
	function Selected(no,description) {									
		document.getElementById('functionno').value = no
		document.getElementById('functiondescription').value = description					 
		ProsisUI.closeWindow('myfunction')
	}		
  

	</script>

</cfoutput>

<cfquery name="Param" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.ID#'
</cfquery>

<cfquery name="Current" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mission
	WHERE  Mission = '#URL.ID#'
</cfquery>

<cfquery name="FundTable" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Fund
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mission
</cfquery>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mandate
	WHERE  Mission = '#URL.ID#' AND MandateNo = '#URL.ID1#'
</cfquery>

<cfinvoke 
  component= "Service.Access"  
  method   = "position" 
  mission  = "#url.id#"
  orgunit  = "#URL.ID2#" 
  posttype = "#URL.ID4#"
  role     = "'HRPosition'"
  returnvariable="accessPosition">
  
<cfinvoke 
  component= "Service.Access"  
  method   = "staffing" 
  mission  = "#url.id#"
  orgunit  = "#URL.ID2#" 
  posttype = "#URL.ID4#"
  role     = "'HROfficer'"
  returnvariable="accessStaffing">  
  
<cfif (Mandate.MandateStatus eq "0" and (AccessPosition eq "EDIT" or AccessStaffing eq "EDIT"))	or (AccessPosition eq "ALL" or AccessStaffing eq "ALL")>
	
	<cfquery name="OrgUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Organization
		WHERE OrgUnit = '#URL.ID2#'
	</cfquery>
	
	<cfif OrgUnit.recordcount eq "0">
	
		<cfquery name="OrgUnit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Organization
			WHERE  OrgUnitCode = '#URL.ID2#'
			AND    Mission = '#URL.ID#' 
			AND    MandateNo = '#URL.ID1#'
		</cfquery>
	
	</cfif>
	
	<cfif URL.ID7 eq "undefined">
	    <cfset URL.ID7 = "0">
	</cfif>
	
	<cfquery name="OrgUnitAdm" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Organization
		WHERE OrgUnit = '#URL.ID7#'
	</cfquery>
	
	<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Position
		WHERE PositionNo = '#URL.ID8#'
	</cfquery>
	
	<cfquery name="Function" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   FunctionTitle
		WHERE  FunctionNo = '#URL.ID3#'
	</cfquery>
					
	<cfquery name="Location" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Location
		WHERE    Mission = '#URL.ID#'
		ORDER By ListingOrder, LocationName
	</cfquery>
	
	<cfquery name="ScopePostType" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	     SELECT *
         FROM   Ref_PostTypeMission 
		 WHERE  Mission = '#url.id#'
	</cfquery>	 
	
	<cfif getAdministrator(url.id) eq "1">
	
		<cfquery name="AccessPostType" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     DISTINCT P.PostType
				FROM       Ref_PostType P 
				WHERE 	   1=1
				<cfif ScopePostType.recordcount gte "1">
				AND        PostType IN (SELECT PostType
					                    FROM   Ref_PostTypeMission 
								        WHERE  Mission = '#url.id#')									   
				</cfif>		
		</cfquery>			
	
	<cfelse>
	
		<cfquery name="AccessPostType" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     DISTINCT P.PostType
				FROM       Ref_PostType P INNER JOIN
			               Organization.dbo.OrganizationAuthorization A ON P.PostType = A.ClassParameter
				WHERE 	   A.Role IN ('HRPosition') 
				AND        A.AccessLevel IN ('1','2')
				AND        A.Mission           = '#URL.ID#'			
				AND        A.UserAccount       = '#SESSION.acc#'		
				<cfif ScopePostType.recordcount gte "1">
				AND        PostType IN (SELECT PostType
					                    FROM   Ref_PostTypeMission 
								        WHERE  Mission = '#url.id#')									   
				</cfif>		
		</cfquery>		
			
	</cfif>		
			
	<cfif AccessPostType.recordcount eq "0">
	
	    <cf_message message = "You are not authorised to record for any post-type. Please contact your administrator.">
	    <cfabort>
	
	</cfif>
	
	<cfquery name="Postclass" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      Ref_PostClass
		WHERE     Operational = 1
		AND       PostClass IN (SELECT PostClass FROM Ref_PostClassMission WHERE Mission = '#url.id#')
		ORDER BY  ListingOrder		
	</cfquery>
	
	<cfif PostClass.recordcount eq "0">
	
		<cfquery name="Postclass" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    *
		    FROM      Ref_PostClass
			WHERE     Operational = 1		
			ORDER BY  ListingOrder		
		</cfquery>
	
	</cfif>
			
	<cf_screentop label="Position - Entry (#URL.ID# #URL.ID1#)" layout="webapp" banner="gray" line="no" jquery="yes" height="100%" scroll="no">
					
	<cf_divscroll>
	
	<cfform method="POST" name="PositionEntry" onSubmit="return false" style="height:96%">	
			
	<table width="100%" align="center">	

	<tr><td height="8"></td></tr>
	
	<tr class="hide"><td id="process"></td></tr>
		  
	  <tr class="hide"><td colspan="2" bgcolor="B9B9B9">
	  
	  	 <input type="hidden" id="missionselect" name="missionselect" value="<cfoutput>#URL.ID#</cfoutput>"  size="20" maxlength="20" readonly class="disabled">	
		 <input type="hidden" id="mandateno"     name="mandateno"     value="<cfoutput>#URL.ID1#</cfoutput>" size="10" maxlength="10" readonly class="disabled">	
	
	  </td></tr>
	     
	<tr><td colspan="2">
	
	<table width="95%" border="0" align="center">
	     
	  <tr>
	    <td width="100%"">
		
		    <table border="0" cellpadding="0" cellspacing="0" width="99%" align="center" class="formpadding">
					
			<TR>
		    <TD class="labelmedium"><cf_tl id="Operational Structure">: <font color="FF0000">*</font></TD>			
		    <TD>
			<cfoutput>
			<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<input type="text" id="orgunitname" name="orgunitname" value="#OrgUnit.orgunitname#" class="regularxl" size="60" maxlength="60" readonly>	
				</td>
				
				<td style="padding-left:4px">
				
				  	<cfinvoke component = "Service.Access"  
					    method          = "position" 
					    mission         = "#URL.id#"							
					    returnvariable  = "accessPosition"> 	
				
				<cfif accessPosition eq "EDIT" or accessPosition eq "ALL">
				
					<button name="btnorg"
					        type="button"
					        class="button10g"
					        style="height:25;width:40"							 
							onClick="selectorgmisn(document.getElementById('mission').value,document.getElementById('mandateno').value,'')"> 
								  <img src="#SESSION.root#/Images/locate.gif" alt="" name="img1" height="15" width="15"
									  style="cursor: pointer;" alt="" border="0" align="top">
					</button>	
				
				</cfif>
				
				</td>
				
				<input type="hidden" id="orgunitclass" name="orgunitclass" value="#OrgUnit.orgunitclass#" class="regular" size="15" maxlength="15" readonly> 
			   	<input type="hidden" id="orgunit"      name="orgunit"      value="#OrgUnit.orgunit#">
				<input type="hidden" id="orgunitcode"  name="orgunitcode"  value="#OrgUnit.orgunitCode#">
				<input type="hidden" id="mission"      name="mission"      value="<cfoutput>#URL.ID#</cfoutput>">
				
			</tr>
			</table>
			</TD>
			</TR>	
						
			<TR>
		    <TD class="labelmedium"><cf_tl id="Function">: <font color="FF0000">*</font></TD>
				
		    <TD>
			<table cellspacing="0" cellpadding="0">
				<tr><td>
			    <input type="text" name="functiondescription" id="functiondescription"  value="#Function.functiondescription#" class="regularxl" size="60" maxlength="60" readonly> 
				</td>
				<td style="padding-left:4px">
				<button name="btnfun" type="button" class="button10g" style="height:25;width:40" onClick="selectfunction('webdialog','functionno','functiondescription','<cfoutput>#current.mission#</cfoutput>','','')"> 
					  <img src="#SESSION.root#/Images/locate.gif" alt="" name="img2" height="15" width="15"  style="cursor: pointer;" alt="" border="0" align="top">
				</button>	
				<input type="hidden" id="functionno"  name="functionno" value="#Function.functionno#" class="disabled" size="6" maxlength="6" readonly>		
				</td>
				</tr>
			</table>
			</TD>
			</TR>			
			
			<cfquery name="Tree" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  *
					FROM    Ref_Mission
					WHERE   Mission = '#URL.ID#'
			</cfquery>
			
			<tr>
			<td class="labelmedium"><cf_uitooltip tooltip="Unit responsible for management of this position"><cf_tl id="Administrative Unit"><cf_uitooltip>:</TD>
			
				    <TD>
					
					<table>
						<tr><td>
						<input type="text" name="mission1" id="mission1" value="#OrgUnitAdm.Mission#" class="regularxl" size="20" maxlength="20" readonly>
						</td>
						<td style="padding-left:4px">
						<button name="btnFunction" type="button" class="button10g" style="height:25;width:40" onClick="selectorgN('#URL.ID#','Administrative','orgunit','applyorgunit','1')"> 
						  <img src="#SESSION.root#/Images/locate.gif" alt="" name="img3" height="15" width="15"
							  style="cursor: pointer;" alt="" border="0" align="top">
						</button>	
						</td>
						<td style="padding-left:4px">
						<cfif Tree.TreeAdministrative eq "">
						<button name="btnFunction" type="button" class="button10g" style="height:25;width:40" onClick="javascript:admblank()"> 
						  <img src="#SESSION.root#/Images/delete5.gif" height="15" width="15" alt="" name="img1" 
							  style="cursor: pointer;" alt="" border="0" align="top">
						</button>	
						</cfif>				
						</td>
						</tr>
					</table>
					</TD> 
			</tr>
			
			<tr><TD class="labelmedium"></TD>
							
				    <TD>
					
					<input type="text" name="orgunitname1" id="orgunitname1" value="#OrgUnitAdm.orgunitName#" class="regularxl" size="60" maxlength="60" readonly>
					<input type="hidden" name="orgunit1" id="orgunit1" value="#OrgUnitAdm.orgunit#">
					<input type="hidden" name="orgunitcode1" id="orgunitcode1" value="#OrgUnitAdm.orgunitcode#"></TD> 
				</tr>
				<input type="hidden" name="orgunitclass1" id="orgunitclass1" value="#OrgUnitAdm.orgunitclass#" class="regularxl" size="20" maxlength="20" readonly></TD> 
				
						
			</cfoutput>
			
			<cfif Location.recordcount eq "0">
			
				<input type="hidden" name="LocationCode" value="">
			
			<cfelse>
			
			<TR>
		    <TD class="labelmedium"><cf_tl id="Location">:</TD>
		    <TD>
			
			   	<select name="LocationCode" size="1" class="regularxl">
				    <cfoutput query="Location">
						<option value="#LocationCode#" <cfif LocationCode eq URL.ID6>selected</cfif>>
				    		#LocationCode# #LocationName#
						</option>
					</cfoutput>
			    </select>
			</TD>
			</TR>
			
			</cfif>
			   
		    <TR>
		    <TD class="labelmedium" style="height:32px"><cf_tl id="Authorised">:</TD>
		    <TD class="labelmedium">
			
					<cfinvoke component="Service.Access"  
			          method="position" 
					  orgunit="#URL.ID2#" 
					  posttype=""
					  returnvariable="accessPosition"> 
					  				 												  
				  <cfif accessPosition eq "EDIT" or accessPosition eq "ALL">
			
					<INPUT type="radio" class="radiol" name="PostAuthorised" value="1" checked> <cf_tl id="Yes">&nbsp;
					<INPUT type="radio" class="radiol" name="PostAuthorised" value="0"> <cf_tl id="No">
				
				<cfelse>
				
				<INPUT type="radio" name="PostAuthorised" value="0" checked> <cf_tl id="No">
				
				</cfif>
				
			</TD>
			</TR>
			
			<script language="JavaScript">
			
				function measuresource(cls) {
				
					se = document.getElementById("approvalpostgradebox")					
					if (cls == "regular")
					   {se.className = "regular"}
					else
					   {se.className = "hide"}					   
				}      
				
			</script>
			
			<cfif Param.ShowPositionFund eq "1">
					
			<TR>
	        <TD height="22" class="labelmedium"><cf_tl id="Fund">: <font color="FF0000">*</font></TD>
			<TD>					
			  	 	<select name="Fund" size="1" class="regularxl">
					    <cfoutput query="FundTable">			<!--- KRW: 7/4/08: Added TRIM in if --->
						<option value="#Code#">
				    		#Code# 
						</option>
						</cfoutput>
		    		</select>
			</td>
			</tr>		
			
			<cfelse>
			
			 <input type="hidden" name="Fund" value="">		 
			
			</cfif>
					
			<cfquery name="Posttype" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_PostType				
				    WHERE  PostType IN (#QuotedValueList(accessPostType.PostType)#) 	
					ORDER BY ListingOrder		
			</cfquery>
					
			<TR>
		    <TD class="labelmedium"><cf_tl id="Post type">: <font color="FF0000">*</font></TD>
		    <TD>
			   	<select name="posttype" size="1" class="regularxl">
			    <cfoutput query="PostType">
				<option value="#PostType#" <cfif PostType eq URL.ID4>selected</cfif>>
		    		#Description#
				</option>
				</cfoutput>
			    </select>
			</TD>
			</TR>					
						
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Grade">: <font color="FF0000">*</font></TD>
		    <TD height="23">
			
			    <script language="JavaScript">
				
				 // callback function from the dialog to limit the selection of the title based on the selected function 
				 
				 function processfunction(funno) {
				    ptoken.navigate('PositionGradeSelect.cfm?field=postgrade&presel=#url.id5#&mission=#url.id#&posttype='+document.getElementById('posttype').value+'&functionno='+funno,'gradeselect')
				 }
				 
				</script>			
			
				<cf_securediv id="gradeselect" bind="url:PositionGradeSelect.cfm?field=postgrade&presel=#url.id5#&mission=#url.id#&posttype={posttype}"/>
				
				
			</TD>
			</TR>
			
			<TR>
		    <TD style="height:33px" class="labelmedium"><cf_tl id="Classified level">:</TD>
		    <TD>
			
			   <table cellspacing="0" cellpadding="0">
			   <tr>
			    <td class="labelmedium">
			    <INPUT type="radio" class="rediol" name="Classified" value="0" checked onclick="measuresource('hide')"> <cf_tl id="Unclassified">
				<INPUT type="radio" class="rediol" name="Classified" value="1" onclick="measuresource('regular')"> <cf_tl id="Classified">			
				</td>
				
				<td style="padding-left:8px" class="hide" id="approvalpostgradebox">
				
				<cf_securediv id="approvalpostgrade" 
						  bind="url:PositionGradeSelect.cfm?field=ApprovalPostGrade&posttype={posttype}&presel=&mission=#url.id#">				
						
				</td></tr>
				
				</table>
							
			</TD>
			</TR>
								
			<TR>
		    <TD class="labelmedium"><cf_tl id="Post class">: <font color="FF0000">*</font></TD>
		    <TD>
			   	<select name="PostClass" size="1" class="regularxl">
			    <cfoutput query="PostClass">
				<option value="#PostClass#">
		    		#Description#
				</option>
				</cfoutput>
			    </select>
			</TD>
			</TR>			
		   
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Vacancy class">: <font color="FF0000">*</font></TD>
		    <TD>					
						
				<cfquery name="VacancyClass" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM Ref_VacancyActionClass
					WHERE Operational = 1
					ORDER BY ListingOrder
				</cfquery>
			
				<select name="VacancyActionClass" size="1" class="regularxl">
			   
				<cfoutput query="VacancyClass">
					<option value="#Code#">#Description#</option>
				</cfoutput>
				
		        </select>
			
			</TD>
			</TR>
			
			<tr class="line"><td colspan="2"></td></tr>
			
			<cfif Current.MissionType neq "TEMPLATE">						
			
			<TR>
		    <TD class="labelmedium" style="height:34px"><cf_tl id="Staffing Period"> :</TD>
		    <TD class="labelmedium" style="padding-left:4px">
			   <cfoutput>
			  	 #Dateformat(Mandate.DateEffective, CLIENT.DateFormatShow)# - #Dateformat(Mandate.DateExpiration, CLIENT.DateFormatShow)#
	   		   </cfoutput>
			</td>
			</TD>
			</TR>
				 
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Position Effective">: <font color="FF0000">*</font></TD>
		    <TD>
			
				<table width="80%" cellspacing="0" cellpadding="0">
				<tr><td>
				
				<cfif Position.DateEffective neq "">
				
				<cf_intelliCalendarDate9			
					FieldName="DateEffective" 
					DateFormat="#APPLICATION.DateFormat#"				
					DateValidStart="#Dateformat(Mandate.DateEffective, 'YYYYMMDD')#"
					DateValidEnd="#Dateformat(Mandate.DateExpiration, 'YYYYMMDD')#"
					Default="#Dateformat(Position.DateEffective, CLIENT.DateFormatShow)#"
					class="regularxl"
					AllowBlank="False">	
														
				<cfelse>
				
				<cf_intelliCalendarDate9			
					FieldName="DateEffective" 
					DateFormat="#APPLICATION.DateFormat#"
					Default="#Dateformat(Mandate.DateEffective, CLIENT.DateFormatShow)#"
					DateValidStart="#Dateformat(Mandate.DateEffective, 'YYYYMMDD')#"
					DateValidEnd="#Dateformat(Mandate.DateExpiration, 'YYYYMMDD')#"
					class="regularxl"
					AllowBlank="False">	
					
									
				</cfif>
				
				</td>
				
				<TD class="labelmedium"><cf_tl id="Expiration">:</TD>
				<td>
				
				<cf_intelliCalendarDate9
					FormName="PositionEntry"
					FieldName="DateExpiration" 
					DateFormat="#APPLICATION.DateFormat#"
					DateValidStart="#Dateformat(Mandate.DateEffective, 'YYYYMMDD')#"
					DateValidEnd="#Dateformat(Mandate.DateExpiration, 'YYYYMMDD')#"
					Default="#Dateformat(Mandate.DateExpiration, CLIENT.DateFormatShow)#"
					class="regularxl"
					AllowBlank="False">	
					
				</td>
				</tr>		
				</table>
					
			</TD>
			</TR>	
			
			<tr class="line"><td colspan="2"></td></tr>	
			<tr><td></td></tr>	
			
			<cfelse>
			
				<cfoutput>
					<input type="hidden" name="dateeffective" value="#Dateformat(Mandate.DateEffective, CLIENT.DateFormatShow)#">	
					<input type="hidden" name="dateexpiration" value="#Dateformat(Mandate.DateExpiration, CLIENT.DateFormatShow)#">	
				</cfoutput>
			
			</cfif>
			
			<TR>
		    <TD class="labelmedium"><cf_tl id="External Reference">:</TD>
		    <TD>
			<INPUT type="text" class="regularxl" name="SourcePostNumber" maxLength="20" size="20">
			</TD>
			</TR>
			
			<TR style="height:30px">
		        <td class="labelmedium"><cf_tl id="Classification">:</td>
		        <td><cfinclude template="PositionEditGroup.cfm"></td>
			</TR>
			
			<cfquery name="Topic" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  	 SELECT *
			     FROM   Ref_PositionParentGroup
				 WHERE  Code IN (SELECT GroupCode 
				                 FROM Ref_PositionParentGroupList)
				 AND    Code IN (SELECT GroupCode 
				                 FROM   Ref_PositionParentGroupMission 
								 WHERE  Mission = '#url.id#')				 
			</cfquery>
			
			<cfif Topic.recordcount gt "0">
		
				<cfoutput query="topic">
					
					<tr>
						<td class="labelmedium">#Description#: <font color="FF0000">*</font></td>
						<td>
						
						<cfquery name="List" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  SELECT  *
						     FROM  Ref_PositionParentGroupList
							 WHERE GroupCode = '#Code#'
							 ORDER BY GroupListOrder, GroupListCode
						</cfquery>
																	
						<select name="ListCode_#Code#" required="No" class="regularxl">
							<cfloop query="List">
							<option value="#GroupListCode#">#Description#</option>
							</cfloop>
						</select>
						</td>
					</tr>
				
				</cfoutput>
			
			</cfif>
									   
			<TR>
		        <td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
		        <TD><textarea style="width:100%;font-size:14px;padding:3px" rows="3" name="Remarks" class="regular"></textarea> </TD>
			</TR>
			
			<tr><td></td></tr>
								   
			<TR style="background-color:f4f4f4;border-top:1px solid silver">
		        <td style="padding-left:10px" class="labelmedium"><cf_tl id="Record">:</td>
		        <TD class="labelmedium"><cfinput class="regularxl" style="background-color:f4f4f4;text-align: center;" type="Text" name="Number" value="1" range="1,99" message="Please enter a valid no of positions to be created" validate="integer" required="Yes" size="2" maxlength="2">&nbsp;positions with the above specification</TD>
			</TR>
			
			<TR style="background-color:f4f4f4; border-bottom:1px solid silver">
		        <td style="padding-left:10px" class="labelmedium"><cf_tl id="Initiate Recruitment">:</td>
		        <TD class="labelmedium">
				
				<cf_securediv id="recruitment" 
						  bind="url:PositionEntryTrack.cfm?posttype={posttype}&mission=#url.id#&mandate=#url.id1#&orgunit={orgunit}">
				
				</TD>
			</TR>
				
			<TR><td height="3"></td></TR>
			
			<TR><td height="3" colspan="2" align="center">
			<cf_tl id="Reset"  var="vReset">
			<cf_tl id="Cancel" var="vCancel">
			<cf_tl id="Apply"   var="vSave">
			<cfoutput>
				<input class="button10g" type="reset"   name="Reset"  value="#vReset#">
				<input class="button10g" type="button"  name="cancel" value="#vCancel#"  onClick="window.close()">
		    	<input class="button10g" type="submit"  name="Submit" value="#vSave#"    onClick="verify(PositionEntry.orgunit.value,PositionEntry.functionno.value)">
			</cfoutput>
		    </td></TR>
				
		</TABLE>
	
	</td></tr>
	
	</table>
	
	</td></tr>
	
	</table>
	
	</cfform>
	
	</cf_divscroll>
			
<cfelse>

	<cf_message message = "Sorry, you are not allowed to add positions. Please contact your administrator." return = "">

</cfif>

<cf_screenbottom layout="webdialog">