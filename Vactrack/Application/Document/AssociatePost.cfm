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


<cf_screentop html="no" height="100%" 
      layout="webapp" banner="gray" line="no" jquery="Yes"
	  label="Associate - Position to recruitment request" band="No">

	  
<cfoutput>

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
	 itm.className = "highLight2 labelmedium2 line fixlengthlist";	 
	 }else{		
     itm.className = "regular labelmedium2 line fixlengthlist";		
	 }
  }
  
function EditPost(posno) {
     w = #CLIENT.width# - 60;
     h = #CLIENT.height# - 130;
     ptoken.open("#SESSION.root#/Staffing/Application/Position/Position/PositionView.cfm?ID=" + posno, posno);
}	 

</script>

</cfoutput>



<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Assign">

<cfquery name="get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *	
	FROM      Vacancy.dbo.Document
	WHERE     DocumentNo = '#url.id#'
</cfquery>

<cfquery name="CheckData" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    PA.DateEffective  AS AssignmentEffective, 
	          PA.DateExpiration AS AssignmentExpiration, 
			  PA.PositionNo, 
			  PA.AssignmentClass,
			  E.IndexNo, 
			  E.LastName, 
			  E.FirstName, 
	          PA.PersonNo		
	INTO      userQuery.dbo.#SESSION.acc#Assign		  
	FROM      Position Post 
	          INNER JOIN PersonAssignment PA ON Post.PositionNo = PA.PositionNo 
			  INNER JOIN Person E ON PA.PersonNo = E.PersonNo
	WHERE     Post.Mission      = '#URL.ID1#'
	AND       PA.DateExpiration >= getDate()
	AND       PA.DateEffective  <= getDate()
	AND       Incumbency > 0
	AND       AssignmentType = 'Actual'
	AND       AssignmentStatus IN ('0','1') 
</cfquery>

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Mandate
	WHERE     Mission = '#URL.ID1#'
	AND       MandateDefault = 1
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    TOP 1 *
		FROM      Ref_Mandate
		WHERE     Mission = '#URL.ID1#'
		ORDER BY  DateEffective DESC
	</cfquery>
	
	<cfset man = "M.MandateNo = '#Check.MandateNo#'">
	
<cfelse>	

    <cfset man = "M.MandateDefault = 1">

</cfif>



<!--- retrieve positions from current/default mandate --->

<cfquery name="Post" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT DISTINCT P.*, A.*,
	
	          (SELECT count(*) 
	           FROM   Vacancy.dbo.DocumentPost S
		 	   WHERE  DocumentNo = '#URL.ID#'
			   AND    PositionNo = P.PositionNo) as CurrentAssigned,
			   
			  (SELECT    VacantOwner 
			   FROM   Vacancy.dbo.DocumentPost S
			   WHERE  DocumentNo = '#URL.ID#'
			   AND    PositionNo = P.PositionNo) as VacantOwner,	   
			   
			  (SELECT    DateVacant 
			   FROM   Vacancy.dbo.DocumentPost S
			   WHERE  DocumentNo = '#URL.ID#'
			   AND    PositionNo = P.PositionNo) as DateVacant,
						  
			  (SELECT    DateVacantUntil 
			   FROM   Vacancy.dbo.DocumentPost S
			   WHERE  DocumentNo = '#URL.ID#'
 			   AND    PositionNo = P.PositionNo) as DateVacantUntil			
			 
	FROM      Employee.dbo.Position P INNER JOIN
              Organization.dbo.Ref_Mandate M ON P.Mission = M.Mission LEFT OUTER JOIN
              userQuery.dbo.#SESSION.acc#Assign A ON P.PositionNo = A.PositionNo	
	WHERE     P.Mission = '#URL.ID1#' 
	AND       #preserveSingleQuotes(man)#
	<!--- same occupational group : to be defined --->
	
	
	<!--- same posttype --->
	AND       P.PostType IN (SELECT PostType FROM Employee.dbo.Position WHERE PositionNo = '#get.PositionNo#')
	
	AND       P.DateExpiration >= getDate()      
	AND       P.PostGrade = '#URL.ID2#' 
	ORDER BY  CurrentAssigned DESC, P.SourcePostNumber 
	
</cfquery>


<cfif Post.recordcount eq "0">
	
	<!--- extract the mandate from the existing positionnumber --->
	
	<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    TOP 1 *
		FROM      Ref_Mandate
		WHERE     Mission = '#URL.ID1#'
		AND       MandateNo IN (SELECT MandateNo 
		                        FROM   Employee.dbo.Position 
								WHERE  PositionNo IN (SELECT Positionno FROM Vacancy.dbo.DocumentPost WHERE DocumentNo = '#URL.ID#'))	
	</cfquery>
		
	<cfif Check.recordcount gte "1">
	
		<cfset man = "P.MandateNo = '#Check.MandateNo#'">
				
		<cfquery name="Post" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT P.*, A.*,
					 (SELECT count(*) 
				          FROM   Vacancy.dbo.DocumentPost S
				 		  WHERE  DocumentNo = '#URL.ID#'
						  AND    PositionNo = P.PositionNo) as CurrentAssigned,	
						  
					  (SELECT    VacantOwner 
				          FROM   Vacancy.dbo.DocumentPost S
				 		  WHERE  DocumentNo = '#URL.ID#'
						  AND    PositionNo = P.PositionNo) as VacantOwner,	  
						  
					  (SELECT    DateVacant 
				          FROM   Vacancy.dbo.DocumentPost S
				 		  WHERE  DocumentNo = '#URL.ID#'
						  AND    PositionNo = P.PositionNo) as DateVacant,
						  
						  (SELECT    DateVacantUntil 
				          FROM   Vacancy.dbo.DocumentPost S
				 		  WHERE  DocumentNo = '#URL.ID#'
						  AND    PositionNo = P.PositionNo) as DateVacantUntil		  		  
						  
			FROM      Employee.dbo.Position P  LEFT OUTER JOIN
		              userQuery.dbo.#SESSION.acc#Assign A ON P.PositionNo = A.PositionNo		  				  
			WHERE     P.Mission = '#URL.ID1#' 
			AND       #preserveSingleQuotes(man)#			
			AND       P.PostGrade = '#URL.ID2#' 
			ORDER BY  CurrentAssigned DESC, P.SourcePostNumber  
		</cfquery>
	
	</cfif>

</cfif>

<cf_dialogStaffing>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Assign">

<cfform action="AssociatePostSubmit.cfm" style="height:95%" method="post" target="result">
	  
	<table width="95%" height="100%" align="center">
	
	  <tr class="hide"><td><iframe name="result" id="result"></iframe></td></tr>
	
	  <tr class="line"><td style="height:40px;font-size:25px;padding-left:4px" class="labelmedium">Organization: <b><cfoutput>&nbsp;#URL.ID1#</b> &nbsp;Grade level: <b>#URL.ID2#</cfoutput></b></td></tr>
	
	  <cfoutput>
	     <input type="hidden" name="DocumentNo" value="#URL.ID#">
	  </cfoutput>
	  
	  <tr><td style="height:95%">
	  
	  <cf_divscroll>
	
	  <table width="100%" class="navigation_table">
	
		  <TR class="labelmedium line fixrow fixlengthlist">
		    <td></td>
			<TD><cf_tl id="Post number"></TD>
		    <TD><cf_tl id="Function"></TD>
		    <TD><cf_tl id="Grade"></TD>
			<TD><cf_tl id="Expiration"></TD>
			<TD><cf_tl id="Vacant for Owner"></TD>
			<TD><cf_tl id="Vacant for Recruitment"></TD>
			<TD colspan="4"><cf_tl id="Current incumbent"></TD>			
		  </TR>
		
		  <cfoutput query="Post"> 	 
		 	
			  <cfif CurrentAssigned eq "0">
			     <tr class="regular labelmedium2 line fixlengthlist navigation_row">
			  <cfelse>
			     <tr class="highLight2 labelmedium2 line fixlengthlist">
			  </cfif>   	  
		  
			  <TD style="padding-left:4px;padding-right:4px"> 
			  <cfif CurrentAssigned eq "0">
			    <input type="checkbox" name="Selected" class="radiol" value="#PositionNo#" onClick="hl(this,this.checked)">
			  <cfelse>
			    <input type="checkbox" name="Selected" class="radiol" value="#PositionNo#" checked onClick="hl(this,this.checked)">
			  </cfif>
			  </TD>
			    <TD><a href="javascript:EditPost('#PositionNo#')"><cfif SourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionParentId#</cfif></a></TD>
				<TD>#FunctionDescription#</TD>
				<TD>#PostGrade#</TD>
			    <TD>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</TD>
								
				<TD align="center" style="border-left:1px solid gray;background-color:f1f1f1">
								  								    				  
				    <cfif currentAssigned NEQ "0">
				
						<table style="width:100%">
						<tr class="labelmedium2">
						
						<cfif VacantOwner neq "">
						
						    <td align="right" style="padding-left:4px;padding:2px">
						
								<cf_intelliCalendarDate9
										FieldName="VacantOwner_#positionno#" 
										class="regularxl"					
										Default="#Dateformat(VacantOwner, CLIENT.DateFormatShow)#">	
									
							</td>
						
						<cfelse>	
						
						       <cfinvoke component = "Service.Process.Employee.PositionAction"  
							      method            = "PositionVacant" 
							      positionparentid  = "#PositionParentId#"
							      returnvariable    = "vacant">						
							  						
								<td align="right" style="padding-left:4px;padding:2px">
							 			
									<cf_intelliCalendarDate9
										FieldName="VacantOwner_#positionno#" 
										class="regularxl"					
										Default="#Dateformat(vacant.original, CLIENT.DateFormatShow)#">						
									
								</td>
						
						</cfif>		
						
						</tr>
						</table>					
					
					<cfelse>
										
					  <cfinvoke component = "Service.Process.Employee.PositionAction"  
						      method            = "PositionVacant" 
						      positionparentid  = "#PositionParentId#"
						      returnvariable    = "vacant">
							  
						 <cfif vacant.original neq "">  
							  
						 <table>
							<tr class="labelmedium2">							
							<td>#Dateformat(vacant.original, CLIENT.DateFormatShow)#</td>
							<input type="hidden" name="VacantOwner_#positionno#" value="#Dateformat(vacant.original, CLIENT.DateFormatShow)#">
							</tr>
						</table>
						
						<cfelse>
						
						<input type="hidden" name="VacantOwner_#positionno#" value="">
						
						</cfif>
						
					</cfif>	
														
				</td>
				
				<td align="center">
				
				#Dateformat(DateVacant, CLIENT.DateFormatShow)#				
				<cfif DateVacantUntil neq "">
				- #Dateformat(DateVacantUntil, CLIENT.DateFormatShow)#
				</cfif>		
				
				
				</td>
				
				<cfif IndexNo neq "">
					<TD style="border-left:1px solid silver;background-color:##ffffaf80"><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></TD>
					<TD style="background-color:##ffffaf80">#FirstName# #LastName#</TD>
					<TD style="background-color:##ffffaf80">#AssignmentClass#</TD>
					<TD style="background-color:##ffffaf80">#Dateformat(AssignmentExpiration, CLIENT.DateFormatShow)#</TD>
				<cfelse> 
				    <TD align="center" colspan="4" style="border-left:1px solid gray;background-color:f1f1f1"><cf_tl id="Vacant"></TD>		
				</cfif>
				
		</TR>
	
		</CFOUTPUT>
	
	</TABLE>
	
	</cf_divscroll>
	
	</td>
	</tr>
	
	<tr><td height="42" colspan="8" align="center">
		
		<input class="button10g" style="width:160;height:33" type="submit" name="Update" value="Associate">
	
	</td></tr>
	
	</table>

</cfform>

<cf_screenbottom layout="webapp">

<cfset ajaxonload("doHighlight")>


	