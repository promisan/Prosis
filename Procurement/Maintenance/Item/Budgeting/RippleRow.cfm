
<!-- <cfform> -->

<cfoutput>

	<tr class="labelmedium linedotted  navigation_row">
	
	<cfquery name="MissionList" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT * 
		  FROM   Ref_ParameterMission M	
		  WHERE  Mission IN (SELECT Mission FROM ItemMasterMission WHERE Mission = M.Mission)
	</cfquery>
		
	<cfif url.mode eq "edit" or url.mode eq "add">
		<td style="height:30px;width:80px;padding-left:3px">
			<select name="Mission" class="regularxl" id="Mission" onchange="ptoken.navigate('Budgeting/getItemMaster.cfm?selected=#rippleitemmaster#&mission='+this.value+'&mode=#URL.mode#','itemmaster')">
			<cfif mission eq "">
				<cfset mission = missionlist.mission>
			</cfif>
			<cfloop query="missionlist">
				<option value="#mission#" <cfif mis eq mission>selected</cfif>>#mission#</option>
			</cfloop>		
			</select>
		</td>	
		<cfelse>
		<td style="height:17px;width:80px;padding-left:3px">
			#mission#
		</td>	
	</cfif>
		
	<td style="padding-left:2px;width:60px">
	
	<cfquery name="TopicList" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT * 
		  FROM   ItemMasterList	
		  WHERE  ItemMaster = '#url.code#'		 
	</cfquery>
	
	<cfif url.mode eq "edit" or url.mode eq "add">
			
		   <select name="TopicValueCode" class="regularxl" id="TopicValueCode">
		   		<option value="">Any</option>
				<cfloop query="TopicList">
					<option value="#TopicValueCode#" <cfif topicvaluecode eq top>selected</cfif>>#TopicValueCode#</option>
				</cfloop>
			</select>
			
	<cfelse>
	
			<cfif top eq "">
				All
			<cfelse>
				#top#
			</cfif>
			
	</cfif>	
	</td>
	
	<cfset url.init = "1">
	
	<td style="min-width:135px">
	
	   <cf_intelliCalendarDate9
			FieldName="DateEffective" 
			Default="#Dateformat(dateeffective, client.dateFormatShow)#"
			Manual="True"	
			class="regularxl"			
			AllowBlank="False">	
	
	</td>
	
	<td width="220" style="padding-top:12px;padding-left:3px" id="itemmaster">
	
		    <cfset url.mission  = mission>
			<cfset url.selected = rippleitemmaster>					
			<cfset url.code     = code>			
			<cfinclude template="getItemMaster.cfm">		
			
	</td>
	
	<td width="80" style="padding-top:12px;padding-left:3px" id="itemmasterobject">
	
		 	<cfset url.itemmaster = rippleitemmaster>		
			<cfset url.selected   = rippleobjectcode>	
			<cfinclude template="getItemMasterObject.cfm">					
	
		
	</td>
	
	<td width="120" style="padding-left:3px">
	
		<cfif url.mode eq "edit" or url.mode eq "add">
			<select name="BudgetMode" id="BudgetMode" class="regularxl">
				<option value="1" <cfif BudgetMode eq "1">selected</cfif>><cf_tl id="Flat Amount"></option>
				<option value="2" <cfif BudgetMode eq "2">selected</cfif>><cf_tl id="Resource qty"></option>
				<option value="3" <cfif BudgetMode eq "3">selected</cfif>><cf_tl id="Requirement qty"></option>
			</select>	
		<cfelse>
			<cfswitch expression="#BudgetMode#">
				<cfcase value="1"><cf_tl id="Flat Amount"></cfcase>
				<cfcase value="2"><cf_tl id="Resource quantity"></cfcase>
				<cfcase value="3"><cf_tl id="Requirement quantity"></cfcase>
			</cfswitch>
		</cfif>	
	
	</td>
	
	<td style="width:90px;padding-left:3px" align="right">
		<cfif url.mode eq "edit" or url.mode eq "add">
			<input type="text" name="BudgetAmount" id="BudgetAmount" style="text-align:right" value="#RippleList.BudgetAmount#" class="regularxl" size="6" maxlength="20">
		<cfelse>
			#NumberFormat(RippleList.BudgetAmount,",.__")#				
		</cfif>	
	
	</td>
	
	<td align="right" style="width:20px">
	
		<cfif url.mode eq "edit">
			<input type="checkbox" name="Operational" id="Operational" class="radiol" value="1" <cfif operational neq "0" >checked</cfif>>
		<cfelseif url.mode eq "view">
			<cfif Operational eq 1>
				<cf_tl id="Y">
			<cfelse>
				<cf_tl id="N">
			</cfif>
		</cfif>
	</td>	
	
	<td align="right" style="width:20px">
		<cfif url.mode eq "view">
			<cf_img icon="edit"  navigation="Yes" onclick="do_edit('#url.code#','#top#','#mission#','#rippleitemmaster#','#rippleobjectcode#','#dateeffective#')">							
		</cfif>	
	</td>

	<td align="center" style="width:20px;padding-right:5px">
		<cfif url.mode eq "edit">
			<button onclick="updateripple('#url.code#','#top#','#mission#','#rippleitemmaster#','#rippleobjectcode#','#dateeffective#')" id="btnSaveLine" name="btnSaveLine" class="button10s" style="height:25"><cf_tl id="Save"></button>										
		<cfelseif url.mode eq "add">
			<button onclick="saveripple('#url.code#')" id="btnSaveLine" name="btnSaveLine" class="button10s" style="height:25"><cf_tl id="Save"></button>			
		<cfelse>
			<cf_img icon="delete" onclick="do_delete('#url.code#','#top#','#mission#','#rippleitemmaster#','#rippleobjectcode#','#dateeffective#')">				
		</cfif>	
	</td>	
	
	</tr>

</cfoutput>

<!-- </cfform> -->

<cfset ajaxonload("doCalendar")>
