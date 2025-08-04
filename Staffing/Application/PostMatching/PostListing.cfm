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

<!--- Pending actions ------------------------------------------------------------------------- --->
<!--- This function can be improved with ajaxto easily select and update positions more quickly --->
<!--- ----------------------------------------------------------------------------------------- --->

<cfajaximport>

<cfparam name="URL.Print" default="0">

<cfif url.print eq "0">

	<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cfelse>

	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

</cfif>	

<cfparam name="CLIENT.Sort" default="PostOrder">
<cfif #CLIENT.Sort# neq "PostOrder" and
      #CLIENT.Sort# neq "DateExpiration">
	  <cfset deleted = deleteClientVariable("Sort")>
</cfif>  

<cfparam name="CLIENT.Sort" default="PostOrder">
<cfparam name="URL.Sort" default="#CLIENT.Sort#">
<cfparam name="URL.Lay" default="Listing">
<cfparam name="URL.Mission" default="Template">
<cfparam name="URL.ShowExpired" default="No">

<cfset condA = "">

<cfswitch expression="#URL.ID#">
    <cfcase value="GRD"><cfset cond = "AND P.PostGrade = '#URL.ID2#'"></cfcase>
</cfswitch>

<cfquery name="Default" 
	datasource="AppsOrganization" 
	maxrows=1 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT  MandateNo 
	   FROM    Ref_Mandate
	   WHERE   Mission = '#URL.Mission#'
	   ORDER BY MandateDefault DESC, MandateNo DESC
</cfquery>
     
<cfif Default.recordCount eq 1>
   <cfparam name="URL.Mandate" default="#Default.MandateNo#">
<cfelse>
   <cfparam name="URL.Mandate" default="0000">   
</cfif>   

<cfparam name="URL.page" default="1">

<cfset CLIENT.sort = URL.Sort>

<cfif URL.Sort eq "DateExpiration">
         <cfset orderby = "P.DateExpiration DESC">
<cfelse> <cfset orderby = "G.PostOrder">	
</cfif> 
		
<cfquery name="Current" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_Mandate
   WHERE  Mission = '#URL.Mission#'
   AND    MandateNo = '#URL.Mandate#' 
</cfquery>

<!--- Query returning search results --->

<!--- I am using stPostNumber_2 testing purposes , Jorge Mazariegos 20-03-2010 ---->

<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT P.*, G.PostOrder
  FROM   stPostNumber P, Ref_PostGrade G
  WHERE  Mission = '#URL.Mission#'
  AND    G.PostGrade = P.PostGrade
         #PreserveSingleQuotes(Cond)#
  <cfif URL.ShowExpired eq "Yes">
	  AND    DateEffective <= '#DateFormat(Current.DateExpiration,client.dateSQL)#'
	  AND    DateExpiration >= '#DateFormat(Current.DateEffective,client.dateSQL)#' 
  <cfelse>
	  AND    DateEffective <= '#DateFormat(now(),client.dateSQL)#'
	  AND    DateExpiration >= '#DateFormat(now(),client.dateSQL)#'   
  </cfif>	  
  ORDER BY #orderby#, P.SourcePostNumber
</cfquery>

<!--- create a subset of matched posts --->

<cfquery name="TmpPosition" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT P.*,PP.Fund, O.OrgUnitName
  FROM  Position P, 
        Organization.dbo.Organization O, 
		PositionParent PP
  WHERE P.Mission = '#URL.Mission#'
  AND   O.OrgUnit = P.OrgUnitOperational
  AND   P.MandateNo = '#URL.Mandate#'
  AND	P.PositionParentId = PP.PositionParentId
  <!--- Post is indeed matched again the valid IMIS Post --->
  AND   P.SourcePostNumber IN
			  (SELECT P.SourcePostNumber
			   FROM   stPostNumber P, Ref_PostGrade G
			   WHERE  Mission = '#URL.Mission#'
			   AND    G.PostGrade = P.PostGrade
				      #PreserveSingleQuotes(Cond)#
			    AND   DateEffective <=  '#DateFormat(Current.DateExpiration,client.dateSQL)#'
				AND   DateExpiration >= '#DateFormat(Current.DateEffective,client.dateSQL)#')
</cfquery>

<cfset currrow = 0>
<cfset counted = Searchresult.recordcount>

<cfquery name="Mandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM   Ref_Mandate
   WHERE  Mission = '#URL.Mission#'
   ORDER BY MandateNo DESC
</cfquery>
   
<cfoutput>

<script>

function reloadForm(page,sort,layout,mission,mandate) {
   vLay=document.getElementById('_Lay');
   vLay.value=layout;   	
   window.location="PostListing.cfm?lay=" + layout + "&ID=#URL.ID#&ID2=#URL.ID2#&Page=" + page + "&Sort=" + sort + "&Mandate=" + mandate + "&Mission=" + mission;
}

function printme() {
    window.open("PostListing.cfm?#CGI.QUERY_STRING#&print=1","_blank","left=40, top=40, width=800, height=600, status=yes, scrollbars=yes, resizable=no")
}

function Process(action) {
	if (confirm("Do you want to " + action + " selected positions ?")) {return true;}
	{return false}
}

function EditParent(mission,mandate,positionparentid,posno) {
     ret = window.showModalDialog(root + "/Staffing/Application/Position/PositionParent/PositionParentInitialEdit.cfm?ID=" + mission + "&ID1=" + mandate + "&ID2=" + positionparentid + "&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:no; dialogHeight:720px; dialogWidth:680px; help:no; scroll:yes; center:yes; resizable:yes");
	 if (ret) {	
	    ColdFusion.navigate('PostListingCheck.cfm?positionno='+posno,'box'+posno)	  
	}	   
}

function showExpired(el) {
   layout = $('##_Lay').val();
   page   = $('##page').val();
   sort   = $('##sort').val();
   mandate   = $('##mandate').val();
   mission   = $('##mission').val();   
   window.location="PostListing.cfm?lay=" + layout + "&ID=#URL.ID#&ID2=#URL.ID2#&Page=" + page + "&Sort=" + sort + "&Mandate=" + mandate + "&Mission=" + mission+"&ShowExpired="+el.value;
}

</script>	

</cfoutput>

<cf_dialogPosition>

<cfform action="../Position/PositionBatch.cfm" method="post" id="result">

<input type="hidden" name="mission"  id="mission" 	value="<cfoutput>#URL.Mission#</cfoutput>">
<input type="hidden" name="ID"       id="ID" 		value="<cfoutput>#URL.ID#</cfoutput>">
<input type="hidden" name="ID1"      id="ID1" 		value="<cfoutput>#URL.Mission#</cfoutput>">
<input type="hidden" name="page1"    id="page1" 	value="<cfoutput>#URL.Page#</cfoutput>">
<input type="hidden" name="lay"      id="lay"  		value="<cfoutput>#URL.Lay#</cfoutput>">
<input type="hidden" name="link"     id="link" 		value="<cfoutput>#CGI.QUERY_STRING#</cfoutput>">

<table width="97%" align="center">

  <cfoutput>
  <tr><td height="30" colspan="3" style="padding-top:10px;" class="labellarge"><b>Mapping of IMIS/Umoja Posts to #SESSION.welcome#/#URL.Mission# Staffing table positions
	  <input type="hidden" name="_Lay" id="_Lay" value="0">
	  </td>
  </tr>	
  </cfoutput>
  
  <tr><td colspan="3" height="1" class="linedotted"></td></tr>
   
  <tr>
    <td height="26" class="labelit">
	
    	<cfoutput>
		   Mandate: <b>#Current.Description#</b> &nbsp;Period: <b>#DateFormat(Current.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(Current.DateExpiration, CLIENT.DateFormatShow)#</b>
    	</cfoutput>
	   		
	</td>
	
	<td class="labelit">  
	
		<cfif url.print eq "0">
			<cfoutput>
			   <a href="javascript:printme()"><b><font color="0080FF">Print Listing</b></a>
			 </cfoutput>
		</cfif>
			 
	</td>
	
	<td align="right">
	
		<cfif url.print eq "0">
		
			 
			 <select name="mandate" id="mandate" size="1" class="regularxl"  
				onChange="javascript:reloadForm(page.value,sort.value,layout.value,mission.value,this.value)">
				<cfoutput query="Mandate">
				<option value="#MandateNo#" <cfif #URL.Mandate# eq "#MandateNo#">selected</cfif>>
		    		#MandateNo# #Description#
				</option>
				</cfoutput>
		     </select>
	
	         <cf_PageCountN count="#counted#">
	         <select name="page" id="page" size="1" class="regularxl" 
	          onChange="javascript:reloadForm(this.value,sort.value,layout.value,mission.value,mandate.value)">
			  <cfloop index="Item" from="1" to="#pages#" step="1">
	             <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
	          </cfloop>	 
	         </SELECT>
			 
		<cfelse>
		
		    <cfset first = 0>
			<cfset last = 99999>	
			<cfset pages = 1> 
		 
		 </cfif>
		 
     &nbsp;  	

    </TD>
	
  </tr>
  
   <tr><td colspan="3" height="1" class="linedotted"></td></tr>
  
  <cfif url.print eq "0">
  
	  <tr>
	      
	  <td colspan="3">
	  
	  <table width="100%" border="0">
	    
	  <tr>
	
	  <td colpsan="2" align="left">
	  		<table width="100%">
			<tr>
				<td class="labelit" width="7%" align="right">Show Expired:</td>
				<td width="5%">
				   <input type="radio" name="ShowExpired" id="ShowExpired" value="Yes" onchange="javascript:showExpired(this)" <cfif URL.ShowExpired eq "Yes">checked="checked"</cfif>>Yes
				   <input type="radio" name="ShowExpired" id="ShowExpired" value="No" onchange="javascript:showExpired(this)" <cfif URL.ShowExpired eq "No">checked="checked"</cfif>>No
				</td>
				<td width="5%"></td>
				<td width="10%">
				  <select name="sort" id="sort" size="1" class="regularxl"
					onChange="javascript:reloadForm(page.value,this.value,layout.value,mission.value,mandate.value)">
				     <option value="PostOrder" <cfif #URL.Sort# eq "PostOrder">selected</cfif>>Group by Post grade
				  	 <option value="DateExpiration" <cfif #URL.Sort# eq "DateExpiration">selected</cfif>>Group by Expiration date
				  </select>
				</td>		
			    <td width="10%">
				  <select name="layout"  id="layout" size="1" class="regularxl"
					onChange="javascript:reloadForm(page.value,sort.value,this.value,mission.value,mandate.value)">
				     <option value="Listing" <cfif #URL.Lay# eq "Listing">selected</cfif>>IMIS posts
					 <option value="Pending" <cfif #URL.Lay# eq "Pending">selected</cfif>>Pending association
				  </select>	 
				</td>	
				<td></td>
	  
		
	 	 	</tr>	
			</table>
	    
	  </td>
	   
	  </tr>
	  
	  </table>
	  
	  </td>
	  
	  </tr>
	  
  </cfif>
  
<tr>

<td width="100%" colspan="3">

<TABLE width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<cfif url.print eq "0">

<tr><td height="1" class="linedotted" colspan="10"></td></tr>
<tr><td height="14" colspan="10">
						 
	 <cfinclude template="Navigation.cfm">
	 				 
</td></tr>
</cfif>

 <tr><td height="1" colspan="10" class="linedotted"></td></tr>  
 <TR>

	<TD></TD>
	<TD></TD>
	<TD class="labelit">Organization</TD>
	<TD class="labelit">Source</TD>
    <TD class="labelit">PostNumber</TD>
    <TD class="labelit">Grade</TD>
    <TD class="labelit">Fund</TD>	
    <TD class="labelit">Effective</TD>
    <TD class="labelit">Expiration</TD>
	<td></td>
	
 </TR>
 <tr><td height="1" colspan="10" class="linedotted"></td></tr>  
 
<cfinvoke component="Service.Access"  
  method="position" 
  orgunit="#tmpPosition.OrgUnitOperational#" 
  posttype=""
  returnvariable="accessPosition"> 
   
<cfoutput query="SearchResult" group="#URL.Sort#">
      
   <tr>
   
   <cfswitch expression = #URL.Sort#>
    <cfcase value = "PostOrder">
     <td colspan="10"><font face="Verdana" size="2">&nbsp;#PostGrade#</font></td>
    </cfcase>
    <cfcase value = "DateExpiration">
     <td colspan="10"><font face="Verdana" size="2">&nbsp;#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</b></font></td>
    </cfcase>
   </cfswitch>

   </tr>
   
   <cfoutput>
        	 
	 <!--- associated position --->
	 
     <cfquery name="Position" dbtype="query">
	     SELECT *
	     FROM   TmpPosition
	     WHERE  SourcePostNumber = '#SourcePostNumber#'
	     ORDER BY DateEffective
	 </cfquery>
	 
	 <cfif URL.lay eq "Pending" and Position.recordcount eq "1">
		 
		 <cfelse> 
		 
		 <cfset currrow = currrow + 1>
							
		 <cfif currrow gte first and currrow lte last>
		 
			 <tr><td colspan="10" class="linedotted"></td></tr>
		   
		     <cfif Position.recordcount eq 0>
			   <cfset cl = "FF8040">
			 <cfelse>
			   <cfset cl = "FFFFFF">	
			 </cfif>  
			 
		     <tr bgcolor="#cl#" class="navigation_row">
		   
			     <td width="2%" class="labelit" style="padding-left:3px">#currrow#</td>
				 <TD class="labelit" style="padding-top:2px;padding-left:3px">
				  <cfif url.print eq "0">
				  <cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL">
				     <button onclick="selectposition('AUT','#URL.Mission#','#URL.Mandate#','','0','#SourcePostNumber#','#Source#')" 
					         type="button"
							 class="button10s"
							 style="border:1px solid silver">
					 		 <img src="#SESSION.root#/Images/copy.jpg" height="15" width="15" border="0" alt="Press here to associate a position to this external post">					 
					 </button>					
				  </cfif>	
				  </cfif>					 
				 </TD>
				 <td class="labelit" style="padding-left:3px">
				 	<cfif Position.recordcount eq 0>
					 	#OrgUnitName# (#Acronym#)
					</cfif>
				 </td>
			     <TD class="labelit" style="padding-left:3px">#Source#</TD>	
			     <TD class="labelit" style="padding-left:3px">#SourcePostNumber#</TD>
			     <TD class="labelit" style="padding-left:3px">#PostGrade#</TD>
			     <TD class="labelit" style="padding-left:3px">#Fund#</TD>				 
			     <TD class="labelit" style="padding-left:3px">#DateFormat(DateEffective, CLIENT.DateFormatShow)#</TD>
			     <TD>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</TD>
				 <td class="labelit" style="padding-left:3px">
				  <cfif Position.recordcount eq 0>
				  <font color="black">Pending</font>
				  <cfelse>
				  <font color="008000">Mapped</font>
				  </cfif>
				 
				 </td>
			    
		     </TR>
			 	 	 	 
			 <cfif Position.recordcount neq 0>
			 					
				<cfif Position.recordcount gte "2">
				
				<tr><td><td colspan="9" align="center" class="labelit" 
				            bgcolor="FF0000"
				            style="color: White;">
							External position IS MAPPED to serveral instances</td></tr>
				</cfif>
								 
				<cfloop query = "Position">
				 				 									 
					 <tr class="navigation_row_child">
					 <td></td>
					 <td width="100%" colspan="9">
					
					 <table width="100%" border="0" cellspacing="0" cellpadding="0">
				      
				     <TR>
						 <td width="2%" align="center" id="box#positionno#">
						   <img src="#SESSION.root#/Images/join.gif" alt="Assiciate a position to this external post" border="0">
						 </td>
						 <td width="2%" bgcolor="FFFFCF">
						 				 				 	 	 
							 <cfif Current.MandateStatus eq "1">
										 
							 <a href="javascript:ViewParentPositionDialog('#Mission#','#MandateNo#','#PositionParentId#','direct')"
							    onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" 
								onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/contract.gif'">
						         <img src="#SESSION.root#/Images/contract.gif" alt="" name="img0_#positionno#" id="img0_#positionno#" width="12" height="12" border="0" align="middle">
						        </a>
									
							 <cfelse>
							 							
							 <a href="javascript:EditParent('#Mission#','#MandateNo#','#PositionParentId#','#PositionNo#')" 
							   onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" 
							   onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/contract.gif'">
						         <img src="#SESSION.root#/Images/contract.gif" alt="" name="img0_#positionno#" id="img0_#positionno#" width="12" height="12" border="0" align="middle">
						      </a>  
								
						     </cfif>	
										 			 	 
					     </td>
						 				  
						 <TD class="labelit" width="20%" bgcolor="FFFFCF">#Position.OrgUnitName#</TD>
					     <TD class="labelit" width="20%" bgcolor="FFFFCF">
						 <a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','box#positionno#')">
							 #Position.FunctionDescription#
							 </a>
						 </TD>
						 <TD class="labelit" width="10%">#Position.PostClass#</TD>
					     <TD class="labelit" width="9%">#Position.PostType#</TD>
	 				     <TD class="labelit" width="8%">#Position.PostGrade#</TD>
	 				     <TD class="labelit" width="7%">#Position.Fund#</TD>					 					 
					     <TD class="labelit" width="80">#DateFormat(Position.DateEffective, CLIENT.DateFormatShow)#&nbsp;</TD>
					     <TD class="labelit" width="80">#DateFormat(Position.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</TD>
					     <TD align="right" style="padding-right:10px">
						 <cfif url.print eq "0">
						 <cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL">
							 <input type="checkbox" name="Position" value="#Position.PositionNo#">
						 </cfif>
						 </cfif>
						 </TD>
					</TR>
						 						 
					<cfquery name="Assignment" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   PersonAssignment A, Person P
						    WHERE  PositionNo = '#PositionNo#' 
							AND    A.PersonNo = P.PersonNo
							AND    A.AssignmentStatus IN ('0','1') 
							ORDER BY DateEffective DESC
					</cfquery>	
						
					<cfif Assignment.recordcount gt "0">
		  		 
					  <cfloop query="Assignment">
						  
						  <tr class="navigation_row_child">
						   <td></td>
						   <td></td>
						   <td></td>
						   <td height="18" class="labelit" width="10%"><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></td>
						   <td class="labelit" colspan="2"><a href="javascript:EditPerson('#PersonNo#')">#FirstName# #LastName#</a></td>
						   <td class="labelit">#Gender#</td>
						   <td class="labelit">#Nationality#</td>
						   <td class="labelit">#dateFormat(Assignment.DateEffective,CLIENT.DateFormatShow)#</td>
						   <td class="labelit">#dateFormat(Assignment.DateExpiration,CLIENT.DateFormatShow)#</td>
						   <td class="labelit">#Assignment.OfficerLastName#</td>
						  </tr>
						 		 		  
							  <cfquery name="Error" 
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
							    SELECT    *
								FROM      PositionParentError
								WHERE     PositionParentId = '#Position.PositionParentId#' 
								AND       Element = 'Assignment' 
								AND       ElementNo = '#AssignmentNo#' 
							   </cfquery>
							   
							   <cfif Error.recordcount gte "1">
							 
								   <cfloop query="Error">
								   <tr><td colspan="10" bgcolor="ffffbf" class="labelit">
								   <img src="#SESSION.root#/Images/join.gif"align="absmiddle" border="0">
								   <font color="FF0000">#Error.Observation#</td></tr>
								   </cfloop>
							 
							   </cfif>
						  		 
						  </cfloop>						  
						
						</cfif>
													
					    </table>
				       </td>
					 </tr>
				 
				 </cfloop>
		 	  
			 </cfif>
		 
		 </cfif>
		
		
	 
	  </cfif>
	 
	   <cfif currrow gt last>
	       <tr><td height="1" class="linedotted" colspan="10"></td></tr>
	 	   <tr><td height="14" colspan="10">
		       	 <cfinclude template="Navigation.cfm">
		   </td></tr>
		   <cfabort>
	  </cfif>	
	 	 	   
   </cfoutput>
    
  </CFOUTPUT>

<cfif url.print eq "0">

	 <tr><td class="line" colspan="10"></td></tr>
	 <tr>
	    <td height="14" colspan="10" class="regular">
			<cfinclude template="Navigation.cfm">
	    </td>
	 </tr> 
		  
	<tr><td class="line" colspan="10"></td></tr> 	  
	
	<tr height="50">
	
	<td colspan="10">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<td height="21" colspan="3" align="left" valign="middle" style="padding-left:10px">
			<input type="button" name="Refresh" style="width:120" value="Refresh" class="button10s" onClick="javascript: history.go()">
		</td>
		<td align="right">
		
		<cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL">
			<input type="submit" name="Unlink" style="width:300" value="Undo association for selected positions&nbsp;&nbsp;" class="button10s" onClick="javascript: return Process('unlink')">&nbsp;
		</cfif>
		
		</td>
		</table>
	</td>
	</tr>
	
<cfelse>

	<script>window.print()</script>	

</cfif>  

</table>

</cfform>
