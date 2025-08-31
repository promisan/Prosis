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
<cfajaximport tags="cfform">

<cf_calendarScript>

<cfparam name="url.title" default="">
<cfparam name="url.mode"  default="">
<cfparam name="url.docno" default="">
<cfparam name="url.owner" default="">

<cfif url.title neq "">
	<cf_screentop jquery="Yes" graphic="No" html="Yes" menuaccess="Context" label="Roster Search Criteria" height="100%" scroll="Yes" line="no" banner="gray" bannerforce="Yes" layout="webapp"
	systemModule="Roster" functionClass="Window" FunctionName="Roster Search">
<cfelse>
	<cf_screentop jquery="Yes" graphic="No" html="No" label="Roster Search Criteria" height="100%" scroll="Yes" systemModule="Roster" functionClass="Window" FunctionName="Roster Search">
</cfif>

<cfquery name="Owner" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * 
			 FROM  Ref_AuthorizationRoleOwner
			 WHERE Code = '#url.Owner#'			
	</cfquery>

<cfif url.mode eq "new" or url.mode eq "reset">

	<!--- create a new instance of the search --->

	<cflock timeout="5" throwontimeout="Yes" name="SerialNo" type="EXCLUSIVE">	
				 
	<cfquery name="AssignNo" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE Parameter 
			 SET    SearchNo = SearchNo+1
	</cfquery>
		
	<cfquery name="LastNo" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT *
		     FROM Parameter
	</cfquery>
			 
	<cfset LastNo = LastNo.SearchNo>
		        
	<cfquery name="InsertSearch" 
		    datasource="AppsSelection" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		     INSERT INTO RosterSearch
					 (SearchId, 
					  Owner, 
					  RosterStatus, 
					  SearchCategory, 
					  SearchCategoryId, 
					  Status, 
					  Description, 
					  Mode, 
					  Access, 
					  OfficerUserId, 
					  OfficerLastName, 
	                  OfficerFirstName)
			 SELECT	  '#lastNo#', 
					  Owner, 
					  RosterStatus, 
					  SearchCategory, 
					  SearchCategoryId, 
					  Status, 
					  Description, 
					  Mode, 
					  Access, 
					  '#SESSION.acc#', 
					  '#SESSION.last#', 
		              '#SESSION.first#'
			  FROM    RosterSearch
			  WHERE   SearchId = '#URL.ID#'			       
	</cfquery>
	
	<cfquery name="InsertSearch" 
		    datasource="AppsSelection" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		     INSERT INTO RosterSearchLine
						 (SearchId, 
						  SearchClass, 
						  SelectId, 
						  SelectParameter, 
						  SelectDescription,
						  SelectDateEffective,
						  SelectDateExpiration, 
						  SearchStage)
				 SELECT	  '#lastNo#', 
						  SearchClass, 
						  SelectId, 
						  SelectParameter, 
						  SelectDescription, 
						  SelectDateEffective,
						  SelectDateExpiration, 
						  SearchStage
				  FROM    RosterSearchLine
				  WHERE   SearchId = '#URL.ID#'			       
					<cfif url.mode eq "reset">				  
						AND SearchClass = 'Function'
					</cfif>
					
			</cfquery>
	
	</cflock>
	
	<cfset url.id = lastNo>

</cfif>

<style>
 
 TD {
	font-family: Verdana; padding : 0px; }		  
</style>	
 
<cfinclude template="../../Maintenance/Parameter/ParameterInsert.cfm">

<cf_tl id="Cleared" var="1">
<cfset tCleared=#lt_text#>
<cf_tl id="Denied" var="1"> 
<cfset tDenied=#lt_text#>
<cf_tl id="Pending" var="1">
<cfset tPending=#lt_text#>

<cfquery name="Search" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   RosterSearch
	WHERE  SearchId = '#URL.ID#'
</cfquery>  	   

<cfoutput>

<script language="JavaScript">
	   
	function chk(review,box) {
		  
		document.getElementById(review+"_1").className = "labelit"
		document.getElementById(review+"_2").className = "labelit"
		document.getElementById(review+"_3").className = "labelit"
								
		se = document.getElementById(review+"_"+box)
		if (se.className == "highlight1 labelit") {  
		   se.className = "labelit" 
	    } else {
	          se.className = "highlight1 labelit" 
		}	
	
	}
		
 ie = document.all?1:0
 ns4 = document.layers?1:0

 function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TD")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TD")
          {itm=itm.parentNode;}
     }
	 		 	 		 	
	 if (fld != false){		
	 itm.className = "highLight3";
	 } else {		
     itm.className = "regular";		
	 }
  }
  
  function st(status,row,val) {				
		if (val == true) {		       	
				$('##status_'+row).addClass("highlight1");			
				$('##dstatusdate_'+status).show();						
				$('##eff_'+status).addClass('dateeffective');					
				$('##exp_'+status).addClass('dateexpiration');								
			} else {			    
				$('##status_'+row).removeClass("highlight1");			
				$('##status_'+row).addClass("regular");			
				$('##dstatusdate_'+status).hide();				
				$('##eff_'+status).removeClass('dateeffective');					
				$('##exp_'+status).removeClass('dateexpiration');								
				$('##eff_'+status).val('');					
				$('##exp_'+status).val('');				
			}			
	
	}
	
	function isNull(t) {
	 if (t == '')
	 	return 'null'
	 else
	 	return t.replace(',','');
	}	
	
	// define the relationship between date A and B bind to the cf_ajax 8

	function validate(control) {

		var vDateRaw = document.getElementById(control);
		vDateRaw.value = vDateRaw.value.replace(/ /g,"");
		
		if (validateDate(vDateRaw,'yes',1)) {

			if (control.indexOf("eff") != -1) {
					eff_value = vDateRaw.value;
					effective = control;
					expiration = control.replace('eff','exp');
					exp_value =  $('##'+expiration).val().replace(/ /g,"");
					
		
				} else {
					exp_value = vDateRaw.value;
					effective = control.replace('exp','eff');
					expiration = control;
					eff_value =  $('##'+effective).val().replace(/ /g,"");

				}		
			

			if (eff_value != '' && exp_value != '') {

					<cfif APPLICATION.DateFormat is "EU">
						dt1 =  new Date (eff_value.substring(6,10),
		                            eff_value.substring(3,5)-1,
		                            eff_value.substring(0,2));
		
						dt2 =  new Date (exp_value.substring(6,10),
		                            exp_value.substring(3,5)-1,
		                            exp_value.substring(0,2));
		
									
					<cfelse>
						dt1 =  new Date (eff_value.substring(6,10),
		                            eff_value.substring(0,2)-1,
		                            eff_value.substring(3,5));
		
						dt2 =  new Date (exp_value.substring(6,10),
		                            exp_value.substring(0,2)-1,
		                            exp_value.substring(3,5));								
					</cfif>	
						
						
					
					if (dt1 > dt2 ) {
						alert('effective date is greater than expiration date');
						$('##'+effective).val($('##'+expiration).val());
						return false;
					} else {
						return true;
					}
			}
			else
				return true;				
				
		}
	}		
	
	function functionbuilder(id,id1) {   
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
		ptoken.open("#SESSION.root#/Roster/Maintenance/FunctionalTitles/FunctionGrade.cfm?mode=embed&idmenu=#url.idmenu#&ID="+id+"&ID1=" + id1, "_blank", "left=30, top=30, width= " + w + ", height=" + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
	}
		
	function setReqLineOperational(id, line, ctrl) {
	var vOp = 0;
	if (!!ctrl.checked) {
		vOp = 1;
	}
	_cf_loadingtexthtml='';	
	ptoken.navigate('#SESSION.root#/Roster/Maintenance/FunctionalTitles/FunctionBuilder/setRequirementLineOperational.cfm?reqId='+id+'&line='+line+'&value='+vOp,'op_'+id+'_'+line);
	}
	
	function reload() {
	     ptoken.location("#SESSION.root#/Roster/RosterGeneric/RosterSearch/Search4.cfm?title=#url.title#&mode=reset&docno=#url.docno#&id=#URL.ID#")	
	}	
  
</script>
</cfoutput>

<cf_dialogCombo> 

<div name="processing" id="processing" class="hide"></div>
     
<cfform target="_self"
 action="Search4Submit.cfm?docno=#url.docno#&ID=#URL.ID#&Owner=#Search.Owner#&mode=#url.mode#&status=#search.status#"
    method="POST" name="searchform" id="searchform" style="height:98.5%">

<table style="height:100%" width="100%">

 <tr>
	    <td height="40" style="padding-left:15px;padding-right:15px">	
	
		<table width="100%" align="center">
		<tr><td class="labellarge" style="font-size:25px;font-weight:300">
		  <cfoutput>#Owner.Description#: <font size="4" color="808080"><cf_tl id="Select one or more criteria to filter on Candidates"></cfoutput>		
		</td>
		<td align="right" height="25">
			<input type="button" class="button10g" value="Reset" style="height:23;width:90px" onclick="javascript:Prosis.busy('yes');reload()">		
		</td>
		</table>
		</td>
	 </tr> 

<tr><td width="100%" height="100%" valign="top">

	<cf_divscroll style="height:100%">
	
	<table width="96%"
	       height="99%"	     
		   class="formpadding"
	       align="center">  
		
	 <input type="hidden" name="date_effective" id="date_effective">
	 <input type="hidden" name="date_expiration" id="date_expiration">	
	 
	   
	<tr><td valign="top" height="100%">
	  
	<cfquery name="Parameter" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterOwner
		WHERE Owner = '#Search.Owner#'
	</cfquery>  
	
	<cfquery name="Check" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'FUNCTION'
	</cfquery>  
	
	<cfquery name="Nationality" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT S.*, L.SelectId 
	    FROM  System.dbo.Ref_Nation S LEFT OUTER JOIN RosterSearchLine L ON S.Code = L.SelectId
		 AND  L.SearchId    = '#URL.ID#'	
		 AND  L.SearchClass = 'Nationality'
		WHERE S.Name > '(Z'
		<cfif Check.recordcount gte "1">
		AND   S.Code IN (SELECT DISTINCT Nationality 
		                 FROM   Applicant L, 
							    ApplicantSubmission SU, 
							    ApplicantFunction F, 
							    RosterSearchLine R
						 WHERE  F.FunctionId  = R.SelectId
						 AND    R.SearchId    = '#URL.ID#'
						 AND    R.SearchClass = 'FUNCTION'
						 AND    L.PersonNo    = SU.PersonNo
						 AND    L.Nationality = S.Code
						 AND    SU.ApplicantNo = F.ApplicantNo)
		</cfif>
		ORDER BY L.SelectId DESC, S.Name 
	</cfquery>
	
	<cfquery name="Keyword" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   DISTINCT L.SelectDescription as SelectId 
	    FROM     RosterSearchLine L
		WHERE    L.SearchId    = '#URL.ID#'
		AND      L.SearchClass = 'Background'
		ORDER BY L.SelectDescription DESC
	</cfquery>
	
	<cfquery name="Experience" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  S.*, L.SelectId 
	    FROM    Ref_Experience S LEFT OUTER JOIN RosterSearchLine L ON S.ExperienceFieldId = L.SelectId
		AND     L.SearchId           = '#URL.ID#'	
		AND     L.SearchClass        = 'Profession'
		WHERE   S.ExperienceClass IN (SELECT ExperienceClass 
		                              FROM   Ref_ExperienceClass 
					   				  WHERE  Parent = 'Degree')
		ORDER BY L.SelectId DESC, 
		         S.Description
	</cfquery>
	
	<table width="100%" border="0" class="formpadding">
	
	<tr><td>
	
	<table width="100%" align="center">	
	<TR class="line" style="height:30px">  
	   <td colspan="1" class="labellarge" style="height:20px;font-weight:360"><cf_tl id="Bucket assessment"></b><font color="FF0000">*)</font></td>
	   <td colspan="1" class="labellarge" style="height:20px;font-weight:360"><cf_tl id="Profile"></td>   
	</TR>
	
	<tr>
	
	<td width="60%" valign="top">
	
	    <!--- can have manu records --->
		   
	    <cfquery name="AllSteps" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT   *
			FROM     Ref_StatusCode
			WHERE    ID    = 'FUN'
			AND      Owner = '#Search.Owner#' 
			AND      ShowRosterSearch = '1' <!--- only if enabled --->		
	   </cfquery>   
		
	   <table width="100%" border="0" cellspacing="0" cellpadding="0">
	      	   
	   <cfoutput query="AllSteps">
	   
	      <cfinvoke component="Service.Access.Roster"  
		   	 method         = "RosterStep" 	 
			 SearchId       = "#URL.ID#" 	<!--- determines the functionid to be taken into consideration ---> 
		     Status         = "#Status#"
			 Process        = "Search"						
		   	 Owner          = "#Search.Owner#"		
			 returnvariable = "Access">	
	      	  				
		   <!--- added a provision that if nothing it selected it will preselect the default actions --->
							  
		   <cfif access eq "1" or (search.SearchCategory eq "Vacancy" and ShowRosterSearchDefault eq "1")>
		   	   	 
			   <tr style="height:23px">
			   
			    <!--- check if this was selected --->
							   
				<cfquery name="Check" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
			        SELECT *
					FROM   RosterSearchLine
					WHERE  SearchId    = '#URL.ID#'
			   		  AND  SearchClass = 'Assessment'
					  AND  SelectId    = '#Status#'
				</cfquery>			
		        
				<td width="60%" align="left" class="<cfif check.SelectId eq #status#>highlight1<cfelse>regular</cfif>" id="status_#currentrow#" name="status_#currentrow#">	
				
				   <table width="100%" cellspacing="0" cellpadding="0">
				   <tr class="labelmedium2">
				      
				   	   <td style="width:20px;padding-left:9px">		
					   
			           <input type    =  "checkbox"  
					       onclick    = "st('#Status#','#currentRow#',this.checked)" 
						   name       = "chk_#Status#" 
		   				   id         = "chk_#Status#" 
						   style      = "height:15px;width:15px"
						   value      = "'#Status#'" 
						   <cfif check.SelectId eq status> checked </cfif>>	
						   
					   </td>
	
					   <td width="37%" style="font-size:14px;height:20px;padding-left:8px">#Meaning#</td>
					  
					   <td align="right">
					   
						   <cfif check.SelectId eq status>
						   		<cfset vClass = "regular">
							<cfelse>
								<cfset vClass = "hide">
						   </cfif>
						   
						   <div name="dstatusdate_#Status#"  id="dstatusdate_#Status#" class="#vClass#">
						   
							   <cfif EnableStatusDate eq "1">
							   
							   		<table width="100%">
									<tr>
										<td align="right" style="z-index:#101-currentrow#; position:relative">
										
									   		<cf_intelliCalendarDate9
												FieldName="eff_#Status#" 
												Default="#DateFormat(Check.SelectDateEffective,CLIENT.DateFormatShow)#"											
												AllowBlank="True"
												class="regularh"
												style="width:90px"
												ValidationScript="Yes">	
												
											<cfajaxproxy bind="javascript:validate('eff_#Status#',{eff_#Status#})"> 	
											
											<cf_space spaces="29">										
											
										</td>
										<td width="3%" style="padding-left:3px;padding-right:3px">-</td>
										<td align="left" style="z-index:#100-currentrow#; position:relative">
										   
										   <cf_intelliCalendarDate9
												FieldName="exp_#Status#" 
												Default="#DateFormat(Check.SelectDateExpiration,CLIENT.DateFormatShow)#"											
												AllowBlank="True"
												class="regularh"
												ValidationScript="Yes">	
	
											<cfajaxproxy bind="javascript:validate('exp_#Status#',{exp_#Status#})"> 
											
											<cf_space spaces="29">		
																																
										</td>	
									</tr>
									</table>
									
							  <cfelse>
							  
								   <input type="hidden"	id="eff_#Status#" name="eff_#Status#" value="">
								   <input type="hidden"	id="exp_#Status#" name="exp_#Status#" value="">
								   
							   </cfif>	
							   
						   </div>				   
					  
					   </td>
					   
					</tr>
				    </table>  
				</td>	
				
				</tr>
					
								       
			</cfif>  
	   
	   </cfoutput>
	      
	   </table>
	   	
	</TD>
	
	<TD valign="top" width="40%" style="padding-left:4px;">
		
	   <cfquery name="Check" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT L.SelectId, R.Code, R.Description
			FROM   RosterSearchLine L RIGHT OUTER JOIN Ref_ReviewClass R ON R.Code = SelectId
			  AND  L.SearchId = '#URL.ID#'
	   		  AND  L.SearchClass = 'ReviewClass'
			 WHERE R.Operational = 1		
		</cfquery>
		
		<table border="0">
				
		<cfoutput query="check">
		
			<cfquery name="Reference" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        SELECT SelectId,
				       SelectParameter
				FROM   RosterSearchLine 
				WHERE  SearchId    = '#URL.ID#'
		   		  AND  SearchClass = 'ReviewClass'
				  AND  SelectId    = '#Code#'
			</cfquery>
			
			
			<tr class="linedotted labelmedium2 fixlengthlist">
			
				<td style="padding-right:13px;height:20px;">#Description#:</td>
			
				<td id="Rev_#code#_1" style="padding-left:8px;padding-right:5px" class = "<cfif #Reference.SelectId# eq "">highlight1</cfif> labelit">
				   <table><tr><td>
			         <input type="radio" 
			           name="Rev_#Code#" style="height:15px;width:15px"
					   onclick = "chk('Rev_#Code#','1')"
					   value="" <cfif Reference.SelectId eq "">checked</cfif>>
					</td>
					<td style="padding-left:6px" class="labelit">N/A</td>
					</table>
				</td>
				<td id="Rev_#code#_2" style="padding-left:8px;padding-right:5px" class = "<cfif #Reference.SelectId# eq '#code#' and #Reference.SelectParameter# eq "1">highlight1</cfif> labelit">		
				    <table><tr><td>
					<input type="radio" 
			           name="Rev_#Code#" style="height:15px;width:15px"
					   onclick = "chk('Rev_#Code#','2')"
					   value="1" <cfif Reference.SelectId eq code and Reference.SelectParameter eq "1">checked</cfif>>
					 </td>
					<td style="padding-left:6px" class="labelit">#tCleared#</td>
					</table>  
					
				</td>
				<td id="Rev_#code#_3" style="padding-left:8px;padding-right:5px" class="<cfif #Reference.SelectId# eq '#code#' and #Reference.SelectParameter# eq "0">highlight1</cfif> labelit">
					<table><tr><td>
					<input type="radio" 
			           name="Rev_#Code#" style="height:15px;width:15px"
					   onclick = "chk('Rev_#Code#','3')"
					   value="0" <cfif Reference.SelectId eq code and Reference.SelectParameter eq "0">checked</cfif>>
					 </td>
					<td style="padding-left:6px" class="labelit">#tDenied#</td>
					</table>  
					
				</td>
			</tr>
			
			</cfoutput>
			
			<!--- interview --->
			
			<cfquery name="Reference" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        SELECT SelectId,SelectParameter
				FROM   RosterSearchLine 
				WHERE  SearchId    = '#URL.ID#'
		   		  AND  SearchClass = 'Interview'
				  AND  SelectId    = 'Int_Initial'
			</cfquery>
					
			<cfoutput>
					
				<tr class="linedotted labelmedium2 fixlengthlist">
				<td style="padding-right:13px;height:20px;" class="labelit"><cf_tl id="Interview">:</td>
				
					<td id="Int_Initial_1" style="padding-left:8px;padding-right:5px" class = "<cfif #Reference.SelectId# eq "">highlight1</cfif> labelit">
					      <table><tr><td>
				         <input type="radio" 
				           name="Int_Initial" style="height:15px;width:15px"
						   onclick = "chk('Int_Initial','1')"
						   value="" <cfif Reference.SelectId eq "">checked</cfif>>
						</td>
						<td style="padding-left:6px" class="labelit">N/A</td>
						</table>
					</td>
					<td id="Int_Initial_2"  style="padding-left:8px;padding-right:5px" class = "<cfif #Reference.SelectId# eq 'Int_Initial' and #Reference.SelectParameter# eq "1">highlight1</cfif> labelit">		
					    <table><tr><td>
						<input type="radio" 
				           name="Int_Initial" style="height:15px;width:15px"
						   onclick = "chk('Int_Initial','2')"
						   value="1" <cfif Reference.SelectId eq "Int_Initial" and Reference.SelectParameter eq "1">checked</cfif>>
						 </td>
						<td style="padding-left:6px" class="labelit">#tCleared#</td>
						</table>  
					</td>
					<td id="Int_Initial_3"  style="padding-left:8px;padding-right:5px" class="<cfif #Reference.SelectId# eq 'Int_Initial' and #Reference.SelectParameter# eq "0">highlight1</cfif> labelit">
					    <table><tr><td>
						<input type="radio" 
				           name="Int_Initial" style="height:15px;width:15px"
						   onclick = "chk('Int_Initial','3')"
						   value="0" <cfif Reference.SelectId eq "Int_Initial" and #Reference.SelectParameter# eq "0">checked</cfif>>
						 </td>
						<td style="padding-left:6px" class="labelit">#tDenied#</td>
						</table>  
					</td>
				</tr>
				
			</cfoutput>
		
		</table>
		
	</td>
	
	
	</tr>
	
	</table>
	
	<table width="100%" align="center">
		
	<tr><td height="4"></td></tr>
	<tr class="line fixlengthlist">
	   <td style="height:20px"><cf_tl id="Application Received">:</td>
	   <td colspan="1" style="height:20px"><cf_tl id="Limit result to VA"></td> 
	   <td colspan="1" style="height:20px"><cf_tl id="Specific Candidate"></td> 
	</tr>
	
	<TR>  
	   <td>
	   
	    <table>
		<tr>
		<td style="padding-left:20px">
		
		<cfquery name="Check" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT SelectId
			FROM   RosterSearchLine
			WHERE  SearchId = '#URL.ID#'
	   		  AND  SearchClass = 'ApplicationFrom'
		</cfquery>
		
		<cf_intelliCalendarDate9
			FieldName="eff_Application" 
			Default="#check.selectid#"
			AllowBlank="True"
			class="regularxl"
			ValidationScript="Yes">	
			
		<cfajaxproxy bind="javascript:validate('eff_Application',{eff_Application})"> 													
		
		</td>
		<td>	
		-
		</td>
		<td>	
		
		<cfquery name="Check" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT SelectId
			FROM RosterSearchLine
			WHERE SearchId = '#URL.ID#'
	   		  AND SearchClass = 'ApplicationUntil'
		</cfquery>
		
		<cf_intelliCalendarDate9
			FieldName="exp_Application" 
			Default="#check.selectid#"
			AllowBlank="True"
			class="regularxl"
			ValidationScript="Yes">		
			
		<cfajaxproxy bind="javascript:validate('exp_Application',{exp_Application})"> 		
													
		</td>
		</table>	
	   </td>
	       
	   <td>
		
		<table class="formpadding">
		
			<tr><td>
			
			<cfif parameter.EnableVARosterFilter eq "0">
			
				<font color="C0C0C0">Disabled</font>
				<input type="hidden" name="ReferenceNo" value="">
			
			<cfelse>
			
				<cfquery name="VA" 
				    datasource="AppsSelection" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    SELECT    FO.FunctionId, FO.ReferenceNo
			        FROM      RosterSearchLine S INNER JOIN
			                  FunctionOrganization FO ON S.SelectId = FO.FunctionId
			        WHERE     S.SearchClass = 'Function' 
					AND       FO.ReferenceNo IS NOT NULL
					AND       S.SearchId = '#URL.ID#'
				</cfquery>				
				
				<cfquery name="Check" 
				    datasource="AppsSelection" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				       SELECT SelectId
					   FROM   RosterSearchLine
					   WHERE  SearchId = '#URL.ID#'
				   	    AND   SearchClass = 'VA'
				</cfquery>
								
				<select name="ReferenceNo" style="width:120px" class="regularxl">
				  <option value="" selected>N/A</option>
				  <cfoutput query="VA">
				  <cfif ReferenceNo neq "Direct">
					  <option  value="#FunctionId#" <cfif check.selectid eq FunctionId>selected</cfif>>#ReferenceNo#</option>
				  </cfif>
				  </cfoutput>			
				</select>
			
			</cfif>
				
			</td></tr>
			
			</tr>
				
		</table>	
		
	  </td>
	  
	  <td height="20">
			
			  <cfquery name="Check" 
			    datasource="AppsSelection" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			       SELECT SelectId
				   FROM   RosterSearchLine
				   WHERE  SearchId    = '#URL.ID#'
			   	    AND   SearchClass = 'Name'
			  </cfquery>
			  		
			  <input type="text"
			      style="width:120px" name="name" id="name" value="<cfoutput>#check.SelectId#</cfoutput>" size="17" maxlength="20" class="regularxl">
			  
			  </td>
	   
	   
	   <!--- 24/12/2011 not needed anymore
	
	   <td height="24"><font color="808080"><cf_tl id="Bucket Assessment">:</td>  
	   
	   <td>
	    <table border="0" cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td>
		
		<cfquery name="Check" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT SelectId
			FROM RosterSearchLine
			WHERE SearchId = '#URL.ID#'
	   		  AND SearchClass = 'AssessmentFrom'
		</cfquery>
		
		<cf_intelliCalendarDate9
			FieldName="eff_Assessment" 
			Default="#check.selectid#"
			AllowBlank="True"
			ValidationScript="Yes">	
	
		<cfajaxproxy bind="javascript:validate('eff_Assessment',{eff_Assessment})"> 															
		</td>
		<td>	
		-
		</td>
		<td>	
		
		<cfquery name="Check" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT SelectId
			FROM RosterSearchLine
			WHERE SearchId = '#URL.ID#'
	   		  AND SearchClass = 'AssessmentUntil'
		</cfquery>
		
		<cf_intelliCalendarDate9
			FieldName="exp_Assessment" 
			Default="#check.selectid#"
			AllowBlank="True"
			ValidationScript="Yes">		
	
		<cfajaxproxy bind="javascript:validate('exp_Assessment',{exp_Assessment})"> 																	
			
		</td>
		</table>	
	    </td>
		
		--->
	</TR>
	
	<tr><td style="height:4px"></td></tr>	
	<tr class="line"><td colspan="3" height="2"></td></tr>
	
	</table>
	
	<table width="100%" align="center">
	
		<!--- Field: Staff.OnBoard=CHAR;20;TRUE --->
	
	<cfquery name="Check" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT SelectId
			FROM RosterSearchLine
			WHERE SearchId = '#URL.ID#'
	   		  AND SearchClass = 'CandidateClass'
	</cfquery>
	
	<cfif Check.recordCount eq 0>
	      <cfset SelectId = "All">
	  <cfelse>	
	      <cfset SelectId = "#Check.SelectId#">  
	  </cfif>
		
	<TR><TD height="30">
	
		<table cellspacing="0" cellpadding="0">
	
		<tr class="fixlengthlist labelmedium"><td style="padding-left:10px;height:20px;font-weight:bold"><cf_tl id="Class">:</td>
		
		<cfquery name="Class" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM Ref_ApplicantClass
		</cfquery>
		
		<td>
			
			<select name="ApplicantClass" class="regularxl">
			<option value="All" <cfif SelectId eq "All">selected</cfif>><cf_tl id="Any">
			<cfoutput query="Class">
				<option value="#ApplicantClassId#" <cfif SelectId eq ApplicantClassId>selected</cfif>>#Description#</option>
			</cfoutput>
			</select>
			
		</td>
			
		</tr>
		
		</table>
		
	</TD>	
	
	<td>
	      
		  <cfquery name="Check" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        SELECT SelectId
				FROM   RosterSearchLine
				WHERE  SearchId = '#URL.ID#'
		   		  AND  SearchClass = 'Gender'
		  </cfquery>
		  
		  <cfif Check.recordCount eq 0>
		      <cfset SelectId = "B">
		  <cfelse>	
		      <cfset SelectId = Check.SelectId>  
		  </cfif>
		  
		  <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		   <tr class="fixlengthlist labelmedium">
		   	<td>
			   <table>
				   <tr class="labelmedium">
				   <td>		
				   <td><cf_tl id="Gender"></td>			      
				   <td style="padding-left:5px">
				   <input type="radio" style="height:17px;width:17px" name="Gender" value="M" <cfif SelectId eq "M">checked</cfif>>
				   </td>
				   <td style="padding-left:3px">
				      <cf_tl id="Male">
				   </td>	  
				   <td style="padding-left:9px">
				   <input type="radio" style="height:17px;width:17px" name="Gender" value="F" <cfif SelectId eq "F">checked</cfif>>
				   </td>
				   <td style="padding-left:3px">
				   <cf_tl id="Female">
				   </td>
				   <td style="padding-left:9px">
				   <input type="radio" style="height:17px;width:17px" name="Gender" value="B" <cfif SelectId eq "B">checked</cfif>>
				   </td>
				   <td style="padding-left:3px">
				   <cf_tl id="Both">
				   </td>
				   </tr>
			   </table>				   
		   </td>
		   </tr>
		  </table>			
	  
	</td>
	<td>
	  <table cellspacing="0" cellpadding="0">
	
	  <tr class="fixlengthlist labelmedium"><td style="height:40px;font-weight:bold"><cf_tl id="Age">:</td>
	  
	  <cfquery name="AgeFrom" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT SelectId
			FROM RosterSearchLine
			WHERE SearchId = '#URL.ID#'
	   		  AND SearchClass = 'AgeFrom'
	  </cfquery>
	  
	  <cfif AgeFrom.recordCount eq 0>
	      <cfset SelectId = "0">
	  <cfelse>	
	      <cfset SelectId = AgeFrom.SelectId>  
	  </cfif>
	  
	  <td class="label" style="padding-left:4px;padding-right:4px"></td>
	  
	  <td style="padding-right:4px">
	  <cfinput type="Text" name="AgeFrom" value="#SelectId#" range="0,125" message="Select a correct age" validate="range" required="Yes" visible="Yes" enabled="Yes" size="1" style="text-align: center;" class="regularxl">
	  </td>
	  
	  <cfquery name="AgeTo" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT SelectId
			FROM RosterSearchLine
			WHERE SearchId = '#URL.ID#'
	   		  AND SearchClass = 'AgeUntil'
	  </cfquery>
	  
	  
	  <cfif AgeTo.recordCount eq 0>
	      <cfif AgeTo.recordcount eq "0">
		      <cfset SelectId = "0">
		  <cfelse>
		      <cfset SelectId = "130">
		  </cfif>	  
	  <cfelse>	
	      <cfset SelectId = AgeTo.SelectId>  
	  </cfif>
	  
	  <td class="labelit" style="padding-right:4px">to</td>  
	  <td style="padding-right:4px">
	  <cfinput type="Text" name="AgeUntil" value="#SelectId#" range="0,125" validate="range" message="Select a correct age" required="Yes" visible="Yes" enabled="Yes" size="1" style="text-align: center;" class="regularxl">
	  </td>
	  <td>Yr</td>
	  
	  </table>
	  
	  </td>
	  
	  <cfquery name="Check" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT SelectId
			FROM RosterSearchLine
			WHERE SearchId = '#URL.ID#'
	   		  AND SearchClass = 'WorkExperience'
	  </cfquery>
	  
	  <cfif Check.recordCount eq 0>
	      <cfset SelectId = "">
	  <cfelse>	
	      <cfset SelectId = Check.SelectId>  
	  </cfif>
	  
	  <td class="labelmedium fixlength" style="height:20px;font-weight:bold" colspan="2">	  
	  <cf_tl id="Minimum Experience">:	 
       <cfinput type="Text" name="WorkYears" value="#SelectId#" range="1,40" message="Select a correct no of years 0 - 40 " validate="range" required="No" visible="Yes" style="width:30;text-align: center;" class="regularxl"> Years 
	  </td>
	
	</TR>	
		
	</table>
	
	</td></tr>
	
	<!--- First layer --->
	
		<cfquery name="Check" 
		  datasource="AppsSelection" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT    *
		  FROM      Ref_ParameterOwner
		  WHERE     Owner = '#Search.Owner#'
		</cfquery>  
	
	<tr><td>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
	<cfif Check.RosterSearchMinimum eq "0">
	
		<!--- ------------------------------------------------- --->
		<!--- allow the selection of keywords for the search -- --->
		<!--- ------------------------------------------------- --->
				
		 <cfquery name="Check" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        SELECT SelectId
				FROM RosterSearchLine
				WHERE SearchId = '#URL.ID#'
		   		  AND SearchClass = 'OwnerKeyword'
		    </cfquery>
			
		<TR>  
		   <td colspan="6" class="labellarge">
		   <table>
		   <cfoutput>
		   <tr class="labellarge">
			   <td style="height:30px" class="labellarge"><cf_tl id="Background Characteristics"><font size="2">&nbsp;(<cf_tl id="Structured keywords cleared by"></td>
			   <td style="padding-left:4px"><input type="radio" name="OwnerKeyword" value="0" <cfif Check.SelectId neq "1">checked</cfif>></td>
			   <td style="padding-left:4px" class="labelmedium">Any</td>
			   <td style="padding-left:4px"><input type="radio" name="OwnerKeyword" value="1" <cfif Check.SelectId eq "1">checked</cfif>></td>
			   <td style="padding-left:4px" class="labelmedium">#Search.Owner#</td>	
			   <td style="padding-left:4px">)</td>
           </tr>
		   </cfoutput>
		   </table>
		   </td> 
		</tr>
		</TR> 	
		
		<tr><td colspan="6">
		
		<cfoutput>
		
		<script language="JavaScript">
		 
		function profiledel(searchid,cls,id) {	  
		   _cf_loadingtexthtml='';	
		   ptoken.navigate('setSearch4DetailDelete.cfm?id='+searchid+'&class='+cls+'&SelectId='+id,'profile');
		}
		
		function profileupdate(searchid,cls,id,param) {	  
		   _cf_loadingtexthtml='';	
		   ptoken.navigate('setSearch4DetailUpdate.cfm?Id=#URL.ID#&Class='+cls+'&SelectId='+id+'&parametervalue='+param,'processing');
		}
		
		function keyword(area){
				  		   
		   ProsisUI.createWindow('keyworddialog', 'Keywords', '',{x:100,y:100,height:document.body.clientHeight-30,width:document.body.clientWidth-30,modal:false,center:true})    		   					
		   ptoken.navigate('Structured/Search4Structured.cfm?ID=#URL.ID#&Area='+area,'keyworddialog') 			
		   
		}   
				  
		function expand(itm,icon,curr) {
		
			 se  = document.getElementById(itm)
			 icM  = document.getElementById(itm+"Min")
		     icE  = document.getElementById(itm+"Exp")
		
		     if (se.className == "hide") {
			
			 se.className = "regular";
			 icM.className = "regular";
			 icE.className = "hide";
			 ptoken.navigate('#SESSION.root#/roster/RosterGeneric/RosterSearch/Structured/Search4KeywordDetail.cfm?ID=#URL.ID#&AR='+itm+'&row='+curr,'i'+itm)		
			 } else {
			  se.className = "hide";
			 icM.className = "hide";
			 icE.className = "regular";
			 
			 }
		  }   
		 	 
		ie = document.all?1:0
		ns4 = document.layers?1:0
	
		function hlkw(bx,itm,fld,cnt,key,keyvalue,cls){
	
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }
		 	 	 	 		 	
		 if (fld != false){							 
		 itm.className = "highLight4"; 		 
		 }else{		 
		 itm.className = "header";					
		 }
	  	}  
	 
		</script>
		
		</cfoutput>
			
		<cf_securediv bind="url:Search4Detail.cfm?ID=#URL.ID#" id="profile">
					
		</td></tr>			
		
	<cfelse>
	
	    <!--- ------------------------------------------------- --->
		<!--- automatically filter for the minimum requirements --->
		<!--- ------------------------------------------------- --->
	
		<TR>  
		   <td colspan="6" class="labelmedium" style="font-size:16px;font-weight:300;height:34px;font-weight:bold"><cf_tl id="Minimum profile requirements"></td>
		</TR> 
			
		<cfquery name="Function" 
		  datasource="AppsSelection" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT  DISTINCT FO.FunctionNo, FO.GradeDeployment, S.SelectDescription, FR.RequirementId
	      FROM    RosterSearchLine S INNER JOIN
	              FunctionOrganization FO ON S.SelectId = FO.FunctionId INNER JOIN
	              FunctionRequirement FR ON FO.FunctionNo = FR.FunctionNo AND FO.GradeDeployment = FR.GradeDeployment
	      WHERE   S.SearchClass = 'Function'
		  AND     S.SearchId = '#URL.ID#'
		</cfquery>
		
		<tr><td colspan="6">
		<table width="100%" align="center" cellspacing="0" cellpadding="0">
			
			<cf_tl id="for" var="1"> 
			<cfset tFor = lt_text>
			
			<cfif function.recordcount eq "0">
				<tr><td align="center" class="labelit">No minimum requirements defined for selected buckets</font></td></tr>
			</cfif>
	
			<cfoutput query="Function">
			<tr><td height="20" colspan="6" style="padding-left:10px" class="labelmedium">
			<a href="javascript:functionbuilder('#FunctionNo#','#GradeDeployment#')"><font color="0080C0">#SelectDescription#</font></a></td></tr>
			<tr><td colspan="6" style="padding-left:30px" class="labelit">			
			<cfinclude template="../../Maintenance/FunctionalTitles/FunctionBuilder/FunctionRequirement.cfm">
			</td></tr>
			</cfoutput>		
			<tr><td height="2"></td></tr>
			
		</table>
		
		</td>
		</tr>
		<tr><td height="5"></td></tr>	
		
	</cfif>	
		
	<cfquery name="Topics" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Topic R 
		WHERE    R.Topic IN (SELECT Topic 
		                     FROM   Ref_TopicOwner 
							 WHERE  Owner = '#search.owner#')				
		AND      R.Parent = 'Skills'					 
	</cfquery>	
	
	<cfif topics.recordcount gte "1">
	
	    <tr><td height="4"></td></tr>
		<TR>  
		   <td colspan="6" height="20" class="labellarge" style="height:30px"><b><cf_tl id="#Search.Owner# specific backgound"></td>
		</TR> 					
		<tr><td colspan="6">
		
		<cfoutput>
		<script language="JavaScript">		  
			 
			function topicdel(cls,id) {
			   _cf_loadingtexthtml='';
			   ptoken.navigate('Topic/TopicCancel.cfm?Owner=#search.Owner#&id=#URL.ID#&Class='+cls+'&SelectId='+id,'topic');
			}
		
			function topic(){
			   w = #CLIENT.width# - 80;
			   h = #CLIENT.height# - 140;
			   ProsisUI.createWindow('topicdialog', 'Profile', '',{x:30,y:30,height:document.body.clientHeight-30,width:document.body.clientWidth-30,modal:false,center:true})    			   
			   _cf_loadingtexthtml='';					
			   ptoken.navigate('Topic/TopicSelect.cfm?Owner=#search.Owner#&ID=#URL.ID#','topicdialog') 			
			   
			}   
		 
		</script>
		</cfoutput>
		
		<cf_securediv bind="url:Topic/Topic.cfm?ID=#URL.ID#&owner=#search.owner#" id="topic">	
				
		</td></tr>	
	  
	 </cfif>  		
	
	 <tr><td height="4"></td></tr>
		<TR>  
		   <td colspan="6" height="20" class="labellarge" style="height:30px"><cf_tl id="Profile Assessment"></td>
		</TR> 			
		<tr><td colspan="6">
		
		<cfoutput>
		
		<script language="JavaScript">		  
			 
			function skilldel(src,id) {
			
			     _cf_loadingtexthtml='';		
			     ptoken.navigate('Assessment/AssessmentCancel.cfm?Id=#URL.ID#&source='+src+'&SelectId='+id,'skill');
			}
		
			function skill(src){
			  
			     w = #CLIENT.width# - 80;
			     h = #CLIENT.height# - 140;
			     ProsisUI.createWindow('assessmentdialog', 'Assessment', '',{x:30,y:30,height:document.body.clientHeight-50,width:document.body.clientWidth-50,modal:true,center:true,minheight:300,minwidth:50 })    			        
			     _cf_loadingtexthtml='';					
			     ptoken.navigate('Assessment/AssessmentSelect.cfm?Source='+src+'&ID=#URL.ID#','assessmentdialog') 							 
			}   
		 
		</script>
		</cfoutput>
		
		<cf_securediv bind="url:Assessment/Assessment.cfm?ID=#URL.ID#" id="skill">	
				
		</td></tr>	
		   
	   <tr><td height="1" colspan="6" class="line"></td></tr>
	   
	   <tr><td height="4"></td></tr>
	   
	   <TR class="fixlengthlist labelmedium">  
	   <td colspan="2" height="21">
	   
	   <table border="0" cellspacing="0" cellpadding="0" class="formpadding">
		   <tr>
		   <td class="labelmedium" style="padding-left:4px;height:30px"><cf_tl id="Language knowledge">:</td>
		  
		   <cfquery name="Check" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        SELECT SelectId
				FROM   RosterSearchLine
				WHERE  SearchId = '#URL.ID#'
		   		  AND  SearchClass = 'LanguageLevel'
		    </cfquery>
			
		   <td style="padding-left:4px"><input class="radiol" type="checkbox" name="LanguageLevel" value="1" <cfif Check.SelectId eq "1">checked</cfif>></td>
		   <td style="padding-left:4px" class="labelit"><cf_tl id="High level only"></td>
		   </tr>
	   </table>
	   </td>
	   <td class="labelmedium" style="height:30px"><cf_tl id="Interested in">:</td>
	   <td>
	   <table cellspacing="0" cellpadding="0" class="formpadding">
	   <tr>
		   <td class="labelmedium"><cf_tl id="Nationality">:</td>
		    <cfquery name="Check" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        SELECT  SelectId
				FROM    RosterSearchLine
				WHERE   SearchId = '#URL.ID#'
		   		AND     SearchClass = 'NationalityMode'
		    </cfquery>
		   <td style="padding-left:4px"><input class="radiol" type="checkbox" name="NationalityMode" value="1" <cfif Check.SelectId eq "1">checked</cfif>></td>
		   <td style="padding-left:4px" class="labelit"><cf_tl id="Exclude selected nationality"></td>
	   </tr>   
	   </table>
	   </td>
	   </TR>      
	     
	   <TR><td height="2" colspan="6" valign="middle"></td></TR>   
	   
	   <tr>
			
		<td width="5"></td>
		
		<cfloop index="item" list="Language,Mission,Nationality" delimiters=",">
		
		    <cfoutput>
					
			<td valign="top" style="padding-left:10px">
			
				<table class="formpadding">
																											  						
					<tr>
					
						<cfquery name="Check" 
					        datasource="AppsSelection" 
					        username="#SESSION.login#" 
					        password="#SESSION.dbpw#">
					        SELECT SelectId
							FROM RosterSearchLine
							WHERE SearchId = '#URL.ID#'
					   		  AND SearchClass = '#item#Operator'
					    </cfquery>
						
						<cfif Check.recordCount eq 0>
					      <cfset SelectId = "ANY">
					    <cfelse>	
					      <cfset SelectId = Check.SelectId>  
					    </cfif>
																
					    <td width="50" align="center" bgcolor="ECF5F9" style="border: 1px dotted gray;">
							
							<table width="100%" cellspacing="0" cellpadding="0" class="formspacing">
							<tr>
								<td style="padding-left:4px"><input type="radio" name="#item#Status" value="ANY" <cfif SelectId eq "ANY">checked</cfif>></td><td class="labelit" style="padding-left:4px">ANY</td>
							</tr>
							<tr>
								<td style="padding-left:4px"><input type="radio" <cfif item eq "nationality">disabled</cfif> name="#item#Status" value="ALL" <cfif SelectId eq "ALL">checked</cfif>></td><td class="labelit" style="padding-left:4px">ALL</td> 
							</tr>
							</table>
							
						</td>
						
						<td id="combo#item#" style="padding:4px;width: 150px; border:1px dotted gray;">
						
						<cfquery name="#item#" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT * 
						    FROM   RosterSearchLine L
							WHERE  L.SearchId = '#URL.ID#'
							AND    L.SearchClass = '#item#'
						</cfquery>
						
						<cfset selected = "">
						<cfloop query="#item#">
						  <cfif selected eq "">
						     <cfset selected = "#SelectId#">
						  <cfelse>
						  	 <cfset selected = "#selected#,#SelectId#">
						  </cfif>	
						</cfloop>
						
						<cfset selected = "#selected#">	
						<cfset mode     = "view">	
						
						<cfif item eq "language">
																				
							<cfset alias    = "appsSelection">
							<cfset table    = "Ref_Language">
							<cfset order    = "ListingOrder">
							<cfset pk       = "LanguageId">
							<cfset desc     = "LanguageName">		
						
						<cfelseif item eq "mission">
						
							<cfset alias    = "appsSelection">
							<cfset table    = "ApplicantMission">
							<cfset pk       = "Mission">
							<cfset desc     = "Mission">
							<cfset order    = "">	
							
						<cfelseif item eq "nationality">
						
							<cfset alias    = "appsSystem">
							<cfset table    = "Ref_Nation">
							<cfset pk       = "Code">
							<cfset desc     = "Name">	
							<cfset order    = "">
																	
						</cfif>
																			
						<cfinclude template="../../../Tools/ComboBox/ComboMultiSelected.cfm">
																									
					    </td>
																
						<td width="1" class="hide" bgcolor="f4f4f4">
									
									<cfinput type="Text" 
										name="#item#" 
										value="#selected#"
										message="" 
										maxlength="800"
										style="width:1px"
										id="#item#"
										class="regularxl"
								    	required="No">  
									
						</td>
					    <td width="23" align="center" style="border:1px dotted gray;">
										
								<cfoutput>						   				   
								    <button class="button3" type="button"
									   onClick="combomulti('#item#','#alias#','#table#','#pk#','#desc#','#order#','No')">
										   <img src="#SESSION.root#/Images/Search.png" 
										    onMouseOver="document.img0_#item#.src='#SESSION.root#/Images/Search1.gif'"
				     						onMouseOut="document.img0_#item#.src='#SESSION.root#/Images/Search.png'"
											id="img0_#item#"
											name="img0_#item#"
										    alt="Search" 
										    border="0" 
										    height="16"
										    width="16"
										    align="absmiddle" 
										    style="cursor: pointer;">
								    </button>
								</cfoutput>
															  					   
					    </td>
					    </tr>
								  
				   </table>
			
			</TD>	
			
			</cfoutput>
		
		</cfloop>
			
		<TR>
	   <td height="3" colspan="6" valign="middle"></td>
	</TR> 
	
	</TABLE>
			
	</td></tr>	
	
	<tr><td>
	
	<table width="100%" align="center">
	
	<!---
	<cfif Search.SearchCategory eq "Roster" or Search.SearchCategory eq "Function">
	--->
	
		 <cfquery name="Select" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT *
			FROM     RosterSearchLine
			WHERE    SearchId = '#URL.ID#'
			AND      SearchClass = 'Function'
	     </cfquery>
		 
		 <cfif Select.recordcount eq "1">
		
			<cfquery name="FunctionTopic" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     FunctionOrganizationTopic
			 WHERE    FunctionId = '#Select.SelectId#'
			 ORDER BY Parent, TopicOrder
			</cfquery>
			
			<cfif FunctionTopic.recordcount gte "1">
					
			<tr><td height="1" colspan="6" class="line"></td></tr>
			<tr><td height="2"></td></tr>
			<TR>  
			   <td colspan="6" class="labellarge" style="height:30px"><cf_tl id="Vacancy topics">/<cf_tl id="questions"></td>
			</TR> 
			
			<tr><td colspan="6">
					<table width="90%" align="left" class="formpadding">
									
					<cfoutput query="FunctionTopic">
					
					<cfquery name="Check" 
			        datasource="AppsSelection" 
			        username="#SESSION.login#" 
			        password="#SESSION.dbpw#">
			        	SELECT SelectId
						FROM   RosterSearchLine
						WHERE  SearchId = '#URL.ID#'
				   		  AND  SearchClass = 'Topic'
						  AND  SelectId = '#FunctionTopic.TopicId#'
					</cfquery>
					
					<cfif Check.recordcount eq "1">
					 <cfset cl = "highlight1">
					<cfelse>
					 <cfset cl = "regular">
					</cfif>
					
					<input type="hidden" name="Topic_#CurrentRow#" value="#TopicId#">
					<input type="hidden" name="TopicDes_#CurrentRow#" value="#TopicPhrase#">
													
					<tr class="#cl#">
					    <td width="5%" style="padding-left:30px">
						<input type="checkbox" class="radiol" name="TopicSelect_#CurrentRow#" value="1" 
						<cfif Check.recordcount eq "1">checked</cfif>
						onclick="javascript: hl(this,this.checked)">
						</td>
						<td style="padding-left:6px" width="12%" class="labelit">#Parent#</td>
						<td style="padding-left:6px" width="5%"  class="labelit">#TopicOrder#</td>
						<td style="padding-left:6px" width="60%" class="labelit">#TopicPhrase#</td>
						<td style="padding-left:6px" width="10%" class="labelit">Answer&nbsp;required:</td>
						<td style="padding-left:6px" width="9%" align="center">
						<select name="TopicParameter_#CurrentRow#" class="regularxl">
							<option value="1" <cfif Select.SelectParameter eq "1" or Select.SelectParameter eq "">selected</cfif>>Yes</option>
							<option value="0" <cfif Select.SelectParameter eq "0">selected</cfif>>No</option>
						</select>
						</td>
					</tr>
					
					<tr><td colspan="6" class="linedotted"></td></tr>
									
					</cfoutput>
					
					<cfquery name="Check" 
			        datasource="AppsSelection" 
			        username="#SESSION.login#" 
			        password="#SESSION.dbpw#">
			        SELECT SelectId
					FROM   RosterSearchLine
					WHERE  SearchId = '#URL.ID#'
			   		  AND  SearchClass = 'TopicOperator'
			        </cfquery>
					
					<tr><td height="3" colspan="6"></td></tr>
					<input type="hidden" name="Topic" value="<cfoutput>#FunctionTopic.recordcount#</cfoutput>">
					<tr><td height="22" style="padding-left:20px" colspan="6" class="labelmedium"><font color="808040">&nbsp;Select candidates that &nbsp;
					<select name="TopicStatus" class="regularxl">
						<option value="1" <cfif Check.SelectId eq "1">selected</cfif>>match</option>
						<option value="0" <cfif Check.SelectId eq "0">selected</cfif>>do not match</option>
					</select> &nbsp; the above selected answers</b>
					</tr>	
																			
					</table>
				</td>
			</td>		
			</tr>
			<tr><td height="5" colspan="6"></td></tr>
					
			</cfif>
			
		</cfif>
		
	<!---	
	
	</cfif>
	
	--->
	
	<tr><td height="1" colspan="6" class="linedotted"></td></tr>
	 
	<tr><td colspan="2" height="2"></td></tr>
	<TR>  
	   <td colspan="6" height="22" class="labellarge" style="height:40px">Wildcard <cf_tl id="Search for Duties and achievements"> &nbsp;(<cf_tl id="Enter keywords">, <cf_tl id="separated by a semicolon"> [;])</td>
	</TR> 
	
	 <tr><td height="5" colspan="6" valign="middle"></td></tr>   
	 
	 <tr>
	   <td colspan="2" valign="top" width="20%">
	   
	   <cfquery name="Check" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT SelectId
			FROM   RosterSearchLine
			WHERE  SearchId = '#URL.ID#'
	   		AND    SearchClass = 'BackgroundOperator'
	    </cfquery>
		
		<cfif Check.recordCount eq 0>
	      <cfset SelectId = "ANY">
	    <cfelse>	
	      <cfset SelectId = Check.SelectId>  
	    </cfif>
		
		<script language="JavaScript">
		
		function freetext(md) {
		se = document.getElementById("cluster")
			if (md == "any") {
			se.className = "Hide"
			} else {
			se.className = "Regular"
			}
		}
		</script>
		
			<table class="formpadding">
			<tr><td><input type="radio" style="height:14px;width:14px" name="BackgroundStatus" value="ANY" onClick="freetext('any')" <cfif SelectId eq "ANY">checked</cfif>></td><td style="padding-left:5px"><cf_tl id="MATCH ANY KEYWORD"></td></tr>
			<tr><td><input type="radio" style="height:14px;width:14px" name="BackgroundStatus" value="ALL" onClick="freetext('cluster')" <cfif SelectId eq "ALL">checked</cfif>></td><td style="padding-left:5px"><cf_tl id="MATCH CLUSTERS"></td></tr>
			</table>
	
	    </td>
		
		<td colspan="4">
		
		<cfif SelectId eq "ANY">
		 <cfset cl = "Hide">
		<cfelse>
		 <cfset cl = "Regular"> 
		</cfif>
		
			<table width="100%">
			<tr><td>
			<textarea style="width:95%" class="regular" rows="2" name="Background"><cfoutput query = Keyword>#SelectId#;</cfoutput></textarea></td></tr>
			</td></tr>
			<tr><td id="cluster" class="<cfoutput>#cl#</cfoutput>">
			<table width="100%" class="formpadding">
			
			<cfloop index="itm" from="1" to="3">
			 
				<cfquery name="Keyword#itm#" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT DISTINCT L.SelectDescription as SelectId 
				    FROM     RosterSearchLine L
					WHERE    L.SearchId = '#URL.ID#'
					AND      L.SearchClass = 'Background#itm#'
					ORDER BY L.SelectDescription DESC
				</cfquery>
		
		    </cfloop>
			
			<cfoutput>
			<tr><td><textarea style="width:95%" class="regular" rows="2" name="Background1"><cfloop query = Keyword1>#SelectId#;</cfloop></textarea></td></tr>
			<tr><td><textarea style="width:95%" class="regular" rows="2" name="Background2"><cfloop query = Keyword2>#SelectId#;</cfloop></textarea></td></tr>
			<tr><td><textarea style="width:95%" class="regular" rows="2" name="Background3"><cfloop query = Keyword3>#SelectId#;</cfloop></textarea></td></tr>
			</cfoutput>
		    </table>	
			
			</TD> 
			</tr>
			</table>
		
		</td></tr>
		<TR>
	   	<td height="5" colspan="6" valign="middle"></td>
	    </TR>   			
		</TABLE>
		
	</td></tr>	
	
	</TABLE>
		
	</td></tr>	
	
	<tr><td height="1" class="line" valign="bottom"></td></tr>
	
	<cfoutput>
		<script language="JavaScript1.1">
			function revert() {
				ptoken.location('Search2.cfm?docno=#url.docno#&ID=#URL.ID#&Owner=#search.Owner#&Mode=#url.Mode#&Status=#search.Status#')
			}
	</script>
	</cfoutput>
	
	</table>
	
	</cf_divscroll>

	</td>
	</tr>

<tr>

	<td align="center" height="35">
	<button name="Prior" class="button10g" style="width:160;height:27px"
	 value="Next" type="button" onClick="revert()">
	<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/prev.gif" align="absmiddle" alt="" border="0"><cf_tl id="Back">
	</button>
	
	<button name="Prios" 
	    class="button10g" 
		value="Prior" 
		type="submit" 
		style="width:160;height:27px">
			<cf_tl id="Search">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/next.gif" border="0" align="absmiddle"> 
	</button>
	
</td>
</tr>

</table>

</CFFORM>

