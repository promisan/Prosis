
<cfquery name="function" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Ref_ModuleControl
		WHERE  	SystemFunctionId = '#url.id#'					
</cfquery>

<cfquery name="qActionModule" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	UserActionModule
		WHERE  	SystemFunctionId = '#url.id#'		
		<cfif url.mission neq "">
		AND     Mission = '#url.mission#'
		</cfif>		   			
</cfquery>

<cfquery name="actionList" dbtype="query">
	SELECT DISTINCT ActionDescription
	FROM   	qActionModule
</cfquery>

<cfquery name="accList" dbtype="query">
	SELECT DISTINCT Account
	FROM   	qActionModule
</cfquery>

<cfquery name="nodeList" dbtype="query">
	SELECT DISTINCT NodeIp
	FROM   	qActionModule
</cfquery>

<cfquery name="hostList" dbtype="query">
	SELECT DISTINCT UPPER(HostName)
	FROM   	qActionModule
</cfquery>

<cfquery name="mindate" dbtype="query">
	SELECT MIN(ActionTimeStamp) as ActionTimeStamp
	FROM   	qActionModule
</cfquery>

<cf_screentop height="100%" 
	  scroll="Yes" 
	  html="Yes" 
	  layout="webapp" 
	  label="#function.FunctionName# Logging" 
	  option="#function.functionMemo#"
	  banner="gray" 	  
	  menuAccess="yes" 
	  jquery="Yes"
	  systemfunctionid="#url.id#">

<cfajaximport tags="cfdiv">
<cf_calendarscript>

<cfset lastNDays = 5>

<cf_tl id = "The end date must be greater or equal than the initial date." var = "vDateError">

<cfoutput>
		
	<script>
	
		function hideAllDetails() {
			$('.detailPanel').hide(350);
			$('##tdHideAll').hide(350);
		}
		
		function showBtnHideAll() {
			if ($('.detailPanel:hidden').length == $('.detailPanel').length) {
				$('##tdHideAll').hide(200);
			}else{
				$('##tdHideAll').show(200);
			}
		}
		
		function viewLoggingDetail(id,desc) {
			
			if ($('##detailPanel_'+id).is(':hidden')) {
				$('##detailPanel_'+id).show(350, showBtnHideAll);
				$('##btnViewDetail_'+id).attr('title','hide '+desc+' detail');
				ptoken.navigate('LoggingDetail.cfm?moduleActionId=' + id + '&ts=' + new Date().getTime(),'loggingDetail_'+id);
			}else{
				$('##detailPanel_'+id).hide(350, showBtnHideAll);
				$('##btnViewDetail_'+id).attr('title','view '+desc+' detail');
			}
			
		}
		
		function validateDateFields(vInitDate,vEndDate) {
		
			var vMessage = '';
			var vFirstError = '';
			
			//Validation expiration > effective
			if (vInitDate > vEndDate) {
				vMessage = vMessage + '#vDateError#\n';
				if (vFirstError == '') vFirstError = '##EndDate';
			}

			//Return error
			if (vMessage != '' && vFirstError != ''){
				alert(vMessage);
				$(vFirstError).focus();
				return false;
			}
			
			//Success
			return true;
		}
		
		function applyFilter() {
			var vAction = $('##action').val();
			var vAccount = $('##account').val();
			var vNode = $('##node').val();
			var vHost = $('##host').val();
			
			var vDay = '';
			var vMonth = '';
			var vYear = '';
			var vTest = '';
			
			//Initial date
			vTest = $('##InitialDate').val();
			if ('#APPLICATION.DateFormat#' == 'EU') {
				vDay = vTest.substring(0,2);
				vMonth = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			else {
				vMonth = vTest.substring(0,2);
				vDay = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			
			var vStringInitDate = vYear + vMonth + vDay;
			var vInitDate = new Date(parseInt(vYear), parseInt(vMonth)-1, parseInt(vDay), 0, 0, 0, 0);
			
			//End date
			vTest = $('##EndDate').val();
			if ('#APPLICATION.DateFormat#' == 'EU') {
				vDay = vTest.substring(0,2);
				vMonth = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			else {
				vMonth = vTest.substring(0,2);
				vDay = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			
			var vStringEndDate = vYear + vMonth + vDay;
			var vEndDate = new Date(parseInt(vYear), parseInt(vMonth)-1, parseInt(vDay), 0, 0, 0, 0);
			
			$('##frmFilter').submit();
			if( _CF_error_messages.length == 0 && validateDateFields(vInitDate,vEndDate)) {
				$('##logStatus').text('Showing records from ' + $('##InitialDate').val() + ' to ' +  $('##EndDate').val() + '.');
				ptoken.navigate('RecordListingDetail.cfm?id=#url.id#&filter=1&lastNDays=#lastNDays#&action='+vAction+'&account='+vAccount+'&node='+vNode+'&host='+vHost+'&initial='+vStringInitDate+'&end='+vStringEndDate,'divDetail');
			}
		}
		
		function showDates() {
			$('##InitialDate').attr('width','100%');
			$('##EndDate').attr('width','100%');
		}
		
		$(document).ready(function(){
			
			$('##toggleFilter').click(function(){				
				if ($('##filterPanel').is(':hidden')) {				
					$('##filterTwistie').attr('src','#SESSION.root#/Images/collapse-up.png');
					$('##toggleFilter').attr('title','Hide filters');
					$('##dateContainer').slideDown(250);
					$('##filterPanel').slideDown(300,showDates);					
				}else{				
					$('##filterTwistie').attr('src','#SESSION.root#/Images/collapse-down.png');
					$('##toggleFilter').attr('title','Show filters');
					$('##dateContainer').slideUp(250);
					$('##filterPanel').slideUp(300);					
				}				
			});			
		});
		
	</script>
</cfoutput>  

<table width="95%" align="center">

	<tr><td height="5"></td></tr>
	
	<tr>
		<td>
			<table width="100%" align="center" style="border:0px dotted #C0C0C0;">
				<tr>
					<td id="toggleFilter" align="center" style="cursor:pointer;" title="Show filters" valign="middle">
						<cfoutput>
							<img id="filterTwistie" name="filterTwistie" src="#SESSION.root#/Images/collapse-down.png" height="12" align="absmiddle">
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td>
						<div id="filterPanel" style="display:none;">
							<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
								<tr><td height="5"></td></tr>
								<tr><td class="linedotted"></td></tr>
								<cfform name="frmFilter" id="frmFilter" method="POST" onsubmit="return false;" target="processFilterLogging">
								<tr>
									<td>
										<table cellspacing="0" width="98%" align="center" class="formpadding">
										
											<tr>
												<td width="12%" class="labelit">In the period:</td>
												<td colspan="3">
													<table cellspacing="0" cellpadding="0" id="dateContainer">
														<tr>
															<td>
																<cfset vDate = now()>
																<cfif mindate.ActionTimeStamp neq "">
																	<cfset vDate = mindate.ActionTimeStamp>
																</cfif>
																<cf_intelliCalendarDate9
																	FieldName="InitialDate"
																	class="regularxl"
																	Message="Select a valid Initial Date"
																	Default="#dateformat(vDate, CLIENT.DateFormatShow)#"
																	AllowBlank="False">
															</td>
															<td>&nbsp;-&nbsp;</td>
															<td>
																<cf_intelliCalendarDate9
																	FieldName="EndDate"
																	Message="Select a valid End Date"
																	class="regularxl"
																	Default="#dateformat(now(), CLIENT.DateFormatShow)#"
																	AllowBlank="False">
															</td>
														</tr>
													</table>
												</td>
											</tr>
											
											<tr>
												<td class="labelit" width="12%">From the host:</td>
												<td>
													<cfselect class="regularxl" name="host" id="host" query="hostList" display="HostName" value="HostName" queryposition="below">
														<option value="">-- All --
													</cfselect>
												</td>
												<td class="labelit">From the IP address:</td>
												<td>
													<cfselect class="regularxl" name="node" id="node" query="nodeList" display="NodeIP" value="NodeIP" queryposition="below">
														<option value="">-- All --
													</cfselect>
												</td>
											</tr>
											
											<tr>
												<td class="labelit">By the account:</td>
												<td>
													<cfselect class="regularxl" name="account" id="account" query="accList" display="Account" value="Account" queryposition="below">
														<option value="">-- All --
													</cfselect>
												</td>
												<td width="15%" class="labelit">Action performed:</td>
												<td>
													<cfselect class="regularxl" name="action" id="action" query="actionList" display="ActionDescription" value="ActionDescription" selected="Update" queryposition="below">
														<option value="">-- All --
													</cfselect>
												</td>
											</tr>
											
										</table>
									</td>
								</tr>
								<tr><td height="5"></td></tr>
								<tr><td class="linedotted"></td></tr>
								<tr><td height="5"></td></tr>
								<tr>
									<td align="center">
										<input type="Button" id="btnfilter" name="btnfilter" value="Filter" class="button10g" onclick="applyFilter();">
									</td>
								</tr>
								<tr><td height="5"></td></tr>
								</cfform>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr><td height="5"></td></tr>
	
	<tr>
		<td id="logStatus" class="labelmedium">
			<cfoutput>
				Showing records from the last #lastNDays# days with log entries.
			</cfoutput>
		</td>
	</tr>
	
	<tr><td height="5"></td></tr>

	<tr>
		<td>
			<cfdiv id="divDetail" bind="url:RecordListingDetail.cfm?mission=#url.mission#&id=#url.id#&filter=0&lastNDays=#lastNDays#">
		</td>
	</tr>
	
	<tr class="hide"><td><iframe name="processFilterLogging" id="processFilterLogging" frameborder="0"></iframe></td></tr>
	
</table>