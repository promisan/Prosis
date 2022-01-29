<cf_dialogPosition>
<cf_dialogOrganization>

<cfparam name="Form.DateArrival"   default="">
<cfparam name="Form.DateDeparture" default="">

<cfparam name="URL.Box" default="">

<cfquery name="Assignment" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT A.*
    FROM   dbo.#SESSION.acc#AssignmentConflict A
</cfquery>

<cfquery name="Location" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Location
	WHERE Mission = '#Assignment.Mission#'
</cfquery>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Man.*, M.MissionOwner, M.StaffingMode 
    FROM   Ref_Mandate Man, 
	       Ref_Mission M
	WHERE  Man.Mission   = '#Assignment.Mission#'
	  AND  Man.MandateNo = '#Assignment.MandateNo#' 
	  AND  M.Mission     = Man.Mission
</cfquery>

<cf_screentop layout="webapp"               
			  bannerheight="50" 
			  line="No"
			  banner="gray"
			  jquery="Yes"
			  label="Assignment Action" height="100%" scroll="Yes">
			  
<cf_systemscript>	
 
<cf_divscroll>
			  
<cfform action="Assignment#URL.Call#Submit.cfm?box=#URL.box#&Caller=#URL.Caller#&Source=#URL.Source#&RecordId=#URL.RecordId#&ApplicantNo=#URL.ApplicantNo#" 
    method="POST" name="AssignmentEntry" target="process"> 

	<table width="98%" align="center" class="formpadding">
	
		<tr class="xxxxxhide"><td colspan="2" height="160"><iframe name="process" id="process" width="100%" height="100%"></iframe></td></tr>
	      
		<tr><td colspan="2">
			<cfinclude template="../Position/Position/PositionViewHeader.cfm">
		</td></tr>
	   
	  <tr>
	    <td width="100%" colspan="2">
	    <table width="98%" align="center" class="formpadding">
		
		<!---				
		<TR>
	    <TD width="130" class="labelmedium">PositionNo:</TD>
	    <TD width="83%" height="20" class="labelmedium"><cfoutput>#Assignment.PositionNo#</cfoutput></TD>
		</TR>
		--->
		
		<cf_calendarscript>
		
		<cfif Assignment.DateArrival neq "" and Assignment.DateDeparture neq "">
		
		<TR>
	    <TD style="min-width:184px"  class="labelmedium"><cf_tl id="Assignment Period">:</TD>
	    <TD><table cellspacing="0" cellpadding="0">
		   <tr><td>
		
			  <cf_intelliCalendarDate9
				FieldName="DateArrival" 
				class="regularxl"
				Default="#Dateformat(Assignment.DateArrival, CLIENT.DateFormatShow)#"
				AllowBlank="False">	
				
			</td>
			<td>-</td>
			<td>
			
			  <cf_intelliCalendarDate9
				FieldName="DateDeparture" 
				class="regularxl"
				Default="#Dateformat(Assignment.DateDeparture, CLIENT.DateFormatShow)#"
				AllowBlank="True">	
			
			</td></tr></table>
			
		</TD>
		</TR>
		
		<cfelse>
			 
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Staffing Period">:</TD>
	    <TD><table cellspacing="0" cellpadding="0">
		   <tr><td>
		
			  <cf_intelliCalendarDate9
			FieldName="DateEffective" 
			class="regularxl"
			Default="#Dateformat(Assignment.DateEffective, CLIENT.DateFormatShow)#"
			AllowBlank="False">	
			</td><td>-</td>
			
			<td>
			  <cf_intelliCalendarDate9
			FieldName="DateExpiration" 
			class="regularxl"
			Default="#Dateformat(Assignment.DateExpiration, CLIENT.DateFormatShow)#"
			AllowBlank="True">	
			
			</td></tr></table>
		</TD>
		</TR>
		
		
		</cfif>
			
		<cfoutput>	
			
		<TR>
	    <td height="20" class="labelmedium"><cf_tl id="Employee">:</td>
		
	    <TD class="labelmedium" style="padding-right:10px"><A HREF ="javascript:EditPerson('#Assignment.PersonNo#')"><b>#Assignment.FirstName# #Assignment.LastName# (IndexNo:#Assignment.IndexNo#)</A>
		
			<input type="hidden" name="name"           value="#Assignment.FirstName# #Assignment.LastName#" readonly style="text-align: center;">	
			<input type="hidden" name="indexno"        value="#Assignment.IndexNo#">
		    <input type="hidden" name="personno"       value="#Assignment.PersonNo#">
		    <input type="hidden" name="lastname"       value="#Assignment.LastName#">
		    <input type="hidden" name="firstname"      value="#Assignment.FirstName#">
			<input type="hidden" name="positionno"     value="#Assignment.PositionNo#">
		    <input type="hidden" name="assignmentno"   value="#Assignment.AssignmentNo#">
			
		</TD>
		</TR>	
		
		</cfoutput>	
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Organization">:</TD>
			
	    <TD class="labelmedium"><cfoutput>	
		
		  <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
						  onMouseOver="document.img0.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
						  style="cursor: pointer;" alt="" width="23" height="23" border="0" align="absmiddle" 
						  onClick="selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass',mission.value, mandateno.value)">
		
		<input type="text"   name="orgunitname"  id="orgunitname"  value="#Assignment.OrgUnitName#" class="regularxl" size="40" maxlength="70" readonly style="text-align: center;">
		<input type="hidden" name="orgunitcode"  id="orgunitcode"  value="#Assignment.OrgUnitCode#" size="5" maxlength="5" readonly style="text-align: center;">
		<input type="hidden" name="mandateno"    id="mandateno"    value="#Assignment.MandateNo#">
		<input type="hidden" name="orgunit"      id="orgunit"      value="#Assignment.OrgUnit#"> 
		<input type="hidden" name="mission"      id="mission"      value="#Assignment.Mission#">
		<input type="hidden" name="orgunitclass" id="orgunitclass" value="#Assignment.OrgUnitClass#" class="disabled" size="20" maxlength="20" readonly style="text-align: center;"> 
		
		
		</td>
		</TR>	
		
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Function">:</TD>
	    <TD class="labelmedium">
		
			 <img src="#SESSION.root#/Images/search.png" alt="Select function" name="img1" 
						  onMouseOver="document.img1.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
						  style="cursor: pointer;" alt="" width="23" height="23" border="0" align="absmiddle" 
						  onClick="selectfunction('webdialog','functionno','functiondescription','#Mandate.MissionOwner#','','')">
					
		      <input type="text" name="functionno" id="functionno" value="#Assignment.functionno#" class="regularxl" size="2" maxlength="4" readonly style="text-align: center;">
		      <input type="text" name="functiondescription" id="functiondescription" value="#Assignment.functiondescription#" size="30" maxlength="60" readonly class="regularxl" style="text-align: center;"></TD> 
		</TD>
		</TR>	
			
		</cfoutput>
				
		<TR>
	    <TD class="labelmedium"><cf_tl id="Duty station">:</TD>
	    <TD class="labelmedium">
		   	<select name="LocationCode" size="1" class="regularxl">
		    <cfoutput query="Location">
			<option value="#LocationCode#" <cfif #Assignment.locationCode# eq #LocationCode#>selected</cfif>>
	    		#LocationCode# #LocationName#
			</option>
			</cfoutput>
		    </select>
		</TD>
		</TR>
		    
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Parent Office">:</TD>
	    <TD class="labelmedium">
		
		 <cfoutput>
		 
		  <img src="#SESSION.root#/Images/search.png" alt="Select function" name="img3" 
						  onMouseOver="document.img3.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
						  style="cursor: pointer;" alt="" width="23" height="23" border="0" align="absmiddle" 
						  onClick="showparent('webdialog','parentoffice','parentlocation')">
						  
		
		</cfoutput>				  
					
		    <input type="text" name="parentoffice"   id="parentoffice"   value="<cfoutput>#Assignment.ParentOffice#</cfoutput>"   size="15" maxlength="20" readonly class="regularxl">
			<input type="text" name="parentlocation" id="parentlocation" value="<cfoutput>#Assignment.ParentLocation#</cfoutput>" size="20" maxlength="20" readonly class="regularxl">
			
		</TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Incumbency">:</TD>
	    <TD class="labelmedium">
	    	<cfoutput>
			<INPUT type="radio" name="Incumbency" value="100" <cfif #Assignment.Incumbency# eq "100">checked</cfif>> 100%
			<INPUT type="radio" name="Incumbency" value="50" <cfif #Assignment.Incumbency# eq "50">checked</cfif>> 50%
			<INPUT type="radio" name="Incumbency" value="0" <cfif #Assignment.Incumbency# eq "0">checked</cfif>> 0%
		    </cfoutput>	
			
		</TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Assignment type"> | <cf_tl id="Assignment class">:</TD>
		
		 <TD>	
				
			<table><tr>
			
			<td>
			
			
			<cfquery name="AssignmentType" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
			    FROM Ref_AssignmentType
			</cfquery>
			
			
			   	<select name="assignmenttype" size="1" class="regularxl" onChange="hidepost();">
			    <cfoutput query="AssignmentType">
				<option value="#AssignmentType#" <cfif Assignment.AssignmentType eq AssignmentType>selected</cfif>>
		    		#Description#
				</option>
				</cfoutput>
		        </select>
			
			</td>
			
			<cfquery name="AssignmentClass" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   * 
			    FROM     Ref_AssignmentClass
				WHERE    Operational = 1
				ORDER BY ListingOrder
			</cfquery>
					
			
			<td style="padding-left:4px">
	   
			   	<select name="assignmentclass" size="1" class="regularxl" onChange="hidepost();">
			    <cfoutput query="AssignmentClass">
				<option value="#AssignmentClass#" <cfif Assignment.AssignmentClass eq AssignmentClass>selected</cfif>>
		    		#Description#
				</option>
				</cfoutput>
			    </select>
			
			</td></tr>
			</table>	
			
			
			</TD>
		
		</TR>
			   
		<TR>
	        <td valign="top" style="padding-top:2px" class="labelmedium"><cf_tl id="Remarks">:</td>
	        <TD><textarea class="regular" style="width:90%;padding:3px;font-size:14px" rows="2" name="Remarks"><cfoutput>#Assignment.Remarks#</cfoutput></textarea> </TD>
		</TR>
		
		<!--- option to record topics in a dropdown --->
			
	    <cfinclude template="AssignmentEditTopic.cfm">
		
		<tr><td height="4"></td></tr>	
		<TR>
	        <td class="labelmedium"><cf_tl id="Incumbency Classification">:</td>
	        <TD>		
			  <cfinclude template="AssignmentEditGroup.cfm">		
			</td>
		</TR>
		
		<tr><td height="3"></td></tr>		
		
		<tr><td colspan="2" class="linedotted"></td></tr>
				
		<tr>
		<td colspan="2">
		
		<cfquery name="Parameter" 
		 datasource="AppsEmployee" 
		 maxrows=1 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	SELECT * 
		    FROM Parameter
		 </cfquery>
	
		<cfquery name="SearchResult" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT 
			    A.PositionNo, 
			    A.PersonNo, 
				A.AssignmentStatus, 
				A.DateEffective, 
				A.DateExpiration, 
				A.Incumbency, 
				A.AssignmentType, 
				A.Remarks, 
				A.AssignmentNo, 
				A.Created,
			    P.LastName, 
				P.FirstName, 
				P.IndexNo, 
				S.PostGrade, 
				A.FunctionDescription, 
				O.OrgUnitName, 
				O.Mission, 
				S.SourcePostNumber, 
				M.MandateStatus
		FROM 	PersonAssignment A, 
			    Person P, 
				Position S, 
				Organization.dbo.Organization O, 
				Organization.dbo.Ref_Mandate M
		WHERE (A.PersonNo = '#Assignment.PersonNo#' or A.PositionNo = '#Assignment.PositionNo#')
		  AND A.PersonNo           = P.PersonNo
		  AND A.PositionNo         = S.PositionNo
		  AND S.OrgUnitOperational = O.OrgUnit
		  AND A.Incumbency        != 0
		  AND A.DateExpiration    >= '#DateFormat(Assignment.DateEffective,client.dateSQL)#'
		  AND A.DateEffective     <= '#DateFormat(Assignment.DateExpiration,client.dateSQL)#'
		  AND A.AssignmentClass    = '#Assignment.AssignmentClass#'
		  AND A.AssignmentNo      <> #Assignment.AssignmentNo#
		  AND A.AssignmentStatus  IN ('0','1')
		  AND M.Mission           = O.Mission
		  AND M.MandateNo         = O.MandateNo 
		  AND S.OrgUnitOperational IN (SELECT OrgUnit 
			                      FROM userQuery.dbo.#SESSION.acc#OrgScope)
		</cfquery>  
	
	  <table width="100%" bgcolor="ffffef" style="border:1px dotted silver"
	     cellspacing="0" cellpadding="0" align="center">
		  
		<tr>
		<td align="center" bgcolor="yellow" height="35">
			
			<font face="Calibri" size="3" color="#FF0000">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/alert.gif" align="absmiddle" height="20" width="20" alt="" border="0">
			A Conflict is detected with the following existing assignment(s)
			
		</td>
		</tr>  
	  
	  <tr>
	  <td width="100%">
	  <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
		
	    <TR class="labelmedium2">
	       <td height="20" width="4%" align="center"></td>
	       <td width="8%">IndexNo</td>
	       <TD width="15%">Name</TD>
		   <TD width="10%">Tree</TD>
		   <TD width="15%">PostNumber</TD>
		   <TD width="5%">Grade</TD>
	       <TD width="6%">Type</TD>
		   <TD width="6%">Inc.</TD>
		   <TD width="8%">Effective</TD>	
		   <TD width="8%">Expiration&nbsp;</TD>	
	    </TR>
		
		<tr><td colspan="10" class="linedotted"></td></tr>
	
	    <cfset last = '1'>
		
		<cfif searchResult.recordcount eq "0">
		    <tr><td colspan="10" align="center" class="labelmedium">No more conflicts found, please press submit to post your transaction!</b></td></tr>
		</cfif>
		
	    <cfoutput query="SearchResult">
		
		<cfif AssignmentStatus eq "0" and searchResult.MandateStatus eq "1">
		   <tr><td colspan="6" style="padding-left:5px" class="labelmedium"><b><font color="FF0000">Pending approval</b></td></tr>
		</cfif>
	   
		<TR bgcolor="<cfif #AssignmentStatus# eq "0">FFFFdF<cfelse>#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F6F6F6'))#</cfif>">
	       <td valign="top" style="padding-top:6px" rowspan="2" align="center">
		       <cf_img icon="edit" onclick="EditAssignment('#PersonNo#','#AssignmentNo#','P','err')">	      
	       </td>	
	       <td style="padding-left:5px" height="25" class="labelmedium"><A HREF ="javascript:EditPerson('#PersonNo#')">#IndexNo#</A></td>
	       <TD class="labelmedium"><A HREF ="javascript:EditPerson('#PersonNo#')">#LastName#, #FirstName#</A></TD>
	   	   <TD class="labelmedium">#Mission#</TD>
		   <TD class="labelmedium">#SourcePostNumber# [#PositionNo#]</TD>
		   <TD class="labelmedium">#PostGrade#</TD>
		   <TD class="labelmedium">#AssignmentType#</TD>
		   <TD class="labelmedium">#Incumbency#%</TD>
		   <td class="labelmedium">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
	       <td class="labelmedium">#Dateformat(DateExpiration, CLIENT.DateFormatShow)#&nbsp;</td>
		 </tr>
		 
		 <TR bgcolor="<cfif #AssignmentStatus# eq "0">FFFFdF<cfelse>#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F6F6F6'))#</cfif>">
		   <TD class="labelmedium" colspan="4">#OrgUnitName#</TD>
	       <td class="labelmedium" colspan="3">#FunctionDescription#</td>
		   <td></td>
	       <td></td>
	     </tr>
		 
		 </tr>
		 <cfif Remarks neq "">
	     <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F6F6F6'))#">
	     <td colspan="2"></td><td colspan="9" align="left" class="regular"><b>#Remarks#&nbsp;</b></td></tr>
	     </cfif>
	    </tr>	
	     
	  </cfoutput>
	
	   </TABLE>
	
	   </td></tr>
	       
	   </TABLE>
	      
	   </td></tr>
	            
	   <cfif URL.Status eq "Go"> 
	 
			<tr><td colspan="2" bgcolor="FFFFFF">
			
				<table width="100%" bgcolor="FFFFFF">
					
				<TR>
			    <TD class="labelmedium">&nbsp;&nbsp;<cf_tl id="Process">:</TD>
			    <TD class="labelmedium" style="padding-left:5px">
					<INPUT type="radio" name="Condition" value="1"> <cf_tl id="Terminate conflicting assignments for this employee">.				
				</TD>
				</TR>
				
				<tr>
				 <TD></TD>
			     <TD class="labelmedium" style="padding-left:5px">	
					<INPUT type="radio" name="Condition" value="2"> <cf_tl id="Terminate any conflicting assignments">.				
				</TD>
				</TR>
				
				<tr>
				<TD></TD>
			    <TD class="labelmedium" style="padding-left:5px">	
					<INPUT type="radio" name="Condition" value="9" checked> <cf_tl id="Reject if any active assignment exists">.				
				</TD>
				</TR>
				
				<tr><td height="4"></td></tr>
				
				</table>
				
			  </td></tr>
					
			  <tr><td height="1" colspan="3" align="right" class="linedotted"></td></tr>
			   
			  <tr><td colspan="3">
				   <table width="100%">
				   	<td height="28" align="center">
					
					    <cf_tl id="Resubmit" var="submit">
						<cfoutput>
						<input class="button10g" type="button" name="Close" value="Close" onclick="parent.window.close()">
				        <input class="button10g" type="submit" name="Submit" value="#submit#">    	
						</cfoutput>
			   	    </td>
				   </table>
		      </td></tr>
	   
	   </cfif>	
	        
	   </TABLE>
	   
	   </td>
	   </tr>
	
	</table>

</cfform>

</cf_divscroll>

<cf_screenbottom layout="webapp">