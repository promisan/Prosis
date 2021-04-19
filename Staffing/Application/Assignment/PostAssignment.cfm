
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cfajaximport>
<cf_dialogstaffing>

 <cfquery name="Parameter" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT * FROM Parameter
</cfquery>

<!--- Query returning search results --->
	
<cfquery name="Assignment" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT   A.*, P.*, 
	         Pos.SourcePositionNo,
			 Pos.OrgUnitOperational,
			 (SELECT LocationName FROM Location WHERE LocationCode = A.LocationCode) as LocationName,
			 O.Mission, 
			 O.OrgUnitName, 			 
			 C.Description as AssignmentDescription 
    FROM     PersonAssignment A, 
	         Person P, 
		     Organization.dbo.Organization O, 
		     Position Pos,
		     Ref_AssignmentClass C		   
	WHERE    A.PersonNo        = P.PersonNo
	AND      A.OrgUnit         = O.OrgUnit
	AND      A.PositionNo      = '#URL.ID#'
	AND      C.AssignmentClass = A.AssignmentClass
	AND      A.PositionNo      = Pos.PositionNo
	AND      A.AssignmentStatus < '#Parameter.AssignmentShow#' 
	ORDER BY A.DateExpiration DESC
</cfquery>

<cfparam name="url.caller" default="regular">
    
<table width="94%" align="center"> 

  <tr>
  <td colspan="2">
  	<cfinclude template="../Position/Position/PositionViewHeader.cfm">
  </td>
  </tr>  
  
  <script>
    function goit() {
		  alert("a")
	}  
  </script>  
  
  <cfinvoke component = "Service.Access"  
   method           = "staffing" 
   mission          = "#Position.MissionOperational#" 
   orgunit          = "#Position.OrgUnitOperational#" 
   posttype         = "#Position.PostType#"
   returnvariable   = "AccessStaffing">	  
    
  <cfif url.caller eq "regular" or url.caller eq "postdialog"> 
  
  <tr class="line">
    <td width="100%" style="font-size:18px;height:40px;padding-left:2px" class="labelmedium2"><cf_tl id="Incumbency"></td>
	<cfoutput>
    <td align="right" style="padding-right:6px">
	   	<input type="hidden" id="refresh_position" onClick="window.open('#session.root#/Staffing/Application/Assignment/PostAssignment.cfm?caller=postdialog&id=#url.id#','assignments')"> 
		<cfif (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT")>
			<cf_tl id="Add incumbency" var="tAdd">
			<input type="button" value="#tAdd#" class="button10g" style="width:180;height:28" onClick="AddAssignment('#URL.ID#','position')">
		</cfif>
    </td>
	</cfoutput>
  </tr>
  
  </cfif>
  
  <tr>
  
  <td width="95%" colspan="2" style="padding-left:6px;padding-right:6px">
  
	  <table border="0" class="formpadding" width="100%" class="navigation_table">
		
	    <TR class="line labelmedium2">
	       <td width="3%" align="center"></td>
	       <td width="7%" align="left"><cf_tl id="IndexNo"></td>
	       <TD width="20%"><cf_tl id="Name"></TD>
		   <TD width="20%"><cf_tl id="Function"></TD>
		   <TD width="6%"><cf_tl id="Location"></TD>
		   <TD colspan="2" width="10%"><cf_tl id="Class"></TD>
		   <!---		   
	       <TD width="6%"><cf_tl id="Type"></TD>
	       --->
		   <TD width="min-width:50"> <cf_tl id="Inc">.</TD>
		   <TD style="min-width:73"> <cf_tl id="Effective"></TD>	
		   <TD style="min-width:73"> <cf_tl id="Expiration"></TD>	
		   <TD style="min-width:93"> <cf_tl id="Processed"></TD>	
	    </TR>
			
	    <cfset last = "1">
		
		<cfif Assignment.recordcount eq "0">		
		<tr><td colspan="12" align="center" class="labelmedium2" style="padding-top:10px"><font color="808080">No assignments recorded for this position</td></tr>
		</cfif>
	
		<cfoutput query="Assignment">
		   
			<TR class="navigation_row line labelmedium2">
		   	   <td align="center" style="padding-left:4px">	   			  
			     <cf_img icon="edit" navigation="Yes" onclick="EditAssignment('#PersonNo#','#AssignmentNo#','','position')">	 
			   </td>	
		       <td><A HREF="javascript:EditPerson('#PersonNo#','#IndexNo#')">#IndexNo#</A></td>
		       <td>#LastName#, #FirstName#</TD>
		   	   <td>#FunctionDescription#</TD>
			   <td>#LocationName#</td>
			   <td colspan="2">#AssignmentDescription#</TD>
			   <!---	
			   <td>#AssignmentType#</TD>
			   --->
			   <td style="padding-right:8px">#Incumbency#%</TD>
			   <td>#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
		       <td>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>
			   <td style="min-width:120px">#Dateformat(Created, CLIENT.DateFormatShow)# #Timeformat(Created, "HH:MM")#</td>
		    </tr>
			 
			<cfif OrgUnit neq OrgUnitOperational>
		     <TR class="navigation_row_child">
		     	<td colspan="2"></td>
				<td colspan="9" align="left" class="labelit">#Mission# #OrgUnitName#</td>
			 </tr>
		    </cfif>
			<cfif Remarks neq "">
		     <TR class="navigation_row_child Line">
		     <td colspan="2"></td><td colspan="9" align="left" class="labelit">#Remarks#</td></tr>
		    </cfif>
		    	
			<cfquery name="GroupAll" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  F.GroupCode, F.Description
				FROM    PersonAssignmentGroup S, 
				        Ref_Group F 
				WHERE   S.AssignmentNo = '#AssignmentNo#'
				AND     S.AssignmentGroup = F.GroupCode
				AND     S.Status <> '9'
			</cfquery>
			
			<cfif GroupAll.recordcount gt 0>
			
				<tr class="navigation_row_child"><td></td>
				    <td colspan="10" class="labelit">
					   [<cfloop query="GroupAll">#GroupAll.Description#</CFLOOP>]
					</td>
				</tr>
			
			</cfif>
		  
		</cfoutput>
		
		<cfquery name="Exist" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM  Position
		  WHERE PositionNo = '#Assignment.SourcePositionNo#'					
	   </cfquery>
        
	   <cfset row = 0>	
         
	  <cfloop condition="#exist.recordcount# eq '1' and row lte '3'">
	  
	  		<cfset row = row+1>
	  
		  	<cfquery name="AssignmentPrior" 
			    datasource="AppsEmployee" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    SELECT   A.*, P.*, 
				         Pos.Mission, 
						 Pos.MandateNo, 
						 Pos.SourcePositionNo, 
						 (SELECT LocationName FROM Location WHERE LocationCode = A.LocationCode) as LocationName,
						 O.Mission, 
						 O.OrgUnitName, 
						 Pos.OrgUnitOperational,
						 C.Description as AssignmentDescription 
			    FROM     PersonAssignment A, 
				         Person P, 
					     Organization.dbo.Organization O, 
					     Position Pos,
					     Ref_AssignmentClass C		   
				WHERE    A.PersonNo = P.PersonNo
				AND      A.OrgUnit = O.OrgUnit
				AND      A.PositionNo = '#exist.PositionNo#'
				AND      C.AssignmentClass = A.AssignmentClass
				AND      A.PositionNo = Pos.PositionNo
				AND      A.AssignmentStatus < '#Parameter.AssignmentShow#' 
				ORDER BY A.DateExpiration DESC
			</cfquery>
			
			<cfoutput query="AssignmentPrior">
			
				<TR class="line labelmedium" style="background-color:e1e1e1">
			   	   <td class="labelit" align="center" style="padding-left:4px">	   			  
				     <!---
				     <cf_img icon="edit" navigation="Yes" onclick="EditAssignment('#PersonNo#','#AssignmentNo#','','position')">	 
					 --->
				   </td>	
			       <td><A HREF="javascript:EditPerson('#PersonNo#','#IndexNo#')"><font color="6688aa">#IndexNo#</A></td>
			       <td>#LastName#, #FirstName#</TD>
			   	   <td>#Mission# #FunctionDescription#</TD>
				   <td>#LocationName#</td>
				   <td colspan="2">#AssignmentDescription#</TD>
				   <!---
				   <td>#AssignmentType#</TD>
				   --->
				   <td style="padding-right:8px">#Incumbency#%</TD>
				   <td>#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
			       <td>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>
				   <td style="min-width:120px">#Dateformat(Created, CLIENT.DateFormatShow)# #Timeformat(Created, "HH:MM")#</td>
			    </tr>
						
			</cfoutput>
	  	  
		   <cfquery name="Exist" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT  *
			  FROM  Position
			  WHERE PositionNo = '#Exist.SourcePositionNo#'					
		   </cfquery>	
		     
	  </cfloop>
	
	</table>

	</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>

<input type="hidden" name="positionno" value="<cfoutput>#URL.ID#</cfoutput>">
