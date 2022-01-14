
<cfparam name="URL.drillid"     default="0">
<cfparam name="URL.ID2"         default="#url.drillid#">
<cfparam name="URL.box"         default="">
<cfparam name="URL.source"      default="Backoffice">

<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Position
		WHERE  PositionNo = '#URL.ID2#' 
</cfquery>

<cfif Position.Recordcount eq "0">

	<!--- position had migrated to a different instance --->
	
	<cfquery name="Position" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Position
		  WHERE  SourcePositionNo  = '#URL.ID2#'			  		 
	</cfquery>	
	
	<cfif Position.recordcount gte "1">
		<cfset url.id2 = Position.PositionNo>
	</cfif>
  
</cfif>

<cfif Position.Recordcount eq "0">

	<!--- position had migrated to a different instance --->
	
	<cfquery name="Position" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT TOP 1 *
		  FROM   Position
		  WHERE  SourcePostNumber  = '#URL.ID2#'	  		 
		  ORDER BY DateEffective DESC
	</cfquery>	
	
	<cfset url.id2 = Position.PositionNo>
  
</cfif>

<cfset parentid = Position.PositionParentId>

<cfquery name="PositionWorkSchedule" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP 1 *
	    FROM   WorkSchedulePosition
		WHERE  PositionNo = '#URL.ID2#'
		AND    CalendarDate >= getDate()
		AND    WorkSchedule IN (SELECT Code FROM WorkSchedule WHERE Operational=1)
</cfquery>

<cfif Position.recordcount eq "0">

  <cf_message message="Problem, request can not be completed. Try again or contact your administrator">
  <cfabort>
  
</cfif>

<cf_tl id="Staffing table Position" var="vPosition">
<cf_tl id="Inquire and Maintain Position and funding" var="vOption">

<cf_menuscript>
<cf_calendarviewscript>
<cf_listingscript>

<cf_dialogPosition>
<cf_FileLibraryScript>
<cf_dialogStaffing>
<cf_dialogLedger>
<cf_dialogProcurement>
<cf_actionlistingscript>
<cf_layoutScript>

<cf_textareascript>
<cfajaximport tags="cfdiv,cfform">

<cf_screentop height = "100%"
	   scroll        = "yes" 	 
	   html          = "Yes"
	   jQuery        = "Yes"
	   SystemModule  = "Staffing"	
	   FunctionClass = "Window"
	   FunctionName  = "Position Parent"	
	   label         = "#vPosition#" 
	   option        = "#vOption#" 
	   layout        = "webapp" 
	   banner        = "gray">

<cfset url.id  = Position.Mission>
<cfset url.id1 = Position.MandateNo>

<cfoutput>
	
<script>

	var vFundPercentageLineId = 0;
	
	function reload() { 
	   try{
	   opener.location.reload();
	   } catch(e) {}
	   window.close();
	}
	
	function backme() {				
		returnValue = curpos.value
		window.close();		
	 }	 	 
		 
	function funding(clr,fundingid,act,fd,fdcl,obj,pg,dat,exp) {	
   	   	ptoken.navigate('#SESSION.root#/Staffing/Application/Position/Funding/PositionFunding.cfm?ID=#Position.PositionParentId#&clear='+clr+'&mission=#Position.Mission#&access=edit&fundingid='+fundingid+'&action='+act+'&fund='+fd+'&fundclass='+fdcl+'&objectcode='+obj+'&programcode='+pg+'&date='+dat+'&expiration='+exp,'fundbox')
	}		
		
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function hl(itm,fld,pos,cat){
	
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }
		 
		 	 		 	
		 if (fld != false){
			
		 itm.className = "highLight2";
		 ptoken.navigate('#SESSION.root#/Staffing/Application/Position/PositionParent/WorkforceEntrySubmit.cfm?action=insert&positionno='+pos+'&category='+cat,'wfresult')
		 }else{		
	     itm.className = "regular";		
		 ptoken.navigate('#SESSION.root#/Staffing/Application/Position/PositionParent/WorkforceEntrySubmit.cfm?action=delete&positionno='+pos+'&category='+cat,'wfresult')
		 }
	  }
	    
	function expand(itm,icon){
		 
		 se  = document.getElementById(itm)
		 icM  = document.getElementById(itm+"Min")
	     icE  = document.getElementById(itm+"Exp")
		 if (se.className == "hide") {
			 se.className = "regular";
			 icM.className = "regular";
			 icE.className = "hide";			
		 } else {
		     se.className = "hide";
		     icM.className = "hide";
		     icE.className = "regular";		
		 }
	  }   
	  
 
	function applyprogram(prg,scope) {	  
	   ptoken.navigate('setProgram.cfm?programcode='+prg+'&scope='+scope,'process')
	}  

	function editFunding(pos, fund) {
		ProsisUI.createWindow('wFundingEdit', 'Funding Edit', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})    				
		ptoken.navigate('#SESSION.root#/Staffing/Application/Position/Funding/PositionFundingPercentageEdit.cfm?PositionParentId='+pos+'&fundingid='+fund, 'wFundingEdit');
	}

	function applyprogramfunding(prg,scope) {	  
   		ptoken.navigate('#session.root#/staffing/application/position/positionparent/setProgram.cfm?programcode='+prg+'&scope='+scope,'process')
	}

	function addFundingLine(pos, fund) {
		vFundPercentageLineId = vFundPercentageLineId + 1;
		$('##fundingList').append('<tr class="navigation_row clsFundingLine" id="fundingLine_'+vFundPercentageLineId+'"><td id="fundingLineTD_'+vFundPercentageLineId+'"></td></tr>');
		$('##btnFundSave').hide();		
		ptoken.navigate('#session.root#/staffing/application/position/funding/setFundPercentageLine.cfm?lineId='+vFundPercentageLineId+'&positionparentid='+pos+'&FundingId='+fund, 'fundingLineTD_'+vFundPercentageLineId)
		$('##btnFundSave').show();		
	}

	function removeFundingLine(id) {
		if ($('.clsFundingLine').length > 1) {
			$('##fundingLine_'+id).remove();
		} 
		validateDisplayButtons();
	}

	function validateDisplayButtons() {
		$('.clsAddButton').hide();
		$('.clsAddButton').last().show();
		$('.clsRemoveButton').show();
		if ($('.clsFundingLine').length < 2) {
			$('.clsRemoveButton').hide();
		}
	}

	function distributeFunding() {
		var vTotalToDistribute = 100;
		var vElements = $('.clsFundingPercentage').length;
		var vThisElementValue = 0;
		var cnt = 0;
		
		$('.clsFundingPercentage').each(function() {
			cnt++;
			vThisElementValue = Math.round(vTotalToDistribute/vElements);
			if (cnt == vElements) {
				vThisElementValue = vTotalToDistribute - (Math.round(vTotalToDistribute/vElements) * (cnt-1));
			}
			$(this).val(vThisElementValue);
		});
	}
 
</script>

<input type="hidden" id="curpos" name="curpos" value="#url.id2#">

</cfoutput>

			
<cf_layout type="border" id="mainLayout" width="100%">	

<cf_layoutArea 
			name="center" 
			position="center">

	<table width="98%" height="100%" align="center">
			
		<tr><td height="10"><table width="100%">
		<tr class="line">
	   
	    <td style="height:35;padding-left:20px" align="left" valign="middle" class="labellarge">
		   	   		
			<cf_tl id="Initially recorded by">:
			<cfoutput><b>#Position.OfficerFirstName# #Position.OfficerLastName# #DateFormat(Position.Created,CLIENT.DateFormatShow)#</cfoutput>
			
	    </td>
			 
	    <td height="16" align="right" class="labellarge">
		    &nbsp;<cfoutput><b>#URL.ID#</b>&nbsp;|&nbsp;<cf_tl id="Period">: <b>#URL.ID1#</b>&nbsp;|&nbsp;<cf_tl id="Id">: <b><font color="800040"><cfif Position.SourcePostNumber eq "">#Position.PositionParentId#<cfelse>#Position.SourcePostNumber#</cfif></font></b>&nbsp;|&nbsp;<cf_tl id="Instance">: <a href="javascript:EditPost('#URL.ID2#')">#URL.ID2#</a></cfoutput></font>
		</td>
		
		<td id="process"></td>
		 
	    </tr> 	
		
		</table>
		</td></tr>
		
		<tr><td style="padding-left:10px;padding-right:10px">
			
		<input type="hidden" id="sourcepost" name="sourcepost">
			
			<table width="100%" border="0" align="center">		  		
		
		        <cfset ht = "52">
				<cfset wd = "52">			
							
				<cfinvoke component="Service.Access"  
					  method         = "position" 
					  orgunit        = "#Position.OrgUnitOperational#" 
					  role           = "'HRLoaner'"
					  posttype       = "#Position.PostType#"
					  returnvariable = "accessLoaner">
						
				<tr>	
							
					<cfset itm = 1>			
					<cf_tl id="Position Properties" var="vEditPost">
					<cf_menutab item   = "#itm#" 
					        iconsrc    = "Maintenance.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "1"
							class      = "highlight1"
							name       = "#vEditPost#"
							iframe     = "position"
							source     = "iframe:../Position/PositionEdit.cfm?action=view&box=#url.box#&ID=#url.id#&ID1=#url.id1#&ID2=#url.id2#">	
							 
					<cfset itm = itm+1>			
					<cf_tl id="Funding/Workforce" var="vFunding">
					<cf_menutab item       = "#itm#" 
					    	iconsrc    = "Funding.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vFunding#"
							source     = "PositionSupply.cfm?ID=#Position.PositionNo#&ID2=#Position.PositionParentId#">		
							
					<cfinvoke component= "Service.Access"
						Method         = "PayrollOfficer"
						Role           = "PayrollOfficer"
						Mission        = "#Position.mission#"
						ReturnVariable = "PayrollAccess">		
						
					<cfinvoke component="Service.Access"  
					  method         = "position" 
					  orgunit        = "#Position.OrgUnitOperational#" 
					  role           = "'HRPosition'"
					  posttype       = "#Position.PostType#"
					  returnvariable = "accessPosition">											
												
					<cfif PayrollAccess is "EDIT"  or PayrollAccess is "ALL" or accessPosition eq "EDIT" or accessPosition eq "ALL">	
										
						<cfset itm = itm+1>		
						<cf_tl id="Payroll" var="vPayroll">
						<cf_menutab item   = "#itm#" 
						        iconsrc    = "Logos/Staffing/Payroll.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "2"
								name       = "#vPayroll#"
								source     = "../Funding/PositionPayrollListing.cfm?systemfunctionid=#url.systemfunctionid#&positionno=#url.id2#">		
	
					</cfif>
													
					<cfset itm = itm+1>		
					<cf_tl id="Amendments" var="vAmendment">
					<cf_menutab item   = "#itm#" 
					        iconsrc    = "Logos/Staffing/Amendments.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vAmendment#"
							source     = "../Position/PositionLog.cfm?positionno=#url.id2#">	
							
					<cfset itm = itm+1>		
					<cf_tl id="Incumbency" var="vIncumbent">
					<cf_menutab item   = "#itm#" 
					        iconsrc    = "Logos/Staffing/Incumbent.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "3"
							name       = "#vIncumbent#"
							iframe     = "assignments"
							source     = "iframe:../../Assignment/PostAssignment.cfm?caller=postdialog&id=#url.id2#">						
							
					<cfset itm = itm+1>		
					<cf_tl id="Recruitment" var="vRecruitment">
					<cf_menutab item   = "#itm#" 
					        iconsrc    = "Logos/Staffing/Staffing.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vRecruitment#"						
							source     = "../Recruitment/PositionView.cfm?caller=postdialog&id=#url.id2#">			
													
					<cfinvoke component="Service.Access"  
						  method         = "position" 
						  orgunit        = "#Position.OrgUnitOperational#" 
						  role           = "'HRPosition'"
						  posttype       = "#Position.PostType#"
						  returnvariable = "accessPosition">	
						  
					<cfif  accessPosition eq "READ" or accessPosition eq "EDIT" or accessPosition eq "ALL" 
					    or  accessloaner eq "READ" or accessloaner eq "EDIT" or accessloaner eq "ALL">  	 								
					 
						 <cfset itm = itm+1>			
						 <cf_tl id="Classify and Loan" var="vLoan">
						 <cf_menutab item       = "#itm#" 
					        iconsrc    = "Logos/Staffing/Loan.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vLoan#"
							source     = "ParentHeader.cfm?ID2=#Position.PositionParentId#">							 
							
					 </cfif>
					 
					 <!---		
						 <cfset itm = itm+1>	
					 	 <cf_tl id="Memo" var="vMiscellaneous">
						 <cf_menutab item       = "#itm#" 
						        iconsrc    = "Logos/Staffing/Memo.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "2"
								name       = "#vMiscellaneous#"
								source     = "../Position/PositionMemo.cfm?positionno=#url.id2#">	
								
						--->			
					 			
					 
					 <cf_verifyOperational module="WorkOrder" Warning="No">
					 
					 <cfif Operational eq "1" and Position.DateExpiration gte now() and PositionWorkSchedule.recordcount gte "1">
								 
						 <cfset itm = itm+1>		
						 <cf_tl id="Workschedule" var="vWork">
						 <cf_menutab item       = "#itm#" 
						    iconsrc    = "Logos/Staffing/WorkSchedule.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vWork#"
							source     = "../../WorkSchedule/Position/WorkScheduleView.cfm?ID=#Position.PositionNo#&ID2=#Position.PositionParentId#">		
									
						<!--- only if this is an active position for now but we can do this also historically now through
							workorderlineactionPerson.PositionNo --->
										
						 <cfset itm = itm+1>		
						 <cf_tl id="Scheduled Actions" var="vAction">
						 <cf_menutab item       = "#itm#" 
						    iconsrc    = "Logos/System/Schedule.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"
							name       = "#vAction#"
							source     = "../ScheduledTask/WorkScheduleListing.cfm?PositionNo=#Position.PositionNo#">		
						
					</cfif>	
					
					<cfquery name="Custom" 
					    datasource="AppsSystem" 
				    	username="#SESSION.login#" 
					    password="#SESSION.dbpw#">		
						
						SELECT     L.SystemFunctionId, L.LanguageCode, L.Mission, L.Operational, L.FunctionName, L.FunctionMemo, L.OfficerUserId, L.Created, R.FunctionPath, 
			                             R.FunctionCondition
						FROM       Ref_ModuleControl_Language AS L INNER JOIN
			                       Ref_ModuleControl AS R ON L.SystemFunctionId = R.SystemFunctionId
						WHERE      R.FunctionName = 'stPosition' 
						AND        R.SystemModule = 'Custom' 
						AND        R.FunctionClass = 'Staffing' 
						AND        L.LanguageCode = 'ENG'						
			                  
					</cfquery> 								
							
					<cfif Custom.recordcount eq "1" and Position.SourcePostNumber neq "" and IsNumeric(Position.SourcePostNumber)>
									
						<cfset itm = itm+1>			
							<cf_tl id="#Custom.FunctionName#" var="vERP">
							<cf_menutab item       = "#itm#" 
							    iconsrc    = "Logos/Staffing/Umoja.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "2"
								name       = "#vERP#"
								source     = "#SESSION.root#/#Custom.FunctionPath#?embed=1&id={sourcepost}">		
								
					</cfif>		
			
					<cftry>
					
						<cfquery name="Custom" 
						    datasource="AppsSystem" 
					    	username="#SESSION.login#" 
						    password="#SESSION.dbpw#">		
							
							SELECT     L.SystemFunctionId, L.LanguageCode, L.Mission, L.Operational, L.FunctionName, L.FunctionMemo, L.OfficerUserId, L.Created, R.FunctionPath, 
				                             R.FunctionCondition
							FROM       Ref_ModuleControl_Language AS L INNER JOIN
				                       Ref_ModuleControl AS R ON L.SystemFunctionId = R.SystemFunctionId
							WHERE      R.FunctionName = 'stPositionLegacy' 
							AND        R.SystemModule = 'Custom' 
							AND        R.FunctionClass = 'Staffing' 
							AND        L.LanguageCode = 'ENG'						
				                  
						</cfquery> 								
								
						<cfif Custom.recordcount eq "1" and Position._SourcePostNumber neq "">
										
							<cfset itm = itm+1>			
								<cf_tl id="#Custom.FunctionName#" var="vIMIS">
								<cf_menutab item       = "#itm#" 
								    iconsrc    = "Logos/Staffing/IMIS.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "2"
									name       = "#vIMIS#"
									source     = "#SESSION.root#/#Custom.FunctionPath#?embed=1&id=#Position._SourcePostNumber#">		
									
						</cfif>	
					
						<cfcatch></cfcatch>	
					
					</cftry>						
			
				</tr>
		
			</table>
		
		</td>
		</tr>
				
		<cfoutput>
				
		<!--- UN only --->
		
		<cfinclude template="../../../../Vactrack/Application/Document/Dialog.cfm">
		
		<script>
		// function ShowPA(Doc,Ind) {
		//	ptoken.open('#SESSION.root#/DWarehouse/InquiryEmployee/PA_Detail.cfm?ID1=' + Doc + '&ID2=' + Ind, 'DialogPA', 'width=900, height=600, toolbar=yes, scrollbars=yes, resizable=yes');
		// }
		
			function doProjectValidations() {
				ptoken.navigate('#session.root#/Staffing/Application/Position/PositionParent/PositionViewValidation.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&PositionNo=#url.id2#', 'divValidations');
			}
			
	    </script>
		
		</cfoutput>
		
		<tr><td height="100%" bgcolor="white" style="padding-top:8px">
		
			<table width="100%" 	    
			  height="100%"
			  cellspacing="0" 
			  cellpadding="0">	  
			  
			  <cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
			  <cfset mid = oSecurity.gethash()/>   
			  
			  <cf_menucontainer item="1" class="regular" iframe="position" template="../Position/PositionEdit.cfm?action=view&box=#url.box#&ID=#url.id#&ID1=#url.id1#&ID2=#url.id2#&mid=#mid#"/>
	  
			  <cf_menucontainer item="2" class="hide">
			   
		      <cf_menucontainer item="3" class="hide" iframe="assignments">
	  	 		
			</table>
	
	</td></tr>
	</table>		
	
</cf_layoutArea>

<cf_layoutarea size="220"  position="right" name="validationbox" initcollapsed="Yes" collapsible="Yes">
		
		<cf_divscroll>
			<cfdiv id="divValidations" style="margin:5px;"> 	  
		</cf_divscroll>	
					
	</cf_layoutarea>	
	
</cf_layout>	

<cfset AjaxOnLoad("function(){ doProjectValidations(); }")>	
	
<cf_screenbottom layout="webapp">
