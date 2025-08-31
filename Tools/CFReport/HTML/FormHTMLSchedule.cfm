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
  <table width="99%" align="center">
     	
		<cfif SESSION.acc neq AnonymousUserId>
				   
			<tr>
				<td colspan="4" bgcolor="ffffcf" id="subscriptions" style="padding:2px;border: 1px solid Silver;border-top:0px">																
				   <cfinclude template="FormHTMLSubscription.cfm">
				</td>
			</tr>				
						
		</cfif>	 	
     
   <tr>

		 <td width="157" class="labelmedium" style="cursor:hand" title="The envisioned recipient of this report">
		 	 
		 <cf_tl id="Reference">:
		
		 </td>	
		 <td colspan="3" width="85%" style="padding: 2px;">
				<cfinput type="Text" 
		         name="DistributionName" 
				 required="No" 
				 value="#SelDistributionName#"
		         size="50" 
		         maxlength="50" 
				 width="200"
		         label="Name:"
				 class="regularxl"
				 message="Please enter your full name" 
				 style="text-align: left;width:400px">	
		 </td>		 
  </tr>
  
  <tr>	 	 
				
	 <td class="labelmedium" style="cursor:hand" title="Send this report to mailing list.">
	  	
	  <cf_tl id="Managed by">:
	  
	 </td>	
	  <td colspan="3" width="85%" style="padding: 2px;">
	  
	  		 <cfquery name="Current" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  TOP 1 *
					FROM    UserReport M
					WHERE   ReportId = '#ReportId#'
				</cfquery>
				 
			 <cfquery name="ManagedBy" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				SELECT   Account,  LastName+' '+AccountMission as Name
				FROM     UserNames
				WHERE    Account IN
                             (SELECT DISTINCT AccountGroup
                              FROM            UserNamesGroup
                              WHERE           Account = '#session.acc#')		
				OR Account 	= '#Current.AccountGroup#'		  		
			
			 </cfquery>
			 		 
			    <cfselect name="AccountGroup" 
					selected="#Current.AccountGroup#"
			    	size="1" 
					class="regularxl"
					id="AccountGroup"
					multiple="No"
				    message="" 
				   	required="No"
					width="50"
					style="width: 400;"							
					label="Managed:"
					query="ManagedBy"
					queryPosition="below"
					value="Account"
					display="Name">
					<option value="">--- <cf_tl id="n/a"> ---</option>
			  </cfselect>	
				 				 
	 </td>		 
				 
  </tr>
	
  <tr>
		 
		 <td class="labelmedium" style="cursor:hand" title="Subject of the eMail that will be sent to you.">		  	
		  <cf_tl id="Variant Name">:		 
		 </td>	
		 <td style="padding: 2px;">						 
				<cfinput type="Text" 
		         name="DistributionSubject" 
				 required="No" 
				 value="#SelDistributionSubject#"
		         size="60" 
		         maxlength="60" 
				 width="200"
		         label="Subject:"
				 class="regularxl"
				 message="Please enter a subject" 
				 style="text-align: left;;width:400px">	
				 
		 </td>
		 
  </tr>
	 
  <tr><td height="2"></td></tr>	 
   
  <tr>
	 
	  <td colspan="1" valign="top">
	  
	  <table cellspacing="0" cellpadding="0">
	  
		  <tr><td height="2"></td></tr>
		  
				  
		  <tr><td height="4"></td></tr>
		  <tr>	
		  
			    <td style="padding:2px;padding-left:10px" class="labelmedium">
			    <input type="radio" style="width:18;height:18" onclick="check('Manual')"   name="DistributionPeriod" id="DistributionPeriod" value="Manual" <cfif SelDistributionPeriod eq "Manual">checked</cfif>>
			    </td>
				<td class="labelmedium" style="cursor: pointer;" onclick="document.getElementsByName('DistributionPeriod')[0].click()"><cf_tl id="Save as variant"></td>
				
		  </tr>
		  
		  <tr><td colspan="2" height="20" style="padding:2px" class="labelmedium">
		  
		  <table>
		  <tr>
		  	<td class="labelmedium" align="right" valign="top" style="padding-top:2px">
			 <cf_tl id="or"> <cf_tl id="Mail">:		 
			 <cf_space spaces="23"> 
			</td>
   		    <td style="padding-right:10px">
			  <table>
			  
			   <tr>	
				<td class="labelmedium" style="padding:2px;padding-left:10px">
		  	    <input type="radio" style="width:18;height:18" onclick="check('Daily')" name="DistributionPeriod" id="DistributionPeriod" value="Daily" <cfif SelDistributionPeriod eq "Daily">checked</cfif>>
			    </td>
				<td class="labelmedium" style="padding-left:5px;cursor:pointer" onclick="document.getElementsByName('DistributionPeriod')[1].click()"><cf_tl id="Daily"></td>
			  </tr>
			  
			  <tr>		
				<td class="labelmedium" style="padding:2px;padding-left:10px">
			    <input type="radio" style="width:18;height:18" onclick="check('Weekly')"   name="DistributionPeriod" id="DistributionPeriod" value="Weekly" <cfif SelDistributionPeriod eq "Weekly">checked</cfif>>
			    </td><td class="labelmedium" style="padding-left:5px;cursor:pointer" onclick="document.getElementsByName('DistributionPeriod')[2].click()"><cf_tl id="Weekly"></td>
			  </tr>	
			  
			  <tr>	
				<td class="labelmedium" style="padding:2px;padding-left:10px">
			      <input type="radio" style="width:18;height:18" onclick="check('Monthly')"  name="DistributionPeriod" id="DistributionPeriod" value="Monthly" <cfif SelDistributionPeriod eq "Monthly">checked</cfif>>
			   </td>
			   <td class="labelmedium" style="padding-left:5px;cursor:pointer" onclick="document.getElementsByName('DistributionPeriod')[3].click()"><cf_tl id="Monthly"></td>				
		  	  </tr>
			  
			  
			  </table>
		  </td>
		  
		  </tr></table>
		  
		  </td></tr>
		 	
	</table>
	</td>
	
	  <cfif SelDistributionPeriod eq "Manual">
	    <cfset cl = "hide">
	  <cfelse>
	    <cfset cl = "regular">			
	  </cfif>	  
	
	<td colspan="3" class="<cfoutput>#cl#</cfoutput>" id="mail">		  
			 	     
	  <table border="0" cellspacing="0" cellpadding="0" bordercolor="FFFFFF">  
	  						
				<cfif SelDistributionPeriod eq "Weekly">
				    <cfset sl = "Regular">
				<cfelse>
				    <cfset sl ="Hide">
				</cfif>
				
				<cfset pd = "2px">
				
				<tr id="dow" class="<cfoutput>#sl#</cfoutput>">
					
					<td class="labelmedium" style="padding:<cfoutput>#pd#</cfoutput>"> <cf_tl id="Weekday">: </td>
					
					<td style="padding:<cfoutput>#pd#</cfoutput>">
					
					<table cellspacing="0" cellpadding="0">
					<tr class="labelmedium">
									
					<cfloop index="day" from="1" to="7">
									
						 <cfswitch expression="#day#">
						     <cfcase value="1"><cfset txt = "Sun"></cfcase> 
							 <cfcase value="2"><cfset txt = "Mon"></cfcase>
							 <cfcase value="3"><cfset txt = "Tue"></cfcase>
							 <cfcase value="4"><cfset txt = "Wed"></cfcase>
							 <cfcase value="5"><cfset txt = "Thu"></cfcase>
							 <cfcase value="6"><cfset txt = "Fri"></cfcase>
							 <cfcase value="7"><cfset txt = "Sat"></cfcase>
							
						 </cfswitch> 
						 					 
						 <cfif find(day,  SeldistributionDOW)> 					 
						        <cfoutput>
								<td style="padding:2px;padding-left:4px">
								<input type="CheckBox" class="radiol" checked name="DistributionDOW#day#" id="DistributionDOW#day#"
							     value="#day#" label="#txt#"/>
								 </td>
								 <td style="padding:2px">
								 <cf_tl id="#txt#">
								 </td>
								 </cfoutput>
						 <cfelse>
						        <cfoutput>
								<td style="padding:2px;padding-left:4px">
								<input type="CheckBox" class="radiol"  name="DistributionDOW#day#" id="DistributionDOW#day#"
							    value="#day#" label="#txt#"/> 
								</td>
								<td style="padding:2px">
								<cf_tl id="#txt#">
								</td>
								</cfoutput>
						 </cfif>	
					 
					</cfloop>	
					</tr>
					</table>
				  </td>
				  
			</tr>	
	  
	  	    <cfif SelDistributionPeriod eq "Monthly">
			    <cfset sl = "Regular">
			<cfelse>
			    <cfset sl ="Hide">
			</cfif>
	  
	  	    <tr id="dom" class="<cfoutput>#sl#</cfoutput>">
									  
				  <td class="labelmedium" style="padding:<cfoutput>#pd#</cfoutput>"> <cf_tl id="Day of month">: </td>
				  
				  <td style="padding:<cfoutput>#pd#</cfoutput>">
									
					 <cfinput type="Text"
				       name="DistributionDOM"
				       range="1,30"
					   class="regularxl"
				       style="width:25px;text-align:center"
				       message="Please enter a valid day number"
				       validate="integer"
				       required="No"
				       visible="Yes"
				       enabled="Yes"	      
					   value="#SelDistributionDOM#"
				       maxlength="2">
						
				  </td>
				  	 
		  </tr>
		  
		  <cf_calendarscript>
					  
		  <tr>
		  
		 	      <td class="labelmedium" style="padding:<cfoutput>#pd#</cfoutput>"><cf_tl id="Period">:</td>	
				
				  <td style="padding:<cfoutput>#pd#</cfoutput>">
				  
				  <table cellspacing="0" cellpadding="0"><tr><td>
				  
				    <cf_intelliCalendarDate9
						FieldName="DistributionDateEffective" 
						Default="#Dateformat(SelDateEffective, CLIENT.DateFormatShow)#"
						AllowBlank="True"
						class="regularxl"
						Mask="False">	
						
					</td>
					<td class="labelmedium">&nbsp;to:&nbsp;</td>
					<td>	
									
					<cf_intelliCalendarDate9
						FieldName="DistributionDateExpiration" 
						Default="#Dateformat(SelDateExpiration, CLIENT.DateFormatShow)#"
						AllowBlank="True"
						class="regularxl"
						Mask="False">	
					
					</td></tr></table>
				
				</td>
						
			</tr>		
					 
				 <cfoutput>
				 <script language="JavaScript">
				  <cfif #Layout.LayoutClass# eq "View">
				    md  = document.getElementsByName("DistributionMode")
					if (md[1])
					{ md[1].checked = true }
					if (md[0])
					{ md[0].disabled = true }
				  </cfif>
				 </script>
				 </cfoutput>
								 
			<tr>
		
				 <td class="labelmedium" style="padding:<cfoutput>#pd#</cfoutput>"><cf_tl id="Mail To">:</td>	
				 <td style="padding:<cfoutput>#pd#</cfoutput>">
				 <cfinput type="Text" 
				         name="DistributionEMail" 
						 required="No" 
						 value="#SelDistributionEMail#"
				         size="100" 
				         maxlength="100" 
						 width="200"
				         label="eMail address TO:"
						 tooltip="Enter one or more comma separated email addresses"
						 class="regularxl"
						 message="Please enter a valid eMail address" 
						 style="text-align: left;;width:100%">	
						 
						<!--- validate="email" --->
						 
				 </td>	
				 
			</tr>
					
			<tr>	 	 
				
				 <td class="labelmedium" style="cursor:pointer;padding:<cfoutput>#pd#</cfoutput>" title="eMail address (example : dev@email)"><cf_tl id="Mail Cc">:</td>	
				 <td style="padding:<cfoutput>#pd#</cfoutput>">
				 <cfinput type="Text" 
				         name="DistributionEMailCC" 
						 required="No" 
						 value="#SelDistributionEMailCC#"
				         size="100" 
				         maxlength="100" 
						 width="200"
				         label="eMail address CC:"
						 class="regularxl"						 
						 message="Please enter a valid eMail address" 
						 style="text-align: left;width:100%">	
						 <!---validate="email"--->
						 
				 </td>		 
				 
			 </tr>
			 				 
			 <tr>	 	 
				
				 <td class="labelmedium" style="padding:<cfoutput>#pd#</cfoutput>"><cf_tl id="Reply to">:</td>	
				 <td style="padding:<cfoutput>#pd#</cfoutput>">
				 <cfinput type="Text" 
				         name="DistributionReplyTo" 
						 required="No" 
						 value="#SelDistributionReplyTo#"
				         size="100" 
				         maxlength="100" 
						 width="200"
				         label="eMail reply To address CC:"
						 class="regularxl"
						 validate="email"
						 message="Please enter a valid eMail address" 
						 style="text-align: left;;width:100%"
						 tooltip="<table><tr><td>eMail address (example : dev@email)</td></table>">	
						 
				 </td>		 
				 
			</tr>
						 
			<cfif Report.EnableMailingList eq "1">
				
			<tr>	 	 
				
				 <td class="labelmedium" style="cursor:pointer;padding:<cfoutput>#pd#</cfoutput>" title="Send this report to mailing list"><cf_tl id="Distribution"><cf_tl id="list">:</td>	
				 <td style="padding:<cfoutput>#pd#</cfoutput>">
				 
					 <cfquery name="Mailing" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  Account,  LastName+' '+AccountMission as Name
						FROM    UserNames U
						WHERE   AccountType != 'Individual'
						AND     AccountOwner = '#Report.Owner#'
						ORDER BY AccountOwner, LastName
					</cfquery>
				 
					 <cfquery name="Current" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  TOP 1 *
						FROM    UserReportMailing M
						WHERE   ReportId = '#ReportId#'
					</cfquery>
				 
				    <cfselect name="AccountMailing" 
								selected="#Current.Account#"
						    	size="1" 
								class="regularxl"
								id="AccountMailing"
								multiple="No"
							    message="" 
							   	required="No"
								width="50"
								style="font:10px;width: 300;"								
								label="Mailing list:"
								query="Mailing"
								queryPosition="below"
								value="Account"
								display="Name">
								<option value="">--- <cf_tl id="None"> ---</option>
				  </cfselect>	
				 				 
				 </td>		 
				 
			 </tr>
			 
			</cfif> 
									
			<cfif initLayoutClass neq "View">
			  <cfset cl = "hide">
			<cfelse>
			  <cfset cl = "regular">  
			</cfif>
			 
			 <tr id="attachmentmode" class="#cl#">
			 
			 	<td class="labelmedium" style="padding:<cfoutput>#pd#</cfoutput>"><cf_tl id="Modality">:<cf_space spaces="40"></td>	
				
				  <td style="padding:<cfoutput>#pd#</cfoutput>;height:28px" class="labelmedium">
				  						  
				  	<cf_UIToolTip  tooltip="<table><tr><td>Define if you want to receive this report as an attachment <br> or that you prefer to run this report directly from the server.</td></table>">
						
						<cfif SelDistributionMode eq "Attachment">
					
							<input type="Radio" 
							         name="DistributionMode" 
									 id="DistributionMode"
									 class="radiol"
									 value="Attachment"
									 label="Attachment" checked /> <cf_tl id="Attachment">
									 
							<input type="Radio" 
							         name="DistributionMode" 
									 id="DistributionMode"
									 class="radiol"
									 value="Hyperlink"
									 label="Hyperlink"/> <cf_tl id="Hyperlink">	
								 
						<cfelse>
						
							<input type="Radio" 
							         name="DistributionMode" 
									 id="DistributionMode"
									 class="radiol"
									 value="Attachment"
									 <cfif Report.EnableAttachment eq "0">disabled</cfif>
									 label="Attachment"/> <cf_tl id="Attachment">
									 
							<input type="Radio" 
							         name="DistributionMode" 
									 id="DistributionMode"
									 class="radiol"
									 value="Hyperlink"
									 label="Hyperlink" checked /> <cf_tl id="Hyperlink">			 
								 
						</cfif>	 
						
					   </cf_UIToolTip>
						
					</td>
					
			</tr>
								 
		</table>
	 
	 </td>	 
	 
	 </tr>	
	  
	 
	 <tr><td height="5"></td></tr>		
	 
	  <cfif SelDistributionPeriod eq "Manual">
	 	 <cfset con = "hide">
	 <cfelse>
		 <cfset con = "regular">
	 </cfif>
	 
	 <cfif Report.TemplateCondition eq "1">
					 		 		 
	 <tr class="<cfoutput>#con#</cfoutput>" id="condition">
		 <td><cf_tl id="Condition for sending">:</td>
		 <td colspan="3">
		 
			 <table width="100%" border="0" cellspacing="0" cellpadding="0" >
			 
				 <tr><td height="2"></td></tr>	
				 <tr><td bgcolor="e4e4e4"></td></tr>	
			    	 
				 <cfset class = "'Condition'">
				 <tr>
					 <td>				
					 <cfinclude template="FormHTMLCriteria.cfm">
					 </td>
				 </tr>	 
			 
			
			 </table>
		 </td>
	 </tr>
	 
	 <cfelse>
	 
	 <tr class="hide"><td id="condition"></td></tr>
	 
	 </cfif>
	 
	 <tr><td></td><td colspan="3">
	 
		     <cfif reportId neq "00000000-0000-0000-0000-000000000000">
			 	 <cf_tl id="Update the criteria of this variant." var="1">
				 <cfoutput>
			     <cf_UIToolTip tooltip="<table><tr><td>#lt_text#</td></table>">
					 <cf_tl id="Update Subscription" var="1">
					   <input type= "button" 
					          class="BUTTON10g" 
							  style="height:26;width:170;border-radius:5px" 
							  name="update" 
							  id="update"
							  value= "#lt_text#" 
							  onclick="verifyaction('update','update','#reportid#');">
				 </cf_UIToolTip>
				 </cfoutput>	
			 </cfif>	

			 <cfif Report.TemplateSQL neq "Application">	
				<cfif URL.Option eq "All">
					<cfif SESSION.acc neq AnonymousUserId>
						<cf_tl id="Create a new variant with the selected criteria and scheduling settings." var="1">
					   <cfoutput>
					   <cf_UIToolTip tooltip="<table><tr><td>#lt_text#</td></tr></table>">
					   <cf_tl id="Save New Subscription" var="1">
						<input type= "button" 
						   class="button10g" 
						   style="height:26;width:190;border-radius:5px" 
						   name="insert"
						   id="insert" 
						   value= "#lt_text#" 
						   onclick="verifyaction('subscribe to','insert');">
					   </cf_UIToolTip>
					   </cfoutput>	
					 </cfif>			
				</cfif>
			</cfif>	
   	 
	 </td></tr>
	 		
</table>		
