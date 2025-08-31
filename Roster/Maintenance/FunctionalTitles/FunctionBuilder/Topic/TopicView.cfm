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
<cfquery name="getlist"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT	  T.Topic, 
				  T.TopicLabel,
				  T.TopicClass,
				  TC.Description as TopicClassDescription,
				  T.Parent,
				  T.Description,
				  T.Tooltip,
				  T.Question,
				  T.ListingOrder,
				  TL.ListCode,
				  TLC.ListLabel,
				  TLC.ListExplanation as ListCodeExplanation,
				  TL.ListValue,
				  TL.ListExplanation,
				  TL.Operational,
				  (
					SELECT	ListCode
					FROM	FunctionRequirementLineTopic
					WHERE	RequirementId = '#url.reqid#'
					AND		Parent = '#url.area#'
					AND		Topic = T.Topic
					AND		ListCode = TL.ListCode
				  ) as IsSelected
				  
		FROM	  Ref_Topic T INNER JOIN 
				  Ref_TopicClass TC ON T.TopicClass = TC.TopicClass INNER JOIN 
				  Ref_TopicList TL	ON T.Topic = TL.Code INNER JOIN 
				  Ref_TopicListCode TLC	ON TL.ListCode = TLC.ListCode
					
		WHERE	  T.Operational = 1
		AND		  T.Parent = '#url.area#'
		
		ORDER BY  TC.ListingOrder ASC,
				  T.ListingOrder ASC,
				  TL.ListOrder ASC
	
</cfquery>

<cf_screentop label="Skills Requirements - #getlist.TopicClassDescription#" layout="webapp"  jquery="yes" user="no" bannerforce="Yes" banner="gray">

<cfquery name="list" dbtype="query">
    SELECT	DISTINCT ListCode
	FROM	getList
</cfquery>

<cfquery name="getHeader"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT 	*
		FROM 	Ref_TopicListCode
		<cfif list.recordCount gt 0>
			WHERE	ListCode IN (#quotedvalueList(list.listcode)#)		
		<cfelse>
			WHERE	1=0
		</cfif>
		ORDER BY  ListOrder ASC
</cfquery>

<cfset w = 7.77>
<cfif getHeader.recordCount gt 0>
	<cfset w = 70.0/getHeader.recordcount>
</cfif>

<cfset vOptCnt = 7>

<table width="99%" align="center" style="height:100%">

<tr><td style="padding:20px" style="height:100%" valign="top">

<cfform 
	name="frmtopic" 
	style="height:100%" 
	action="#session.root#/Roster/Maintenance/FunctionalTitles/FunctionBuilder/Topic/TopicSubmit.cfm?ID=#URL.ID#&ID1=#URL.ID1#&reqid=#url.reqid#&reqline=#url.reqline#&box=#url.box#&area=#url.area#&idMenu=#url.idmenu#">
	
	<table style="width:100%;height:100%" border="0">	    
	
		<tr><td>
	
	    <table style="width:100%;height:100%">
		<tr class="line">
			<td width="2%" class="labellarge" style="padding-left:30px;">&nbsp;</td>
			<td width="28%" class="labellarge" style="padding-left:30px;" colspan="9">&nbsp;</td>
			<cfoutput query="getHeader">
				<td width="#w#%" align="center" class="labelmedium" style="width:#w#%; max-width:#w#%; min-width:#w#%;">				
					#ListLabel# 
				</td>
			</cfoutput>
			<td id="bannerScrollSpace" style="width:0px;"></td>
		</tr>
		
		</table>
		
		</td></tr>
					
		<tr><td height="100%">
						
			<cf_divscroll id="divTopicContent">
				<cfset cnt = 1>
				<table width="100%" align="center" class="navigation_table" id="tableTopicContent">
					<cfoutput query="getlist" group="TopicClass">			
						<cfoutput group="Description">
							<tr class="clsRow">
								<td class="labelmedium" colspan="17" style="padding-left:5px; cursor:pointer;" title="#Tooltip#"><b>#Description#</b></td>
							</tr>
							<cfoutput group="Topic">
								<tr class="navigation_row clsRow">
									<td class="labelit" width="2%" style="padding-left:10px;">#cnt#.</td>
									<td class="labelit clsContent" width="28%" colspan="9">[#TopicLabel#] #Question#</td>
									<cfoutput>
										<cfif operational eq 1>
											<td 
												class="labelit" 
												width="#w#%" 
												align="center" 
												valign="middle" 
												style="background-color:##E1E1E1; border:1px solid ##FAFAFA; width:#w#%; max-width:#w#%; min-width:#w#%;" 
												title="#ListCode# - #ListLabel#">
													<input 
														type="Checkbox" 
														id="level_#topic#_#ListCode#" 
														name="level_#topic#_#ListCode#" 
														value="#ListValue#" 
														style="height:15px; width:15px;"
														<cfif IsSelected eq ListCode>checked</cfif>> 
											</td>
										<cfelse>
											<td style="background-color:##CACACA; border:1px solid ##FAFAFA;"></td>
										</cfif>
									</cfoutput>
								</tr>
								<cfset cnt = cnt + 1>
							</cfoutput>
							<tr class="clsRow"><td height="5"></td></tr>
						</cfoutput>
						<tr class="clsRow"><td height="5"></td></tr>
					</cfoutput>
				</table>
			</cf_divscroll>
		
		</td></tr>
							
		<tr><td colspan="1" valign="bottom" height="20">
		
			<table width="99%" align="center">
				<tr><td height="3"></td></tr>
				<tr><td class="line"></td></tr>
				<tr><td height="3"></td></tr>
				<tr>
					<td align="center">
						<cfif getlist.recordCount gt 0>
							<cf_tl id="Save" var="1">
							<cf_button2 
								image="save_white.png" 
								height="40px"
								width="125px"
								borderColor="##FAFAFA"
								borderColorInit="##FAFAFA"
								textcolor="##FAFAFA"
								borderRadius="0px"
								textSize="16px"
								bgcolor="##ABABAB" 
								type="submit" 
								text="#lt_text#">
						</cfif>
					</td>
				</tr>
			</table>
		
		</td></tr>
	
</cfform>

</td>
</tr>
</table>

<cfsavecontent variable="ajaxFunctionContent">
	doHighlight();
	if ($('#tableTopicContent').height() > $('#divTopicContent').height()) {
		$('#bannerScrollSpace').html('&nbsp;');
		$('#bannerScrollSpace').css('width','20px');
		$('#bannerScrollSpace').css('min-width','20px');
		$('#bannerScrollSpace').css('max-width','20px');
	}
</cfsavecontent>

<cfset AjaxOnLoad("function() { #ajaxFunctionContent# }")>


